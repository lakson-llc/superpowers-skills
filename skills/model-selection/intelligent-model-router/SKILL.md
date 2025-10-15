# Intelligent Model Router Skill

**Version**: 1.0.0
**Type**: Auto-invoked (before_request)
**Priority**: High (runs before task execution)

## Purpose

Automatically analyzes incoming user requests and recommends the optimal Claude model (Opus vs Sonnet 4.5) based on task complexity, scope, and current token budget.

## Decision Matrix

### Route to Opus (Deep Reasoning Required)

**Trigger Conditions:**
- **Keywords detected**: "design", "architecture", "plan", "review", "analyze", "debug complex", "refactor large", "qcheck", "qcheckf", "qcheckt"
- **File impact**: >5 files will be modified (detected via git diff or user description)
- **Database changes**: Schema migrations, table alterations, data safety concerns
- **Complex debugging**: Race conditions, performance issues, security vulnerabilities
- **Token budget**: >50k tokens remaining in session
- **User shortcuts**: QCHECK, QCHECKF, QCHECKT, QPLAN

**Reasoning:**
Opus excels at:
- Multi-step reasoning
- Architectural decisions
- Code quality analysis
- Complex problem decomposition
- Security and safety review

### Route to Sonnet 4.5 (Fast Execution Required)

**Trigger Conditions:**
- **Keywords detected**: "implement", "fix bug", "test", "commit", "deploy", "run", "write", "add", "update"
- **File impact**: <3 files will be modified
- **Iteration loops**: Fix → test → fix cycles
- **Token budget**: <50k tokens remaining (need efficiency)
- **User shortcuts**: QCODE, QGIT, QUX, QNEW
- **Testing phase**: Running Playwright tests, unit tests, or build verification

**Reasoning:**
Sonnet 4.5 excels at:
- Fast code generation
- Test execution
- Iterative improvements
- Routine refactoring
- Token efficiency (83% less for testing)

### Stay Current Model

