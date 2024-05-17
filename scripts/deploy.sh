#!/bin/bash
GIT_BRANCH=$(git symbolic-ref -q HEAD)
GIT_REPO_URL=$(git config --get remote.origin.url)
BUILD_FOLDER=".build"

# Ensure there are no local changes
if ! git diff-index --quiet HEAD --; then
  echo "ERROR: Local file changes. Commit or stash them first! Aborting!" && exit 1
fi

# Build
# npm run build

# Deploy & setup
mkdir $BUILD_FOLDER
cd $BUILD_FOLDER
git init .
git remote add origin $GIT_REPO_URL
git checkout -b gh-pages || (echo "Cannot chekout gh-pages branch!" && exit 1)
# git pull origin gh-pages --rebase || (echo "Unable to pull remote changes on gh-pages branch!" && exit 1)

# Add CNAME file if present
cp ../CNAME .

# Ensure static assets can be served properly
touch .nojekyll

git add .
git commit -am "Static site deploy"
git push origin gh-pages --force
cd ..
rm -rf $BUILD_FOLDER

# Restore
git checkout main
