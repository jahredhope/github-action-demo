#!/usr/bin/env bash

# exit when any command fails
set -e

version="$1"

if [[ -z "$version" ]]; then
  echo "Error: Missing version argument. $version"
  exit 1
fi

if [[ $version != v* ]]; then
  echo "Error: Version argument does not begin with v. Version recieved: $version"
  exit 1
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

git status

echo "Making back-up"
git branch --force back-up

echo "Making forcing $branch_name to be current head"
git branch --force "$branch_name"
git checkout "$branch_name"

echo "Committing new content"
echo "!dist" >> .gitignore

git add dist

git commit -m "Build assets"

git checkout -- .gitignore 

git tag -a "$version" --force --message "$current_branch - $version"

echo "Returning to $current_branch"
git checkout "$current_branch"