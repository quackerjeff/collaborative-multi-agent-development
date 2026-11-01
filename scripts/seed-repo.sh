#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage:
  seed-repo.sh --type <ui|api|worker|data|fullstack|platform|ios> [--dest <directory>] [--no-git-init] <project-name>

Environment:
  CMD_LOCATION   Path to the canonical Collaborative Multi-Agent Development repository.
USAGE
}

fail() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

require_command() {
  command -v "$1" >/dev/null 2>&1 || fail "Required command not found: $1"
}

render_template() {
  local src="$1"
  local dest="$2"
  sed \
    -e "s|__PROJECT_NAME__|$PROJECT_NAME|g" \
    -e "s|__REPO_TYPE__|$REPO_TYPE|g" \
    -e "s|__CMD_LOCATION__|$CMD_ROOT|g" \
    "$src" > "$dest"
}

copy_profile_assets() {
  local combined_manifest
  combined_manifest="$(mktemp)"
  cat "$CMD_ROOT/templates/profiles/base.txt" "$CMD_ROOT/templates/profiles/$REPO_TYPE.txt" \
    | awk 'NF && $1 !~ /^#/' \
    | sort -u > "$combined_manifest"

  while IFS= read -r rel_path; do
    [ -n "$rel_path" ] || continue
    local src="$CMD_ROOT/$rel_path"
    local dest="$TARGET_DIR/$rel_path"
    [ -f "$src" ] || fail "Manifest entry does not exist: $rel_path"
    mkdir -p "$(dirname "$dest")"
    cp "$src" "$dest"
  done < "$combined_manifest"

  rm -f "$combined_manifest"
}

copy_gitignore() {
  local gitignore_tmpl="$CMD_ROOT/templates/repo/gitignore.tmpl"
  if [ -f "$CMD_ROOT/templates/repo/gitignore-${REPO_TYPE}.tmpl" ]; then
    gitignore_tmpl="$CMD_ROOT/templates/repo/gitignore-${REPO_TYPE}.tmpl"
  fi
  cp "$gitignore_tmpl" "$TARGET_DIR/.gitignore"
}

copy_ios_scaffold() {
  local ios_tmpl="$CMD_ROOT/templates/ios"

  mkdir -p "$TARGET_DIR/Sources" "$TARGET_DIR/Tests" "$TARGET_DIR/Resources/Assets.xcassets/AppIcon.appiconset"

  render_template "$ios_tmpl/project.yml.tmpl" "$TARGET_DIR/project.yml"
  render_template "$ios_tmpl/Sources/App.swift.tmpl" "$TARGET_DIR/Sources/App.swift"
  render_template "$ios_tmpl/Sources/ContentView.swift.tmpl" "$TARGET_DIR/Sources/ContentView.swift"
  render_template "$ios_tmpl/Resources/Info.plist.tmpl" "$TARGET_DIR/Resources/Info.plist"
  render_template "$ios_tmpl/Tests/ContentViewTests.swift.tmpl" "$TARGET_DIR/Tests/ContentViewTests.swift"

  cp "$ios_tmpl/Resources/Assets.xcassets/Contents.json" "$TARGET_DIR/Resources/Assets.xcassets/Contents.json"
  cp "$ios_tmpl/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json" "$TARGET_DIR/Resources/Assets.xcassets/AppIcon.appiconset/Contents.json"

  mkdir -p "$TARGET_DIR/scripts"
  render_template "$ios_tmpl/bootstrap.sh.tmpl" "$TARGET_DIR/scripts/bootstrap.sh"
  chmod +x "$TARGET_DIR/scripts/bootstrap.sh"
}

init_repo() {
  if [ "$DO_GIT_INIT" = "true" ]; then
    git -C "$TARGET_DIR" init >/dev/null
  fi
}

REPO_TYPE=""
DEST_ROOT="$PWD"
DO_GIT_INIT="true"

