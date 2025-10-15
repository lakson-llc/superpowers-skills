# Example: Token-Constrained Session

## User Request
```
"Review the notification system architecture and suggest improvements"
```

## Analysis

### Keyword Detection
- ✅ "Review" (opus_keyword)
- ✅ "architecture" (opus_keyword)
- ⚠️ "suggest improvements" (requires deep analysis)

### Scope Estimation
- **Task complexity**: HIGH (architecture review)
- **Expected token cost**: 40-50k tokens (Opus deep analysis)

### Token Budget Check
- **Tokens remaining**: 35k / 200k
- **Below opus_threshold (50k)**: ❌
- **Critical constraint**: Limited tokens available

### Scoring

**Opus Score (Ideal):**
- Review keyword: +0.3
- Architecture keyword: +0.3
- Improvement suggestions: +0.2
- **Subtotal: 0.8 = 80%**
- **Token penalty**: -0.5 (insufficient budget)
- **Final: 0.3 = 30%**

**Sonnet Score (Practical):**
- Can handle basic architectural review: +0.3
- Token-efficient mode: +0.4
- Emergency mode active: +0.2
- **Total: 0.9 = 90%**

## Recommendation

```
🤖 Model Router Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Task Type: Architecture Review
💡 Recommended Model: Sonnet 4.5 (Token-Constrained Mode)
🎯 Confidence: 90%

⚠️  TOKEN BUDGET WARNING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📊 Reasoning:
• Ideally requires Opus (deep architectural analysis)
• HOWEVER: Only 35k tokens remaining
• Opus review would consume ~40-50k tokens
• Risk of session termination mid-analysis

🎯 Recommended Strategy:
1. Use Sonnet for focused review (10-15k tokens)
2. Start fresh Opus session for comprehensive analysis
3. OR break into smaller review chunks

📈 Current Session:
• Tokens Used: 165k / 200k
• Tokens Remaining: 35k (CRITICAL THRESHOLD)
• Model: Sonnet 4.5

⚡ Action: Continue with Sonnet in focused mode
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 Tip: Consider starting new session with Opus for full analysis
```

## Expected Outcome (Sonnet Focused Mode)

**Sonnet Session Output:**

### Quick Architecture Scan
```
✅ WebSocket implementation: Standard socket.io pattern
✅ Redis pub/sub: Properly configured for horizontal scaling
⚠️ Missing: Connection pooling for PostgreSQL
⚠️ Missing: Message queuing for failed deliveries

Key Improvements (Summary):
1. Add connection pooling (pg-pool)
2. Implement retry logic with exponential backoff
3. Add dead letter queue for failed messages
```

**Token Usage:** ~12k tokens (efficient focused scan)

### Detailed Analysis Deferred
```
📋 For comprehensive review, start fresh Opus session:
• Detailed performance analysis
• Security audit
• Scalability projections
• Cost optimization strategies
```

## Alternative: Fresh Session Strategy

If user prefers comprehensive analysis:

```
💡 RECOMMENDATION: Start Fresh Opus Session

Current session: 35k tokens remaining (insufficient)

Suggested workflow:
1. End current Sonnet session
2. Start new Opus session (200k tokens)
3. Run comprehensive architecture review
4. Generate detailed improvement plan

This ensures:
• Complete analysis without interruption
• Room for iterative discussion
• Proper documentation generation
```

## Token Budget Integration

This example shows coordination with `token-aware-testing` skill:

```typescript
// Shared token budget logic
if (tokensRemaining < 50000) {
  // Model router: Prefer Sonnet
  // Testing skill: Use BashOutput mode
  // Both skills coordinate for efficiency
}
```

## Key Takeaway

**Model router adapts recommendations based on token budget:**
- Abundant tokens (>100k): Use ideal model (Opus for planning, Sonnet for implementation)
- Medium tokens (50-100k): Balance quality vs efficiency
- Low tokens (<50k): Prioritize efficiency, suggest fresh session for deep work
