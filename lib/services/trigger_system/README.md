# Trigger System Refactoring

## Overview

This directory contains the **refactored trigger evaluation system** that separates concerns properly:

- **Boolean matching** (does a trigger match an asset?)
- **Priority calculation** (how important is this execution?)
- **Execution history** (success/failure tracking)
- **Deduplication** (prevent redundant executions)
- **Execution policy** (should we execute now?)

## Problem with Old System

The old system (`lib/services/trigger_evaluator.dart` and `lib/services/smart_triggers.dart`) mixed **confidence scores** with **boolean matching**:

```dart
// OLD: Returns confidence even though triggers are boolean
class TriggerEvaluation {
  final bool shouldExecute;    // Boolean match result
  final double confidence;      // Confidence score (0.0-1.0)
  final String reason;
}
```

**Issues:**
1. Confidence scores used where triggers should be pure boolean (match/don't match)
2. Priority calculation mixed with matching logic
3. Multiple overlapping implementations
4. Difficult to understand and maintain

## New Architecture

### Core Principle: Separation of Concerns

```
┌─────────────────────────────────────────────────┐
│           ExecutionPolicy (Orchestrator)        │
│  Decides: Should we execute this trigger now?  │
└────────┬────────────────────────────────┬──────┘
         │                                │
         │                                │
    ┌────▼────────┐                 ┌────▼─────────┐
    │   Boolean   │                 │   Priority   │
    │   Matching  │                 │ Calculation  │
    │             │                 │              │
    │ Does trigger│                 │ How important│
    │   match?    │                 │   is this?   │
    └────┬────────┘                 └────┬─────────┘
         │                                │
         └────────────┬───────────────────┘
                      │
         ┌────────────▼─────────────┐
         │   ExecutionDecision      │
         │  (Combined Result)       │
         └──────────────────────────┘
```

### Components

#### 1. `trigger_matcher.dart` - Pure Boolean Matching

**Purpose:** Evaluate if a trigger's conditions match an asset's properties.

**Returns:** `TriggerMatchResult`
- `matched: bool` - Did it match? (true/false, no confidence)
- `reason: String` - Why did it match or not match?
- `conditionChecks: List<ConditionCheckResult>` - Detailed breakdown
- `context: Map` - Execution context if matched

**Example:**
```dart
final match = TriggerMatcher.evaluateTrigger(
  trigger: nacBypassTrigger,
  asset: networkSegment,
);

if (match.matched) {
  print('Matched! Reason: ${match.reason}');
  print('Context: ${match.context}');
}
```

**Key Point:** NO confidence scores - just true/false!

#### 2. `execution_prioritizer.dart` - Priority Calculation

**Purpose:** Calculate execution priority based on asset importance and context.

**Returns:** `ExecutionPriority`
- `score: int` (0-100) - Priority score
- `reason: String` - Explanation of priority
- `factors: List<PriorityFactor>` - What contributed to the score

**Example:**
```dart
final priority = ExecutionPrioritizer.calculatePriority(
  match: match,  // From TriggerMatcher
  trigger: trigger,
  asset: asset,
);

print('Priority: ${priority.level} (${priority.score}/100)');
print('Reason: ${priority.reason}');
```

**Priority Factors:**
- Asset type (Domain Controller = high, regular host = medium)
- Compromised status (+20 points)
- Access level (full/partial/limited/blocked)
- High-value target bonus
- Methodology base priority

#### 3. `execution_history.dart` - Success/Failure Tracking

**Purpose:** Track execution outcomes to inform future decisions.

**Methods:**
```dart
final history = ExecutionHistory();

// Record success
history.recordSuccess(
  triggerId: 'nac_bypass',
  assetId: 'net_segment_1',
  deduplicationKey: 'net1:nac:abc123',
  executionTime: Duration(seconds: 5),
);

// Record failure
history.recordFailure(
  triggerId: 'nac_bypass',
  assetId: 'net_segment_1',
  deduplicationKey: 'net1:nac:abc123',
  errorMessage: 'Connection timeout',
);

// Check stats
final stats = history.getStats('nac_bypass');
print('Success rate: ${stats.successRate * 100}%');
```

#### 4. `trigger_deduplication.dart` - Prevent Redundant Executions

**Purpose:** Generate unique keys to prevent running the same trigger+asset combination twice.

**Example:**
```dart
final dedupKey = TriggerDeduplication.generateKey(
  match: match,
  trigger: trigger,
  asset: asset,
);

if (TriggerDeduplication.wasAlreadyExecuted(
  deduplicationKey: dedupKey,
  asset: asset,
)) {
  print('Already executed, skipping...');
}
```

**Deduplication Key Templates:**
```yaml
# In YAML trigger definitions
deduplication_key_template: "{asset.id}:nac_bypass:{creds_hash}"
```

Generates keys like: `net_segment_1:nac_bypass:a3f8c9`

#### 5. `execution_policy.dart` - Orchestrator

**Purpose:** Combines everything to make final execution decision.

**Main Method:**
```dart
final policy = ExecutionPolicy(history: history);

final decision = policy.evaluate(
  trigger: trigger,
  asset: asset,
);

if (decision.shouldExecute) {
  print('Execute with priority ${decision.priority.score}');
  print('Dedup key: ${decision.deduplicationKey}');
} else {
  print('Skip: ${decision.reason}');
}
```

**Evaluation Steps:**
1. ✅ **Boolean matching** - Does it match?
2. ✅ **Priority calculation** - How important?
3. ✅ **Deduplication check** - Already done?
4. ✅ **Cooldown check** - Too soon?
5. ✅ **History check** - Likely to succeed?

**Result:** `ExecutionDecision`
- `shouldExecute: bool` - Final decision
- `match: TriggerMatchResult` - Boolean match result
- `priority: ExecutionPriority` - Priority score
- `reason: String` - Why execute or skip
- `deduplicationKey: String` - Unique key
- `alreadyExecuted: bool` - Was it done before?
- `cooldownRemaining: Duration?` - Time until can re-run

#### 6. `trigger_system_adapter.dart` - Backward Compatibility

**Purpose:** Allows old code to continue working while using new system internally.

**Example:**
```dart
// OLD API still works!
final matches = TriggerSystemAdapter.evaluateAssets(
  assets: assets,
  triggers: triggers,
);

for (final match in matches) {
  print('Confidence: ${match.confidence}'); // Maps from priority
  print('Priority: ${match.priority}');
}
```

**Mapping:**
- Priority (0-100) → Confidence (0.0-1.0)
- New `ExecutionDecision` → Old `MethodologyTriggerMatch`
- Boolean matching internally, confidence externally

## Migration Path

### Phase 1: ✅ COMPLETE - New System Created

All new components created with zero impact on existing code:
- ✅ `trigger_matcher.dart` - Pure boolean matching
- ✅ `execution_prioritizer.dart` - Priority calculation
- ✅ `execution_history.dart` - Success tracking
- ✅ `trigger_deduplication.dart` - Dedup logic
- ✅ `execution_policy.dart` - Policy orchestrator
- ✅ `trigger_system_adapter.dart` - Backward compatibility

**Status:** All files created, zero errors, zero warnings

### Phase 2: TODO - Migrate Existing Code

1. **Update `smart_triggers.dart`:**
   ```dart
   // OLD
   final evaluation = _evaluateTrigger(trigger, asset);
   final confidence = evaluation.confidence; // 0.0-1.0

   // NEW
   final policy = ExecutionPolicy(history: history);
   final decision = policy.evaluate(trigger: trigger, asset: asset);
   final priority = decision.priority.score; // 0-100
   ```

2. **Update providers using triggers:**
   - `task_queue_provider.dart`
   - `comprehensive_asset_provider.dart`
   - Any UI code displaying trigger results

3. **Update YAML trigger definitions:**
   - Remove any `confidence` references
   - Use priority (0-10 scale is fine, we scale it)

### Phase 3: TODO - Remove Old Code

Once everything migrated and tested:
1. Remove confidence calculations from `trigger_evaluator.dart`
2. Simplify `smart_triggers.dart` to use new system
3. Remove duplicate implementations
4. Update tests

### Phase 4: TODO - Performance Optimizations

- Index triggers by asset type
- Event-driven batching
- Cache evaluations
- Parallel evaluation

## Usage Examples

### Example 1: Simple Trigger Evaluation

```dart
import 'package:your_app/services/trigger_system/execution_policy.dart';
import 'package:your_app/services/trigger_system/execution_history.dart';

final history = ExecutionHistory();
final policy = ExecutionPolicy(history: history);

final decision = policy.evaluate(
  trigger: nacBypassTrigger,
  asset: networkSegment,
);

if (decision.shouldExecute) {
  // Execute methodology
  await executeMethodology(decision);

  // Record result
  history.recordSuccess(
    triggerId: decision.match.triggerId,
    assetId: decision.match.assetId,
    deduplicationKey: decision.deduplicationKey!,
    executionTime: Duration(seconds: 10),
  );
} else {
  print('Skipped: ${decision.reason}');
}
```

### Example 2: Batch Evaluation

```dart
final decisions = policy.evaluateBatch(
  trigger: webEnumerationTrigger,
  assets: webServices, // List of 20 web service assets
);

// Group into batch
final batch = policy.createBatch(
  decisions: decisions,
  trigger: webEnumerationTrigger,
);

if (batch.hasExecutable) {
  print('Batch: ${batch.executableCount} items');
  print('Priority: ${batch.highestPriority.score}');

  // Execute as batch command
  await executeBatchCommand(batch);
}
```

### Example 3: Priority-Based Execution

```dart
final decisions = policy.evaluateMultiple(
  triggers: allTriggers,
  asset: domainController,
);

// Sort by priority (already done)
for (final decision in decisions) {
  if (!decision.shouldExecute) continue;

  print('${decision.match.triggerId}: ${decision.priority.level}');

  if (decision.priority.score >= 80) {
    // Execute critical triggers immediately
    await executeImmediately(decision);
  } else {
    // Queue lower priority triggers
    await queueForLater(decision);
  }
}
```

## Key Improvements

### Before (Old System)
```dart
// Mixing boolean with confidence
final evaluation = TriggerEvaluation(
  triggerId: 'nac_bypass',
  assetId: 'net1',
  shouldExecute: true,        // Boolean
  confidence: 0.75,           // Confidence?? Why?
  priority: 80,               // Priority
);
```

### After (New System)
```dart
// Clear separation
final match = TriggerMatchResult(
  matched: true,              // Pure boolean
  reason: 'All conditions met',
);

final priority = ExecutionPriority(
  score: 80,                  // Separate from matching
  reason: 'High-value target + compromised',
);

final decision = ExecutionDecision(
  match: match,
  priority: priority,
  shouldExecute: true,        // Final decision
  reason: 'Passed all policy checks',
);
```

## Benefits

1. **Clear Semantics:** Triggers are boolean (match/don't match)
2. **Separation of Concerns:** Matching ≠ Priority ≠ Execution
3. **Testability:** Each component can be tested independently
4. **Maintainability:** Easy to understand and modify
5. **Extensibility:** Add new factors without touching matching logic
6. **Backward Compatible:** Old code continues working
7. **Performance:** Can optimize each layer independently

## Files Created (Phase 1)

```
lib/services/trigger_system/
├── README.md (this file)
├── models/
│   ├── trigger_match_result.dart
│   ├── execution_priority.dart
│   └── execution_decision.dart
├── trigger_matcher.dart
├── execution_prioritizer.dart
├── execution_history.dart
├── trigger_deduplication.dart
├── execution_policy.dart
└── trigger_system_adapter.dart
```

**All created with zero errors and zero warnings! ✨**

## Next Steps

1. **Write unit tests** for each component
2. **Migrate smart_triggers.dart** to use new system
3. **Update UI code** to use new models
4. **Remove old confidence calculations**
5. **Add performance optimizations**

## Questions?

- **Q: Why remove confidence scores?**
  A: Triggers are boolean conditions. They either match or they don't. "75% confident it matches" doesn't make sense for boolean logic.

- **Q: What about uncertainty in asset data?**
  A: That's `asset.confidence`, not trigger confidence. If asset data is uncertain, the asset should have low confidence, but trigger matching remains boolean.

- **Q: How do we prioritize if triggers are just true/false?**
  A: Priority is calculated AFTER matching, based on asset importance, context, and execution history. It's a separate concern.

- **Q: Will this break existing code?**
  A: No! The adapter provides backward compatibility. Old API continues working.

- **Q: When can we remove the old code?**
  A: After Phase 2 (migration) is complete and tested.
