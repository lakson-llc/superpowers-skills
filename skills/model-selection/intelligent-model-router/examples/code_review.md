# Example: Code Review (QCHECK)

## User Request
```
"qcheck"
```

## Analysis

### Shortcut Detection
- ✅ "qcheck" (opus_shortcut)
- Shortcut triggers high confidence for Opus

### Context from Recent Changes
```bash
git diff --stat
client/services/auth.ts           | 45 ++++++++----
server/auth/passport.ts            | 120 ++++++++++++++++++----------
shared/types/user.ts               | 8 +-
server/db/schema.ts                | 15 +++-
```

### Scope Estimation
- **Files modified**: 4 files
- **Changes**: Authentication refactor
- **Safety concerns**: YES (authentication is security-critical)

### Token Budget Check
- Tokens remaining: 150k / 200k
- Above opus_threshold: ✅

### Scoring

**Opus Score:**
- QCHECK shortcut: +0.5
- Security-critical code: +0.4
- 4 files modified: +0.1
- Authentication changes: +0.3
- **Total: 1.3 (capped at 1.0) = 100%**

**Sonnet Score:**
- Not an implementation task: 0
- **Total: 0.0 = 0%**

## Recommendation

```
🤖 Model Router Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Task Type: Code Quality Review (QCHECK)
💡 Recommended Model: Opus
🎯 Confidence: 100%

📊 Reasoning:
• QCHECK shortcut detected (requires deep analysis)
• Authentication refactor (security-critical)
• 4 files modified across client/server/shared
• 150k tokens available for thorough review

📈 Current Session:
• Tokens Used: 50k / 200k
• Model: Sonnet 4.5

⚡ Action: Switch to Opus for comprehensive code review
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 QCHECK will analyze:
• Writing Functions Best Practices
• Writing Tests Best Practices
• Implementation Best Practices
• Security vulnerabilities
```

## Expected Outcome

**Opus QCHECK Analysis:**

### 1. Function Analysis
```
✅ client/services/auth.ts:validateToken()
• Clear, single responsibility
• No cyclomatic complexity issues
• Properly testable

⚠️ server/auth/passport.ts:handleGoogleCallback()
• High cyclomatic complexity (6 nested conditions)
• Recommendation: Extract validation logic
• Suggested refactor: [code example]
```

### 2. Test Coverage
```
⚠️ Missing tests for error paths:
• Invalid token refresh scenario
• Expired session handling
• Race condition with concurrent logins

Recommendation: Add integration tests for these cases
```

### 3. Security Review
```
🔴 CRITICAL: Token stored in plain text cookie
• Current: res.cookie('token', jwt, { httpOnly: true })
• Risk: XSS vulnerability if httpOnly fails
• Fix: Add secure flag + SameSite=Strict

✅ Password hashing: bcrypt with salt rounds=10 (good)
✅ Rate limiting: Express-rate-limit configured correctly
```

### 4. Implementation Best Practices
```
✅ Conventional commits used
✅ No Claude references in code
✅ Type-only imports used correctly

⚠️ C-3 violation: New class AuthenticationManager introduced
• Recommendation: Replace with composable functions
• Functions more testable than classes
```

**Token Usage:** ~30k tokens (comprehensive review)

## Follow-up Action

After Opus review:

```
"Use Sonnet: Fix the critical security issue in token storage"
```

Sonnet efficiently implements the fix while Opus provides oversight.
