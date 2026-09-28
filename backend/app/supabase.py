"""Supabase access through the caller's validated token, never a service-role key.

Supabase Auth validates the bearer token at /auth/v1/user. Subsequent PostgREST
calls use that same token, so database RLS is enforced on every operation.
"""
from typing import Any
import httpx
import jwt
from fastapi import Depends, HTTPException, Request, status
from .config import Settings, get_settings


def require_configuration(settings: Settings = Depends(get_settings)) -> Settings:
    if not settings.configured:
        raise HTTPException(
            status_code=503,
            detail="Portfolio database is not configured yet. Set SUPABASE_URL and SUPABASE_ANON_KEY.",
        )
    return settings


def auth_headers(settings: Settings, token: str | None = None) -> dict[str, str]:
    return {
        "apikey": settings.supabase_anon_key,
        "Authorization": f"Bearer {token or settings.supabase_anon_key}",
    }


async def supabase_request(
    settings: Settings,
    method: str,
    path: str,
    token: str | None = None,
    *,
    params: dict[str, str] | None = None,
    payload: Any = None,
    prefer: str | None = None,
) -> Any:
    headers = auth_headers(settings, token)
    if prefer:
        headers["Prefer"] = prefer
    url = settings.supabase_url.rstrip("/") + "/rest/v1/" + path
    try:
        async with httpx.AsyncClient(timeout=15) as client:
            response = await client.request(method, url, headers=headers, params=params, json=payload)
    except httpx.RequestError:
        raise HTTPException(502, "Portfolio database is temporarily unavailable.") from None
    if response.status_code >= 400:
        # Avoid leaking upstream table or SQL details to public callers.
        if response.status_code in (401, 403):
            raise HTTPException(403, "Database access denied.")
        if response.status_code == 409:
            raise HTTPException(409, "A record with this identifier already exists.")
        raise HTTPException(502, "Database request failed.")
    return response.json() if response.content else None


async def require_admin(
    request: Request, settings: Settings = Depends(require_configuration)
) -> tuple[Settings, str]:
    authorization = request.headers.get("authorization", "")
    scheme, _, token = authorization.partition(" ")
    if scheme.lower() != "bearer" or not token.strip():
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Sign in to Portfolio Studio.")
    token = token.strip()
    try:
        async with httpx.AsyncClient(timeout=10) as client:
            user_response = await client.get(
                settings.supabase_url.rstrip("/") + "/auth/v1/user",
                headers=auth_headers(settings, token),
            )
    except httpx.RequestError:
        raise HTTPException(502, "Authentication service is temporarily unavailable.") from None
    if user_response.status_code != 200:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Session expired or invalid.")
    user = user_response.json()
    # We read the claims only AFTER Supabase Auth has validated this exact token.
    claims = jwt.decode(token, options={"verify_signature": False, "verify_aud": False})
    if not user.get("id") or claims.get("sub") != user["id"]:
        raise HTTPException(status.HTTP_401_UNAUTHORIZED, "Session identity mismatch.")
    if claims.get("aal") != "aal2":
        raise HTTPException(403, "Multi-factor authentication is required.")
    members = await supabase_request(
        settings, "GET", "admin_members", token,
        params={"select": "user_id", "user_id": f"eq.{user['id']}", "limit": "1"},
    )
    if not members:
        raise HTTPException(403, "This account is not a Portfolio Studio administrator.")
    return settings, token
