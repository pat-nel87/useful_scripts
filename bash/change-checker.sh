#!/bin/bash

# Define the directories you want to check
DIRECTORIES=("dir1" "dir2" "dir3")

# Get the last commit hash
last_commit_hash=$(git rev-parse HEAD)

# Get the files changed in the last commit
changed_files=$(git diff-tree --no-commit-id --name-only -r $last_commit_hash)

# Set a variable that defaults to true
changes_outside_directories="true"

# Loop through each changed file
for file in $changed_files
do
  # Loop through each directory
  for dir in "${DIRECTORIES[@]}"
  do
    # If the file is in the directory
    if [[ $file == $dir* ]]
    then
      # Then set the variable to false and break
      changes_outside_directories="false"
      break
    fi
  done
done

echo $changes_outside_directories
