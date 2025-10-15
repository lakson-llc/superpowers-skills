---
name: Token-Aware Testing
description: Automatically select optimal testing approach based on token budget and test complexity
when_to_use: when performing any behavioral verification or testing task
version: 1.0.0
---

# Token-Aware Testing

## Overview

Automatically manages token budget during testing by selecting the most efficient testing approach. **Never ask the user which testing mode to use—decide automatically based on context.**

## Core Principle

**Testing quality is non-negotiable. Token efficiency is the optimization.**

Always maintain dual-verification (systematic + behavioral) while minimizing token cost.

## Quick Reference

### Token Budget Thresholds

```
0-100k tokens    → Optimized Playwright (~18k per test)
100k-150k tokens → BashOutput monitoring (~2k per test)
150k-180k tokens → Emergency manual mode (~1k per test)
>180k tokens     → Warn user, force manual mode
```

### Test Complexity Decision

```
Simple API test          → curl or BashOutput (~2k)
Single UI interaction    → Optimized Playwright (~18k)
Multi-step flow          → Optimized Playwright (~18k)
Complex integration      → Full Playwright (~50k)
```

### Mode Selection Logic

```python
def select_testing_mode(tokens_used, test_complexity):
    if tokens_used > 180_000:
        return "emergency_manual"  # 1k tokens

    if test_complexity == "simple":
        return "bashoutput"  # 2k tokens

    if tokens_used > 150_000:
        return "bashoutput"  # 2k tokens

    if tokens_used > 100_000:
        if test_complexity in ["simple", "medium"]:
            return "bashoutput"  # 2k tokens
        else:
            return "optimized_playwright"  # 18k tokens

    # Plenty of budget
    if test_complexity == "complex":
        return "full_playwright"  # 50k tokens
    else:
        return "optimized_playwright"  # 18k tokens
```

## Implementation

### Phase 1: Assess Context (Automatic)

**Check token budget:**
```
Look for system warnings:
- "Token usage: X/200000"
- "⚠ Large MCP response"

Calculate remaining budget:
remaining = 200000 - tokens_used
```

**Classify test complexity:**
```
Simple:
- Single API call verification
- Console log check
- Single state change

Medium:
- Single UI interaction
- Comment, like, share action
- Modal open/close

Complex:
- Multi-step flow
- Authentication + navigation
- Cross-page interactions
```

### Phase 2: Select Mode (Automatic)

**Never ask user.** Choose mode using decision matrix above.

**Announce selection:**
```
Good: "Using BashOutput monitoring (token-efficient)..."
Good: "Testing with optimized Playwright (~18k tokens)..."
Good: "⚠️ Token budget tight. Using manual mode (~1k)..."

Bad: "Would you like me to use Playwright or manual testing?"
```

### Phase 3: Execute Test (Automatic)

**Use selected mode:**

**Optimized Playwright (~18k tokens):**
```typescript
// Navigate once
await page.goto(url);

// Get before state (evaluate - no snapshot)
const before = await page.evaluate(() => window.getTestResults());

// Perform actions (no intermediate snapshots)
await page.click('[data-testid="button"]');
await page.fill('[data-testid="input"]', 'text');
await page.click('[data-testid="submit"]');

// Wait for completion (cheap)
await page.waitForFunction(() =>
  window.testLogs.some(l => l.includes('expected pattern'))
);

// Get after state (evaluate - no snapshot)
const after = await page.evaluate(() => window.getTestResults());

// Verify (local - 0 tokens)
assert(after.count > before.count);
```

**BashOutput Monitoring (~2k tokens):**
```typescript
// Monitor dev server console
BashOutput(bash_id, filter: 'pattern|pattern2');

// Instruct user for manual action
"Please perform: [specific steps]"

// Verify from console logs
Check logs for expected patterns
```

**Emergency Manual (~1k tokens):**
```
Provide clear test steps:
"Please test manually:
1. [Step 1]
2. [Step 2]
3. Report: [what to verify]"

User reports back
Verify from report
```

### Phase 4: Verify Results (Automatic)

**Systematic verification:**
```bash
grep -n "pattern" file.ts  # ~100 tokens
```

**Behavioral verification:**
```
Use selected mode from Phase 2
Extract verification data
Assert expectations
```

## Dual-Verification Checklist

Use TodoWrite to track both phases:

```typescript
TodoWrite([
  {
    content: "Systematic: Verify code structure",
    status: "in_progress",
    activeForm: "Verifying code structure"
  },
  {
    content: "Behavioral: Test runtime behavior",
    status: "pending",
    activeForm: "Testing runtime behavior"
  }
]);
```