**Trigger Conditions:**
- User explicitly specified model in request
- Mid-task execution (don't interrupt flow)
- Ambiguous task type
- Model switching would cause context loss

## Implementation

### Analysis Process

```typescript
function analyzeRequest(userRequest: string, context: SessionContext): ModelRecommendation {
  // 1. Parse keywords
  const keywords = extractKeywords(userRequest.toLowerCase());

  // 2. Check token budget
  const tokensRemaining = context.tokenBudget - context.tokensUsed;

  // 3. Analyze scope
  const fileImpact = estimateFileImpact(userRequest, context.gitStatus);

  // 4. Check shortcuts
  const shortcut = detectShortcut(userRequest);

  // 5. Calculate confidence score
  const opusScore = calculateOpusScore(keywords, tokensRemaining, fileImpact, shortcut);
  const sonnetScore = calculateSonnetScore(keywords, tokensRemaining, fileImpact, shortcut);

  // 6. Return recommendation
  if (opusScore > sonnetScore && opusScore > 0.6) {
    return { model: 'opus', confidence: opusScore, reason: generateReason(opusScore) };
  } else if (sonnetScore > opusScore && sonnetScore > 0.6) {
    return { model: 'sonnet', confidence: sonnetScore, reason: generateReason(sonnetScore) };
  } else {
    return { model: 'current', confidence: 0.5, reason: 'Ambiguous task - continuing with current model' };
  }
}
```

### Scoring Algorithm

**Opus Score Factors:**
- Design/architecture keywords: +0.3
- >5 file impact: +0.2
- Database schema changes: +0.4
- QCHECK shortcuts: +0.5
- >50k tokens remaining: +0.2
- Complex debugging keywords: +0.3

**Sonnet Score Factors:**
- Implementation keywords: +0.3
- <3 file impact: +0.2
- Testing keywords: +0.3
- QCODE/QGIT shortcuts: +0.4
- <50k tokens remaining: +0.3
- Iteration loop detected: +0.2

### Output Format

When recommendation confidence >0.6:

```
🤖 Model Router Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Task Type: [Planning / Implementation / Review / Testing]
💡 Recommended Model: [Opus / Sonnet 4.5]
🎯 Confidence: [XX%]

📊 Reasoning:
• [Primary reason - e.g., "Architectural design detected"]
• [Supporting reason - e.g., "50k+ tokens available"]
• [Additional context - e.g., "5+ files will be modified"]

📈 Current Session:
• Tokens Used: XXk / 200k
• Model: [Current model name]

⚡ Action: [Auto-switching to Opus / Continue with current model]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Integration with Existing Skills

### Token-Aware Testing Coordination

Shares token budget data with `token-aware-testing` skill:

```typescript
// Model router considers testing mode when recommending model
if (testingModeActive && tokensRemaining < 100k) {
  // Prefer Sonnet for optimized Playwright
  sonnetScore += 0.2;
}
```

### Auto-Testing Workflow Integration

Works in sequence:

```
[User Request]
    ↓
[intelligent-model-router] → Analyzes & recommends
    ↓
[User switches model if needed]
    ↓
[Code changes made]
    ↓
[auto-testing-workflow] → Triggers testing
    ↓
[token-aware-testing] → Selects test mode
    ↓
[mandatory-dual-verification] → Enforces verification
```

## Configuration

**File**: `skill.json`

```json
{
  "opus_token_threshold": 50000,
  "sonnet_token_threshold": 50000,
  "confidence_threshold": 0.6,
  "auto_proceed_delay": 3,
  "opus_keywords": [
    "design", "architecture", "plan", "review", "analyze",
    "debug complex", "refactor large", "qcheck", "security"
  ],
  "sonnet_keywords": [
    "implement", "fix", "test", "commit", "deploy", "run",
    "write", "add", "update", "qcode", "qgit"
  ],
  "file_impact_threshold": 5
}
```

## Examples

### Example 1: Planning Session

**Input:**
```
"Design a notification system with WebSocket support and database persistence"
```

**Analysis:**
- Keywords: "design" (+0.3)
- Estimated files: 8+ (+0.2)
- Database changes: Yes (+0.4)
- Opus Score: 0.9

**Output:**
```
🤖 Recommended: Opus (90% confidence)
📊 Reasoning: Architectural design + database schema + 8+ files
⚡ Switching to Opus for planning phase
```

### Example 2: Implementation Task

**Input:**
```
"Implement the notification badge counter in the header component"
```

**Analysis:**
- Keywords: "implement" (+0.3)
- Estimated files: 2 (+0.2)
- Component-level change (+0.1)
- Sonnet Score: 0.6

**Output:**
```
🤖 Recommended: Sonnet 4.5 (60% confidence)
📊 Reasoning: Implementation task + 2 files + component-level
⚡ Continuing with Sonnet 4.5
```

### Example 3: Code Review

**Input:**
```
"Run QCHECK on the authentication refactor"
```

**Analysis:**
- Shortcut: QCHECK (+0.5)
- Keywords: "review", "authentication" (+0.3)
- Opus Score: 0.8

**Output:**
```
🤖 Recommended: Opus (80% confidence)
📊 Reasoning: QCHECK shortcut detected + code quality review
⚡ Switching to Opus for thorough review
```

## Testing Strategy

### Manual Activation

Users can explicitly invoke:
```
"QROUTE: [describe your task]"
```

This will output the recommendation without auto-switching, allowing users to manually choose.

### Continuous Learning

Track recommendation accuracy:
```typescript
// Log when user overrides recommendation
if (userOverride) {
  logOverride({
    request: userRequest,
    recommended: recommendedModel,
    chosen: chosenModel,
    reason: userReason
  });
}
```

## Rollout Plan

**Phase 1**: Recommendation only (no auto-switching)
- Show analysis but don't change model
- Collect user feedback
- Refine scoring algorithm

**Phase 2**: Opt-in auto-switching
- Add `auto_switch: true` config option
- Proceed after 3-second delay
- Allow instant cancel with Ctrl+C

**Phase 3**: Full automation
- Default to auto-switching
- Silent mode for high-confidence decisions
- Verbose mode for learning/debugging

## Success Metrics

- **Accuracy**: >80% of recommendations accepted by user
- **Token Efficiency**: 20% improvement in token usage per session
- **User Satisfaction**: Reduced friction in model switching
- **Time Saved**: 30 seconds per task (no manual decision needed)

## Limitations

- Cannot detect complexity from vague requests
- May misjudge scope without git context
- Initial learning curve for scoring weights
- Requires periodic recalibration

## Future Enhancements

1. **Machine Learning**: Train on historical user choices
2. **Context Awareness**: Consider previous task outcomes
3. **Team Patterns**: Learn org-specific preferences
4. **Cost Optimization**: Factor in API costs per model
5. **Performance Tracking**: Measure actual vs estimated complexity
