#!/bin/sh -l

echo "Script starting"
GITHUB_USERNAME="$1"
GITHUB_REPO="$2"
USER_EMAIL="$3"
REPO_USERNAME="$4"
TARGET_BRANCH="$5"
SOURCE_BRANCH="$6"
REMOTE_NAME="$7"

if [ -z "$REPO_USERNAME" ]
then
  REPO_USERNAME="$GITHUB_USERNAME"
fi

if [ -z "$TARGET_BRANCH" ]
then
  TARGET_BRANCH="master"
fi

if [ -z "$SOURCE_BRANCH" ]
then
  SOURCE_BRANCH="master"
fi

if [ -z "$REMOTE_NAME" ]
then
  REMOTE_NAME="upstream"
fi

# FIXME: removing this as it seems actions automatically checkouts the repo under $GITHUB_WORKSPACE

# CLONE_DIR=$(mktemp -d)

# echo "Cloning source git repository"
# git config --global user.email "$USER_EMAIL"
# git config --global user.name "$GITHUB_USERNAME"
# git clone --single-branch --branch "$SOURCE_BRANCH" "https://$API_TOKEN_GITHUB@github.com/$GITHUB_REPOSITORY.git" "$CLONE_DIR"

cd "$GITHUB_WORKSPACE/main"

echo "Adding destination repository as remote"
git remote add "$REMOTE_NAME" "https://$API_TOKEN_GITHUB@github.com/$REPO_USERNAME/$GITHUB_REPO.git"

echo "Fetching from remote"
git fetch "$REMOTE_NAME"

echo "Merging remote branch into local master"
git merge "$REMOTE_NAME/$TARGET_BRANCH"

echo "Pushing local master to remote branch"
git push "$REMOTE_NAME" "$SOURCE_BRANCH:$TARGET_BRANCH"
