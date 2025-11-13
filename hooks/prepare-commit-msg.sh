#!/bin/bash
# Remove AI assistant signatures from commit messages

COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2

# Only process if this is a regular commit (not merge, squash, etc.)
if [ -z "$COMMIT_SOURCE" ] || [ "$COMMIT_SOURCE" = "message" ]; then
  # Remove AI signature lines (Linux compatible)
  sed -i '/^🤖 Generated with.*Claude Code/d' "$COMMIT_MSG_FILE"
  sed -i '/^Co-Authored-By: Claude/d' "$COMMIT_MSG_FILE"
  # Remove multiple consecutive empty lines, keep only one
  sed -i '/^$/N;/^\n$/D' "$COMMIT_MSG_FILE"
fi
