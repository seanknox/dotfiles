#!/bin/bash

# Create directory if it doesn't exist
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"

# Create config file with proper content
cat > "$HOME/Library/Application Support/com.mitchellh.ghostty/config" << EOF
clipboard-read=allow
clipboard-write=allow
copy-on-select=clipboard
EOF

echo "Ghostty configuration has been installed."
