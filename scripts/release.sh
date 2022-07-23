if [[ `git status --porcelain` ]]; then
  git status
  echo "Unable to release with pending changes"
  exit 1
else
  echo "Confirmed no pending changes"
fi

pnpm build

current_branch=$(git branch --show-current)

if [[current_branch != "master"]]; then
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

echo "Returning to $current_branch"
git checkout "$current_branch"