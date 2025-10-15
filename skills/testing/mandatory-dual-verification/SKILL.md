---
name: Mandatory Dual-Verification
description: Enforce systematic + behavioral verification for every code change, automatically managed with TodoWrite
when_to_use: after any bug fix, feature implementation, or code modification
version: 1.0.0
---

# Mandatory Dual-Verification

## Overview

**Every code change MUST be verified twice:**
1. **Systematic** (Code-level): Verify structure, patterns, dependencies
2. **Behavioral** (Runtime): Verify actual execution and user-facing behavior

This skill automates the dual-verification process using TodoWrite and ensures both phases complete before marking work as done.

## Core Principle

**Code that compiles ≠ Code that works correctly.**

- Systematic verification catches structural issues
- Behavioral verification catches runtime issues
- **Both required** for confidence

## Quick Reference

### When to Use

**Always use after:**
- Bug fixes
- Feature implementations
- Refactoring
- Dependency updates
- Configuration changes

**Never skip, even for "simple" changes.**

### Verification Phases

```
Phase 1: Systematic Verification (~500 tokens)
  - grep for patterns
  - Read specific sections
  - Verify dependencies
  - Check TypeScript types

Phase 2: Behavioral Verification (~2k-18k tokens)
  - Use token-aware-testing skill
  - Automatic mode selection
  - Runtime execution test
  - User-facing verification
```

## Implementation

### Step 1: Create TodoWrite Checklist (Mandatory)

**After making code changes, immediately create todos:**

```typescript
TodoWrite([
  {
    content: "Systematic: Verify [specific aspect]",
    status: "in_progress",
    activeForm: "Verifying systematic correctness"
  },
  {
    content: "Behavioral: Test [specific behavior]",
    status: "pending",
    activeForm: "Testing behavioral correctness"
  }
]);
```

**Example:**
```typescript
// After fixing comment callback bug
TodoWrite([
  {
    content: "Systematic: Verify hookSubmitComment usage and onCommentAdded in dependencies",
    status: "in_progress",
    activeForm: "Verifying systematic correctness"
  },
  {
    content: "Behavioral: Test comment submission triggers activity count update",
    status: "pending",
    activeForm: "Testing behavioral correctness"
  }
]);
```

### Step 2: Systematic Verification (~500 tokens)

**Use grep and Read to verify code structure:**

```bash
# Verify function exists
grep -n "functionName" path/to/file.ts

# Verify it's used correctly
grep -n "functionName" path/to/usage.ts

# Verify dependencies include all captured values
grep -A10 "useCallback" path/to/file.ts | grep "dependencies"

# Verify types are correct
grep -n "interface\|type" path/to/file.ts
```

**Check these patterns:**

For hooks:
- [ ] Hook function exists
- [ ] Hook called in component
- [ ] Dependencies array complete
- [ ] Callback props passed correctly

For components:
- [ ] Props typed correctly
- [ ] State updates synchronous
- [ ] Event handlers connected
- [ ] data-testid added (if testable)

For API routes:
- [ ] Route registered
- [ ] Auth middleware present
- [ ] Error handling exists
- [ ] Response format correct

**Mark systematic todo complete:**
```typescript
TodoWrite([
  {
    content: "Systematic: Verify...",
    status: "completed",  // ✅ Mark done
    activeForm: "Verifying systematic correctness"
  },
  {
    content: "Behavioral: Test...",
    status: "in_progress",  // ⏭️ Start next
    activeForm: "Testing behavioral correctness"
  }
]);
```

### Step 3: Behavioral Verification (Token-Aware)

**Use token-aware-testing skill automatically:**

Read the `token-aware-testing` skill and follow its guidance:
1. Check token budget
2. Classify test complexity
3. Select optimal mode (Playwright/BashOutput/Manual)
4. Execute test
5. Verify results

**Announce mode selection:**
```
"Using optimized Playwright for behavioral test (~18k tokens)..."
"Using BashOutput monitoring for efficient verification (~2k tokens)..."
"⚠️ Token budget tight. Using manual testing mode (~1k tokens)..."
```

