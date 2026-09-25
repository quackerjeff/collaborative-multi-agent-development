# Repository Bootstrapping

Use `scripts/seed-repo.sh` on macOS/Linux or `scripts/seed-repo.ps1` on Windows to create a new service repository from Collaborative Multi-Agent Development (CMD).

## Requirements

- `CMD_LOCATION` environment variable pointing to the canonical CMD repository
- `bash` for macOS/Linux bootstrap
- `PowerShell` for Windows bootstrap
- `git`

macOS/Linux example:

```bash
export CMD_LOCATION=~/Development/AI/codex-multiagent-development
$CMD_LOCATION/scripts/seed-repo.sh --type ui storefront-web
```

Windows PowerShell example:

```powershell
$env:CMD_LOCATION = "C:\Development\AI\codex-multiagent-development"
& "$env:CMD_LOCATION\scripts\seed-repo.ps1" -Type ui -ProjectName storefront-web
```

## Supported Repository Types

- `ui`
  Frontend applications and user-facing web surfaces.
- `api`
  Backend services and synchronous APIs.
- `worker`
  Background jobs, schedulers, queue consumers, and async processors.
- `data`
  Database, schema, migration, and data-oriented repositories.
- `fullstack`
  Repositories containing both UI and backend delivery concerns.
- `platform`
  Infrastructure, CI/CD, deployment, and operational repositories.

## What The Script Does

The bootstrap script:

1. creates the target directory
2. copies shared CMD assets listed in the manifests for the selected repo type
3. renders local bootstrap files such as `AGENTS.md`, `SYSTEM_CONTEXT.md`, `README.md`, `docs/tech.md`, and `.gitignore`
4. creates `.codex/specs/`
5. initializes a git repository unless `--no-git-init` is passed

## Usage

```bash
seed-repo.sh --type <ui|api|worker|data|fullstack|platform> <project-name>
```

```powershell
seed-repo.ps1 -Type <ui|api|worker|data|fullstack|platform> -ProjectName <project-name>
```

Optional flags:

- `--dest <directory>`
  Create the project under a specific parent directory. Default is the current working directory.
- `--no-git-init`
  Skip `git init`.
- `--help`
  Show usage.

PowerShell parameters:

- `-Dest <directory>`
  Create the project under a specific parent directory. Default is the current working directory.
- `-NoGitInit`
  Skip `git init`.

## Manifests

Profile manifests live under `templates/profiles/`.

- `base.txt`
  Shared CMD assets copied into every seeded repository.
- `<type>.txt`
  Type-specific CMD assets copied into the target repository.

Keep the manifests small and intentional. They should contain only the shared files that are broadly useful for that repo profile.

## Repo-Local Files Created By The Script

Each seeded repository gets local bootstrap files that should be customized:

- `AGENTS.md`
- `SYSTEM_CONTEXT.md`
- `README.md`
- `docs/tech.md`
- `.gitignore`

The script points `AGENTS.md` back to the canonical CMD source using `CMD_LOCATION`, but local repo instructions still take precedence.

## Recommended Next Steps After Seeding

1. Replace placeholders in `AGENTS.md` and `SYSTEM_CONTEXT.md`.
2. Add repo-specific runtime, contract, and environment notes in `docs/tech.md`.
3. Review the copied `agents/`, `steering/`, and `prompts/` files and remove anything that truly does not fit the repo.
4. Start the first scoped spec under `.codex/specs/`.

For a concrete walkthrough of the first session in a seeded `ui` repo, see [FIRST_UI_REPO_SESSION.md](FIRST_UI_REPO_SESSION.md).
For a concrete walkthrough of the first session in a seeded `api` repo, see [FIRST_API_REPO_SESSION.md](FIRST_API_REPO_SESSION.md).
For a concrete walkthrough of the first session in a seeded `worker` repo, see [FIRST_WORKER_REPO_SESSION.md](FIRST_WORKER_REPO_SESSION.md).
For a concrete walkthrough of the first session in a seeded `platform` repo, see [FIRST_PLATFORM_REPO_SESSION.md](FIRST_PLATFORM_REPO_SESSION.md).
