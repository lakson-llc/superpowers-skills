# Example: Implementation Task

## User Request
```
"Implement the notification badge counter in the header component.
It should show unread count from the API."
```

## Analysis

### Keyword Detection
- ✅ "Implement" (sonnet_keyword)
- ✅ "component" (small scope indicator)

### Scope Estimation
- **Files to modify**: 2-3
  - `client/components/Header.tsx` (add badge)
  - `shared/types/notifications.ts` (type definitions)
  - `client/hooks/useNotifications.ts` (API hook - might already exist)

- **Database changes**: NO
- **Architecture changes**: NO (using existing API)

### Token Budget Check
- Tokens remaining: 120k / 200k
- Above sonnet_threshold: ✅ (efficient mode preferred)

### Scoring

**Sonnet Score:**
- Implementation keyword: +0.3
- 2-3 files (small scope): +0.2
- Component-level change: +0.1
- No architecture needed: +0.2
- **Total: 0.8 = 80%**

**Opus Score:**
- No design keywords: 0
- Small scope: -0.1
- **Total: 0.0 = 0%**

## Recommendation

```
🤖 Model Router Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Task Type: Component Implementation
💡 Recommended Model: Sonnet 4.5
🎯 Confidence: 80%

📊 Reasoning:
• Straightforward implementation task
• Small scope (2-3 files)
• Component-level change with existing API
• No architectural decisions required

📈 Current Session:
• Tokens Used: 80k / 200k
• Model: Sonnet 4.5

⚡ Action: Continue with Sonnet 4.5 (optimal for fast implementation)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Expected Outcome

**Sonnet Session Output:**
1. **Read existing code**
   - Check Header component structure
   - Review notification API endpoint
   - Check if useNotifications hook exists

2. **Implement badge**
   ```tsx
   // Add to Header.tsx
   const { unreadCount } = useNotifications();

   <Badge count={unreadCount} />
   ```

3. **Write tests**
   ```typescript
   describe('Header notification badge', () => {
     it('displays unread count', () => {
       // ...
     });
   });
   ```

4. **Run verification**
   - TypeScript typecheck: ✅
   - Unit tests: ✅
   - Playwright test: ✅

**Token Usage:** ~15k tokens (efficient implementation)

## Workflow Complete

Task completed in single Sonnet session - no model switch needed.
