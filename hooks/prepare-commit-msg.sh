#!/bin/bash
# Remove AI assistant signatures from commit messages

COMMIT_MSG_FILE=$1
COMMIT_SOURCE=$2

# Only process if this is a regular commit (not merge, squash, etc.)
if [ -z "$COMMIT_SOURCE" ] || [ "$COMMIT_SOURCE" = "message" ]; then
  # Remove AI signature lines
  sed -i.bak '/^🤖 Generated with.*Claude Code/d' "$COMMIT_MSG_FILE"
  sed -i.bak '/^Co-Authored-By: Claude/d' "$COMMIT_MSG_FILE"
  sed -i.bak '/^$/d' "$COMMIT_MSG_FILE"  # Remove empty lines
  rm -f "${COMMIT_MSG_FILE}.bak"
fi
