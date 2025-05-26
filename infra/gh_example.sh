#!/bin/bash

# One line to create a new pull request
git checkout -b my-branch && git add . && git commit -m "${1}" && git push -u origin my-branch && gh pr create --fill


# List all open pull requests
echo "Listing open pull requests..."
gh pr list

# Create a new pull request
echo -e "\nCreating a new pull request..."
gh pr create --title "ci: run workflow only on default branch" --body "Update CI workflow to run only on the default branch"


# Add an approval comment to a specific PR
echo -e "\nAdding approval comment to PR #11..."
gh pr comment 11 --body "APPROVED"

# List recent workflow runs
echo -e "\nListing recent workflow runs..."
gh run list --limit 1

# View details of a specific workflow run
echo -e "\nViewing workflow run details..."
gh run view 15202918864

# View failed logs of a specific workflow run
echo -e "\nViewing failed logs..."
gh run view 15202918864 --log-failed

# Note: To fix the auto-approve workflow, you need to:
# 1. Go to repository settings on GitHub
# 2. Navigate to Actions > General
# 3. Under "Workflow permissions", enable "Read and write permissions"
# 4. Save the changes 