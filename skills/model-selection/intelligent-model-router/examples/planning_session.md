# Example: Planning Session

## User Request
```
"Design a real-time notification system with WebSocket support,
Redis pub/sub for scaling, and PostgreSQL persistence"
```

## Analysis

### Keyword Detection
- ✅ "Design" (opus_keyword)
- ✅ "system" (architecture context)
- ✅ "PostgreSQL" (database keyword)

### Scope Estimation
- **Files to modify**: 10+
  - WebSocket server setup
  - Redis integration
  - Database schema migration
  - Frontend WebSocket client
  - API endpoints
  - TypeScript types
  - Tests

- **Database changes**: YES
  - New notifications table
  - User preferences table
  - Migration files

### Token Budget Check
- Tokens remaining: 180k / 200k
- Above opus_threshold (50k): ✅

### Scoring

**Opus Score:**
- Design keyword: +0.3
- Architecture context: +0.2
- 10+ files: +0.2
- Database schema: +0.4
- High token budget: +0.2
- **Total: 1.3 (capped at 1.0) = 100%**

**Sonnet Score:**
- No implementation keywords: 0
- **Total: 0.0 = 0%**

## Recommendation

```
🤖 Model Router Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Task Type: Architectural Planning
💡 Recommended Model: Opus
🎯 Confidence: 100%

📊 Reasoning:
• System design with WebSocket architecture
• Database schema changes required (new tables + migrations)
• 10+ files estimated for implementation
• 180k tokens available for deep analysis

📈 Current Session:
• Tokens Used: 20k / 200k
• Model: Sonnet 4.5

⚡ Action: Switch to Opus for comprehensive planning
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 Tip: After Opus creates the plan, switch back to Sonnet for implementation
```

## Expected Outcome

**Opus Session Output:**
1. **Architecture Overview**
   - WebSocket server design
   - Redis pub/sub topology
   - Database schema design
   - Frontend integration approach

2. **Technical Specifications**
   - Message format (JSON schema)
   - Authentication strategy
   - Connection management
   - Error handling

3. **Implementation Plan**
   - Step-by-step breakdown
   - Dependencies to install
   - Configuration requirements
   - Testing strategy

4. **Rollout Strategy**
   - Feature flags
   - Gradual rollout plan
   - Monitoring requirements

**Token Usage:** ~40k tokens (deep analysis)

## Next Step

After Opus completes planning:

```
"Use Sonnet: Implement the notification system following the plan"
```

This switches to efficient implementation mode.
