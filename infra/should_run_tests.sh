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

# Ensure git repository is initialized
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: Not in a git repository"
    exit 2
fi

# Ensure we have the latest changes
if git rev-parse --is-shallow-repository >/dev/null 2>&1; then
    git fetch --unshallow 2>/dev/null || true
fi
git fetch origin 2>/dev/null || true

# Get the list of changed files
if [ -n "$BASE_REF" ] && [ -n "$SHA" ]; then
    # If both base_ref and sha are provided, compare them
    if ! git fetch origin "$BASE_REF" "$SHA" 2>/dev/null; then
        echo "Warning: Could not fetch commits, using local comparison"
        if ! CHANGED=$(git diff --name-only "$BASE_REF" "$SHA" 2>/dev/null); then
            echo "Error: Could not compare commits locally"
            echo "Running tests to be safe."
            exit 0
        fi
    else
        if ! CHANGED=$(git diff --name-only "origin/$BASE_REF" "$SHA" 2>/dev/null); then
            echo "Error: Could not compare origin/$BASE_REF with $SHA"
            echo "Running tests to be safe."
            exit 0
        fi
    fi
elif git rev-parse --verify HEAD^ >/dev/null 2>&1; then
    # If HEAD^ exists, compare with it
    if ! CHANGED=$(git diff --name-only HEAD^ HEAD 2>/dev/null); then
        echo "Error: Could not compare HEAD^ with HEAD"
        echo "Running tests to be safe."
        exit 0
    fi
else
    # If neither exists, try to get the base branch from GitHub context
    if [ -n "$GITHUB_BASE_REF" ]; then
        # Use the base branch from the pull request
        if ! git fetch origin "$GITHUB_BASE_REF" 2>/dev/null; then
            echo "Warning: Could not fetch base branch, using local comparison"
            if ! CHANGED=$(git diff --name-only "$GITHUB_BASE_REF" HEAD 2>/dev/null); then
                echo "Error: Could not compare branches locally"
                echo "Running tests to be safe."
                exit 0
            fi
        else
            if ! CHANGED=$(git diff --name-only "origin/$GITHUB_BASE_REF" HEAD 2>/dev/null); then
                echo "Error: Could not compare origin/$GITHUB_BASE_REF with HEAD"
                echo "Running tests to be safe."
                exit 0
            fi
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
    if [[ "$file" =~ ^test/ ]] || \
       [[ "$file" =~ ^infra/ ]] || \
       [[ "$file" =~ ^\.github/workflows/ ]] || \
       [[ "$file" =~ \.lua$ ]]; then
        echo "Found changes in test/, infra/, .github/workflows/, or .lua files. Running tests."
        exit 0
    fi
done

echo "No test/infra/.lua changes. Skipping tests."
exit 1
