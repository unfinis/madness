import '../models/credential.dart';
import '../models/scope.dart';
import '../models/contact.dart';
import '../models/asset.dart';

/// Centralized asset conversion utilities
class AssetConverters {
  AssetConverters._();

  /// Convert a Credential to an asset map
  static Map<String, dynamic> credentialToAsset(Credential credential) {
    return {
      'type': 'credential',
      'identifier': credential.username,
      'username': credential.username,
      'password': credential.password,
      'hash': credential.hash,
      'domain': credential.domain,
      'target': credential.target,
      'notes': credential.notes,
      'discovered': credential.dateAdded.toIso8601String(),
      'source': credential.source.name,
      'metadata': {
        'credentialType': credential.type.name,
        'status': credential.status.name,
        'privilege': credential.privilege.name,
        'lastTested': credential.lastTested?.toIso8601String(),
      },
    };
  }

  /// Convert a ScopeItem to an asset map
  static Map<String, dynamic> scopeItemToAsset(ScopeItem scopeItem) {
    final Map<String, dynamic> asset = {
      'type': scopeItem.type.name,
      'identifier': scopeItem.target,
      'target': scopeItem.target,
      'description': scopeItem.description,
      'notes': scopeItem.notes,
      'discovered': scopeItem.dateAdded.toIso8601String(),
      'metadata': {
        'isActive': scopeItem.isActive,
      },
    };

    // Add type-specific properties
    switch (scopeItem.type) {
      case ScopeItemType.ipRange:
        asset['host'] = scopeItem.target;
        asset['metadata']['network'] = _parseNetworkInfo(scopeItem.target);
        break;
      case ScopeItemType.domain:
        asset['domain'] = scopeItem.target;
        asset['metadata']['tld'] = _extractTld(scopeItem.target);
        break;
      case ScopeItemType.url:
        asset['url'] = scopeItem.target;
        final uri = Uri.tryParse(scopeItem.target);
        if (uri != null) {
          asset['host'] = uri.host;
          asset['port'] = uri.port;
          asset['path'] = uri.path;
          asset['metadata']['scheme'] = uri.scheme;
        }
        break;
      case ScopeItemType.host:
        asset['host'] = scopeItem.target;
        break;
      case ScopeItemType.network:
        asset['networkSegment'] = scopeItem.target;
        break;
    }

    return asset;
  }

  /// Convert a Contact to an asset map
  static Map<String, dynamic> contactToAsset(Contact contact) {
    return {
      'type': 'contact',
      'identifier': contact.email,
      'name': contact.name,
      'email': contact.email,
      'phone': contact.phone,
      'role': contact.role,
      'notes': contact.notes,
      'tags': contact.tags.toList(),
      'metadata': {
        'dateAdded': contact.dateAdded.toIso8601String(),
        'dateModified': contact.dateModified.toIso8601String(),
      },
    };
  }

  /// Convert an Asset to a standard map
  static Map<String, dynamic> assetToMap(Asset asset) {
    final Map<String, dynamic> result = {
      'id': asset.id,
      'type': asset.type.name,
      'identifier': asset.name,
      'name': asset.name,
      'description': asset.description,
      'projectId': asset.projectId,
      'discovered': asset.discoveredAt.toIso8601String(),
      // Note: Asset model doesn't have lastUpdated field yet
      'metadata': <String, dynamic>{},
    };

    // Convert properties to simple map
    asset.properties.forEach((key, value) {
      result['metadata'][key] = _propertyValueToJson(value);
    });

    // Add relationships if present
    if (asset.parentAssetIds.isNotEmpty) {
      result['parentAssets'] = asset.parentAssetIds;
    }
    if (asset.childAssetIds.isNotEmpty) {
      result['childAssets'] = asset.childAssetIds;
    }

    return result;
  }

  static dynamic _propertyValueToJson(PropertyValue value) {
    // This is a placeholder - actual implementation depends on PropertyValue structure
    // For now, return the raw value
    return value.toString();
  }

