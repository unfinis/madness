import 'dart:async';

/// Advanced multi-layer caching system with TTL and invalidation
///
/// Features:
/// - L1 Cache: In-memory with TTL (fast, limited size)
/// - L2 Cache: In-memory persistent (larger, slower eviction)
/// - LRU eviction policy
/// - Pattern-based invalidation
/// - Cache statistics and monitoring
class AdvancedTriggerCache {
  /// L1 Cache: In-memory with short TTL for hot data
  final Map<String, CachedItem> _l1Cache = {};
  static const _l1MaxSize = 1000;
  static const _l1TTL = Duration(minutes: 5);

  /// L2 Cache: In-memory with longer TTL for warm data
  final Map<String, CachedItem> _l2Cache = {};
  static const _l2MaxSize = 10000;
  static const _l2TTL = Duration(hours: 24);

  /// Access order tracking for LRU
  final Map<String, DateTime> _l1AccessTime = {};
  final Map<String, DateTime> _l2AccessTime = {};

  /// Cache statistics
  int _hits = 0;
  int _misses = 0;
  int _evictions = 0;
  int _l1Promotions = 0;
  final _startTime = DateTime.now();

  /// Get value from cache with multi-layer lookup
  T? get<T>(String key) {
    // Check L1 (hot cache)
    final l1Item = _l1Cache[key];
    if (l1Item != null && !l1Item.isExpired) {
      _hits++;
      _updateL1Access(key);
      return l1Item.value as T?;
    }

    // Check L2 (warm cache)
    final l2Item = _l2Cache[key];
    if (l2Item != null && !l2Item.isExpired) {
      _hits++;
      _updateL2Access(key);

      // Promote to L1 if accessed frequently
      _promoteToL1(key, l2Item);

      return l2Item.value as T?;
    }

    _misses++;
    return null;
  }

  /// Set value in cache with write-through
  void set<T>(String key, T value, {Duration? ttl}) {
    final item = CachedItem(
      value: value,
      timestamp: DateTime.now(),
      ttl: ttl ?? _l1TTL,
    );

    // Write to L1
    _l1Cache[key] = item;
    _updateL1Access(key);
    _enforceL1Size();

    // Also write to L2 with longer TTL
    final l2Item = CachedItem(
      value: value,
      timestamp: DateTime.now(),
      ttl: _l2TTL,
    );
    _l2Cache[key] = l2Item;
    _updateL2Access(key);
    _enforceL2Size();
  }

  /// Set value only in L1 (hot cache)
  void setHot<T>(String key, T value, {Duration? ttl}) {
    final item = CachedItem(
      value: value,
      timestamp: DateTime.now(),
      ttl: ttl ?? _l1TTL,
    );

    _l1Cache[key] = item;
    _updateL1Access(key);
    _enforceL1Size();
  }

  /// Invalidate by exact key
  void invalidate(String key) {
    _l1Cache.remove(key);
    _l2Cache.remove(key);
    _l1AccessTime.remove(key);
    _l2AccessTime.remove(key);
  }

  /// Invalidate by regex pattern
  void invalidatePattern(String pattern) {
    final regex = RegExp(pattern);

    // Invalidate L1
    _l1Cache.removeWhere((key, _) {
      final shouldRemove = regex.hasMatch(key);
      if (shouldRemove) {
        _evictions++;
        _l1AccessTime.remove(key);
      }
      return shouldRemove;
    });

    // Invalidate L2
    _l2Cache.removeWhere((key, _) {
      final shouldRemove = regex.hasMatch(key);
      if (shouldRemove) {
        _evictions++;
        _l2AccessTime.remove(key);
      }
      return shouldRemove;
    });
  }

  /// Invalidate by prefix
  void invalidatePrefix(String prefix) {
    invalidatePattern('^${RegExp.escape(prefix)}');
  }

  /// Invalidate by suffix
  void invalidateSuffix(String suffix) {
    invalidatePattern('${RegExp.escape(suffix)}\$');
  }

  /// Invalidate all cache
  void invalidateAll() {
    final count = _l1Cache.length + _l2Cache.length;
    _l1Cache.clear();
    _l2Cache.clear();
    _l1AccessTime.clear();
    _l2AccessTime.clear();
    _evictions += count;
  }