**Mark behavioral todo complete:**
```typescript
TodoWrite([
  {
    content: "Systematic: Verify...",
    status: "completed",
    activeForm: "Verifying systematic correctness"
  },
  {
    content: "Behavioral: Test...",
    status: "completed",  // ✅ Both done
    activeForm: "Testing behavioral correctness"
  }
]);
```

### Step 4: Document Results

**Update CHANGELOG_LOCAL.md:**
```markdown
### Testing Performed
**Systematic Verification:**
- ✅ Verified hookSubmitComment usage in Index.tsx:2606
- ✅ Verified onCommentAdded in useCallback dependencies
- ✅ Confirmed state props use hook values

**Behavioral Verification:**
- ✅ Tested on localhost:8080/feed
- ✅ Comment submission triggers activity refresh
- ✅ Sidebar count increments in real-time
```

## Systematic Verification Patterns

### Pattern 1: Hook Verification

```bash
# 1. Verify hook exists
grep -n "export function useHookName" client/hooks/useHookName.ts

# 2. Verify hook is imported
grep -n "import.*useHookName" client/pages/Component.tsx

# 3. Verify hook is called
grep -n "useHookName(" client/pages/Component.tsx

# 4. Verify dependencies
grep -A5 "useCallback\|useEffect" client/hooks/useHookName.ts

# 5. Verify callbacks passed
grep -n "onCallbackName" client/pages/Component.tsx
```

### Pattern 2: Component Props Verification

```bash
# 1. Verify component receives props
grep -n "<ComponentName" client/pages/Parent.tsx

# 2. Verify props match interface
grep -n "interface ComponentNameProps" client/components/ComponentName.tsx

# 3. Verify prop values come from correct source
grep -B5 -A5 "<ComponentName" client/pages/Parent.tsx
```

### Pattern 3: API Route Verification

```bash
# 1. Verify route exists
grep -n "router.*\\/api\\/endpoint" server/routes/*.ts

# 2. Verify authentication
grep -B5 "router.*\\/api\\/endpoint" server/routes/*.ts | grep "requireAuth"

# 3. Verify error handling
grep -A20 "router.*\\/api\\/endpoint" server/routes/*.ts | grep "try\|catch"
```

## Behavioral Verification Patterns

### Pattern 1: UI Interaction Test

**Optimized Playwright (~18k tokens):**
```typescript
await page.goto(url);
const before = await page.evaluate(() => window.getTestResults());

await page.click('[data-testid="button"]');
await page.fill('[data-testid="input"]', 'text');
await page.click('[data-testid="submit"]');

await page.waitForFunction(() =>
  window.testLogs.some(l => l.includes('expected'))
);

const after = await page.evaluate(() => window.getTestResults());
expect(after.count).toBeGreaterThan(before.count);
```

### Pattern 2: API Test

**BashOutput (~2k tokens):**
```bash
# Monitor dev server
BashOutput(bash_id)

# Ask user to test API
"Please run: curl -X POST http://localhost:8080/api/endpoint
Report: Status code and response"

# Verify from logs + user report
```

### Pattern 3: Console Log Verification

**BashOutput (~2k tokens):**
```bash
# Monitor dev server console
BashOutput(bash_id)

# Ask user to perform action
"Please:
1. Navigate to /page
2. Click button
3. Report: Did expected behavior occur?"

# Verify console logs show expected patterns
```

## Examples

### Example 1: Comment Callback Bug Fix

**Code Change:** Deleted duplicate function, fixed props

**Systematic Verification:**
```bash
# Verify duplicate removed
grep -c "const submitComment" client/pages/Index.tsx
# Expected: 0 (no local duplicate)

# Verify using hook function
grep -n "submitComment={hook" client/pages/Index.tsx
# Expected: Line 2606: submitComment={hookSubmitComment}

# Verify props use hook state
grep -n "newComment={hook" client/pages/Index.tsx
# Expected: Line 2589: newComment={hookNewComment}

✅ Systematic phase complete
```

