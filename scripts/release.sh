changed_files=$(git status --porcelain)

if [[ -n "$changed_files" ]]; then
  echo "Error: Unable to release with pending changes"
  echo "$changed_files"
  exit 1
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

git checkout -- .gitignore 

echo "Returning to $current_branch"
git checkout "$current_branch"