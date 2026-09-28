from functools import lru_cache
from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    supabase_url: str = ""
    supabase_anon_key: str = ""
    allowed_origins: str = "http://localhost:5173"

    model_config = SettingsConfigDict(env_file=".env", extra="ignore")

    @property
    def configured(self) -> bool:
        return self.supabase_url.startswith("https://") and bool(self.supabase_anon_key)

    @property
    def origins(self) -> list[str]:
        return [s.strip() for s in self.allowed_origins.split(",") if s.strip()]


@lru_cache
def get_settings() -> Settings:
    return Settings()
