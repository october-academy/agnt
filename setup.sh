#!/usr/bin/env bash
set -euo pipefail

# Agentic30 agnt plugin — post-install setup
# Copies references to .claude/agnt/ and initializes state.json

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR=".claude/agnt"

echo "Setting up agnt..."

# Determine source: either local clone or plugin cache
if [[ -d "$SCRIPT_DIR/references" ]]; then
  SOURCE_DIR="$SCRIPT_DIR"
else
  echo "Error: references/ directory not found in $SCRIPT_DIR"
  echo "Run this script from the agnt repository root."
  exit 1
fi

# Create target directory
mkdir -p "$TARGET_DIR"

# Copy references
if command -v rsync >/dev/null 2>&1; then
  rsync -a "$SOURCE_DIR/references/" "$TARGET_DIR/references/"
else
  cp -R "$SOURCE_DIR/references" "$TARGET_DIR/"
fi
echo "  Copied references/ → $TARGET_DIR/references/"

# Initialize state.json (preserve existing)
STATE_FILE="$TARGET_DIR/state.json"
if [[ ! -f "$STATE_FILE" ]]; then
  cat > "$STATE_FILE" <<'EOF'
{"currentDay":0,"currentBlock":0,"completedDays":[],"completedBlocks":{},"choices":[],"character":null,"interview":null,"authenticated":false}
EOF
  echo "  Initialized state.json"
else
  echo "  state.json already exists (preserved)"
fi

# Merge MCP server into .mcp.json
MCP_FILE=".mcp.json"
MCP_URL="https://mcp.agentic30.app/mcp"

if command -v node >/dev/null 2>&1; then
  node -e "
const fs = require('fs');
let raw = {};
if (fs.existsSync('$MCP_FILE')) {
  raw = JSON.parse(fs.readFileSync('$MCP_FILE', 'utf8'));
}
if (!raw.mcpServers) raw.mcpServers = {};
if (raw.mcpServers.agentic30 && raw.mcpServers.agentic30.url === '$MCP_URL') {
  console.log('  MCP agentic30 already configured');
} else {
  raw.mcpServers.agentic30 = { type: 'http', url: '$MCP_URL' };
  fs.writeFileSync('$MCP_FILE', JSON.stringify(raw, null, 2) + '\n');
  console.log('  Added agentic30 MCP server to .mcp.json');
}
"
elif command -v bun >/dev/null 2>&1; then
  bun -e "
const fs = require('fs');
let raw = {};
if (fs.existsSync('$MCP_FILE')) {
  raw = JSON.parse(fs.readFileSync('$MCP_FILE', 'utf8'));
}
if (!raw.mcpServers) raw.mcpServers = {};
if (raw.mcpServers.agentic30 && raw.mcpServers.agentic30.url === '$MCP_URL') {
  console.log('  MCP agentic30 already configured');
} else {
  raw.mcpServers.agentic30 = { type: 'http', url: '$MCP_URL' };
  fs.writeFileSync('$MCP_FILE', JSON.stringify(raw, null, 2) + '\n');
  console.log('  Added agentic30 MCP server to .mcp.json');
}
"
else
  echo "  Skipped MCP merge (node/bun not found). Add manually to .mcp.json:"
  echo "    \"agentic30\": { \"type\": \"http\", \"url\": \"$MCP_URL\" }"
fi

echo ""
echo "Done! Start with: /agnt:continue"
