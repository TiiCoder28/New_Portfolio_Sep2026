from typing import Literal
from pydantic import BaseModel, Field, HttpUrl

Slug = str


class ProjectCreate(BaseModel):
    slug: str = Field(pattern=r"^[a-z0-9]+(?:-[a-z0-9]+)*$", max_length=100)
    title: str = Field(min_length=1, max_length=180)
    summary: str = Field(default="", max_length=1200)
    category: str = Field(default="", max_length=100)
    hero_asset_path: str | None = Field(default=None, max_length=500)
    github_url: HttpUrl | None = None
    live_url: HttpUrl | None = None
    featured: bool = False
    sort_order: int = 0
    status: Literal["draft", "published", "archived"] = "draft"


class ProjectPatch(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=180)
    summary: str | None = Field(default=None, max_length=1200)
    category: str | None = Field(default=None, max_length=100)
    hero_asset_path: str | None = Field(default=None, max_length=500)
    github_url: HttpUrl | None = None
    live_url: HttpUrl | None = None
    featured: bool | None = None
    sort_order: int | None = None
    status: Literal["draft", "published", "archived"] | None = None


class PostCreate(BaseModel):
    slug: str = Field(pattern=r"^[a-z0-9]+(?:-[a-z0-9]+)*$", max_length=100)
    title: str = Field(min_length=1, max_length=180)
    excerpt: str = Field(default="", max_length=1200)
    category: str | None = Field(default=None, max_length=100)
    cover_asset_path: str | None = Field(default=None, max_length=500)
    status: Literal["draft", "published", "archived"] = "draft"


class PostPatch(BaseModel):
    title: str | None = Field(default=None, min_length=1, max_length=180)
    excerpt: str | None = Field(default=None, max_length=1200)
    category: str | None = Field(default=None, max_length=100)
    cover_asset_path: str | None = Field(default=None, max_length=500)
    status: Literal["draft", "published", "archived"] | None = None