**Mark complete only when both phases pass.**

## Examples

### Example 1: Comment Callback Test

**Context:**
- Tokens used: 50k / 200k
- Test: Verify comment triggers activity refresh
- Complexity: Medium (single UI interaction)

**Decision: Optimized Playwright (~18k tokens)**

**Execution:**
```typescript
// Navigate once (15k tokens)
await page.goto('http://localhost:8080/feed');

// Get state via evaluate (1k tokens)
const before = await page.evaluate(() => window.getTestResults());

// Actions (no snapshots - 0 tokens)
await page.click('[data-testid="comment-button"]');
await page.fill('[data-testid="comment-input"]', 'Test');
await page.click('[data-testid="send-button"]');

await page.waitForFunction(() =>
  window.testLogs.some(l => l.includes('Activity Stats'))
);

// Verify via evaluate (2k tokens)
const after = await page.evaluate(() => window.getTestResults());

// Total: ~18k tokens
```

### Example 2: API Endpoint Test

**Context:**
- Tokens used: 120k / 200k
- Test: Verify API returns correct data
- Complexity: Simple (API only)

**Decision: BashOutput (~2k tokens)**

**Execution:**
```bash
# Monitor dev server
BashOutput(bash_id)

# Ask user to call API
"Please run:
curl -X POST http://localhost:8080/api/endpoint
Report: Status code and response"

# Verify from user report
# Total: ~2k tokens
```

### Example 3: Multi-Step Auth Flow

**Context:**
- Tokens used: 170k / 200k
- Test: Login → Navigate → Verify state
- Complexity: Complex (multi-step)

**Decision: Emergency Manual (~1k tokens)**

**Execution:**
```
"⚠️ Token budget tight. Using manual testing.

Please test:
1. Navigate to /login
2. Click 'Continue with Google'
3. Complete OAuth flow
4. Verify redirected to /dashboard
5. Report: Did dashboard load with user data?"

User reports back
Total: ~1k tokens
```

## Anti-Patterns

### ❌ DON'T: Ask User to Choose

```
Bad: "Would you like Playwright or manual testing?"
Bad: "Should I use BashOutput or full automation?"
Bad: "What's your preference for testing?"
```

**Why:** User hired you to make these decisions. Asking is outsourcing your job.

### ❌ DON'T: Use Expensive Method When Cheap Works

```
Bad: Using Playwright for simple API test (18k tokens)
Good: Using curl or BashOutput (2k tokens)
```

### ❌ DON'T: Ignore Token Budget

```
Bad: "I'll use Playwright" when at 185k tokens
Good: "Token budget tight. Using manual mode."
```

### ❌ DON'T: Skip Systematic Verification

```
Bad: Only doing behavioral test
Good: Always grep/Read to verify code structure first
```

## Success Criteria

**You're doing it right when:**
1. ✅ User never thinks about token budget
2. ✅ Testing mode switches automatically
3. ✅ Dual-verification always happens
4. ✅ Tests use minimal tokens necessary
5. ✅ User only intervenes if they want to override

**You're doing it wrong when:**
1. ❌ Asking user which mode to use
2. ❌ Using expensive mode when cheap one works
3. ❌ Skipping systematic verification
4. ❌ Not using TodoWrite to track phases
5. ❌ Ignoring token warnings

## Integration with Other Skills

**Combine with:**
- `systematic-debugging` - For finding bugs before testing
- `test-driven-development` - For writing tests first
- `verification-before-completion` - For ensuring quality

## Summary

### Key Points

1. **Never ask user about testing mode**
   - Decide automatically based on budget + complexity
   - Announce your choice

2. **Token budget thresholds**
   - <100k: Optimized Playwright
   - 100-150k: BashOutput
   - >150k: Emergency manual

3. **Test complexity drives decision**
   - Simple → Cheap methods
   - Complex → More thorough (if budget allows)

4. **Dual-verification is mandatory**
   - Systematic (grep/Read)
   - Behavioral (chosen mode)

5. **Use TodoWrite for tracking**
   - Shows progress to user
   - Ensures both phases complete

### Quick Checklist

- [ ] Check token budget automatically
- [ ] Classify test complexity
- [ ] Select optimal mode (don't ask!)
- [ ] Announce selection
- [ ] Create TodoWrite todos
- [ ] Execute systematic verification
- [ ] Execute behavioral verification
- [ ] Mark both complete
- [ ] Document results

**User should never think about token optimization. You handle it.** 🚀
