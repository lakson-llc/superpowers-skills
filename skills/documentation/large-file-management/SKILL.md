---
name: Large File Management
description: Automatically detect and archive growing documentation files before they exceed Read tool limits
when_to_use: at session start (automatic) or when encountering file size errors
version: 1.0.0
---

# Large File Management

## Overview

**Automatically manages documentation files that grow over time**, preventing Read tool failures by archiving old content before files exceed 256KB limit.

**Core principle:** Detect early, archive proactively, search transparently.

**Runs automatically at session start** - no manual intervention required.

---

## Quick Start

**If you see "File content exceeds maximum allowed size" error:**

```bash
# Quick fix for CHANGELOG
archive_changelog

# Or any doc file
archive_doc_file FILENAME.md CUTOFF_DATE ARCHIVE_NAME.md
```

**Search across all files (active + archives):**

```bash
grep "search term" CHANGELOG*.md
grep "search term" docs/*.md docs/archives/*.md
```

---

## Configuration

### File Thresholds

```yaml
CHANGELOG_LOCAL.md:
  threshold: 200KB        # Archive when file exceeds this
  active_window: 7 days   # Keep only last 7 days in main file
  archive_pattern: CHANGELOG_ARCHIVE_YYYY_QN.md

TODO.md:
  threshold: 150KB
  active_window: current quarter
  archive_pattern: TODO_ARCHIVE_YYYY_QN.md

docs/*.md:
  threshold: 250KB
  active_window: 30 days
  archive_pattern: {FILENAME}_ARCHIVE_YYYY_MM.md
```

### Monitored Locations

- Root directory: `*.md` files
- Documentation: `docs/*.md` files
- Specific files: `CHANGELOG_LOCAL.md`, `TODO.md`

---

## Session Start Behavior

**Automatic Detection:**

```
Session start
↓
Check all monitored files
↓
If any file >200KB:
  Display warning with file size
  Offer one-command fix
  Wait for user confirmation
↓
If user confirms:
  Run archive script
  Show results (new sizes)
  Continue session
```

**Silent Success:**
If all files under threshold, no notification shown.

---

## Core Functions

### 1. Check Documentation Files

Runs at session start, scans for large files.

```bash
# Internal function - runs automatically
checkDocumentationFiles() {
  for file in CHANGELOG_LOCAL.md TODO.md docs/*.md; do
    if [ -f "$file" ]; then
      SIZE=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
      if [ $SIZE -gt 204800 ]; then  # 200KB
        echo "⚠️  Large file: $file ($(numfmt --to=iec $SIZE))"
      fi
    fi
  done
}
```

### 2. Safe Read Wrapper

Handles files of any size without failing.

```bash
# Usage: safeRead FILENAME
safeRead() {
  local file="$1"
  local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)

  if [ $size -gt 262144 ]; then  # 256KB
    echo "⚠️  File too large for Read tool, using grep/tail"
    echo "Recent entries:"
    tail -n 1000 "$file"
  else
    cat "$file"
  fi
}
```

### 3. Search All Docs

Searches across active and archived files.

```bash
# Usage: searchAllDocs "pattern"
searchAllDocs() {
  local pattern="$1"
  echo "Searching active files..."
  grep -n "$pattern" CHANGELOG_LOCAL.md TODO.md docs/*.md

  echo ""
  echo "Searching archives..."
  grep -n "$pattern" CHANGELOG_ARCHIVE*.md TODO_ARCHIVE*.md docs/*_ARCHIVE*.md
}
```

### 4. List Archives

Shows all archive files and their sizes.

```bash
# Usage: list_archives
list_archives() {
  echo "Archive files:"
  ls -lh *_ARCHIVE_*.md CHANGELOG_ARCHIVE*.md TODO_ARCHIVE*.md 2>/dev/null | \
    awk '{print $5, $9}'
}
```

---

## Archive Script

Located at: `/tmp/archive_doc_file.sh`

**Usage:**
```bash
./archive_doc_file.sh SOURCE_FILE CUTOFF_DATE ARCHIVE_FILE

# Examples:
./archive_doc_file.sh CHANGELOG_LOCAL.md 2025-10-01 CHANGELOG_ARCHIVE_2025_Q3.md
./archive_doc_file.sh TODO.md 2025-07-01 TODO_ARCHIVE_2025_Q3.md
```

