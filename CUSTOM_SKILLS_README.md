# Custom Claude Skills for GoalKyper Development

This fork contains custom skills specifically developed for the GoalKyper project to optimize token usage, improve testing efficiency, and enhance development workflow.

## 🎯 Custom Skills Overview

### 1. Testing Framework Skills
Located in `skills/testing/`:

#### **auto-testing-workflow**
- **Purpose**: Automatically triggers testing after code changes
- **Token Savings**: Reduces context by systematic testing
- **Usage**: Runs automatically after code modifications

#### **mandatory-dual-verification**
- **Purpose**: Enforces both systematic (code inspection) and behavioral (Playwright) testing
- **Key Feature**: Prevents incomplete testing by requiring both verification types
- **Usage**: Automatically invoked during testing phase

#### **token-aware-testing**
- **Purpose**: Intelligently selects testing mode based on token budget
- **Token Savings**: 83% reduction (105k → 18k tokens per test)
- **Modes**:
  - 0-100k tokens: Optimized Playwright (console-first)
  - 100-150k tokens: BashOutput monitoring for simple tests
  - 150k+ tokens: Emergency manual mode
- **Usage**: Automatically selects appropriate mode

### 2. Model Selection Skill
Located in `skills/model-selection/`:

#### **intelligent-model-router**
- **Purpose**: Analyzes tasks and recommends Opus vs Sonnet 4.5
- **Trigger**: Use `QROUTE` command
- **Decision Factors**:
  - Task complexity (design vs implementation)
  - File impact (>5 files → Opus, <3 files → Sonnet)
  - Token budget remaining
  - Keywords and shortcuts used
- **Output**: Confidence score with reasoning

### 3. Documentation Management Skill
Located in `skills/documentation/`:

#### **large-file-management**
- **Purpose**: Prevents documentation files from exceeding Claude's 256KB limit
- **Features**:
  - Auto-detects large files
  - Provides one-command archiving
  - Maintains searchability across archives
- **Usage**: Runs at session start

## 🚀 Quick Setup on New Machine

### Prerequisites
- Git installed
- GitHub CLI installed (`gh`)
- Claude Code installed

### One-Command Setup

```bash
# Run this single command to set up everything
curl -sSL https://raw.githubusercontent.com/lakson-llc/superpowers-skills/main/setup-skills.sh | bash
```

### Manual Setup Steps

If you prefer manual setup or the script fails:

```bash
# 1. Clone this forked repository with custom skills
git clone https://github.com/lakson-llc/superpowers-skills.git ~/.config/superpowers/skills

# 2. Set up remotes
cd ~/.config/superpowers/skills
git remote add upstream https://github.com/obra/superpowers-skills.git

# 3. Install superpowers plugin for Claude
mkdir -p ~/.claude/plugins/repos
git clone https://github.com/obra/superpowers.git ~/.claude/plugins/repos/superpowers

# 4. Create commands directory and symlink
mkdir -p ~/.claude/commands
cd ~/.claude/commands
for file in ~/.claude/plugins/repos/superpowers/commands/*.md; do
  [[ $(basename "$file") != "README.md" ]] && ln -sf "$file" .
done

# 5. Update plugin configuration
cat > ~/.claude/plugins/config.json << 'EOF'
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

# 6. Verify installation
echo "✅ Skills installed at: ~/.config/superpowers/skills"
echo "✅ Plugin installed at: ~/.claude/plugins/repos/superpowers"
ls -la ~/.config/superpowers/skills/skills/{testing,documentation,model-selection}/
```

## 📦 Backup & Restore

### Create Backup
```bash
# Create timestamped backup of all custom skills
tar -czf ~/Documents/claude-custom-skills-backup-$(date +%Y%m%d).tar.gz \
  -C ~/.config/superpowers/skills \
  skills/testing/auto-testing-workflow \
  skills/testing/mandatory-dual-verification \
  skills/testing/token-aware-testing \
  skills/documentation/large-file-management \
  skills/model-selection/intelligent-model-router

echo "✅ Backup created: ~/Documents/claude-custom-skills-backup-$(date +%Y%m%d).tar.gz"
```

### Restore from Backup
```bash
# Restore skills from backup file
BACKUP_FILE="~/Documents/claude-custom-skills-backup-YYYYMMDD.tar.gz"
tar -xzf "$BACKUP_FILE" -C ~/.config/superpowers/skills/
echo "✅ Skills restored to ~/.config/superpowers/skills/"
```