while [ $# -gt 0 ]; do
  case "$1" in
    --type)
      [ $# -ge 2 ] || fail "--type requires a value"
      REPO_TYPE="$2"
      shift 2
      ;;
    --dest)
      [ $# -ge 2 ] || fail "--dest requires a value"
      DEST_ROOT="$2"
      shift 2
      ;;
    --no-git-init)
      DO_GIT_INIT="false"
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    --*)
      fail "Unknown option: $1"
      ;;
    *)
      if [ -n "${PROJECT_NAME:-}" ]; then
        fail "Only one project name may be provided"
      fi
      PROJECT_NAME="$1"
      shift
      ;;
  esac
done

[ -n "$REPO_TYPE" ] || {
  usage
  fail "Missing required --type"
}

case "$REPO_TYPE" in
  ui|api|worker|data|fullstack|platform|ios)
    ;;
  *)
    fail "Unsupported repo type: $REPO_TYPE"
    ;;
esac

[ -n "${PROJECT_NAME:-}" ] || {
  usage
  fail "Missing required <project-name>"
}

[ -n "${CMD_LOCATION:-}" ] || fail "CMD_LOCATION must be set"
CMD_ROOT="${CMD_LOCATION%/}"

[ -d "$CMD_ROOT" ] || fail "CMD_LOCATION does not point to a directory: $CMD_ROOT"
[ -f "$CMD_ROOT/templates/profiles/base.txt" ] || fail "CMD_LOCATION does not look like a CMD repository: $CMD_ROOT"

require_command git
require_command sed
require_command awk
require_command sort
require_command mktemp

mkdir -p "$DEST_ROOT"
TARGET_DIR="$DEST_ROOT/$PROJECT_NAME"
[ ! -e "$TARGET_DIR" ] || fail "Target already exists: $TARGET_DIR"

mkdir -p "$TARGET_DIR/.cmd/specs" "$TARGET_DIR/docs"
: > "$TARGET_DIR/.cmd/specs/.gitkeep"

copy_profile_assets

cp "$CMD_ROOT/templates/SATELLITE_AGENTS.md" "$TARGET_DIR/AGENTS.md"
sed -i.bak "s|<replace-with-canonical-cmd-location>|$CMD_ROOT|g" "$TARGET_DIR/AGENTS.md"
rm -f "$TARGET_DIR/AGENTS.md.bak"
cp "$CMD_ROOT/templates/SYSTEM_CONTEXT.md" "$TARGET_DIR/SYSTEM_CONTEXT.md"
render_template "$CMD_ROOT/templates/repo/README.md.tmpl" "$TARGET_DIR/README.md"
render_template "$CMD_ROOT/templates/repo/tech.md.tmpl" "$TARGET_DIR/docs/tech.md"
copy_gitignore

chmod +x "$TARGET_DIR"/scripts/guardrails/*.sh 2>/dev/null || true

if [ "$REPO_TYPE" = "ios" ]; then
  copy_ios_scaffold

  cat >> "$TARGET_DIR/README.md" <<'IOS_README'

## iOS Project Setup

This is a SwiftUI project managed by [XcodeGen](https://github.com/yonaskolb/XcodeGen).

### Bootstrap

Run the bootstrap script to install dependencies and generate the Xcode project:

```bash
scripts/bootstrap.sh
```

The bootstrap script will:
1. Install Homebrew (if not present)
2. Install XcodeGen (if not present)
3. Generate the `.xcodeproj` from `project.yml`
4. Resolve Swift Package Manager dependencies
5. Open the project in Xcode

To skip opening Xcode automatically:

```bash
SKIP_OPEN=true scripts/bootstrap.sh
```

### Project Structure

```
Sources/          SwiftUI application code
Tests/            Unit tests
Resources/        Info.plist, asset catalogs
project.yml       XcodeGen project definition (source of truth)
```

### Regenerating the Xcode Project

After editing `project.yml`, regenerate with:

```bash
xcodegen generate
```
IOS_README
fi

init_repo

printf 'Seeded %s repository at %s\n' "$REPO_TYPE" "$TARGET_DIR"
printf 'Next: replace placeholders in AGENTS.md and SYSTEM_CONTEXT.md\n'
if [ "$REPO_TYPE" = "ios" ]; then
  printf 'Then: run scripts/bootstrap.sh to generate the Xcode project\n'
fi
