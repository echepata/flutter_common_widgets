#!/bin/bash

# Function to increase the version number based on user input
increase_version() {
  local current_version="$1"
  local change_type="$2"

  # Split the version into major, minor, and patch parts
  IFS='.' read -r -a version_parts <<< "$current_version"
  major="${version_parts[0]}"
  minor="${version_parts[1]}"
  patch="${version_parts[2]}"

  case "$change_type" in
    "major")
      major=$((major + 1))
      minor=0
      patch=0
      ;;
    "minor")
      minor=$((minor + 1))
      patch=0
      ;;
    "patch")
      patch=$((patch + 1))
      ;;
    *)
      echo "Invalid change type. Please choose 'major', 'minor', or 'patch'."
      exit 1
      ;;
  esac

  echo "$major.$minor.$patch"
}

# Ask the user for change type and description
while true; do
  read -p "Enter change type (major/minor/patch): " change_type
  case "$change_type" in
    "major"|"minor"|"patch")
      break
      ;;
    *)
      echo "Invalid change type. Please choose 'major', 'minor', or 'patch'."
      ;;
  esac
done
read -p "Enter a short sentence or paragraph describing the change: " change_description

# Get the current version from pubspec.yaml
current_version=$(grep "version:" pubspec.yaml | awk '{print $2}')

# Calculate the new version number
new_version=$(increase_version "$current_version" "$change_type")

# Update pubspec.yaml with the new version number
sed -i "s/version: $current_version/version: $new_version/" pubspec.yaml

# Create a release branch if change is not "patch"
if [ "$change_type" != "patch" ]; then
  release_branch="release/v$(echo "$new_version" | cut -d. -f1,2)"
  git checkout -b "$release_branch"

  # Set the upstream branch
  git push --set-upstream origin "$release_branch"
fi

# Prepend change description to CHANGELOG.md
changelog_file="CHANGELOG.md"
changelog_title="## Version $new_version - $(date +%Y-%m-%d)"
changelog_entry="* $change_description"

# Create a temporary file to store the updated content
temp_file="temp_changelog.md"
echo -e "$changelog_title\n$changelog_entry\n$(cat $changelog_file)" > "$temp_file"

# Overwrite the original CHANGELOG.md with the updated content
mv "$temp_file" "$changelog_file"

# Delete the temporary file
rm -f "$temp_file"

# Commit and push changes to Git
git add pubspec.yaml "$changelog_file"
git commit -m "autogenerated version update"
git push

echo "Version $new_version created and pushed to Git."
