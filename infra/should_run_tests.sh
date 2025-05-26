#!/bin/bash
# should_run_tests.sh
# Usage: bash infra/should_run_tests.sh <base_ref> <sha>
# Returns 0 if tests should run, 1 otherwise

BASE_REF="$1"
SHA="$2"

# Get the list of changed files
if [ -n "$BASE_REF" ] && [ -n "$SHA" ]; then
  # If both base_ref and sha are provided, compare them
  CHANGED=$(git diff --name-only "$BASE_REF" "$SHA")
elif git rev-parse --verify HEAD^ >/dev/null 2>&1; then
  # If HEAD^ exists, compare with it
  CHANGED=$(git diff --name-only HEAD^ HEAD)
else
  # If neither exists, compare with the default branch
  DEFAULT_BRANCH=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
  CHANGED=$(git diff --name-only "origin/$DEFAULT_BRANCH" HEAD)
fi

# If no changes found, exit with 1 (skip tests)
if [ -z "$CHANGED" ]; then
  echo "No changes found. Skipping tests."
  exit 1
fi

# Check if any changed files match our criteria
for file in $CHANGED; do
  if [[ "$file" =~ ^test/ ]] || [[ "$file" =~ ^infra/ ]] || [[ "$file" =~ \.lua$ ]]; then
    echo "Found changes in test/, infra/, or .lua files. Running tests."
    exit 0
  fi
done

echo "No test/ infra/ or .lua changes. Skipping tests."
exit 1 