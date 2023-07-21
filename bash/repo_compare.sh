#!/bin/bash

# Check if the correct number of arguments is provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <json_file> <github_token>"
    exit 1
fi

json_file="$1"
github_token="$2"

# Check if the JSON file exists
if [ ! -f "$json_file" ]; then
    echo "Error: JSON file '$json_file' not found."
    exit 1
fi

# Create a temporary directory to store the repositories
temp_dir=$(mktemp -d)

# Change directory to the temporary directory
cd "$temp_dir" || exit

# Modify the JSON file with the GitHub token
jq ".[] |= (.github_url | sub(\"<TOKEN>\"; \"$github_token\"))" "$json_file" > modified.json

# Assuming your modified JSON data is in 'modified.json'
jq -r 'to_entries[] | "\(.key),\(.value.github_url),\(.value.tfs_url)"' modified.json |
while IFS=',' read -r entry_name github_url tfs_url; do
    # Create a folder based on the name of the entry
    mkdir "$entry_name"
    cd "$entry_name" || exit

    # Clone repositories from github_url and tfs_url
    git clone "$github_url" github
    git clone "$tfs_url" tfs

    # Change back to the original working directory
    cd "$temp_dir" || exit
done

# Clean up the temporary directory
rm -rf "$temp_dir"
