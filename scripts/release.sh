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

branch_name="v1"

echo "Forcing $branch_name to be current head"
git branch --force "$branch_name"
git checkout "$branch_name"

echo "Committing new content"
echo "!dist" >> .gitignore

git add dist

git commit -m "Build assets"

git checkout -- .gitignore 

git tag -a "$version" --force --message "Branch: $branch_name\n\nVersion:$version"

git push origin --force "$branch_name"

git push origin --force "refs/tags/$version:refs/tags/$version"

echo "Returning to $current_branch"
git checkout "$current_branch"