**Behavioral Verification:**
```
Token budget: 50k / 200k (plenty)
Test complexity: Medium (single UI interaction)
Mode: Optimized Playwright (~18k tokens)

Test: Add comment → Verify sidebar increments
Result: ✅ Count incremented from 17 → 18
Console logs: ✅ All GRANULAR logs executed
Callback: ✅ onCommentAdded fired

✅ Behavioral phase complete
```

### Example 2: API Endpoint Addition

**Code Change:** Added new endpoint `/api/stats`

**Systematic Verification:**
```bash
# Verify route registered
grep -n "/api/stats" server/routes/stats.ts
# Expected: Found at line X

# Verify authentication
grep -B5 "/api/stats" server/routes/stats.ts | grep "requireAuth"
# Expected: Auth middleware present

# Verify error handling
grep -A20 "/api/stats" server/routes/stats.ts | grep "try"
# Expected: try/catch blocks present

✅ Systematic phase complete
```

**Behavioral Verification:**
```
Token budget: 140k / 200k (moderate)
Test complexity: Simple (API only)
Mode: BashOutput (~2k tokens)

Ask user: "curl http://localhost:8080/api/stats"
User reports: "Status 200, returns {success: true, data: {...}}"
Dev server logs: [Stats] Fetching statistics for user...

✅ Behavioral phase complete
```

## Anti-Patterns

### ❌ DON'T: Skip Systematic Verification

```
Bad: Fix code → Immediately run Playwright test
Good: Fix code → grep verify structure → Then test behavior
```

**Why:** Structural issues waste time in behavioral testing. Find them first.

### ❌ DON'T: Skip Behavioral Verification

```
Bad: grep shows correct structure → Assume it works
Good: grep shows correct structure → Test runtime execution
```

**Why:** Code can be structurally correct but have runtime bugs.

### ❌ DON'T: Do Behavioral Before Systematic

```
Bad Order:
1. Fix code
2. Run Playwright test
3. Test fails
4. grep to debug
5. Fix structural issue
6. Re-run test

Good Order:
1. Fix code
2. grep verify structure
3. Catch structural issue early
4. Fix it
5. Run behavioral test
6. Pass on first try
```

**Why:** Systematic verification is cheaper and faster. Do it first.

### ❌ DON'T: Mark Complete Without Both Phases

```
Bad: TodoWrite shows only behavioral completed
Good: TodoWrite shows both systematic AND behavioral completed
```

**Why:** Half-verified code is unverified code.

## Success Criteria

**You're doing it right when:**
1. ✅ TodoWrite always has both systematic + behavioral todos
2. ✅ Systematic verification always happens first
3. ✅ Both todos marked complete before moving on
4. ✅ CHANGELOG documents both verification types
5. ✅ User sees progress via TodoWrite updates

**You're doing it wrong when:**
1. ❌ Only doing one type of verification
2. ❌ Doing behavioral before systematic
3. ❌ Not using TodoWrite to track
4. ❌ Marking work complete with todos unfinished
5. ❌ Skipping verification for "simple" changes

## Integration with Other Skills

**This skill is mandatory. Use with:**
- `token-aware-testing` - For automatic mode selection
- `systematic-debugging` - For finding root causes
- `verification-before-completion` - Before claiming "done"

**Workflow:**
```
1. Make code change
2. Use mandatory-dual-verification skill
   ├─ Creates TodoWrite todos
   ├─ Systematic verification
   └─ Behavioral verification (uses token-aware-testing)
3. Document results
4. Mark complete
```

## Quick Checklist

Every code change:
- [ ] Create TodoWrite todos (systematic + behavioral)
- [ ] Run systematic verification first
- [ ] Mark systematic todo complete
- [ ] Run behavioral verification (token-aware mode)
- [ ] Mark behavioral todo complete
- [ ] Document both in CHANGELOG
- [ ] Clear TodoWrite list

**Never skip dual-verification. Never mark complete without both.** 🚀
