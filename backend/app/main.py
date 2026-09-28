"""Portfolio API foundation. Admin mutations remain intentionally unimplemented until auth and RLS are in place."""
from fastapi import FastAPI

app = FastAPI(title="Tiisetso Portfolio API", version="0.1.0")

@app.get("/health", tags=["system"])
def health():
    return {"status": "ok"}
