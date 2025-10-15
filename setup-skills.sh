#!/bin/bash
# Setup script for Claude custom skills
# This script sets up all custom skills on a new machine
# Usage: curl -sSL https://raw.githubusercontent.com/lakson-llc/superpowers-skills/main/setup-skills.sh | bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🤖 Claude Custom Skills Setup Script${NC}"
echo "================================================"
echo ""

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check prerequisites
echo -e "${YELLOW}📋 Checking prerequisites...${NC}"

if ! command_exists git; then
    echo -e "${RED}❌ Git is not installed. Please install git first.${NC}"
    exit 1
fi

if ! command_exists gh; then
    echo -e "${YELLOW}⚠️  GitHub CLI (gh) is not installed. Some features may not work.${NC}"
    echo "   Install with: brew install gh (macOS) or https://cli.github.com"
fi

# Backup existing skills if they exist
if [ -d "$HOME/.config/superpowers/skills" ]; then
    echo -e "${YELLOW}📦 Existing skills found. Creating backup...${NC}"
    BACKUP_DIR="$HOME/.config/superpowers/skills.backup.$(date +%Y%m%d-%H%M%S)"
    cp -r "$HOME/.config/superpowers/skills" "$BACKUP_DIR"
    echo -e "${GREEN}✅ Backup created at: $BACKUP_DIR${NC}"
fi

# Clone or update skills repository
echo ""
echo -e "${YELLOW}📥 Setting up skills repository...${NC}"

if [ -d "$HOME/.config/superpowers/skills/.git" ]; then
    echo "Skills directory exists, updating..."
    cd "$HOME/.config/superpowers/skills"

    # Stash any local changes
    if [[ -n $(git status -s) ]]; then
        echo "Stashing local changes..."
        git stash push -m "Auto-stash before update $(date +%Y%m%d-%H%M%S)"
    fi

    # Pull latest changes
    git pull origin main || {
        echo -e "${RED}❌ Failed to pull updates. You may need to resolve conflicts manually.${NC}"
        echo "   Try: cd ~/.config/superpowers/skills && git status"
        exit 1
    }
else
    echo "Cloning custom skills repository..."
    mkdir -p "$HOME/.config/superpowers"
    git clone https://github.com/lakson-llc/superpowers-skills.git \
        "$HOME/.config/superpowers/skills" || {
        echo -e "${RED}❌ Failed to clone repository.${NC}"
        echo "   The repository may be private or doesn't exist."
        echo "   Try cloning manually: git clone https://github.com/lakson-llc/superpowers-skills.git ~/.config/superpowers/skills"
        exit 1
    }
fi

# Set up git remotes
echo -e "${YELLOW}🔗 Configuring git remotes...${NC}"
cd "$HOME/.config/superpowers/skills"

# Remove existing upstream if it exists
git remote remove upstream 2>/dev/null || true

# Add upstream remote for original repository
git remote add upstream https://github.com/obra/superpowers-skills.git
echo -e "${GREEN}✅ Git remotes configured${NC}"

# Install superpowers plugin
echo ""
echo -e "${YELLOW}🔌 Installing superpowers plugin...${NC}"

if [ ! -d "$HOME/.claude/plugins/repos/superpowers" ]; then
    mkdir -p "$HOME/.claude/plugins/repos"
    git clone https://github.com/obra/superpowers.git \
        "$HOME/.claude/plugins/repos/superpowers" || {
        echo -e "${RED}❌ Failed to install superpowers plugin.${NC}"
        exit 1
    }
    echo -e "${GREEN}✅ Superpowers plugin installed${NC}"
else
    echo "Superpowers plugin already installed, updating..."
    cd "$HOME/.claude/plugins/repos/superpowers"
    git pull origin main || echo -e "${YELLOW}⚠️  Could not update plugin${NC}"
fi

# Create plugin configuration
echo ""
echo -e "${YELLOW}⚙️  Configuring plugin...${NC}"
mkdir -p "$HOME/.claude/plugins"

cat > "$HOME/.claude/plugins/config.json" << EOF
{
  "repositories": {
    "superpowers": {
      "source": {
        "source": "github",
        "repo": "obra/superpowers"
      },
      "installLocation": "$HOME/.claude/plugins/repos/superpowers",
      "lastUpdated": "$(date -u +%Y-%m-%dT%H:%M:%S.000Z)",
      "enabled": true
    }
  }
}
EOF

echo -e "${GREEN}✅ Plugin configuration created${NC}"

# Set up command symlinks
echo ""
echo -e "${YELLOW}🔗 Setting up command symlinks...${NC}"
mkdir -p "$HOME/.claude/commands"
cd "$HOME/.claude/commands"

# Remove old symlinks
rm -f *.md 2>/dev/null || true