  /// Convert a generic asset map to a standardized format
  static Map<String, dynamic> standardizeAsset(Map<String, dynamic> asset) {
    // Ensure required fields exist
    final standardized = Map<String, dynamic>.from(asset);

    // Set default type if missing
    standardized['type'] ??= 'unknown';

    // Ensure identifier exists
    if (standardized['identifier'] == null) {
      standardized['identifier'] = _generateIdentifier(standardized);
    }

    // Ensure metadata exists
    standardized['metadata'] ??= <String, dynamic>{};

    // Standardize network information
    if (standardized['host'] != null || standardized['ip'] != null) {
      standardized['host'] ??= standardized['ip'];
      standardized.remove('ip'); // Normalize to 'host'
    }

    // Standardize timestamps
    standardized['discovered'] = _standardizeTimestamp(
      standardized['discovered'] ?? standardized['discoveredAt'],
    );
    standardized['lastSeen'] = _standardizeTimestamp(
      standardized['lastSeen'] ?? standardized['lastSeenAt'],
    );

    // Clean up duplicate fields
    standardized.remove('discoveredAt');
    standardized.remove('lastSeenAt');

    return standardized;
  }

  /// Merge multiple asset representations
  static Map<String, dynamic> mergeAssets(List<Map<String, dynamic>> assets) {
    if (assets.isEmpty) return {};
    if (assets.length == 1) return Map<String, dynamic>.from(assets.first);

    // Start with the first asset
    final merged = Map<String, dynamic>.from(assets.first);

    // Merge in additional assets
    for (int i = 1; i < assets.length; i++) {
      final asset = assets[i];

      // Merge tags
      final tags = <String>{
        ...?merged['tags'] as List<String>?,
        ...?asset['tags'] as List<String>?,
      }.toList();
      if (tags.isNotEmpty) merged['tags'] = tags;

      // Merge metadata
      final metadata = <String, dynamic>{
        ...?merged['metadata'] as Map<String, dynamic>?,
        ...?asset['metadata'] as Map<String, dynamic>?,
      };
      if (metadata.isNotEmpty) merged['metadata'] = metadata;

      // Take the most recent timestamp
      final mergedTime = DateTime.tryParse(merged['lastSeen'] ?? '');
      final assetTime = DateTime.tryParse(asset['lastSeen'] ?? '');
      if (assetTime != null &&
          (mergedTime == null || assetTime.isAfter(mergedTime))) {
        merged['lastSeen'] = asset['lastSeen'];
      }

      // Merge other fields (prefer non-null values)
      for (final key in asset.keys) {
        if (key != 'tags' && key != 'metadata' && key != 'lastSeen') {
          merged[key] ??= asset[key];
        }
      }
    }

    return merged;
  }

  // Helper methods
  static String _generateIdentifier(Map<String, dynamic> asset) {
    // Try various fields to generate an identifier
    return asset['host'] ??
        asset['domain'] ??
        asset['username'] ??
        asset['email'] ??
        asset['name'] ??
        asset['value'] ??
        'asset_${DateTime.now().millisecondsSinceEpoch}';
  }

  static String? _standardizeTimestamp(dynamic timestamp) {
    if (timestamp == null) return null;
    if (timestamp is String) return timestamp;
    if (timestamp is DateTime) return timestamp.toIso8601String();
    return timestamp.toString();
  }

  static Map<String, dynamic> _parseNetworkInfo(String value) {
    final info = <String, dynamic>{};

    // Check if it's an IP range
    if (value.contains('/')) {
      final parts = value.split('/');
      info['network'] = parts[0];
      info['cidr'] = parts[1];
    } else if (value.contains('-')) {
      final parts = value.split('-');
      info['startIp'] = parts[0].trim();
      info['endIp'] = parts.length > 1 ? parts[1].trim() : parts[0].trim();
    } else {
      info['ip'] = value;
    }

    return info;
  }

  static String? _extractTld(String domain) {
    final parts = domain.split('.');
    return parts.length >= 2 ? parts.sublist(parts.length - 2).join('.') : null;
  }
}