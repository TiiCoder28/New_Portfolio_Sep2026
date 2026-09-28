from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_health_works_without_supabase():
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "ok"


def test_cms_unconfigured_returns_503(monkeypatch):
    from app.config import get_settings
    monkeypatch.delenv("SUPABASE_URL", raising=False)
    monkeypatch.delenv("SUPABASE_ANON_KEY", raising=False)
    get_settings.cache_clear()
    response = client.get("/api/projects")
    assert response.status_code == 503


def test_studio_requires_configuration_or_login():
    response = client.get("/api/studio/projects")
    assert response.status_code in (401, 503)
