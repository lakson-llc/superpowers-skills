# Intelligent Model Router

Automatically recommends the optimal Claude model (Opus vs Sonnet 4.5) for your task based on complexity, scope, and token budget.

## Quick Start

### Automatic Analysis (Coming Soon)

The skill will automatically analyze your requests when enabled in `skill.json`:

```json
{
  "auto_switch_enabled": true
}
```

### Manual Trigger (Current Phase)

Use the `QROUTE` shortcut to analyze your task:

```
QROUTE: Design a notification system
```

Output:
```
🤖 Model Router Analysis
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 Task Type: Architectural Planning
💡 Recommended Model: Opus
🎯 Confidence: 95%

📊 Reasoning:
• System design with database changes
• 8+ files estimated
• 175k tokens available

⚡ Action: Switch to Opus for planning
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## Decision Logic

### Use Opus For:
- ✅ System architecture and design
- ✅ Complex debugging (race conditions, performance issues)
- ✅ Code reviews (QCHECK shortcuts)
- ✅ Database schema changes
- ✅ Security audits
- ✅ Large refactors (5+ files)
- ✅ When you have >50k tokens remaining

### Use Sonnet 4.5 For:
- ✅ Implementation tasks
- ✅ Bug fixes with known root cause
- ✅ Writing tests
- ✅ Git operations (commits, pushes)
- ✅ Running builds and deployments
- ✅ Small refactors (<3 files)
- ✅ When token budget is tight (<50k remaining)

## Integration with Existing Skills

### Token-Aware Testing
```
Model Router → Sonnet (low tokens)
    ↓
Testing Skill → BashOutput mode (token-efficient)
```

Both skills coordinate to maximize efficiency.

### Auto-Testing Workflow
```
[QROUTE analysis] → Recommends Sonnet
    ↓
[Implementation] → Code changes
    ↓
[auto-testing-workflow] → Triggers tests
    ↓
[token-aware-testing] → Optimized Playwright
```

## Configuration

Edit `skill.json` to customize:

```json
{
  "config": {
    "opus_token_threshold": 50000,      // Min tokens for Opus
    "confidence_threshold": 0.6,        // Min confidence to recommend
    "auto_proceed_delay": 3,            // Delay before auto-switch
    "auto_switch_enabled": false,       // Enable auto-switching
    "verbose_mode": true                // Show detailed analysis
  }
}
```

## Examples

See `examples/` directory for detailed scenarios:
- `planning_session.md` - System design with Opus
- `implementation_task.md` - Component implementation with Sonnet
- `code_review.md` - QCHECK with Opus
- `token_constrained.md` - Handling low token budgets

## Rollout Phases

### Phase 1 (Current): Recommendation Only
- Shows analysis but doesn't switch models
- Use `QROUTE` shortcut to trigger
- Collect feedback and refine algorithm

### Phase 2: Opt-In Auto-Switching
- Set `auto_switch_enabled: true`
- 3-second delay before switch
- Can cancel with Ctrl+C

### Phase 3: Full Automation
- Silent mode for high-confidence decisions
- Automatic switching without delay
- Verbose mode available for debugging

## Accuracy Tracking

The skill logs your choices to improve recommendations:

```typescript
// When you override a recommendation
logOverride({
  recommended: 'opus',
  chosen: 'sonnet',
  reason: 'Task simpler than estimated'
});
```

This data helps refine the scoring algorithm over time.

## Troubleshooting

### Recommendation seems wrong?

1. Check the reasoning section in output
2. Verify token budget is accurate
3. Review file impact estimation
4. Submit feedback via override logging

### How to disable?

Set in `skill.json`:
```json
{
  "triggers": []
}
```

### How to force a model?

Explicitly state in your request:
```
"Use Opus: Design the system"
"Use Sonnet: Implement the feature"
```

## Metrics

Track success with these metrics:
- **Accuracy**: % of recommendations accepted
- **Token Efficiency**: Avg tokens saved per session
- **Time Saved**: Seconds saved on decision making
- **User Satisfaction**: Override rate and feedback

## Support

For issues or suggestions:
1. Check examples/ for similar scenarios
2. Review SKILL.md for detailed algorithm
3. Adjust config in skill.json
4. Submit feedback in override logs

## Version History

- **1.0.0** (2025-10-14): Initial release
  - Recommendation-only mode
  - QROUTE shortcut
  - Integration with token-aware-testing
  - 4 example scenarios
