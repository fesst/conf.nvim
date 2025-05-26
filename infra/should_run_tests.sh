#!/bin/bash
# should_run_tests.sh
# Usage: bash infra/should_run_tests.sh <base_ref> <sha>
# Returns:
#   0 - Tests should run
#   1 - Tests should be skipped
#   2 - Error occurred

# Remove set -e to handle errors more gracefully
# set -e  # Exit on any error

BASE_REF="$1"
SHA="$2"

# Get the list of changed files
if [ -n "$BASE_REF" ] && [ -n "$SHA" ]; then
  # If both base_ref and sha are provided, compare them
  if ! CHANGED=$(git diff --name-only "$BASE_REF" "$SHA" 2>/dev/null); then
    echo "Error: Could not compare $BASE_REF with $SHA"
    echo "Tip: Make sure both commits are fetched. Try: git fetch origin $BASE_REF && git fetch origin $SHA"
    echo "Unexpected error occurred (exit code: 2). Running tests to be safe."
    exit 0  # Run tests when in doubt
  fi
elif git rev-parse --verify HEAD^ >/dev/null 2>&1; then
  # If HEAD^ exists, compare with it
  if ! CHANGED=$(git diff --name-only HEAD^ HEAD 2>/dev/null); then
    echo "Error: Could not compare HEAD^ with HEAD"
    echo "Unexpected error occurred. Running tests to be safe."
    exit 0  # Run tests when in doubt
  fi
else
  # If neither exists, try to get the base branch from GitHub context
  if [ -n "$GITHUB_BASE_REF" ]; then
    # Use the base branch from the pull request
    if ! CHANGED=$(git diff --name-only "origin/$GITHUB_BASE_REF" HEAD 2>/dev/null); then
      echo "Error: Could not compare origin/$GITHUB_BASE_REF with HEAD"
      echo "Unexpected error occurred. Running tests to be safe."
      exit 0  # Run tests when in doubt
    fi
  else
    # If all else fails, run the tests to be safe
    echo "Could not determine base branch. Running tests to be safe."
    exit 0
  fi
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

echo "No test/infra/.lua changes. Skipping tests."
exit 1 