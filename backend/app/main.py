"""Portfolio API. Authentication and RLS are enforced before any Studio write."""
from datetime import datetime, timezone
from fastapi import Depends, FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from .config import get_settings, Settings
from .supabase import require_configuration, require_admin, supabase_request
from .models import ProjectCreate, ProjectPatch, PostCreate, PostPatch

app = FastAPI(title="Tiisetso Portfolio API", version="0.2.0")
app.add_middleware(
    CORSMiddleware,
    allow_origins=get_settings().origins,
    allow_credentials=False,
    allow_methods=["GET", "POST", "PATCH", "DELETE", "OPTIONS"],
    allow_headers=["Authorization", "Content-Type"],
)


@app.get("/health", tags=["system"])
def health():
    return {"status": "ok", "database_configured": get_settings().configured}


@app.get("/api/projects", tags=["public"])
async def public_projects(settings: Settings = Depends(require_configuration)):
    return await supabase_request(
        settings, "GET", "portfolio_projects",
        params={"select": "*", "status": "eq.published", "order": "sort_order.asc"},
    )


@app.get("/api/posts", tags=["public"])
async def public_posts(settings: Settings = Depends(require_configuration)):
    return await supabase_request(
        settings, "GET", "portfolio_posts",
        params={"select": "*", "status": "eq.published", "order": "published_at.desc"},
    )


@app.get("/api/studio/session", tags=["studio"])
async def studio_session(admin: tuple[Settings, str] = Depends(require_admin)):
    return {"authenticated": True, "administrator": True, "mfa": True}


async def list_studio(table: str, admin: tuple[Settings, str]):
    settings, token = admin
    return await supabase_request(
        settings, "GET", table, token,
        params={"select": "*", "order": "updated_at.desc"},
    )


async def create_studio(table: str, payload: dict, admin: tuple[Settings, str]):
    settings, token = admin
    if payload["status"] == "published":
        payload["published_at"] = datetime.now(timezone.utc).isoformat()
    result = await supabase_request(settings, "POST", table, token, payload=payload, prefer="return=representation")
    return result[0]


async def patch_studio(table: str, record_id: str, payload: dict, admin: tuple[Settings, str]):
    if not payload:
        raise HTTPException(400, "No changes supplied.")
    settings, token = admin
    if payload.get("status") == "published":
        payload["published_at"] = datetime.now(timezone.utc).isoformat()
    payload["updated_at"] = datetime.now(timezone.utc).isoformat()
    rows = await supabase_request(
        settings, "PATCH", table, token, params={"id": f"eq.{record_id}"},
        payload=payload, prefer="return=representation",
    )
    if not rows:
        raise HTTPException(404, "Record not found.")
    return rows[0]


async def archive_studio(table: str, record_id: str, admin: tuple[Settings, str]):
    return await patch_studio(table, record_id, {"status": "archived"}, admin)


@app.get("/api/studio/projects", tags=["studio"])
async def studio_projects(admin: tuple[Settings, str] = Depends(require_admin)):
    return await list_studio("portfolio_projects", admin)


@app.post("/api/studio/projects", tags=["studio"], status_code=201)
async def new_project(project: ProjectCreate, admin: tuple[Settings, str] = Depends(require_admin)):
    return await create_studio("portfolio_projects", project.model_dump(mode="json"), admin)


@app.patch("/api/studio/projects/{record_id}", tags=["studio"])
async def edit_project(record_id: str, project: ProjectPatch, admin: tuple[Settings, str] = Depends(require_admin)):
    return await patch_studio("portfolio_projects", record_id, project.model_dump(exclude_unset=True, mode="json"), admin)


@app.delete("/api/studio/projects/{record_id}", tags=["studio"])
async def archive_project(record_id: str, admin: tuple[Settings, str] = Depends(require_admin)):
    return await archive_studio("portfolio_projects", record_id, admin)


@app.get("/api/studio/posts", tags=["studio"])
async def studio_posts(admin: tuple[Settings, str] = Depends(require_admin)):
    return await list_studio("portfolio_posts", admin)


@app.post("/api/studio/posts", tags=["studio"], status_code=201)
async def new_post(post: PostCreate, admin: tuple[Settings, str] = Depends(require_admin)):
    return await create_studio("portfolio_posts", post.model_dump(mode="json"), admin)


@app.patch("/api/studio/posts/{record_id}", tags=["studio"])
async def edit_post(record_id: str, post: PostPatch, admin: tuple[Settings, str] = Depends(require_admin)):
    return await patch_studio("portfolio_posts", record_id, post.model_dump(exclude_unset=True, mode="json"), admin)


@app.delete("/api/studio/posts/{record_id}", tags=["studio"])
async def archive_post(record_id: str, admin: tuple[Settings, str] = Depends(require_admin)):
    return await archive_studio("portfolio_posts", record_id, admin)
