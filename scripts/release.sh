#!/usr/bin/env bash

# exit when any command fails
set -e

# Retrieve version from package.json
version="v$(cat package.json | jq --raw-output ".version")"

# Check for an existing tag
existing_tag=$(git ls-remote --tags --quiet origin "$version")

if [[ -n "$existing_tag" ]]; then
  echo "Tag for this version already exists. Exiting without release. Version: $version"
  exit 0
fi

# Split the version by full-stop, taking the first and second segments
major_version=$(echo "$version" | cut -d "." -f 1)
minor_version=$(echo "$version" | cut -d "." -f 2)

# Detach so we don't affect the current branch
git checkout --detach

# Add the dist folder even though it's ignored
git add --force dist

# Create a new commit with the compiled assets
git commit --message "$version"

# Apply Changeset Tags / Releases
changeset tag

# Apply additional flexible-version tags. E.g. v1 and v1.0
git tag --force "$major_version"
git tag --force "$major_version.$minor_version"

# Push tags, override existing when required
git push --force --tags