# Create new symlinks
for file in "$HOME/.claude/plugins/repos/superpowers/commands"/*.md; do
    if [[ -f "$file" && $(basename "$file") != "README.md" ]]; then
        ln -sf "$file" . 2>/dev/null
        echo "  → Linked $(basename "$file")"
    fi
done

echo -e "${GREEN}✅ Command symlinks created${NC}"

# Verify installation
echo ""
echo -e "${YELLOW}🔍 Verifying installation...${NC}"

ERRORS=0

# Check skills
if [ -d "$HOME/.config/superpowers/skills/skills/testing/auto-testing-workflow" ]; then
    echo -e "${GREEN}✓ auto-testing-workflow installed${NC}"
else
    echo -e "${RED}✗ auto-testing-workflow not found${NC}"
    ERRORS=$((ERRORS + 1))
fi

if [ -d "$HOME/.config/superpowers/skills/skills/testing/token-aware-testing" ]; then
    echo -e "${GREEN}✓ token-aware-testing installed${NC}"
else
    echo -e "${RED}✗ token-aware-testing not found${NC}"
    ERRORS=$((ERRORS + 1))
fi

if [ -d "$HOME/.config/superpowers/skills/skills/model-selection/intelligent-model-router" ]; then
    echo -e "${GREEN}✓ intelligent-model-router installed${NC}"
else
    echo -e "${RED}✗ intelligent-model-router not found${NC}"
    ERRORS=$((ERRORS + 1))
fi

if [ -d "$HOME/.config/superpowers/skills/skills/documentation/large-file-management" ]; then
    echo -e "${GREEN}✓ large-file-management installed${NC}"
else
    echo -e "${RED}✗ large-file-management not found${NC}"
    ERRORS=$((ERRORS + 1))
fi

# Check commands
if [ -L "$HOME/.claude/commands/brainstorm.md" ]; then
    echo -e "${GREEN}✓ Commands linked properly${NC}"
else
    echo -e "${RED}✗ Commands not linked${NC}"
    ERRORS=$((ERRORS + 1))
fi

# Final status
echo ""
echo "================================================"
if [ $ERRORS -eq 0 ]; then
    echo -e "${GREEN}🎉 SUCCESS! All custom skills installed successfully!${NC}"
    echo ""
    echo "Available custom skills:"
    echo "  • auto-testing-workflow    - Automatic testing after code changes"
    echo "  • mandatory-dual-verification - Enforced dual testing"
    echo "  • token-aware-testing      - Smart mode selection (83% token savings!)"
    echo "  • intelligent-model-router - QROUTE command for model selection"
    echo "  • large-file-management    - Prevent 256KB file errors"
    echo ""
    echo "Available commands:"
    echo "  • /brainstorm   - Interactive idea refinement"
    echo "  • /write-plan   - Create detailed implementation plan"
    echo "  • /execute-plan - Execute plan with review"
    echo ""
    echo -e "${YELLOW}📚 Documentation:${NC}"
    echo "  ~/.config/superpowers/skills/CUSTOM_SKILLS_README.md"
    echo ""
    echo -e "${GREEN}✨ Happy coding with Claude!${NC}"
else
    echo -e "${RED}⚠️  Installation completed with $ERRORS errors${NC}"
    echo ""
    echo "To troubleshoot:"
    echo "  1. Check the repository exists: https://github.com/lakson-llc/superpowers-skills"
    echo "  2. Verify git access: git ls-remote https://github.com/lakson-llc/superpowers-skills.git"
    echo "  3. Check permissions: ls -la ~/.config/superpowers/"
    echo "  4. See README: ~/.config/superpowers/skills/CUSTOM_SKILLS_README.md"
    exit 1
fi

# Create update script
echo ""
echo -e "${YELLOW}📝 Creating update script...${NC}"
cat > "$HOME/.config/superpowers/update-skills.sh" << 'EOFSCRIPT'
#!/bin/bash
# Update custom Claude skills

cd "$HOME/.config/superpowers/skills" || exit 1
echo "📥 Updating custom skills..."

# Stash any local changes
if [[ -n $(git status -s) ]]; then
    echo "Stashing local changes..."
    git stash push -m "Auto-stash before update $(date +%Y%m%d-%H%M%S)"
fi

# Pull from fork
git pull origin main

# Fetch from upstream
git fetch upstream

echo "✅ Skills updated!"
echo ""
echo "To merge upstream changes:"
echo "  cd ~/.config/superpowers/skills"
echo "  git merge upstream/main"
EOFSCRIPT

chmod +x "$HOME/.config/superpowers/update-skills.sh"
echo -e "${GREEN}✅ Update script created at: ~/.config/superpowers/update-skills.sh${NC}"