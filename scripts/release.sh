#!/usr/bin/env bash

# exit when any command fails
set -e

version="v$(cat package.json | jq --raw-output ".version")"

echo "Checking for existing tag"
existing_tag=$(git ls-remote --tags -q origin "$version")

if [[ -n "$existing_tag" ]]; then
  echo "Warning: Tag for this version already exists. Exiting without action. $version"
  exit 0
fi

changed_files=$(git status --porcelain)

if [[ -n "$changed_files" ]]; then
  echo "Error: Unable to release with pending changes"
  echo "$changed_files"
  exit 1
fi

pnpm build

current_branch=$(git branch --show-current)

if [[ $current_branch != "master" ]]; then
  echo "Releasing from non-master branch is not supported"
  exit 1
fi

branch_name=$(echo "$version" | cut -d "." -f 1)

git checkout --detach

echo "Committing new content"

git add --force dist

git commit --message "$version"

changeset tag

git push --force --follow-tags origin "HEAD:refs/heads/${branch}"