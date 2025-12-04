#!/bin/bash
#
# Script to create a zipped tar (.tgz) for all edited subpackages we need in `desktop.`
#
# It checks out the `desktop-tgz` branch, packs subpackages using `npm pack`, commits new .tgz
# files to Git and creates a tag to have a stable reference we can then use in `desktop`.
#
# The `desktop-tgz` is only used for automatic .tgz publishing and is always overwritten by this script.
set -euo pipefail

PACKAGES=(
  "delivery-electron"
  "electron"
  "plugin-electron-app"
  "plugin-electron-client-state-persistence"
)
TGZ_DIR="tgz"
BRANCH=$(git rev-parse --abbrev-ref HEAD)
TGZ_BRANCH="desktop-tgz"

if [ "$BRANCH" != "desktop" ]; then
  echo "❌ Script must be run on the 'desktop' branch. Current branch is '$BRANCH'."
  exit 1
fi

if [ -n "$(git status --porcelain)" ]; then
  echo "❌ Uncommitted changes detected on '$BRANCH'. Commit or stash them first."
  exit 1
fi

echo "Checking out branch ${TGZ_BRANCH}..."
git branch -f "$TGZ_BRANCH" "$BRANCH"
git checkout "$TGZ_BRANCH"

mkdir -p "$TGZ_DIR"

echo "Packing packages..."
for PACKAGE in "${PACKAGES[@]}"; do
  echo "• ${PACKAGE}"
  PACKAGE_TGZ=$(npm pack "./packages/$PACKAGE" --pack-destination "$TGZ_DIR")
  echo "✓ $PACKAGE → $PACKAGE_TGZ"
  echo
done

MAIN_PACKAGE_VERSION="$(node -p "require('./packages/electron/package.json').version")"
TAG="desktop-v$MAIN_PACKAGE_VERSION"

EXISTING_TAGS=$(git tag -l "$TAG*")
# tag already exists, append -1, -2, -3...
if [ -n "$EXISTING_TAGS" ]; then
  EXISTING_SUFFIXES=$(echo "$EXISTING_TAGS" | sed "s/^$TAG-//" | sort -n)

  if [ -z "$EXISTING_SUFFIXES" ]; then
      NEXT_SUFFIX=1
  else
      LAST_SUFFIX=$(echo "$EXISTING_SUFFIXES" | tail -n1)
      NEXT_SUFFIX=$((LAST_SUFFIX + 1))
  fi

  TAG="${TAG}-${NEXT_SUFFIX}"
fi

echo "Adding ${TGZ_DIR} to Git and committing..."
git add "$TGZ_DIR"
git commit -m "Pack .tgz packages for $TAG"
git push -f origin "$TGZ_BRANCH"

echo "Creating tag: $TAG..."
git tag "$TAG"
git push origin "$TAG"

echo
echo "📦 Download URLs for your .tgz packages:"
for TGZ_PATH in "$TGZ_DIR"/*.tgz; do
  echo "  https://raw.githubusercontent.com/Paperpile/bugsnag-js/refs/tags/$TAG/$TGZ_PATH"
done

git checkout "$BRANCH"