  /// Check if key exists in cache
  bool contains(String key) {
    final l1Item = _l1Cache[key];
    if (l1Item != null && !l1Item.isExpired) return true;

    final l2Item = _l2Cache[key];
    if (l2Item != null && !l2Item.isExpired) return true;

    return false;
  }

  /// Get all keys matching a pattern
  List<String> getKeysMatching(String pattern) {
    final regex = RegExp(pattern);
    final keys = <String>{};

    // Check L1
    for (final key in _l1Cache.keys) {
      final item = _l1Cache[key];
      if (regex.hasMatch(key) && item != null && !item.isExpired) {
        keys.add(key);
      }
    }

    // Check L2
    for (final key in _l2Cache.keys) {
      final item = _l2Cache[key];
      if (regex.hasMatch(key) && item != null && !item.isExpired) {
        keys.add(key);
      }
    }

    return keys.toList();
  }

  /// Get cache statistics
  Map<String, dynamic> getStats() {
    final total = _hits + _misses;
    final uptime = DateTime.now().difference(_startTime);

    return {
      'hits': _hits,
      'misses': _misses,
      'hitRate': total > 0 ? (_hits / total * 100).toStringAsFixed(2) : '0.00',
      'l1Size': _l1Cache.length,
      'l2Size': _l2Cache.length,
      'evictions': _evictions,
      'l1Promotions': _l1Promotions,
      'l1SizeBytes': _estimateL1Size(),
      'l2SizeBytes': _estimateL2Size(),
      'totalSizeBytes': _estimateL1Size() + _estimateL2Size(),
      'uptimeMinutes': uptime.inMinutes,
      'requestsPerMinute': uptime.inMinutes > 0 ? total / uptime.inMinutes : 0,
    };
  }

  /// Get detailed breakdown
  Map<String, dynamic> getDetailedStats() {
    final stats = getStats();
    final total = _hits + _misses;

    return {
      ...stats,
      'l1MaxSize': _l1MaxSize,
      'l2MaxSize': _l2MaxSize,
      'l1FillRate': (_l1Cache.length / _l1MaxSize * 100).toStringAsFixed(2),
      'l2FillRate': (_l2Cache.length / _l2MaxSize * 100).toStringAsFixed(2),
      'l1HitRate': _calculateL1HitRate(),
      'avgItemSizeBytes': total > 0
          ? ((stats['totalSizeBytes'] as int) / total).toStringAsFixed(0)
          : '0',
    };
  }

  /// Warm up cache with multiple values
  void warmUp(Map<String, dynamic> values, {Duration? ttl}) {
    for (final entry in values.entries) {
      set(entry.key, entry.value, ttl: ttl);
    }
  }

  /// Preload specific patterns
  Future<void> preload(
    String pattern,
    Future<Map<String, dynamic>> Function() loader,
  ) async {
    final data = await loader();
    warmUp(data);
  }

  /// Clean up expired entries
  int cleanExpired() {
    var removed = 0;

    // Clean L1
    _l1Cache.removeWhere((key, item) {
      if (item.isExpired) {
        _l1AccessTime.remove(key);
        removed++;
        return true;
      }
      return false;
    });

    // Clean L2
    _l2Cache.removeWhere((key, item) {
      if (item.isExpired) {
        _l2AccessTime.remove(key);
        removed++;
        return true;
      }
      return false;
    });

    _evictions += removed;
    return removed;
  }

  /// Start periodic cleanup
  Timer startPeriodicCleanup({Duration interval = const Duration(minutes: 5)}) {
    return Timer.periodic(interval, (_) => cleanExpired());
  }

  /// Update L1 access time (for LRU)
  void _updateL1Access(String key) {
    _l1AccessTime[key] = DateTime.now();
  }

  /// Update L2 access time (for LRU)
  void _updateL2Access(String key) {
    _l2AccessTime[key] = DateTime.now();
  }

  /// Promote frequently accessed L2 item to L1
  void _promoteToL1(String key, CachedItem item) {
    final accessTime = _l2AccessTime[key];
    if (accessTime == null) return;

    // Check if accessed recently (within last minute)
    final elapsed = DateTime.now().difference(accessTime);
    if (elapsed < const Duration(minutes: 1)) {
      _l1Cache[key] = item.copyWith(
        timestamp: DateTime.now(),
        ttl: _l1TTL,
      );
      _updateL1Access(key);
      _enforceL1Size();
      _l1Promotions++;
    }
  }

