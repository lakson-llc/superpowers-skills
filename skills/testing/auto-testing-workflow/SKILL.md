---
name: Auto Testing Workflow
description: Complete automated testing workflow - reads mandatory-dual-verification and token-aware-testing, executes everything automatically
when_to_use: immediately after any code change (bug fix, feature, refactor)
version: 1.0.0
---

# Auto Testing Workflow

## Overview

**This skill automates the entire testing workflow.**

User makes code change → You run this skill → Everything handled automatically.

## Core Principle

**You handle all testing decisions. User just codes.**

No questions. No choices. Just automatic, intelligent testing with progress visibility.

## Quick Reference

### Workflow Sequence

```
1. Detect code change
2. Read mandatory-dual-verification skill
3. Create TodoWrite todos
4. Execute systematic verification
5. Read token-aware-testing skill
6. Execute behavioral verification (auto mode)
7. Mark todos complete
8. Document results
9. Done
```

### User Experience

**What user sees:**
```
Them: [Makes code change]
You:  "Testing fix with dual-verification..."
      [TodoWrite shows: Systematic verification in progress]
      [TodoWrite shows: Behavioral verification in progress]
      [TodoWrite shows: Both completed]
You:  "✅ Verified: [summary]"
```

**What user doesn't see:**
- Token budget calculations
- Mode selection logic
- Testing strategy decisions
- Tool selection rationale

**They just see: "It works" ✅**

## Implementation

### Phase 1: Initiation (Automatic)

**Triggered by:**
- Bug fix completed
- Feature implementation done
- Refactoring finished
- User says "test this" or "verify this"

**Action:**
```typescript
// Immediately read both skills
Read('/Users/slakhani/.config/superpowers/skills/skills/testing/mandatory-dual-verification/SKILL.md');
Read('/Users/slakhani/.config/superpowers/skills/skills/testing/token-aware-testing/SKILL.md');
```

### Phase 2: Todo Creation (Automatic)

**Create todos based on change type:**

```typescript
TodoWrite([
  {
    content: "Systematic: Verify [specific structure]",
    status: "in_progress",
    activeForm: "Verifying code structure"
  },
  {
    content: "Behavioral: Test [specific behavior]",
    status: "pending",
    activeForm: "Testing runtime behavior"
  }
]);
```

**Announce to user:**
```
"Testing [change description] with dual-verification..."
```

### Phase 3: Systematic Verification (Automatic)

**Use grep patterns from mandatory-dual-verification skill:**

```bash
# Check structure based on change type
grep -n "pattern" file.ts
grep -A5 "useCallback" file.ts
grep -n "interface\|type" file.ts
```

**Verify checklist:**
- [ ] Hook/function exists
- [ ] Used in correct locations
- [ ] Dependencies complete
- [ ] Props passed correctly
- [ ] Types are correct

**Update todo:**
```typescript
TodoWrite([
  {
    content: "Systematic: Verify...",
    status: "completed",  // ✅ Done
    activeForm: "Verifying code structure"
  },
  {
    content: "Behavioral: Test...",
    status: "in_progress",  // ⏭️ Start
    activeForm: "Testing runtime behavior"
  }
]);
```

### Phase 4: Behavioral Verification (Automatic)

**Use token-aware-testing skill logic:**

```typescript
// Check token budget
tokens_used = getCurrentTokenUsage();

// Classify test complexity
complexity = classifyTestComplexity(change_type);

// Select mode automatically
mode = selectTestingMode(tokens_used, complexity);

// Announce selection
console.log(`Using ${mode} for behavioral test...`);

// Execute test
switch(mode) {
  case "optimized_playwright":
    executeOptimizedPlaywright();
    break;
  case "bashoutput":
    executeBashOutputTest();
    break;
  case "emergency_manual":
    executeManualTest();
    break;
}
```

**Update todo:**
```typescript
TodoWrite([
  {
    content: "Systematic: Verify...",
    status: "completed",
    activeForm: "Verifying code structure"
  },
  {
    content: "Behavioral: Test...",
    status: "completed",  // ✅ Both done
    activeForm: "Testing runtime behavior"
  }
]);
```

### Phase 5: Documentation (Automatic)

**Update CHANGELOG_LOCAL.md:**

```markdown
### Testing Performed

**Systematic Verification:**
- ✅ [What was verified]
- ✅ [What was checked]
- ✅ [What was confirmed]

**Behavioral Verification:**
- ✅ [What was tested]
- ✅ [What behavior was verified]
- ✅ [What results were observed]
```

### Phase 6: Completion (Automatic)

**Clear todos:**
```typescript
TodoWrite([]);  // All done
```

**Announce to user:**
```
"✅ Verified: [concise summary]
  - Systematic: [key points]
  - Behavioral: [key results]"
```

## Mode Selection Examples

### Example 1: Early Session, Simple Test

**Context:**
- Tokens used: 30k / 200k
- Change: Fixed typo in button text
- Complexity: Simple

**Decision: BashOutput (~2k tokens)**

**Execution:**
```
1. grep verify button text changed
2. Monitor dev server console
3. Ask user: "Check button displays correct text?"
4. User confirms
5. Done
```

### Example 2: Mid Session, UI Interaction

**Context:**
- Tokens used: 80k / 200k
- Change: Fixed comment callback
- Complexity: Medium

**Decision: Optimized Playwright (~18k tokens)**

**Execution:**
```
1. grep verify hook usage
2. Navigate to page once
3. Get before state via evaluate
4. Perform actions (no snapshots)
5. Get after state via evaluate
6. Verify results
7. Done
```

