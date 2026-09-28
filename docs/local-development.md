# Local development and safe synchronisation

## First-time setup (Windows PowerShell)

1. Install Node.js 22 LTS and Git.
2. Clone: `git clone https://github.com/TiiCoder28/New_Portfolio_Sep2026.git`
3. `cd New_Portfolio_Sep2026`
4. After the feature branch is merged into main, use `git switch main`, then `npm ci` and `npm run dev`.
5. Open the localhost URL printed by Vite (normally http://localhost:5173).

## Safe updates

Run `powershell -NoProfile -ExecutionPolicy Bypass -File .\\scripts\\Sync-Portfolio.ps1 -Branch main` from the repository folder. The script **stops** if you have uncommitted changes, untracked files, are on another branch, cannot fetch, or need a non-fast-forward merge. It never resets or overwrites work.

To schedule a check every few minutes, configure Windows Task Scheduler to run that command with **Start in** set to your repository path. Scheduling is optional; don't configure an unattended merge of a development branch. Keep `npm run dev` running in a terminal; Vite will pick up changed source files. Run `npm ci` again when dependency manifests change. Restart the dev server if configuration changes require it.

GitHub Actions checks PR builds. A successful CI build is not a substitute for review. Enable main-branch protection requiring the Frontend CI check and PR review before merging; synchronize **main** to get reviewed changes.

Do not use `git reset --hard`, force pulls, or auto-stash/auto-pop in a background script. Never commit `.env` or API credentials.