  /// Enforce L1 size limit using LRU
  void _enforceL1Size() {
    if (_l1Cache.length <= _l1MaxSize) return;

    // Sort by access time (oldest first)
    final sorted = _l1AccessTime.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    // Remove oldest entries
    final toRemove = _l1Cache.length - _l1MaxSize;
    for (var i = 0; i < toRemove; i++) {
      final key = sorted[i].key;
      _l1Cache.remove(key);
      _l1AccessTime.remove(key);
      _evictions++;
    }
  }

  /// Enforce L2 size limit using LRU
  void _enforceL2Size() {
    if (_l2Cache.length <= _l2MaxSize) return;

    // Sort by access time (oldest first)
    final sorted = _l2AccessTime.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    // Remove oldest entries
    final toRemove = _l2Cache.length - _l2MaxSize;
    for (var i = 0; i < toRemove; i++) {
      final key = sorted[i].key;
      _l2Cache.remove(key);
      _l2AccessTime.remove(key);
      _evictions++;
    }
  }

  /// Estimate L1 memory usage
  int _estimateL1Size() {
    return _l1Cache.length * 1024; // Assume ~1KB per entry
  }

  /// Estimate L2 memory usage
  int _estimateL2Size() {
    return _l2Cache.length * 1024; // Assume ~1KB per entry
  }

  /// Calculate L1 hit rate
  String _calculateL1HitRate() {
    // This is a simplified calculation
    // In reality, you'd need to track L1-specific hits
    final l1Hits = _hits - _l1Promotions;
    final total = _hits + _misses;
    return total > 0 ? (l1Hits / total * 100).toStringAsFixed(2) : '0.00';
  }

  /// Reset statistics
  void resetStats() {
    _hits = 0;
    _misses = 0;
    _evictions = 0;
    _l1Promotions = 0;
  }

  /// Print debug information
  void printDebugInfo() {
    final stats = getDetailedStats();
    print('=== Advanced Cache Stats ===');
    print('Hit Rate: ${stats['hitRate']}%');
    print('L1: ${stats['l1Size']}/${stats['l1MaxSize']} (${stats['l1FillRate']}% full)');
    print('L2: ${stats['l2Size']}/${stats['l2MaxSize']} (${stats['l2FillRate']}% full)');
    print('Evictions: ${stats['evictions']}');
    print('L1 Promotions: ${stats['l1Promotions']}');
    print('Memory: ${(stats['totalSizeBytes'] / 1024 / 1024).toStringAsFixed(2)} MB');
    print('Requests/min: ${stats['requestsPerMinute'].toStringAsFixed(2)}');
    print('============================');
  }
}

/// Cached item with TTL
class CachedItem {
  final dynamic value;
  final DateTime timestamp;
  final Duration ttl;

  CachedItem({
    required this.value,
    required this.timestamp,
    required this.ttl,
  });

  bool get isExpired => DateTime.now().difference(timestamp) > ttl;

  Duration get remainingTTL {
    final remaining = ttl - DateTime.now().difference(timestamp);
    return remaining.isNegative ? Duration.zero : remaining;
  }

  Map<String, dynamic> toJson() => {
        'value': value,
        'timestamp': timestamp.toIso8601String(),
        'ttl': ttl.inMilliseconds,
      };

  factory CachedItem.fromJson(Map<String, dynamic> json) {
    return CachedItem(
      value: json['value'],
      timestamp: DateTime.parse(json['timestamp']),
      ttl: Duration(milliseconds: json['ttl']),
    );
  }

  CachedItem copyWith({
    dynamic value,
    DateTime? timestamp,
    Duration? ttl,
  }) {
    return CachedItem(
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      ttl: ttl ?? this.ttl,
    );
  }

  @override
  String toString() {
    return 'CachedItem(timestamp: $timestamp, ttl: ${ttl.inMinutes}m, '
        'remaining: ${remainingTTL.inMinutes}m, expired: $isExpired)';
  }
}
