# Tiisetso Khumalo — Editorial Portfolio

Vue 3 + **JavaScript** + **Tailwind CSS** + Vite. Vue single-file components follow **`<template>`, `<script setup>`, `<style scoped>`** ordering.

## Repository layout

- `frontend/`: public portfolio, package.json, lockfile, Vite and Tailwind configurations.
- `backend/`: FastAPI foundation (separate Python environment).
- `docs/`: architecture and local development notes.
- `scripts/`: safe local synchronisation script.

## Local frontend setup

Run the frontend commands **from the frontend folder**, not the repository root:

```powershell
cd frontend
npm ci
npm run dev
npm run build
```

Open the localhost URL printed by Vite (normally http://localhost:5173). For a hosting provider such as Vercel, set the **Root Directory** to `frontend`; use the Vite build command `npm run build` and output directory `dist` relative to that root.

## Current milestone

- Light-editorial responsive home, work, about, logbook and contact pages.
- Dynamic magazine-style project case-study routes (`/work/:slug`).
- Placeholder visual slots await actual approved application screenshots and a portrait.
- Content is temporarily held in `frontend/src/data/projects.js` until the admin-backed CMS is implemented.

## Planned milestones

- FastAPI + Supabase-backed protected admin/CMS and image uploads.
- Visitor analytics with appropriate privacy controls.
- Grounded portfolio chatbot with a secured backend.

Do not commit API keys, confidential client information or unapproved screenshots.
