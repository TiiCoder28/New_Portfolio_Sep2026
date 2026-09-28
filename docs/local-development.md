# Local development and safe synchronisation

## First-time setup (Windows PowerShell)

1. Install a current Node.js 22 LTS release and Git.
2. Clone: `git clone https://github.com/TiiCoder28/New_Portfolio_Sep2026.git`
3. `cd New_Portfolio_Sep2026`
4. Work on `main` or your chosen feature branch. `cd frontend`, then `npm ci` and `npm run dev`.
5. Open the localhost URL printed by Vite (normally http://localhost:5173).

All frontend tooling and the lockfile are under `frontend/`; do not run `npm run build` at the repository root. From the root you can use `npm --prefix frontend run build`.

## Safe updates

From the repository root, run `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Sync-Portfolio.ps1 -Branch main`. The script stops if you have uncommitted changes, untracked files, are on another branch, cannot fetch, or need a non-fast-forward merge. It never resets or overwrites work.

Optionally configure Windows Task Scheduler to run that command with **Start in** set to your repository root. Keep `npm run dev` running from `frontend/`; Vite refreshes changed source files. Run `npm ci` again when frontend dependency manifests change. Restart the dev server for configuration changes.

GitHub Actions builds from `frontend/` and caches `frontend/package-lock.json`. Successful CI is not a substitute for review; require its check before merging into `main`.

Do not use `git reset --hard`, force pulls or automatic stash/pop in a background script. Never commit `.env` or credentials.