### Example 3: Late Session, Complex Flow

**Context:**
- Tokens used: 170k / 200k
- Change: OAuth flow fix
- Complexity: Complex

**Decision: Emergency Manual (~1k tokens)**

**Execution:**
```
1. grep verify OAuth config
2. Provide manual test steps
3. User performs and reports
4. Verify from report
5. Done
```

## Complexity Classification

### Simple Tests
- API endpoint changes
- Text/styling updates
- Configuration changes
- Console log additions

**Test with:** BashOutput or curl

### Medium Tests
- Single UI interactions
- Form submissions
- Modal open/close
- State updates

**Test with:** Optimized Playwright

### Complex Tests
- Multi-step flows
- Authentication flows
- Cross-page navigation
- Integration scenarios

**Test with:** Optimized Playwright (if budget) or Manual (if tight)

## Token Budget Monitoring

### Automatic Warnings

**At 150k tokens:**
```
"⚠️ Token budget: 150k/200k used. Switching to cheaper testing modes."
```

**At 180k tokens:**
```
"⚠️ Token budget critical: 180k/200k used. Using manual testing only."
```

**At 190k tokens:**
```
"🚨 Token budget exhausted: 190k/200k used.
Recommend clearing context or continuing in new session."
```

### Automatic Mode Switching

```
Session start (0-100k):
  Default: Optimized Playwright
  Override: Never (plenty of budget)

Mid session (100-150k):
  Default: BashOutput for simple, Playwright for medium/complex
  Override: Only if user requests

Late session (150-180k):
  Default: BashOutput for all tests
  Override: Only if critically important

Critical (180k+):
  Default: Emergency manual only
  Override: Never (protect user's session)
```

## Success Metrics

**You're doing it right when:**
1. ✅ User never asks "how should we test?"
2. ✅ TodoWrite shows clear progress
3. ✅ Testing happens automatically after changes
4. ✅ Mode selection invisible to user
5. ✅ Both systematic + behavioral always done

**You're doing it wrong when:**
1. ❌ Asking user about testing approach
2. ❌ Not creating TodoWrite todos
3. ❌ Skipping systematic verification
4. ❌ Using expensive mode when cheap works
5. ❌ Not monitoring token budget

## Integration Points

**This skill orchestrates:**
- `mandatory-dual-verification` - What to verify
- `token-aware-testing` - How to verify
- TodoWrite - Progress tracking
- CHANGELOG_LOCAL.md - Documentation

**Workflow:**
```
Code Change
    ↓
Auto Testing Workflow (this skill)
    ├─→ mandatory-dual-verification
    │   ├─ Systematic phase
    │   └─ Behavioral phase trigger
    └─→ token-aware-testing
        ├─ Budget check
        ├─ Complexity assessment
        ├─ Mode selection
        └─ Test execution
    ↓
Documentation
    ↓
Complete
```

## Quick Checklist

For every code change:
- [ ] Read both testing skills
- [ ] Create TodoWrite todos
- [ ] Systematic verification (grep/Read)
- [ ] Check token budget
- [ ] Select test mode automatically
- [ ] Behavioral verification (chosen mode)
- [ ] Update todos to completed
- [ ] Document results
- [ ] Clear todos
- [ ] Announce completion

**Never ask user about testing. Always handle automatically.** 🚀

## Example Session

```
User: "I fixed the comment callback bug"

You:  "Testing fix with dual-verification..."
      [Internal: Read mandatory-dual-verification skill]
      [Internal: Read token-aware-testing skill]
      [Internal: Tokens: 50k/200k, Complexity: Medium]
      [Internal: Decision: Optimized Playwright ~18k]

      [Creates todos]
      TodoWrite([
        {content: "Systematic: Verify hookSubmitComment usage", status: "in_progress"},
        {content: "Behavioral: Test comment triggers activity refresh", status: "pending"}
      ])

      [Systematic verification]
      grep -n "hookSubmitComment" client/pages/Index.tsx
      ✅ Found at line 2606

      [Updates todo]
      TodoWrite([
        {content: "Systematic...", status: "completed"},
        {content: "Behavioral...", status: "in_progress"}
      ])

      [Behavioral verification - Optimized Playwright]
      "Using optimized Playwright (~18k tokens)..."
      await page.goto(...)
      const before = await page.evaluate(...)
      [Actions...]
      const after = await page.evaluate(...)
      ✅ Sidebar incremented: 17 → 18
      ✅ Callback fired

      [Updates todo]
      TodoWrite([
        {content: "Systematic...", status: "completed"},
        {content: "Behavioral...", status: "completed"}
      ])

      [Documentation]
      Update CHANGELOG_LOCAL.md...

      [Clear todos]
      TodoWrite([])

You:  "✅ Verified: Comment callback triggers activity refresh
        - Systematic: hookSubmitComment usage correct
        - Behavioral: Sidebar increments in real-time (17→18)"

User: "Thanks!" [Doesn't need to think about testing at all]
```

## Summary

### What This Skill Does

1. **Reads other skills** - Gets latest patterns
2. **Creates todos** - Shows progress
3. **Verifies systematically** - grep/Read patterns
4. **Selects mode** - Based on budget/complexity
5. **Tests behaviorally** - Chosen mode
6. **Documents** - CHANGELOG updates
7. **Completes** - Clear todos, announce

### What User Experiences

1. Makes code change
2. Sees "Testing..."
3. Sees TodoWrite progress
4. Sees "✅ Verified"
5. Done

**User never thinks about:**
- Token budgets
- Testing modes
- Tool selection
- Verification patterns

**You handle everything. That's the superpower.** ⚡
