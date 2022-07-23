#!/usr/bin/env bash

# exit when any command fails
set -e

version="v$(cat package.json | jq --raw-output ".version")"

existing_tag=$(git ls-remote --tags --quiet origin "$version")

if [[ -n "$existing_tag" ]]; then
  echo "Tag for this version already exists. Exiting without release. Version: $version"
  exit 0
fi

branch_name=$(echo "$version" | cut -d "." -f 1)

git checkout --detach

git add --force dist

git commit --message "$version"

changeset tag

git tag "$branch_name.x"

git push --force --follow-tags origin "HEAD:refs/heads/${branch_name}"