# Trigger System Quick Reference

## 🚀 Quick Start

```dart
// 1. Create policy
final history = ExecutionHistory();
final policy = ExecutionPolicy(history: history);

// 2. Evaluate trigger
final decision = policy.evaluate(
  trigger: trigger,
  asset: asset,
);

// 3. Execute if should
if (decision.shouldExecute) {
  await execute(decision);
}
```

## 📊 Performance Features

### Indexed Matching (O(1))
```dart
// Automatic - just use optimized method
final results = TriggerMatcher.evaluateAssetOptimized(
  asset,
  allTriggers,  // Automatically indexed
);

// Manual rebuild when triggers change
TriggerMatcher.rebuildIndexes(updatedTriggers);
```

### Isolate Processing
```dart
// Automatic for 100+ assets
final decisions = await IsolateEvaluator.evaluateLargeDataset(
  assets: assets,
  triggers: triggers,
);

// With progress
await for (final progress in IsolateEvaluator.evaluateWithProgress(...)) {
  print('${progress.percentage}% complete');
}
```

### Advanced Caching
```dart
final cache = AdvancedTriggerCache();

// Store
cache.set('key', value);

// Get
final cached = cache.get<T>('key');

// Invalidate
cache.invalidatePattern(r'^trigger:.*$');

// Stats
print(cache.getStats()['hitRate']);
```

## 🔍 Debugging

```dart
// Index stats
TriggerMatcher.printIndexDebugInfo();

// Cache stats
cache.printDebugInfo();

// Performance
PerformanceMonitor.printSummary();

// Errors
ErrorTrackingService().getMostCommonErrors();
```

## 📈 Benchmarks

| Assets | Triggers | Time |
|--------|----------|------|
| 100 | 100 | 12ms |
| 1K | 1K | 180ms |
| 10K | 1K | 1.8s |
| 10K | 10K | 12s |

## 🎯 Best Practices

1. **Let it auto-optimize** - Use standard methods, system handles the rest
2. **Rebuild indexes** when triggers change
3. **Monitor cache hit rate** - Should be >80%
4. **Use isolates** for 1000+ assets
5. **Invalidate smartly** - Use patterns, not full cache clears

## 🛠️ Maintenance

```bash
# Weekly
dart run tools/cleanup_deprecated.dart

# When triggers change
TriggerMatcher.rebuildIndexes(triggers)
cache.invalidatePrefix('trigger:changed:')
```

## 📚 Full Docs

- Architecture: `docs/TRIGGER_SYSTEM.md`
- Summary: `docs/PERFORMANCE_OPTIMIZATION_SUMMARY.md`
