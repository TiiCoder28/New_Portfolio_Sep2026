# Portfolio image manifest

Copy the contents of the supplied asset ZIP into the repository root; its paths begin with `frontend/public/images/`. **Do not place assets under `frontend/src`**. The Vite dev server serves them from `/images/...`.

- `images/portrait.jpg`: supplied formal portrait, displayed on About.
- `images/contentforge/hero.webp`: actual landing-page screenshot.
- `images/contentforge/editor.webp`: actual content editor screenshot.
- `images/contentforge/media.webp`: actual image replacement flow, including a visible storage quota error (kept as a real development state).
- `images/betbetter/logo.png`: user-supplied original BetBetter branding. Extract the separate logo ZIP at the repository root.
- `images/betbetter/hero.webp`: actual fixture screen.
- `images/betbetter/markets.webp`: bookmaker market tables.
- `images/betbetter/model-review.webp`: confidence/risk analysis.
- `images/betbetter/odds-movement.webp`: historical market line graph.
- `images/betbetter/history-empty.webp`: empty history state.
- `images/betbetter/privacy-memory.webp`: privacy request and candidate memory screens.

Only one professional portrait was selected for publication. The other portrait remains available privately for a later design choice. MineSafe slide screenshots are **not** actual app captures and have not been published.

After extracting assets from the ZIP at repository root:

```powershell
git status
git add frontend/public/images
git commit -m "assets: add approved personal portrait and project screenshots"
git push
cd frontend
npm install
npm run build
npm run dev
```

To push onto this PR branch, switch to `feature/real-project-case-studies` first, after checking/committing any local work. Otherwise the ZIP can be extracted after merging this PR, with a separate assets commit.

Ensure the images and any visible sample information may be publicly shared. Do not publish client screenshots without permission. External GitHub/demo links remain intentionally blank until verified.
