#!/usr/bin/env bash

# exit when any command fails
set -e

version="v$(cat package.json | jq --raw-output ".version")"

existing_tag=$(git ls-remote --tags -q origin "$version")

if [[ -n "$existing_tag" ]]; then
  echo "Warning: Tag for this version already exists. Exiting without action. Version: $version"
  exit 0
fi

branch_name=$(echo "$version" | cut -d "." -f 1)

git checkout --detach

git add --force dist

git commit --message "$version"

changeset tag

git push --force --follow-tags origin "HEAD:refs/heads/${branch_name}"