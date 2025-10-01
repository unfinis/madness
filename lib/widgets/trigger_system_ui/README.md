# Trigger System UI Components

This directory contains UI components for displaying trigger system information with clarity and precision. The UI has been redesigned to use **boolean trigger matching** with **separate execution priority** instead of confusing confidence scores.

## Philosophy

The trigger system UI follows these principles:

1. **Boolean Matching**: Triggers either match or don't match - no percentages
2. **Separate Priority**: Execution priority is calculated independently from matching
3. **Clear Visualization**: Use icons, colors, and badges to convey status at a glance
4. **Historical Context**: Show past performance to inform decisions
5. **Actionable**: Provide clear actions for execution decisions

## Components

### Core Indicators

#### TriggerMatchIndicator
Displays whether a trigger matched an asset.

```dart
TriggerMatchIndicator(
  match: triggerMatchResult,
  showLabel: true,
)
```

**Visual Output:**
- ✅ Green check + "Match" for matches
- ⚪ Gray X + "No Match" for non-matches

#### ExecutionPriorityBadge
Shows the calculated execution priority.

```dart
ExecutionPriorityBadge(
  priority: executionPriority,
  showScore: true,
  compact: false,
)
```

**Visual Output:**
- 🔴 Critical (score ≥80): Red with warning icon
- 🟠 High (score ≥60): Orange with up arrow
- 🟡 Medium (score ≥40): Amber with horizontal line
- 🔵 Low (score <40): Blue with down arrow

#### ExecutionDecisionCard
Complete card displaying all decision information.

```dart
ExecutionDecisionCard(
  decision: executionDecision,
  methodologyName: 'NAC Detection',
  onExecute: () => executeMethodology(),
  onSkip: () => skipExecution(),
)
```

**Contains:**
- Match status (boolean)
- Execution priority (score + level)
- Decision reason
- Deduplication key
- Warnings (already executed, cooldown)
- Execution context preview
- Action buttons

### History & Stats

#### TriggerHistoryStats
Displays historical performance metrics.

```dart
TriggerHistoryStats(
  triggerId: 'trigger-123',
  history: executionHistory,
)
```

**Shows:**
- Success rate (percentage)
- Total executions (count)
- Average execution time
- Failure count (if any)

### Progress & Feedback

#### ExecutionProgressIndicator
Real-time progress during execution.

```dart
ExecutionProgressIndicator(
  progressStream: progressStream,
)
```

**Displays:**
- Linear progress bar
- Current step description
- Completed/Total count
- Error state (if applicable)

#### TriggerNotifications
Toast notifications for events.

```dart
// Execution started
TriggerNotifications.showExecutionStarted(context, 'Port Scan');

// Execution complete
TriggerNotifications.showExecutionComplete(
  context,
  success: true,
  methodologyName: 'Port Scan',
);

// Trigger matched
TriggerNotifications.showTriggerMatched(context, 'NAC Detection', matchCount: 3);

// Evaluation summary
TriggerNotifications.showEvaluationSummary(
  context,
  totalTriggers: 10,
  matchedTriggers: 6,
  decisionsToExecute: 12,
);

// Errors and warnings
TriggerNotifications.showError(context, 'Execution failed', details: errorMsg);
TriggerNotifications.showWarning(context, 'Cooldown active');
```

## Screens

### TriggerEvaluationScreen
Main screen for viewing and managing trigger evaluations.

```dart
TriggerEvaluationScreen(
  decisions: executionDecisions,
  methodologyNames: {'trigger-1': 'NAC Detection', ...},
  onExecute: (decision) => execute(decision),
  onSkip: (decision) => skip(decision),
)
```

**Features:**
- Three tabs: All, To Execute, Skipped
- Sorting by priority, name, or status
- Bulk execution
- Floating action button for quick execution

### TriggerMonitoringDashboard
Real-time monitoring of trigger system.

```dart
TriggerMonitoringDashboard()
```

**Displays:**
- Performance metrics (evaluation speed, cache hit rate, throughput)
- Quality metrics (match rate, success rate, false positives)
- Active executions with progress
- Recent events timeline

## Theme

The `TriggerSystemTheme` class provides consistent styling:

```dart
// Priority colors
TriggerSystemTheme.getPriorityColor('critical') // Returns red
TriggerSystemTheme.priorityDecoration('high')   // Returns styled box
TriggerSystemTheme.priorityIcon('medium')       // Returns appropriate icon

// Match colors
TriggerSystemTheme.getMatchColor(true)  // Green for match
TriggerSystemTheme.getMatchColor(false) // Grey for no match

// Execution colors
TriggerSystemTheme.getExecutionColor('success') // Green
TriggerSystemTheme.getExecutionColor('failed')  // Red
```

## Usage Examples

### Basic Trigger Display

```dart
// Show a single trigger evaluation
ExecutionDecisionCard(
  decision: decision,
  methodologyName: 'Network Scan',
  onExecute: () {
    // Execute the methodology
  },
)
```

### Trigger List with History

```dart
Column(
  children: [
    ExecutionDecisionCard(decision: decision),
    SizedBox(height: 8),
    TriggerHistoryStats(
      triggerId: decision.match.triggerId,
      history: executionHistory,
    ),
  ],
)
```

### Full Evaluation Flow

```dart
// 1. User triggers evaluation
final decisions = await evaluateTriggers(assets);

// 2. Show summary
TriggerNotifications.showEvaluationSummary(
  context,
  totalTriggers: triggers.length,
  matchedTriggers: decisions.where((d) => d.match.matched).length,
  decisionsToExecute: decisions.where((d) => d.shouldExecute).length,
);

// 3. Navigate to evaluation screen
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => TriggerEvaluationScreen(
      decisions: decisions,
      methodologyNames: methodologyMap,
      onExecute: (decision) async {
        TriggerNotifications.showExecutionStarted(context, methodologyName);

        final success = await executeMethodology(decision);

        TriggerNotifications.showExecutionComplete(
          context,
          success: success,
          methodologyName: methodologyName,
        );
      },
    ),
  ),
);
```

## Migration from Confidence UI

### Old Pattern (Confidence)
```dart
// ❌ OLD: Confusing percentage
ListTile(
  title: Text('Trigger Match'),
  trailing: Text('${(confidence * 100).toInt()}%'),
)
```

### New Pattern (Boolean + Priority)
```dart
// ✅ NEW: Clear boolean match + separate priority
Row(
  children: [
    TriggerMatchIndicator(match: matchResult),
    Spacer(),
    ExecutionPriorityBadge(priority: priority),
  ],
)
```

## Best Practices

1. **Always show both match and priority** - They represent different concepts
2. **Use appropriate notifications** - Don't spam the user with trivial updates
3. **Provide historical context** - Show stats when users need to make decisions
4. **Enable bulk actions** - For efficiency when multiple triggers match
5. **Clear visual hierarchy** - Most important info (match, priority) should be prominent

## Color Coding

- 🟢 **Green**: Success, Match, High success rate
- 🔴 **Red**: Critical priority, Failure, Error
- 🟠 **Orange**: High priority, Warning
- 🟡 **Yellow**: Medium priority
- 🔵 **Blue**: Low priority, Information, Running
- ⚪ **Grey**: No match, Neutral, Inactive

## Accessibility

All components follow accessibility guidelines:
- Sufficient color contrast (WCAG AA)
- Semantic icons alongside text
- Screen reader friendly labels
- Touch targets ≥48x48 (mobile)
- Keyboard navigation support