**How it works:**
1. Detects date patterns: `## YYYY-MM-DD`, `### YYYY-MM-DD`
2. Finds line number of cutoff date
3. Splits file at that line
4. Creates archive with old content
5. Keeps recent content in main file
6. Validates both files (no data loss)
7. Shows before/after sizes

**Safety features:**
- Works on temp files first
- Only replaces original after validation
- Original file untouched if error occurs
- Checks for git uncommitted changes

---

## User Commands

### Quick Archive Commands

```bash
# Archive CHANGELOG (keeps last 7 days)
archive_changelog

# Archive TODO (keeps current quarter)
archive_todo

# Archive all docs over threshold
archive_all_docs

# Archive specific file
archive_doc_file myfile.md 2025-10-01 myfile_archive.md
```

### Search Commands

```bash
# Search across all changelog files
grep "bug fix" CHANGELOG*.md

# Search across all docs
grep -r "API change" docs/

# Smart search (active + archives)
searchAllDocs "authentication"
```

### Maintenance Commands

```bash
# List all archives
list_archives

# Check file sizes
ls -lh *.md docs/*.md | awk '{print $5, $9}'

# Manual archive (if auto fails)
/tmp/archive_doc_file.sh FILENAME.md CUTOFF_DATE ARCHIVE.md
```

---

## Error Handling

### Scenario 1: Archive Script Fails
```
Error: Archive script failed at line 42
→ Original file preserved (untouched)
→ Check /tmp/archive_error.log for details
→ Manual fix: See docs/CHANGELOG_MANAGEMENT.md
```

### Scenario 2: No Date Patterns Found
```
Warning: No date headers found in file
→ Fallback: Keep last 1000 lines, archive rest
→ Confirm: Archive by line count? [Y/n]
```

### Scenario 3: File Already Too Large
```
Error: Cannot read file (exceeds 256KB limit)
→ Using grep/tail to show recent content
→ Running auto-archive now...
→ Archive created: filename_archive.md
→ File now readable: 45KB
```

### Scenario 4: Multiple Large Files
```
⚠️  Multiple large files detected:
  1. CHANGELOG_LOCAL.md: 285KB
  2. TODO.md: 205KB
  3. docs/API.md: 310KB

Archive all? [Y/n] or select: [1,2,3]
```

---

## Integration with CLAUDE.md

Add to Session Start Checklist:

```markdown
### Session Start Checklist
1. Read TODO.md for current tasks
2. **Check file sizes** - Large-file-management skill runs automatically
3. Review git status
4. Check recent commits
```

Add to Changelog section:

```markdown
### IMPORTANT: Changelog Management
- File is auto-archived when exceeds 200KB
- Keeps only last 7 days in CHANGELOG_LOCAL.md
- Archives located in: CHANGELOG_ARCHIVE_YYYY_QN.md
- Search all: `grep "pattern" CHANGELOG*.md`
```

---

## Testing Checklist

**Before deploying:**
- [ ] Test archive script with 300KB file
- [ ] Test with file containing no dates
- [ ] Test safeRead() with 300KB file
- [ ] Test searchAllDocs() across split files
- [ ] Test session-start detection (create large file first)
- [ ] Test error handling (invalid dates, missing files)
- [ ] Test git safety (uncommitted changes warning)

---

## Maintenance

**Weekly:**
- Check archive file sizes (shouldn't exceed 500KB)
- Review session-start logs for detection accuracy

**Quarterly:**
- Review threshold settings (too aggressive or too lenient?)
- Check if any archives need further splitting
- User feedback: Is auto-archiving helpful?

**Yearly:**
- Archive old archives (create yearly super-archives)
- Clean up very old archives (>2 years)

---

## Related Documentation

- `docs/CHANGELOG_MANAGEMENT.md` - Manual archiving guide
- `/tmp/archive_doc_file.sh` - Archive script implementation
- `CLAUDE.md` - Session guidelines and workflows

---

## Summary

**What this skill does:**
1. Monitors documentation file sizes automatically
2. Warns before files exceed Read tool limits
3. Offers one-command archiving
4. Enables transparent search across all files
5. Self-healing - fixes issues proactively

**What user experiences:**
- Never encounters "file too large" errors
- Files stay manageable automatically
- Can search all content (active + archives)
- Zero manual file size management

**Token savings:**
- Prevents Read tool failures (saves debugging time)
- Keeps files small for faster operations
- Enables efficient file access patterns

**The skill runs automatically - you never think about file sizes.** ⚡