## 🔄 Keeping Skills Updated

### Pull Latest Custom Skills
```bash
cd ~/.config/superpowers/skills
git pull origin main
```

### Pull Updates from Original Repository
```bash
cd ~/.config/superpowers/skills
git fetch upstream
git merge upstream/main
```

### Push Your Improvements
```bash
cd ~/.config/superpowers/skills
git add skills/your-new-skill
git commit -m "feat: add new skill for X"
git push origin main
```

## 🛠️ Helper Scripts

### Create Setup Script for Team
Save this as `setup-claude-skills.sh` in your project:

```bash
#!/bin/bash
set -e

echo "🤖 Setting up Claude custom skills..."

# Check if skills already exist
if [ -d "$HOME/.config/superpowers/skills/.git" ]; then
  echo "📦 Skills directory exists, updating..."
  cd "$HOME/.config/superpowers/skills"
  git pull origin main
else
  echo "📦 Cloning custom skills repository..."
  git clone https://github.com/lakson-llc/superpowers-skills.git \
    "$HOME/.config/superpowers/skills"
fi

# Set up remotes
cd "$HOME/.config/superpowers/skills"
git remote add upstream https://github.com/obra/superpowers-skills.git 2>/dev/null || true

# Install superpowers plugin
if [ ! -d "$HOME/.claude/plugins/repos/superpowers" ]; then
  echo "🔌 Installing superpowers plugin..."
  mkdir -p "$HOME/.claude/plugins/repos"
  git clone https://github.com/obra/superpowers.git \
    "$HOME/.claude/plugins/repos/superpowers"
fi

# Create symlinks for commands
echo "🔗 Setting up command symlinks..."
mkdir -p "$HOME/.claude/commands"
cd "$HOME/.claude/commands"
for file in "$HOME/.claude/plugins/repos/superpowers/commands"/*.md; do
  [[ $(basename "$file") != "README.md" ]] && ln -sf "$file" . 2>/dev/null
done

echo "✅ Custom skills setup complete!"
echo ""
echo "Available custom skills:"
echo "  - auto-testing-workflow (automatic testing)"
echo "  - mandatory-dual-verification (enforced testing)"
echo "  - token-aware-testing (83% token savings)"
echo "  - intelligent-model-router (QROUTE command)"
echo "  - large-file-management (prevent 256KB errors)"
echo ""
echo "Commands available:"
echo "  - /brainstorm"
echo "  - /write-plan"
echo "  - /execute-plan"
```

## 📊 Token Savings Data

Our custom testing framework reduces token usage by **83%**:
- Traditional Playwright: ~105,000 tokens per test
- Optimized Framework: ~18,000 tokens per test
- Savings per session: ~87,000 tokens

## 🤝 Contributing

To contribute improvements:

1. Make changes in your local skills directory
2. Test thoroughly with Claude Code
3. Commit with descriptive messages
4. Push to your fork
5. Create PR to upstream if sharing with community

## 📝 Integration with GoalKyper

These skills are specifically referenced in the GoalKyper project's `CLAUDE.md`:
- Testing framework documentation
- QROUTE model selection command
- Large file management protocols

## ⚠️ Important Notes

1. **Always backup before major updates**
2. **Test skills after cloning to new machine**
3. **Keep fork synced with upstream for community improvements**
4. **Document any new skills you create**

## 📚 Skill Documentation

Each skill contains its own `SKILL.md` file with:
- Purpose and use cases
- Implementation details
- Configuration options
- Examples
- Testing strategies

## 🔧 Troubleshooting

### Skills not loading?
```bash
# Verify installation
ls -la ~/.config/superpowers/skills/skills/
ls -la ~/.claude/plugins/repos/superpowers/

# Check plugin config
cat ~/.claude/plugins/config.json

# Restart Claude Code
```

### Commands not working?
```bash
# Recreate symlinks
cd ~/.claude/commands
rm *.md
for file in ~/.claude/plugins/repos/superpowers/commands/*.md; do
  [[ $(basename "$file") != "README.md" ]] && ln -sf "$file" .
done
```

## 📧 Support

For issues specific to these custom skills:
- Create issue on https://github.com/lakson-llc/superpowers-skills/issues
- Reference the skill name and Claude Code version

---

Last Updated: October 2025
Custom Skills Version: 1.0.0
Compatible with: Claude Code 0.7.9+