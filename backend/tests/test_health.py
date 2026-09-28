from fastapi.testclient import TestClient
from app.main import app
from app.config import Settings, get_settings

client = TestClient(app)


def test_health_works_without_supabase():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_cms_unconfigured_returns_503():
    app.dependency_overrides[get_settings] = lambda: Settings(
        supabase_url="", supabase_anon_key="", _env_file=None
    )
    try:
        response = client.get("/api/projects")
        assert response.status_code == 503
    finally:
        app.dependency_overrides.clear()


def test_studio_unconfigured_is_not_open():
    app.dependency_overrides[get_settings] = lambda: Settings(
        supabase_url="", supabase_anon_key="", _env_file=None
    )
    try:
        response = client.get("/api/studio/projects")
        assert response.status_code == 503
    finally:
        app.dependency_overrides.clear()
