// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assets.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

NetworkFirewallRule _$NetworkFirewallRuleFromJson(Map<String, dynamic> json) {
  return _NetworkFirewallRule.fromJson(json);
}

/// @nodoc
mixin _$NetworkFirewallRule {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  FirewallAction get action => throw _privateConstructorUsedError;
  String get sourceNetwork =>
      throw _privateConstructorUsedError; // CIDR or "any"
  String get destinationNetwork =>
      throw _privateConstructorUsedError; // CIDR or "any"
  String get protocol => throw _privateConstructorUsedError; // tcp/udp/icmp/any
  String get ports =>
      throw _privateConstructorUsedError; // "80", "80-443", "any"
  String? get description => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;
  DateTime? get lastModified => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NetworkFirewallRuleCopyWith<NetworkFirewallRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkFirewallRuleCopyWith<$Res> {
  factory $NetworkFirewallRuleCopyWith(
          NetworkFirewallRule value, $Res Function(NetworkFirewallRule) then) =
      _$NetworkFirewallRuleCopyWithImpl<$Res, NetworkFirewallRule>;
  @useResult
  $Res call(
      {String id,
      String name,
      FirewallAction action,
      String sourceNetwork,
      String destinationNetwork,
      String protocol,
      String ports,
      String? description,
      bool enabled,
      DateTime? lastModified});
}

/// @nodoc
class _$NetworkFirewallRuleCopyWithImpl<$Res, $Val extends NetworkFirewallRule>
    implements $NetworkFirewallRuleCopyWith<$Res> {
  _$NetworkFirewallRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? action = null,
    Object? sourceNetwork = null,
    Object? destinationNetwork = null,
    Object? protocol = null,
    Object? ports = null,
    Object? description = freezed,
    Object? enabled = null,
    Object? lastModified = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as FirewallAction,
      sourceNetwork: null == sourceNetwork
          ? _value.sourceNetwork
          : sourceNetwork // ignore: cast_nullable_to_non_nullable
              as String,
      destinationNetwork: null == destinationNetwork
          ? _value.destinationNetwork
          : destinationNetwork // ignore: cast_nullable_to_non_nullable
              as String,
      protocol: null == protocol
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as String,
      ports: null == ports
          ? _value.ports
          : ports // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastModified: freezed == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkFirewallRuleImplCopyWith<$Res>
    implements $NetworkFirewallRuleCopyWith<$Res> {
  factory _$$NetworkFirewallRuleImplCopyWith(_$NetworkFirewallRuleImpl value,
          $Res Function(_$NetworkFirewallRuleImpl) then) =
      __$$NetworkFirewallRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      FirewallAction action,
      String sourceNetwork,
      String destinationNetwork,
      String protocol,
      String ports,
      String? description,
      bool enabled,
      DateTime? lastModified});
}

/// @nodoc
class __$$NetworkFirewallRuleImplCopyWithImpl<$Res>
    extends _$NetworkFirewallRuleCopyWithImpl<$Res, _$NetworkFirewallRuleImpl>
    implements _$$NetworkFirewallRuleImplCopyWith<$Res> {
  __$$NetworkFirewallRuleImplCopyWithImpl(_$NetworkFirewallRuleImpl _value,
      $Res Function(_$NetworkFirewallRuleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? action = null,
    Object? sourceNetwork = null,
    Object? destinationNetwork = null,
    Object? protocol = null,
    Object? ports = null,
    Object? description = freezed,
    Object? enabled = null,
    Object? lastModified = freezed,
  }) {
    return _then(_$NetworkFirewallRuleImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      action: null == action
          ? _value.action
          : action // ignore: cast_nullable_to_non_nullable
              as FirewallAction,
      sourceNetwork: null == sourceNetwork
          ? _value.sourceNetwork
          : sourceNetwork // ignore: cast_nullable_to_non_nullable
              as String,
      destinationNetwork: null == destinationNetwork
          ? _value.destinationNetwork
          : destinationNetwork // ignore: cast_nullable_to_non_nullable
              as String,
      protocol: null == protocol
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as String,
      ports: null == ports
          ? _value.ports
          : ports // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      lastModified: freezed == lastModified
          ? _value.lastModified
          : lastModified // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NetworkFirewallRuleImpl implements _NetworkFirewallRule {
  const _$NetworkFirewallRuleImpl(
      {required this.id,
      required this.name,
      required this.action,
      required this.sourceNetwork,
      required this.destinationNetwork,
      required this.protocol,
      required this.ports,
      this.description,
      this.enabled = true,
      this.lastModified});

  factory _$NetworkFirewallRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetworkFirewallRuleImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final FirewallAction action;
  @override
  final String sourceNetwork;
// CIDR or "any"
  @override
  final String destinationNetwork;
// CIDR or "any"
  @override
  final String protocol;
// tcp/udp/icmp/any
  @override
  final String ports;
// "80", "80-443", "any"
  @override
  final String? description;
  @override
  @JsonKey()
  final bool enabled;
  @override
  final DateTime? lastModified;

  @override
  String toString() {
    return 'NetworkFirewallRule(id: $id, name: $name, action: $action, sourceNetwork: $sourceNetwork, destinationNetwork: $destinationNetwork, protocol: $protocol, ports: $ports, description: $description, enabled: $enabled, lastModified: $lastModified)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkFirewallRuleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.sourceNetwork, sourceNetwork) ||
                other.sourceNetwork == sourceNetwork) &&
            (identical(other.destinationNetwork, destinationNetwork) ||
                other.destinationNetwork == destinationNetwork) &&
            (identical(other.protocol, protocol) ||
                other.protocol == protocol) &&
            (identical(other.ports, ports) || other.ports == ports) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, action, sourceNetwork,
      destinationNetwork, protocol, ports, description, enabled, lastModified);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkFirewallRuleImplCopyWith<_$NetworkFirewallRuleImpl> get copyWith =>
      __$$NetworkFirewallRuleImplCopyWithImpl<_$NetworkFirewallRuleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NetworkFirewallRuleImplToJson(
      this,
    );
  }
}

abstract class _NetworkFirewallRule implements NetworkFirewallRule {
  const factory _NetworkFirewallRule(
      {required final String id,
      required final String name,
      required final FirewallAction action,
      required final String sourceNetwork,
      required final String destinationNetwork,
      required final String protocol,
      required final String ports,
      final String? description,
      final bool enabled,
      final DateTime? lastModified}) = _$NetworkFirewallRuleImpl;

  factory _NetworkFirewallRule.fromJson(Map<String, dynamic> json) =
      _$NetworkFirewallRuleImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  FirewallAction get action;
  @override
  String get sourceNetwork;
  @override // CIDR or "any"
  String get destinationNetwork;
  @override // CIDR or "any"
  String get protocol;
  @override // tcp/udp/icmp/any
  String get ports;
  @override // "80", "80-443", "any"
  String? get description;
  @override
  bool get enabled;
  @override
  DateTime? get lastModified;
  @override
  @JsonKey(ignore: true)
  _$$NetworkFirewallRuleImplCopyWith<_$NetworkFirewallRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NetworkRoute _$NetworkRouteFromJson(Map<String, dynamic> json) {
  return _NetworkRoute.fromJson(json);
}

/// @nodoc
mixin _$NetworkRoute {
  String get id => throw _privateConstructorUsedError;
  String get destinationNetwork =>
      throw _privateConstructorUsedError; // Target network CIDR
  String get nextHop => throw _privateConstructorUsedError; // Gateway IP
  int get metric => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NetworkRouteCopyWith<NetworkRoute> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkRouteCopyWith<$Res> {
  factory $NetworkRouteCopyWith(
          NetworkRoute value, $Res Function(NetworkRoute) then) =
      _$NetworkRouteCopyWithImpl<$Res, NetworkRoute>;
  @useResult
  $Res call(
      {String id,
      String destinationNetwork,
      String nextHop,
      int metric,
      bool active,
      String? description});
}

/// @nodoc
class _$NetworkRouteCopyWithImpl<$Res, $Val extends NetworkRoute>
    implements $NetworkRouteCopyWith<$Res> {
  _$NetworkRouteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? destinationNetwork = null,
    Object? nextHop = null,
    Object? metric = null,
    Object? active = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      destinationNetwork: null == destinationNetwork
          ? _value.destinationNetwork
          : destinationNetwork // ignore: cast_nullable_to_non_nullable
              as String,
      nextHop: null == nextHop
          ? _value.nextHop
          : nextHop // ignore: cast_nullable_to_non_nullable
              as String,
      metric: null == metric
          ? _value.metric
          : metric // ignore: cast_nullable_to_non_nullable
              as int,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkRouteImplCopyWith<$Res>
    implements $NetworkRouteCopyWith<$Res> {
  factory _$$NetworkRouteImplCopyWith(
          _$NetworkRouteImpl value, $Res Function(_$NetworkRouteImpl) then) =
      __$$NetworkRouteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String destinationNetwork,
      String nextHop,
      int metric,
      bool active,
      String? description});
}

/// @nodoc
class __$$NetworkRouteImplCopyWithImpl<$Res>
    extends _$NetworkRouteCopyWithImpl<$Res, _$NetworkRouteImpl>
    implements _$$NetworkRouteImplCopyWith<$Res> {
  __$$NetworkRouteImplCopyWithImpl(
      _$NetworkRouteImpl _value, $Res Function(_$NetworkRouteImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? destinationNetwork = null,
    Object? nextHop = null,
    Object? metric = null,
    Object? active = null,
    Object? description = freezed,
  }) {
    return _then(_$NetworkRouteImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      destinationNetwork: null == destinationNetwork
          ? _value.destinationNetwork
          : destinationNetwork // ignore: cast_nullable_to_non_nullable
              as String,
      nextHop: null == nextHop
          ? _value.nextHop
          : nextHop // ignore: cast_nullable_to_non_nullable
              as String,
      metric: null == metric
          ? _value.metric
          : metric // ignore: cast_nullable_to_non_nullable
              as int,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NetworkRouteImpl implements _NetworkRoute {
  const _$NetworkRouteImpl(
      {required this.id,
      required this.destinationNetwork,
      required this.nextHop,
      required this.metric,
      this.active = true,
      this.description});

  factory _$NetworkRouteImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetworkRouteImplFromJson(json);

  @override
  final String id;
  @override
  final String destinationNetwork;
// Target network CIDR
  @override
  final String nextHop;
// Gateway IP
  @override
  final int metric;
  @override
  @JsonKey()
  final bool active;
  @override
  final String? description;

  @override
  String toString() {
    return 'NetworkRoute(id: $id, destinationNetwork: $destinationNetwork, nextHop: $nextHop, metric: $metric, active: $active, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkRouteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.destinationNetwork, destinationNetwork) ||
                other.destinationNetwork == destinationNetwork) &&
            (identical(other.nextHop, nextHop) || other.nextHop == nextHop) &&
            (identical(other.metric, metric) || other.metric == metric) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, destinationNetwork, nextHop,
      metric, active, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkRouteImplCopyWith<_$NetworkRouteImpl> get copyWith =>
      __$$NetworkRouteImplCopyWithImpl<_$NetworkRouteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NetworkRouteImplToJson(
      this,
    );
  }
}

abstract class _NetworkRoute implements NetworkRoute {
  const factory _NetworkRoute(
      {required final String id,
      required final String destinationNetwork,
      required final String nextHop,
      required final int metric,
      final bool active,
      final String? description}) = _$NetworkRouteImpl;

  factory _NetworkRoute.fromJson(Map<String, dynamic> json) =
      _$NetworkRouteImpl.fromJson;

  @override
  String get id;
  @override
  String get destinationNetwork;
  @override // Target network CIDR
  String get nextHop;
  @override // Gateway IP
  int get metric;
  @override
  bool get active;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$NetworkRouteImplCopyWith<_$NetworkRouteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NetworkAccessPoint _$NetworkAccessPointFromJson(Map<String, dynamic> json) {
  return _NetworkAccessPoint.fromJson(json);
}

/// @nodoc
mixin _$NetworkAccessPoint {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  NetworkAccessType get accessType => throw _privateConstructorUsedError;
  String? get sourceAssetId =>
      throw _privateConstructorUsedError; // Host/device we're accessing from
  String? get sourceNetworkId =>
      throw _privateConstructorUsedError; // Network segment we're coming from
  String? get description => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;
  String? get credentials =>
      throw _privateConstructorUsedError; // Reference to credential asset
  Map<String, String>? get accessDetails =>
      throw _privateConstructorUsedError; // Protocol-specific details
  DateTime? get discoveredAt => throw _privateConstructorUsedError;
  DateTime? get lastTested => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NetworkAccessPointCopyWith<NetworkAccessPoint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkAccessPointCopyWith<$Res> {
  factory $NetworkAccessPointCopyWith(
          NetworkAccessPoint value, $Res Function(NetworkAccessPoint) then) =
      _$NetworkAccessPointCopyWithImpl<$Res, NetworkAccessPoint>;
  @useResult
  $Res call(
      {String id,
      String name,
      NetworkAccessType accessType,
      String? sourceAssetId,
      String? sourceNetworkId,
      String? description,
      bool active,
      String? credentials,
      Map<String, String>? accessDetails,
      DateTime? discoveredAt,
      DateTime? lastTested});
}

/// @nodoc
class _$NetworkAccessPointCopyWithImpl<$Res, $Val extends NetworkAccessPoint>
    implements $NetworkAccessPointCopyWith<$Res> {
  _$NetworkAccessPointCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? accessType = null,
    Object? sourceAssetId = freezed,
    Object? sourceNetworkId = freezed,
    Object? description = freezed,
    Object? active = null,
    Object? credentials = freezed,
    Object? accessDetails = freezed,
    Object? discoveredAt = freezed,
    Object? lastTested = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      accessType: null == accessType
          ? _value.accessType
          : accessType // ignore: cast_nullable_to_non_nullable
              as NetworkAccessType,
      sourceAssetId: freezed == sourceAssetId
          ? _value.sourceAssetId
          : sourceAssetId // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceNetworkId: freezed == sourceNetworkId
          ? _value.sourceNetworkId
          : sourceNetworkId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      credentials: freezed == credentials
          ? _value.credentials
          : credentials // ignore: cast_nullable_to_non_nullable
              as String?,
      accessDetails: freezed == accessDetails
          ? _value.accessDetails
          : accessDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      discoveredAt: freezed == discoveredAt
          ? _value.discoveredAt
          : discoveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastTested: freezed == lastTested
          ? _value.lastTested
          : lastTested // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkAccessPointImplCopyWith<$Res>
    implements $NetworkAccessPointCopyWith<$Res> {
  factory _$$NetworkAccessPointImplCopyWith(_$NetworkAccessPointImpl value,
          $Res Function(_$NetworkAccessPointImpl) then) =
      __$$NetworkAccessPointImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      NetworkAccessType accessType,
      String? sourceAssetId,
      String? sourceNetworkId,
      String? description,
      bool active,
      String? credentials,
      Map<String, String>? accessDetails,
      DateTime? discoveredAt,
      DateTime? lastTested});
}

/// @nodoc
class __$$NetworkAccessPointImplCopyWithImpl<$Res>
    extends _$NetworkAccessPointCopyWithImpl<$Res, _$NetworkAccessPointImpl>
    implements _$$NetworkAccessPointImplCopyWith<$Res> {
  __$$NetworkAccessPointImplCopyWithImpl(_$NetworkAccessPointImpl _value,
      $Res Function(_$NetworkAccessPointImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? accessType = null,
    Object? sourceAssetId = freezed,
    Object? sourceNetworkId = freezed,
    Object? description = freezed,
    Object? active = null,
    Object? credentials = freezed,
    Object? accessDetails = freezed,
    Object? discoveredAt = freezed,
    Object? lastTested = freezed,
  }) {
    return _then(_$NetworkAccessPointImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      accessType: null == accessType
          ? _value.accessType
          : accessType // ignore: cast_nullable_to_non_nullable
              as NetworkAccessType,
      sourceAssetId: freezed == sourceAssetId
          ? _value.sourceAssetId
          : sourceAssetId // ignore: cast_nullable_to_non_nullable
              as String?,
      sourceNetworkId: freezed == sourceNetworkId
          ? _value.sourceNetworkId
          : sourceNetworkId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      active: null == active
          ? _value.active
          : active // ignore: cast_nullable_to_non_nullable
              as bool,
      credentials: freezed == credentials
          ? _value.credentials
          : credentials // ignore: cast_nullable_to_non_nullable
              as String?,
      accessDetails: freezed == accessDetails
          ? _value._accessDetails
          : accessDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      discoveredAt: freezed == discoveredAt
          ? _value.discoveredAt
          : discoveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastTested: freezed == lastTested
          ? _value.lastTested
          : lastTested // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NetworkAccessPointImpl implements _NetworkAccessPoint {
  const _$NetworkAccessPointImpl(
      {required this.id,
      required this.name,
      required this.accessType,
      this.sourceAssetId,
      this.sourceNetworkId,
      this.description,
      this.active = true,
      this.credentials,
      final Map<String, String>? accessDetails,
      this.discoveredAt,
      this.lastTested})
      : _accessDetails = accessDetails;

  factory _$NetworkAccessPointImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetworkAccessPointImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final NetworkAccessType accessType;
  @override
  final String? sourceAssetId;
// Host/device we're accessing from
  @override
  final String? sourceNetworkId;
// Network segment we're coming from
  @override
  final String? description;
  @override
  @JsonKey()
  final bool active;
  @override
  final String? credentials;
// Reference to credential asset
  final Map<String, String>? _accessDetails;
// Reference to credential asset
  @override
  Map<String, String>? get accessDetails {
    final value = _accessDetails;
    if (value == null) return null;
    if (_accessDetails is EqualUnmodifiableMapView) return _accessDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Protocol-specific details
  @override
  final DateTime? discoveredAt;
  @override
  final DateTime? lastTested;

  @override
  String toString() {
    return 'NetworkAccessPoint(id: $id, name: $name, accessType: $accessType, sourceAssetId: $sourceAssetId, sourceNetworkId: $sourceNetworkId, description: $description, active: $active, credentials: $credentials, accessDetails: $accessDetails, discoveredAt: $discoveredAt, lastTested: $lastTested)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkAccessPointImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.accessType, accessType) ||
                other.accessType == accessType) &&
            (identical(other.sourceAssetId, sourceAssetId) ||
                other.sourceAssetId == sourceAssetId) &&
            (identical(other.sourceNetworkId, sourceNetworkId) ||
                other.sourceNetworkId == sourceNetworkId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.active, active) || other.active == active) &&
            (identical(other.credentials, credentials) ||
                other.credentials == credentials) &&
            const DeepCollectionEquality()
                .equals(other._accessDetails, _accessDetails) &&
            (identical(other.discoveredAt, discoveredAt) ||
                other.discoveredAt == discoveredAt) &&
            (identical(other.lastTested, lastTested) ||
                other.lastTested == lastTested));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      accessType,
      sourceAssetId,
      sourceNetworkId,
      description,
      active,
      credentials,
      const DeepCollectionEquality().hash(_accessDetails),
      discoveredAt,
      lastTested);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkAccessPointImplCopyWith<_$NetworkAccessPointImpl> get copyWith =>
      __$$NetworkAccessPointImplCopyWithImpl<_$NetworkAccessPointImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NetworkAccessPointImplToJson(
      this,
    );
  }
}

abstract class _NetworkAccessPoint implements NetworkAccessPoint {
  const factory _NetworkAccessPoint(
      {required final String id,
      required final String name,
      required final NetworkAccessType accessType,
      final String? sourceAssetId,
      final String? sourceNetworkId,
      final String? description,
      final bool active,
      final String? credentials,
      final Map<String, String>? accessDetails,
      final DateTime? discoveredAt,
      final DateTime? lastTested}) = _$NetworkAccessPointImpl;

  factory _NetworkAccessPoint.fromJson(Map<String, dynamic> json) =
      _$NetworkAccessPointImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  NetworkAccessType get accessType;
  @override
  String? get sourceAssetId;
  @override // Host/device we're accessing from
  String? get sourceNetworkId;
  @override // Network segment we're coming from
  String? get description;
  @override
  bool get active;
  @override
  String? get credentials;
  @override // Reference to credential asset
  Map<String, String>? get accessDetails;
  @override // Protocol-specific details
  DateTime? get discoveredAt;
  @override
  DateTime? get lastTested;
  @override
  @JsonKey(ignore: true)
  _$$NetworkAccessPointImplCopyWith<_$NetworkAccessPointImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NetworkHostReference _$NetworkHostReferenceFromJson(Map<String, dynamic> json) {
  return _NetworkHostReference.fromJson(json);
}

/// @nodoc
mixin _$NetworkHostReference {
  String get hostAssetId => throw _privateConstructorUsedError;
  String get ipAddress => throw _privateConstructorUsedError;
  String? get hostname => throw _privateConstructorUsedError;
  String? get macAddress => throw _privateConstructorUsedError;
  bool get isGateway => throw _privateConstructorUsedError;
  bool get isDhcpServer => throw _privateConstructorUsedError;
  bool get isDnsServer => throw _privateConstructorUsedError;
  bool get isCompromised => throw _privateConstructorUsedError;
  List<String>? get openPorts => throw _privateConstructorUsedError;
  DateTime? get lastSeen => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NetworkHostReferenceCopyWith<NetworkHostReference> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkHostReferenceCopyWith<$Res> {
  factory $NetworkHostReferenceCopyWith(NetworkHostReference value,
          $Res Function(NetworkHostReference) then) =
      _$NetworkHostReferenceCopyWithImpl<$Res, NetworkHostReference>;
  @useResult
  $Res call(
      {String hostAssetId,
      String ipAddress,
      String? hostname,
      String? macAddress,
      bool isGateway,
      bool isDhcpServer,
      bool isDnsServer,
      bool isCompromised,
      List<String>? openPorts,
      DateTime? lastSeen});
}

/// @nodoc
class _$NetworkHostReferenceCopyWithImpl<$Res,
        $Val extends NetworkHostReference>
    implements $NetworkHostReferenceCopyWith<$Res> {
  _$NetworkHostReferenceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hostAssetId = null,
    Object? ipAddress = null,
    Object? hostname = freezed,
    Object? macAddress = freezed,
    Object? isGateway = null,
    Object? isDhcpServer = null,
    Object? isDnsServer = null,
    Object? isCompromised = null,
    Object? openPorts = freezed,
    Object? lastSeen = freezed,
  }) {
    return _then(_value.copyWith(
      hostAssetId: null == hostAssetId
          ? _value.hostAssetId
          : hostAssetId // ignore: cast_nullable_to_non_nullable
              as String,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      hostname: freezed == hostname
          ? _value.hostname
          : hostname // ignore: cast_nullable_to_non_nullable
              as String?,
      macAddress: freezed == macAddress
          ? _value.macAddress
          : macAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      isGateway: null == isGateway
          ? _value.isGateway
          : isGateway // ignore: cast_nullable_to_non_nullable
              as bool,
      isDhcpServer: null == isDhcpServer
          ? _value.isDhcpServer
          : isDhcpServer // ignore: cast_nullable_to_non_nullable
              as bool,
      isDnsServer: null == isDnsServer
          ? _value.isDnsServer
          : isDnsServer // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompromised: null == isCompromised
          ? _value.isCompromised
          : isCompromised // ignore: cast_nullable_to_non_nullable
              as bool,
      openPorts: freezed == openPorts
          ? _value.openPorts
          : openPorts // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkHostReferenceImplCopyWith<$Res>
    implements $NetworkHostReferenceCopyWith<$Res> {
  factory _$$NetworkHostReferenceImplCopyWith(_$NetworkHostReferenceImpl value,
          $Res Function(_$NetworkHostReferenceImpl) then) =
      __$$NetworkHostReferenceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String hostAssetId,
      String ipAddress,
      String? hostname,
      String? macAddress,
      bool isGateway,
      bool isDhcpServer,
      bool isDnsServer,
      bool isCompromised,
      List<String>? openPorts,
      DateTime? lastSeen});
}

/// @nodoc
class __$$NetworkHostReferenceImplCopyWithImpl<$Res>
    extends _$NetworkHostReferenceCopyWithImpl<$Res, _$NetworkHostReferenceImpl>
    implements _$$NetworkHostReferenceImplCopyWith<$Res> {
  __$$NetworkHostReferenceImplCopyWithImpl(_$NetworkHostReferenceImpl _value,
      $Res Function(_$NetworkHostReferenceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? hostAssetId = null,
    Object? ipAddress = null,
    Object? hostname = freezed,
    Object? macAddress = freezed,
    Object? isGateway = null,
    Object? isDhcpServer = null,
    Object? isDnsServer = null,
    Object? isCompromised = null,
    Object? openPorts = freezed,
    Object? lastSeen = freezed,
  }) {
    return _then(_$NetworkHostReferenceImpl(
      hostAssetId: null == hostAssetId
          ? _value.hostAssetId
          : hostAssetId // ignore: cast_nullable_to_non_nullable
              as String,
      ipAddress: null == ipAddress
          ? _value.ipAddress
          : ipAddress // ignore: cast_nullable_to_non_nullable
              as String,
      hostname: freezed == hostname
          ? _value.hostname
          : hostname // ignore: cast_nullable_to_non_nullable
              as String?,
      macAddress: freezed == macAddress
          ? _value.macAddress
          : macAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      isGateway: null == isGateway
          ? _value.isGateway
          : isGateway // ignore: cast_nullable_to_non_nullable
              as bool,
      isDhcpServer: null == isDhcpServer
          ? _value.isDhcpServer
          : isDhcpServer // ignore: cast_nullable_to_non_nullable
              as bool,
      isDnsServer: null == isDnsServer
          ? _value.isDnsServer
          : isDnsServer // ignore: cast_nullable_to_non_nullable
              as bool,
      isCompromised: null == isCompromised
          ? _value.isCompromised
          : isCompromised // ignore: cast_nullable_to_non_nullable
              as bool,
      openPorts: freezed == openPorts
          ? _value._openPorts
          : openPorts // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NetworkHostReferenceImpl implements _NetworkHostReference {
  const _$NetworkHostReferenceImpl(
      {required this.hostAssetId,
      required this.ipAddress,
      this.hostname,
      this.macAddress,
      this.isGateway = false,
      this.isDhcpServer = false,
      this.isDnsServer = false,
      this.isCompromised = false,
      final List<String>? openPorts,
      this.lastSeen})
      : _openPorts = openPorts;

  factory _$NetworkHostReferenceImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetworkHostReferenceImplFromJson(json);

  @override
  final String hostAssetId;
  @override
  final String ipAddress;
  @override
  final String? hostname;
  @override
  final String? macAddress;
  @override
  @JsonKey()
  final bool isGateway;
  @override
  @JsonKey()
  final bool isDhcpServer;
  @override
  @JsonKey()
  final bool isDnsServer;
  @override
  @JsonKey()
  final bool isCompromised;
  final List<String>? _openPorts;
  @override
  List<String>? get openPorts {
    final value = _openPorts;
    if (value == null) return null;
    if (_openPorts is EqualUnmodifiableListView) return _openPorts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? lastSeen;

  @override
  String toString() {
    return 'NetworkHostReference(hostAssetId: $hostAssetId, ipAddress: $ipAddress, hostname: $hostname, macAddress: $macAddress, isGateway: $isGateway, isDhcpServer: $isDhcpServer, isDnsServer: $isDnsServer, isCompromised: $isCompromised, openPorts: $openPorts, lastSeen: $lastSeen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkHostReferenceImpl &&
            (identical(other.hostAssetId, hostAssetId) ||
                other.hostAssetId == hostAssetId) &&
            (identical(other.ipAddress, ipAddress) ||
                other.ipAddress == ipAddress) &&
            (identical(other.hostname, hostname) ||
                other.hostname == hostname) &&
            (identical(other.macAddress, macAddress) ||
                other.macAddress == macAddress) &&
            (identical(other.isGateway, isGateway) ||
                other.isGateway == isGateway) &&
            (identical(other.isDhcpServer, isDhcpServer) ||
                other.isDhcpServer == isDhcpServer) &&
            (identical(other.isDnsServer, isDnsServer) ||
                other.isDnsServer == isDnsServer) &&
            (identical(other.isCompromised, isCompromised) ||
                other.isCompromised == isCompromised) &&
            const DeepCollectionEquality()
                .equals(other._openPorts, _openPorts) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      hostAssetId,
      ipAddress,
      hostname,
      macAddress,
      isGateway,
      isDhcpServer,
      isDnsServer,
      isCompromised,
      const DeepCollectionEquality().hash(_openPorts),
      lastSeen);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkHostReferenceImplCopyWith<_$NetworkHostReferenceImpl>
      get copyWith =>
          __$$NetworkHostReferenceImplCopyWithImpl<_$NetworkHostReferenceImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NetworkHostReferenceImplToJson(
      this,
    );
  }
}

abstract class _NetworkHostReference implements NetworkHostReference {
  const factory _NetworkHostReference(
      {required final String hostAssetId,
      required final String ipAddress,
      final String? hostname,
      final String? macAddress,
      final bool isGateway,
      final bool isDhcpServer,
      final bool isDnsServer,
      final bool isCompromised,
      final List<String>? openPorts,
      final DateTime? lastSeen}) = _$NetworkHostReferenceImpl;

  factory _NetworkHostReference.fromJson(Map<String, dynamic> json) =
      _$NetworkHostReferenceImpl.fromJson;

  @override
  String get hostAssetId;
  @override
  String get ipAddress;
  @override
  String? get hostname;
  @override
  String? get macAddress;
  @override
  bool get isGateway;
  @override
  bool get isDhcpServer;
  @override
  bool get isDnsServer;
  @override
  bool get isCompromised;
  @override
  List<String>? get openPorts;
  @override
  DateTime? get lastSeen;
  @override
  @JsonKey(ignore: true)
  _$$NetworkHostReferenceImplCopyWith<_$NetworkHostReferenceImpl>
      get copyWith => throw _privateConstructorUsedError;
}

RestrictedEnvironment _$RestrictedEnvironmentFromJson(
    Map<String, dynamic> json) {
  return _RestrictedEnvironment.fromJson(json);
}

/// @nodoc
mixin _$RestrictedEnvironment {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  EnvironmentType get environmentType => throw _privateConstructorUsedError;
  List<RestrictionMechanism> get restrictions =>
      throw _privateConstructorUsedError;
  String get hostAssetId =>
      throw _privateConstructorUsedError; // Host where restriction exists
  String? get applicationAssetId =>
      throw _privateConstructorUsedError; // Specific app if applicable
  String? get networkAssetId =>
      throw _privateConstructorUsedError; // Network segment if applicable
  String? get description => throw _privateConstructorUsedError;
  List<String> get securityControlIds => throw _privateConstructorUsedError;
  List<String> get breakoutAttemptIds => throw _privateConstructorUsedError;
  Map<String, String>? get environmentDetails =>
      throw _privateConstructorUsedError;
  DateTime? get discoveredAt => throw _privateConstructorUsedError;
  DateTime? get lastTested => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $RestrictedEnvironmentCopyWith<RestrictedEnvironment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RestrictedEnvironmentCopyWith<$Res> {
  factory $RestrictedEnvironmentCopyWith(RestrictedEnvironment value,
          $Res Function(RestrictedEnvironment) then) =
      _$RestrictedEnvironmentCopyWithImpl<$Res, RestrictedEnvironment>;
  @useResult
  $Res call(
      {String id,
      String name,
      EnvironmentType environmentType,
      List<RestrictionMechanism> restrictions,
      String hostAssetId,
      String? applicationAssetId,
      String? networkAssetId,
      String? description,
      List<String> securityControlIds,
      List<String> breakoutAttemptIds,
      Map<String, String>? environmentDetails,
      DateTime? discoveredAt,
      DateTime? lastTested});
}

/// @nodoc
class _$RestrictedEnvironmentCopyWithImpl<$Res,
        $Val extends RestrictedEnvironment>
    implements $RestrictedEnvironmentCopyWith<$Res> {
  _$RestrictedEnvironmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? environmentType = null,
    Object? restrictions = null,
    Object? hostAssetId = null,
    Object? applicationAssetId = freezed,
    Object? networkAssetId = freezed,
    Object? description = freezed,
    Object? securityControlIds = null,
    Object? breakoutAttemptIds = null,
    Object? environmentDetails = freezed,
    Object? discoveredAt = freezed,
    Object? lastTested = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      environmentType: null == environmentType
          ? _value.environmentType
          : environmentType // ignore: cast_nullable_to_non_nullable
              as EnvironmentType,
      restrictions: null == restrictions
          ? _value.restrictions
          : restrictions // ignore: cast_nullable_to_non_nullable
              as List<RestrictionMechanism>,
      hostAssetId: null == hostAssetId
          ? _value.hostAssetId
          : hostAssetId // ignore: cast_nullable_to_non_nullable
              as String,
      applicationAssetId: freezed == applicationAssetId
          ? _value.applicationAssetId
          : applicationAssetId // ignore: cast_nullable_to_non_nullable
              as String?,
      networkAssetId: freezed == networkAssetId
          ? _value.networkAssetId
          : networkAssetId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      securityControlIds: null == securityControlIds
          ? _value.securityControlIds
          : securityControlIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      breakoutAttemptIds: null == breakoutAttemptIds
          ? _value.breakoutAttemptIds
          : breakoutAttemptIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      environmentDetails: freezed == environmentDetails
          ? _value.environmentDetails
          : environmentDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      discoveredAt: freezed == discoveredAt
          ? _value.discoveredAt
          : discoveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastTested: freezed == lastTested
          ? _value.lastTested
          : lastTested // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RestrictedEnvironmentImplCopyWith<$Res>
    implements $RestrictedEnvironmentCopyWith<$Res> {
  factory _$$RestrictedEnvironmentImplCopyWith(
          _$RestrictedEnvironmentImpl value,
          $Res Function(_$RestrictedEnvironmentImpl) then) =
      __$$RestrictedEnvironmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      EnvironmentType environmentType,
      List<RestrictionMechanism> restrictions,
      String hostAssetId,
      String? applicationAssetId,
      String? networkAssetId,
      String? description,
      List<String> securityControlIds,
      List<String> breakoutAttemptIds,
      Map<String, String>? environmentDetails,
      DateTime? discoveredAt,
      DateTime? lastTested});
}

/// @nodoc
class __$$RestrictedEnvironmentImplCopyWithImpl<$Res>
    extends _$RestrictedEnvironmentCopyWithImpl<$Res,
        _$RestrictedEnvironmentImpl>
    implements _$$RestrictedEnvironmentImplCopyWith<$Res> {
  __$$RestrictedEnvironmentImplCopyWithImpl(_$RestrictedEnvironmentImpl _value,
      $Res Function(_$RestrictedEnvironmentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? environmentType = null,
    Object? restrictions = null,
    Object? hostAssetId = null,
    Object? applicationAssetId = freezed,
    Object? networkAssetId = freezed,
    Object? description = freezed,
    Object? securityControlIds = null,
    Object? breakoutAttemptIds = null,
    Object? environmentDetails = freezed,
    Object? discoveredAt = freezed,
    Object? lastTested = freezed,
  }) {
    return _then(_$RestrictedEnvironmentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      environmentType: null == environmentType
          ? _value.environmentType
          : environmentType // ignore: cast_nullable_to_non_nullable
              as EnvironmentType,
      restrictions: null == restrictions
          ? _value._restrictions
          : restrictions // ignore: cast_nullable_to_non_nullable
              as List<RestrictionMechanism>,
      hostAssetId: null == hostAssetId
          ? _value.hostAssetId
          : hostAssetId // ignore: cast_nullable_to_non_nullable
              as String,
      applicationAssetId: freezed == applicationAssetId
          ? _value.applicationAssetId
          : applicationAssetId // ignore: cast_nullable_to_non_nullable
              as String?,
      networkAssetId: freezed == networkAssetId
          ? _value.networkAssetId
          : networkAssetId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      securityControlIds: null == securityControlIds
          ? _value._securityControlIds
          : securityControlIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      breakoutAttemptIds: null == breakoutAttemptIds
          ? _value._breakoutAttemptIds
          : breakoutAttemptIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      environmentDetails: freezed == environmentDetails
          ? _value._environmentDetails
          : environmentDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      discoveredAt: freezed == discoveredAt
          ? _value.discoveredAt
          : discoveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastTested: freezed == lastTested
          ? _value.lastTested
          : lastTested // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RestrictedEnvironmentImpl implements _RestrictedEnvironment {
  const _$RestrictedEnvironmentImpl(
      {required this.id,
      required this.name,
      required this.environmentType,
      required final List<RestrictionMechanism> restrictions,
      required this.hostAssetId,
      this.applicationAssetId,
      this.networkAssetId,
      this.description,
      final List<String> securityControlIds = const [],
      final List<String> breakoutAttemptIds = const [],
      final Map<String, String>? environmentDetails,
      this.discoveredAt,
      this.lastTested})
      : _restrictions = restrictions,
        _securityControlIds = securityControlIds,
        _breakoutAttemptIds = breakoutAttemptIds,
        _environmentDetails = environmentDetails;

  factory _$RestrictedEnvironmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$RestrictedEnvironmentImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final EnvironmentType environmentType;
  final List<RestrictionMechanism> _restrictions;
  @override
  List<RestrictionMechanism> get restrictions {
    if (_restrictions is EqualUnmodifiableListView) return _restrictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_restrictions);
  }

  @override
  final String hostAssetId;
// Host where restriction exists
  @override
  final String? applicationAssetId;
// Specific app if applicable
  @override
  final String? networkAssetId;
// Network segment if applicable
  @override
  final String? description;
  final List<String> _securityControlIds;
  @override
  @JsonKey()
  List<String> get securityControlIds {
    if (_securityControlIds is EqualUnmodifiableListView)
      return _securityControlIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_securityControlIds);
  }

  final List<String> _breakoutAttemptIds;
  @override
  @JsonKey()
  List<String> get breakoutAttemptIds {
    if (_breakoutAttemptIds is EqualUnmodifiableListView)
      return _breakoutAttemptIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_breakoutAttemptIds);
  }

  final Map<String, String>? _environmentDetails;
  @override
  Map<String, String>? get environmentDetails {
    final value = _environmentDetails;
    if (value == null) return null;
    if (_environmentDetails is EqualUnmodifiableMapView)
      return _environmentDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? discoveredAt;
  @override
  final DateTime? lastTested;

  @override
  String toString() {
    return 'RestrictedEnvironment(id: $id, name: $name, environmentType: $environmentType, restrictions: $restrictions, hostAssetId: $hostAssetId, applicationAssetId: $applicationAssetId, networkAssetId: $networkAssetId, description: $description, securityControlIds: $securityControlIds, breakoutAttemptIds: $breakoutAttemptIds, environmentDetails: $environmentDetails, discoveredAt: $discoveredAt, lastTested: $lastTested)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RestrictedEnvironmentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.environmentType, environmentType) ||
                other.environmentType == environmentType) &&
            const DeepCollectionEquality()
                .equals(other._restrictions, _restrictions) &&
            (identical(other.hostAssetId, hostAssetId) ||
                other.hostAssetId == hostAssetId) &&
            (identical(other.applicationAssetId, applicationAssetId) ||
                other.applicationAssetId == applicationAssetId) &&
            (identical(other.networkAssetId, networkAssetId) ||
                other.networkAssetId == networkAssetId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._securityControlIds, _securityControlIds) &&
            const DeepCollectionEquality()
                .equals(other._breakoutAttemptIds, _breakoutAttemptIds) &&
            const DeepCollectionEquality()
                .equals(other._environmentDetails, _environmentDetails) &&
            (identical(other.discoveredAt, discoveredAt) ||
                other.discoveredAt == discoveredAt) &&
            (identical(other.lastTested, lastTested) ||
                other.lastTested == lastTested));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      environmentType,
      const DeepCollectionEquality().hash(_restrictions),
      hostAssetId,
      applicationAssetId,
      networkAssetId,
      description,
      const DeepCollectionEquality().hash(_securityControlIds),
      const DeepCollectionEquality().hash(_breakoutAttemptIds),
      const DeepCollectionEquality().hash(_environmentDetails),
      discoveredAt,
      lastTested);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RestrictedEnvironmentImplCopyWith<_$RestrictedEnvironmentImpl>
      get copyWith => __$$RestrictedEnvironmentImplCopyWithImpl<
          _$RestrictedEnvironmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RestrictedEnvironmentImplToJson(
      this,
    );
  }
}

abstract class _RestrictedEnvironment implements RestrictedEnvironment {
  const factory _RestrictedEnvironment(
      {required final String id,
      required final String name,
      required final EnvironmentType environmentType,
      required final List<RestrictionMechanism> restrictions,
      required final String hostAssetId,
      final String? applicationAssetId,
      final String? networkAssetId,
      final String? description,
      final List<String> securityControlIds,
      final List<String> breakoutAttemptIds,
      final Map<String, String>? environmentDetails,
      final DateTime? discoveredAt,
      final DateTime? lastTested}) = _$RestrictedEnvironmentImpl;

  factory _RestrictedEnvironment.fromJson(Map<String, dynamic> json) =
      _$RestrictedEnvironmentImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  EnvironmentType get environmentType;
  @override
  List<RestrictionMechanism> get restrictions;
  @override
  String get hostAssetId;
  @override // Host where restriction exists
  String? get applicationAssetId;
  @override // Specific app if applicable
  String? get networkAssetId;
  @override // Network segment if applicable
  String? get description;
  @override
  List<String> get securityControlIds;
  @override
  List<String> get breakoutAttemptIds;
  @override
  Map<String, String>? get environmentDetails;
  @override
  DateTime? get discoveredAt;
  @override
  DateTime? get lastTested;
  @override
  @JsonKey(ignore: true)
  _$$RestrictedEnvironmentImplCopyWith<_$RestrictedEnvironmentImpl>
      get copyWith => throw _privateConstructorUsedError;
}

BreakoutAttempt _$BreakoutAttemptFromJson(Map<String, dynamic> json) {
  return _BreakoutAttempt.fromJson(json);
}

/// @nodoc
mixin _$BreakoutAttempt {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get restrictedEnvironmentId => throw _privateConstructorUsedError;
  String get techniqueId => throw _privateConstructorUsedError;
  BreakoutStatus get status => throw _privateConstructorUsedError;
  DateTime get attemptedAt => throw _privateConstructorUsedError;
  String? get testerAssetId =>
      throw _privateConstructorUsedError; // Person performing test
  String? get description => throw _privateConstructorUsedError;
  String? get command =>
      throw _privateConstructorUsedError; // Command/payload used
  String? get output => throw _privateConstructorUsedError; // Command output
  String? get evidence =>
      throw _privateConstructorUsedError; // Screenshots, logs, etc.
  BreakoutImpact? get impact => throw _privateConstructorUsedError;
  List<String>? get assetsGained =>
      throw _privateConstructorUsedError; // New assets accessed
  List<String>? get credentialsGained =>
      throw _privateConstructorUsedError; // New credentials obtained
  Map<String, String>? get attemptDetails =>
      throw _privateConstructorUsedError; // Tool-specific data
  String? get blockedBy =>
      throw _privateConstructorUsedError; // Security control that blocked
  DateTime? get completedAt => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BreakoutAttemptCopyWith<BreakoutAttempt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreakoutAttemptCopyWith<$Res> {
  factory $BreakoutAttemptCopyWith(
          BreakoutAttempt value, $Res Function(BreakoutAttempt) then) =
      _$BreakoutAttemptCopyWithImpl<$Res, BreakoutAttempt>;
  @useResult
  $Res call(
      {String id,
      String name,
      String restrictedEnvironmentId,
      String techniqueId,
      BreakoutStatus status,
      DateTime attemptedAt,
      String? testerAssetId,
      String? description,
      String? command,
      String? output,
      String? evidence,
      BreakoutImpact? impact,
      List<String>? assetsGained,
      List<String>? credentialsGained,
      Map<String, String>? attemptDetails,
      String? blockedBy,
      DateTime? completedAt,
      String? notes});
}

/// @nodoc
class _$BreakoutAttemptCopyWithImpl<$Res, $Val extends BreakoutAttempt>
    implements $BreakoutAttemptCopyWith<$Res> {
  _$BreakoutAttemptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? restrictedEnvironmentId = null,
    Object? techniqueId = null,
    Object? status = null,
    Object? attemptedAt = null,
    Object? testerAssetId = freezed,
    Object? description = freezed,
    Object? command = freezed,
    Object? output = freezed,
    Object? evidence = freezed,
    Object? impact = freezed,
    Object? assetsGained = freezed,
    Object? credentialsGained = freezed,
    Object? attemptDetails = freezed,
    Object? blockedBy = freezed,
    Object? completedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      restrictedEnvironmentId: null == restrictedEnvironmentId
          ? _value.restrictedEnvironmentId
          : restrictedEnvironmentId // ignore: cast_nullable_to_non_nullable
              as String,
      techniqueId: null == techniqueId
          ? _value.techniqueId
          : techniqueId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BreakoutStatus,
      attemptedAt: null == attemptedAt
          ? _value.attemptedAt
          : attemptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      testerAssetId: freezed == testerAssetId
          ? _value.testerAssetId
          : testerAssetId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      command: freezed == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as String?,
      output: freezed == output
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String?,
      evidence: freezed == evidence
          ? _value.evidence
          : evidence // ignore: cast_nullable_to_non_nullable
              as String?,
      impact: freezed == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as BreakoutImpact?,
      assetsGained: freezed == assetsGained
          ? _value.assetsGained
          : assetsGained // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      credentialsGained: freezed == credentialsGained
          ? _value.credentialsGained
          : credentialsGained // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      attemptDetails: freezed == attemptDetails
          ? _value.attemptDetails
          : attemptDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      blockedBy: freezed == blockedBy
          ? _value.blockedBy
          : blockedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BreakoutAttemptImplCopyWith<$Res>
    implements $BreakoutAttemptCopyWith<$Res> {
  factory _$$BreakoutAttemptImplCopyWith(_$BreakoutAttemptImpl value,
          $Res Function(_$BreakoutAttemptImpl) then) =
      __$$BreakoutAttemptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String restrictedEnvironmentId,
      String techniqueId,
      BreakoutStatus status,
      DateTime attemptedAt,
      String? testerAssetId,
      String? description,
      String? command,
      String? output,
      String? evidence,
      BreakoutImpact? impact,
      List<String>? assetsGained,
      List<String>? credentialsGained,
      Map<String, String>? attemptDetails,
      String? blockedBy,
      DateTime? completedAt,
      String? notes});
}

/// @nodoc
class __$$BreakoutAttemptImplCopyWithImpl<$Res>
    extends _$BreakoutAttemptCopyWithImpl<$Res, _$BreakoutAttemptImpl>
    implements _$$BreakoutAttemptImplCopyWith<$Res> {
  __$$BreakoutAttemptImplCopyWithImpl(
      _$BreakoutAttemptImpl _value, $Res Function(_$BreakoutAttemptImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? restrictedEnvironmentId = null,
    Object? techniqueId = null,
    Object? status = null,
    Object? attemptedAt = null,
    Object? testerAssetId = freezed,
    Object? description = freezed,
    Object? command = freezed,
    Object? output = freezed,
    Object? evidence = freezed,
    Object? impact = freezed,
    Object? assetsGained = freezed,
    Object? credentialsGained = freezed,
    Object? attemptDetails = freezed,
    Object? blockedBy = freezed,
    Object? completedAt = freezed,
    Object? notes = freezed,
  }) {
    return _then(_$BreakoutAttemptImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      restrictedEnvironmentId: null == restrictedEnvironmentId
          ? _value.restrictedEnvironmentId
          : restrictedEnvironmentId // ignore: cast_nullable_to_non_nullable
              as String,
      techniqueId: null == techniqueId
          ? _value.techniqueId
          : techniqueId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BreakoutStatus,
      attemptedAt: null == attemptedAt
          ? _value.attemptedAt
          : attemptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      testerAssetId: freezed == testerAssetId
          ? _value.testerAssetId
          : testerAssetId // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      command: freezed == command
          ? _value.command
          : command // ignore: cast_nullable_to_non_nullable
              as String?,
      output: freezed == output
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String?,
      evidence: freezed == evidence
          ? _value.evidence
          : evidence // ignore: cast_nullable_to_non_nullable
              as String?,
      impact: freezed == impact
          ? _value.impact
          : impact // ignore: cast_nullable_to_non_nullable
              as BreakoutImpact?,
      assetsGained: freezed == assetsGained
          ? _value._assetsGained
          : assetsGained // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      credentialsGained: freezed == credentialsGained
          ? _value._credentialsGained
          : credentialsGained // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      attemptDetails: freezed == attemptDetails
          ? _value._attemptDetails
          : attemptDetails // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      blockedBy: freezed == blockedBy
          ? _value.blockedBy
          : blockedBy // ignore: cast_nullable_to_non_nullable
              as String?,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BreakoutAttemptImpl implements _BreakoutAttempt {
  const _$BreakoutAttemptImpl(
      {required this.id,
      required this.name,
      required this.restrictedEnvironmentId,
      required this.techniqueId,
      required this.status,
      required this.attemptedAt,
      this.testerAssetId,
      this.description,
      this.command,
      this.output,
      this.evidence,
      this.impact,
      final List<String>? assetsGained,
      final List<String>? credentialsGained,
      final Map<String, String>? attemptDetails,
      this.blockedBy,
      this.completedAt,
      this.notes})
      : _assetsGained = assetsGained,
        _credentialsGained = credentialsGained,
        _attemptDetails = attemptDetails;

  factory _$BreakoutAttemptImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreakoutAttemptImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String restrictedEnvironmentId;
  @override
  final String techniqueId;
  @override
  final BreakoutStatus status;
  @override
  final DateTime attemptedAt;
  @override
  final String? testerAssetId;
// Person performing test
  @override
  final String? description;
  @override
  final String? command;
// Command/payload used
  @override
  final String? output;
// Command output
  @override
  final String? evidence;
// Screenshots, logs, etc.
  @override
  final BreakoutImpact? impact;
  final List<String>? _assetsGained;
  @override
  List<String>? get assetsGained {
    final value = _assetsGained;
    if (value == null) return null;
    if (_assetsGained is EqualUnmodifiableListView) return _assetsGained;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// New assets accessed
  final List<String>? _credentialsGained;
// New assets accessed
  @override
  List<String>? get credentialsGained {
    final value = _credentialsGained;
    if (value == null) return null;
    if (_credentialsGained is EqualUnmodifiableListView)
      return _credentialsGained;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// New credentials obtained
  final Map<String, String>? _attemptDetails;
// New credentials obtained
  @override
  Map<String, String>? get attemptDetails {
    final value = _attemptDetails;
    if (value == null) return null;
    if (_attemptDetails is EqualUnmodifiableMapView) return _attemptDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Tool-specific data
  @override
  final String? blockedBy;
// Security control that blocked
  @override
  final DateTime? completedAt;
  @override
  final String? notes;

  @override
  String toString() {
    return 'BreakoutAttempt(id: $id, name: $name, restrictedEnvironmentId: $restrictedEnvironmentId, techniqueId: $techniqueId, status: $status, attemptedAt: $attemptedAt, testerAssetId: $testerAssetId, description: $description, command: $command, output: $output, evidence: $evidence, impact: $impact, assetsGained: $assetsGained, credentialsGained: $credentialsGained, attemptDetails: $attemptDetails, blockedBy: $blockedBy, completedAt: $completedAt, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreakoutAttemptImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(
                    other.restrictedEnvironmentId, restrictedEnvironmentId) ||
                other.restrictedEnvironmentId == restrictedEnvironmentId) &&
            (identical(other.techniqueId, techniqueId) ||
                other.techniqueId == techniqueId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.attemptedAt, attemptedAt) ||
                other.attemptedAt == attemptedAt) &&
            (identical(other.testerAssetId, testerAssetId) ||
                other.testerAssetId == testerAssetId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.command, command) || other.command == command) &&
            (identical(other.output, output) || other.output == output) &&
            (identical(other.evidence, evidence) ||
                other.evidence == evidence) &&
            (identical(other.impact, impact) || other.impact == impact) &&
            const DeepCollectionEquality()
                .equals(other._assetsGained, _assetsGained) &&
            const DeepCollectionEquality()
                .equals(other._credentialsGained, _credentialsGained) &&
            const DeepCollectionEquality()
                .equals(other._attemptDetails, _attemptDetails) &&
            (identical(other.blockedBy, blockedBy) ||
                other.blockedBy == blockedBy) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      restrictedEnvironmentId,
      techniqueId,
      status,
      attemptedAt,
      testerAssetId,
      description,
      command,
      output,
      evidence,
      impact,
      const DeepCollectionEquality().hash(_assetsGained),
      const DeepCollectionEquality().hash(_credentialsGained),
      const DeepCollectionEquality().hash(_attemptDetails),
      blockedBy,
      completedAt,
      notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreakoutAttemptImplCopyWith<_$BreakoutAttemptImpl> get copyWith =>
      __$$BreakoutAttemptImplCopyWithImpl<_$BreakoutAttemptImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BreakoutAttemptImplToJson(
      this,
    );
  }
}

abstract class _BreakoutAttempt implements BreakoutAttempt {
  const factory _BreakoutAttempt(
      {required final String id,
      required final String name,
      required final String restrictedEnvironmentId,
      required final String techniqueId,
      required final BreakoutStatus status,
      required final DateTime attemptedAt,
      final String? testerAssetId,
      final String? description,
      final String? command,
      final String? output,
      final String? evidence,
      final BreakoutImpact? impact,
      final List<String>? assetsGained,
      final List<String>? credentialsGained,
      final Map<String, String>? attemptDetails,
      final String? blockedBy,
      final DateTime? completedAt,
      final String? notes}) = _$BreakoutAttemptImpl;

  factory _BreakoutAttempt.fromJson(Map<String, dynamic> json) =
      _$BreakoutAttemptImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get restrictedEnvironmentId;
  @override
  String get techniqueId;
  @override
  BreakoutStatus get status;
  @override
  DateTime get attemptedAt;
  @override
  String? get testerAssetId;
  @override // Person performing test
  String? get description;
  @override
  String? get command;
  @override // Command/payload used
  String? get output;
  @override // Command output
  String? get evidence;
  @override // Screenshots, logs, etc.
  BreakoutImpact? get impact;
  @override
  List<String>? get assetsGained;
  @override // New assets accessed
  List<String>? get credentialsGained;
  @override // New credentials obtained
  Map<String, String>? get attemptDetails;
  @override // Tool-specific data
  String? get blockedBy;
  @override // Security control that blocked
  DateTime? get completedAt;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$BreakoutAttemptImplCopyWith<_$BreakoutAttemptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BreakoutTechnique _$BreakoutTechniqueFromJson(Map<String, dynamic> json) {
  return _BreakoutTechnique.fromJson(json);
}

/// @nodoc
mixin _$BreakoutTechnique {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  TechniqueCategory get category => throw _privateConstructorUsedError;
  List<EnvironmentType> get applicableEnvironments =>
      throw _privateConstructorUsedError;
  List<RestrictionMechanism> get targetsRestrictions =>
      throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get methodology =>
      throw _privateConstructorUsedError; // Step-by-step process
  String? get payload =>
      throw _privateConstructorUsedError; // Example command/code
  List<String>? get prerequisites =>
      throw _privateConstructorUsedError; // Required conditions
  List<String>? get indicators =>
      throw _privateConstructorUsedError; // Signs of success
  List<String>? get mitigations =>
      throw _privateConstructorUsedError; // How to prevent
  String? get cveReference =>
      throw _privateConstructorUsedError; // CVE if applicable
  String? get source =>
      throw _privateConstructorUsedError; // Where technique came from
  Map<String, String>? get metadata =>
      throw _privateConstructorUsedError; // MITRE ATT&CK, etc.
  DateTime? get discoveredAt => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BreakoutTechniqueCopyWith<BreakoutTechnique> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BreakoutTechniqueCopyWith<$Res> {
  factory $BreakoutTechniqueCopyWith(
          BreakoutTechnique value, $Res Function(BreakoutTechnique) then) =
      _$BreakoutTechniqueCopyWithImpl<$Res, BreakoutTechnique>;
  @useResult
  $Res call(
      {String id,
      String name,
      TechniqueCategory category,
      List<EnvironmentType> applicableEnvironments,
      List<RestrictionMechanism> targetsRestrictions,
      String? description,
      String? methodology,
      String? payload,
      List<String>? prerequisites,
      List<String>? indicators,
      List<String>? mitigations,
      String? cveReference,
      String? source,
      Map<String, String>? metadata,
      DateTime? discoveredAt,
      DateTime? lastUpdated});
}

/// @nodoc
class _$BreakoutTechniqueCopyWithImpl<$Res, $Val extends BreakoutTechnique>
    implements $BreakoutTechniqueCopyWith<$Res> {
  _$BreakoutTechniqueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? applicableEnvironments = null,
    Object? targetsRestrictions = null,
    Object? description = freezed,
    Object? methodology = freezed,
    Object? payload = freezed,
    Object? prerequisites = freezed,
    Object? indicators = freezed,
    Object? mitigations = freezed,
    Object? cveReference = freezed,
    Object? source = freezed,
    Object? metadata = freezed,
    Object? discoveredAt = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TechniqueCategory,
      applicableEnvironments: null == applicableEnvironments
          ? _value.applicableEnvironments
          : applicableEnvironments // ignore: cast_nullable_to_non_nullable
              as List<EnvironmentType>,
      targetsRestrictions: null == targetsRestrictions
          ? _value.targetsRestrictions
          : targetsRestrictions // ignore: cast_nullable_to_non_nullable
              as List<RestrictionMechanism>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      methodology: freezed == methodology
          ? _value.methodology
          : methodology // ignore: cast_nullable_to_non_nullable
              as String?,
      payload: freezed == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as String?,
      prerequisites: freezed == prerequisites
          ? _value.prerequisites
          : prerequisites // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      indicators: freezed == indicators
          ? _value.indicators
          : indicators // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      mitigations: freezed == mitigations
          ? _value.mitigations
          : mitigations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      cveReference: freezed == cveReference
          ? _value.cveReference
          : cveReference // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      discoveredAt: freezed == discoveredAt
          ? _value.discoveredAt
          : discoveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BreakoutTechniqueImplCopyWith<$Res>
    implements $BreakoutTechniqueCopyWith<$Res> {
  factory _$$BreakoutTechniqueImplCopyWith(_$BreakoutTechniqueImpl value,
          $Res Function(_$BreakoutTechniqueImpl) then) =
      __$$BreakoutTechniqueImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      TechniqueCategory category,
      List<EnvironmentType> applicableEnvironments,
      List<RestrictionMechanism> targetsRestrictions,
      String? description,
      String? methodology,
      String? payload,
      List<String>? prerequisites,
      List<String>? indicators,
      List<String>? mitigations,
      String? cveReference,
      String? source,
      Map<String, String>? metadata,
      DateTime? discoveredAt,
      DateTime? lastUpdated});
}

/// @nodoc
class __$$BreakoutTechniqueImplCopyWithImpl<$Res>
    extends _$BreakoutTechniqueCopyWithImpl<$Res, _$BreakoutTechniqueImpl>
    implements _$$BreakoutTechniqueImplCopyWith<$Res> {
  __$$BreakoutTechniqueImplCopyWithImpl(_$BreakoutTechniqueImpl _value,
      $Res Function(_$BreakoutTechniqueImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? applicableEnvironments = null,
    Object? targetsRestrictions = null,
    Object? description = freezed,
    Object? methodology = freezed,
    Object? payload = freezed,
    Object? prerequisites = freezed,
    Object? indicators = freezed,
    Object? mitigations = freezed,
    Object? cveReference = freezed,
    Object? source = freezed,
    Object? metadata = freezed,
    Object? discoveredAt = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$BreakoutTechniqueImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as TechniqueCategory,
      applicableEnvironments: null == applicableEnvironments
          ? _value._applicableEnvironments
          : applicableEnvironments // ignore: cast_nullable_to_non_nullable
              as List<EnvironmentType>,
      targetsRestrictions: null == targetsRestrictions
          ? _value._targetsRestrictions
          : targetsRestrictions // ignore: cast_nullable_to_non_nullable
              as List<RestrictionMechanism>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      methodology: freezed == methodology
          ? _value.methodology
          : methodology // ignore: cast_nullable_to_non_nullable
              as String?,
      payload: freezed == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as String?,
      prerequisites: freezed == prerequisites
          ? _value._prerequisites
          : prerequisites // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      indicators: freezed == indicators
          ? _value._indicators
          : indicators // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      mitigations: freezed == mitigations
          ? _value._mitigations
          : mitigations // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      cveReference: freezed == cveReference
          ? _value.cveReference
          : cveReference // ignore: cast_nullable_to_non_nullable
              as String?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      discoveredAt: freezed == discoveredAt
          ? _value.discoveredAt
          : discoveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BreakoutTechniqueImpl implements _BreakoutTechnique {
  const _$BreakoutTechniqueImpl(
      {required this.id,
      required this.name,
      required this.category,
      required final List<EnvironmentType> applicableEnvironments,
      required final List<RestrictionMechanism> targetsRestrictions,
      this.description,
      this.methodology,
      this.payload,
      final List<String>? prerequisites,
      final List<String>? indicators,
      final List<String>? mitigations,
      this.cveReference,
      this.source,
      final Map<String, String>? metadata,
      this.discoveredAt,
      this.lastUpdated})
      : _applicableEnvironments = applicableEnvironments,
        _targetsRestrictions = targetsRestrictions,
        _prerequisites = prerequisites,
        _indicators = indicators,
        _mitigations = mitigations,
        _metadata = metadata;

  factory _$BreakoutTechniqueImpl.fromJson(Map<String, dynamic> json) =>
      _$$BreakoutTechniqueImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final TechniqueCategory category;
  final List<EnvironmentType> _applicableEnvironments;
  @override
  List<EnvironmentType> get applicableEnvironments {
    if (_applicableEnvironments is EqualUnmodifiableListView)
      return _applicableEnvironments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_applicableEnvironments);
  }

  final List<RestrictionMechanism> _targetsRestrictions;
  @override
  List<RestrictionMechanism> get targetsRestrictions {
    if (_targetsRestrictions is EqualUnmodifiableListView)
      return _targetsRestrictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetsRestrictions);
  }

  @override
  final String? description;
  @override
  final String? methodology;
// Step-by-step process
  @override
  final String? payload;
// Example command/code
  final List<String>? _prerequisites;
// Example command/code
  @override
  List<String>? get prerequisites {
    final value = _prerequisites;
    if (value == null) return null;
    if (_prerequisites is EqualUnmodifiableListView) return _prerequisites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Required conditions
  final List<String>? _indicators;
// Required conditions
  @override
  List<String>? get indicators {
    final value = _indicators;
    if (value == null) return null;
    if (_indicators is EqualUnmodifiableListView) return _indicators;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// Signs of success
  final List<String>? _mitigations;
// Signs of success
  @override
  List<String>? get mitigations {
    final value = _mitigations;
    if (value == null) return null;
    if (_mitigations is EqualUnmodifiableListView) return _mitigations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// How to prevent
  @override
  final String? cveReference;
// CVE if applicable
  @override
  final String? source;
// Where technique came from
  final Map<String, String>? _metadata;
// Where technique came from
  @override
  Map<String, String>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// MITRE ATT&CK, etc.
  @override
  final DateTime? discoveredAt;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'BreakoutTechnique(id: $id, name: $name, category: $category, applicableEnvironments: $applicableEnvironments, targetsRestrictions: $targetsRestrictions, description: $description, methodology: $methodology, payload: $payload, prerequisites: $prerequisites, indicators: $indicators, mitigations: $mitigations, cveReference: $cveReference, source: $source, metadata: $metadata, discoveredAt: $discoveredAt, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BreakoutTechniqueImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality().equals(
                other._applicableEnvironments, _applicableEnvironments) &&
            const DeepCollectionEquality()
                .equals(other._targetsRestrictions, _targetsRestrictions) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.methodology, methodology) ||
                other.methodology == methodology) &&
            (identical(other.payload, payload) || other.payload == payload) &&
            const DeepCollectionEquality()
                .equals(other._prerequisites, _prerequisites) &&
            const DeepCollectionEquality()
                .equals(other._indicators, _indicators) &&
            const DeepCollectionEquality()
                .equals(other._mitigations, _mitigations) &&
            (identical(other.cveReference, cveReference) ||
                other.cveReference == cveReference) &&
            (identical(other.source, source) || other.source == source) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.discoveredAt, discoveredAt) ||
                other.discoveredAt == discoveredAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      category,
      const DeepCollectionEquality().hash(_applicableEnvironments),
      const DeepCollectionEquality().hash(_targetsRestrictions),
      description,
      methodology,
      payload,
      const DeepCollectionEquality().hash(_prerequisites),
      const DeepCollectionEquality().hash(_indicators),
      const DeepCollectionEquality().hash(_mitigations),
      cveReference,
      source,
      const DeepCollectionEquality().hash(_metadata),
      discoveredAt,
      lastUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BreakoutTechniqueImplCopyWith<_$BreakoutTechniqueImpl> get copyWith =>
      __$$BreakoutTechniqueImplCopyWithImpl<_$BreakoutTechniqueImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BreakoutTechniqueImplToJson(
      this,
    );
  }
}

abstract class _BreakoutTechnique implements BreakoutTechnique {
  const factory _BreakoutTechnique(
      {required final String id,
      required final String name,
      required final TechniqueCategory category,
      required final List<EnvironmentType> applicableEnvironments,
      required final List<RestrictionMechanism> targetsRestrictions,
      final String? description,
      final String? methodology,
      final String? payload,
      final List<String>? prerequisites,
      final List<String>? indicators,
      final List<String>? mitigations,
      final String? cveReference,
      final String? source,
      final Map<String, String>? metadata,
      final DateTime? discoveredAt,
      final DateTime? lastUpdated}) = _$BreakoutTechniqueImpl;

  factory _BreakoutTechnique.fromJson(Map<String, dynamic> json) =
      _$BreakoutTechniqueImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  TechniqueCategory get category;
  @override
  List<EnvironmentType> get applicableEnvironments;
  @override
  List<RestrictionMechanism> get targetsRestrictions;
  @override
  String? get description;
  @override
  String? get methodology;
  @override // Step-by-step process
  String? get payload;
  @override // Example command/code
  List<String>? get prerequisites;
  @override // Required conditions
  List<String>? get indicators;
  @override // Signs of success
  List<String>? get mitigations;
  @override // How to prevent
  String? get cveReference;
  @override // CVE if applicable
  String? get source;
  @override // Where technique came from
  Map<String, String>? get metadata;
  @override // MITRE ATT&CK, etc.
  DateTime? get discoveredAt;
  @override
  DateTime? get lastUpdated;
  @override
  @JsonKey(ignore: true)
  _$$BreakoutTechniqueImplCopyWith<_$BreakoutTechniqueImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SecurityControl _$SecurityControlFromJson(Map<String, dynamic> json) {
  return _SecurityControl.fromJson(json);
}

/// @nodoc
mixin _$SecurityControl {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // "appLocker", "sandbox", etc.
  String get hostAssetId => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;
  String? get configuration => throw _privateConstructorUsedError;
  bool get enabled => throw _privateConstructorUsedError;
  List<String> get protectedAssets => throw _privateConstructorUsedError;
  List<String> get bypassTechniques => throw _privateConstructorUsedError;
  Map<String, String>? get settings => throw _privateConstructorUsedError;
  DateTime? get installedAt => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SecurityControlCopyWith<SecurityControl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecurityControlCopyWith<$Res> {
  factory $SecurityControlCopyWith(
          SecurityControl value, $Res Function(SecurityControl) then) =
      _$SecurityControlCopyWithImpl<$Res, SecurityControl>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String hostAssetId,
      String? description,
      String? version,
      String? configuration,
      bool enabled,
      List<String> protectedAssets,
      List<String> bypassTechniques,
      Map<String, String>? settings,
      DateTime? installedAt,
      DateTime? lastUpdated});
}

/// @nodoc
class _$SecurityControlCopyWithImpl<$Res, $Val extends SecurityControl>
    implements $SecurityControlCopyWith<$Res> {
  _$SecurityControlCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? hostAssetId = null,
    Object? description = freezed,
    Object? version = freezed,
    Object? configuration = freezed,
    Object? enabled = null,
    Object? protectedAssets = null,
    Object? bypassTechniques = null,
    Object? settings = freezed,
    Object? installedAt = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      hostAssetId: null == hostAssetId
          ? _value.hostAssetId
          : hostAssetId // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      configuration: freezed == configuration
          ? _value.configuration
          : configuration // ignore: cast_nullable_to_non_nullable
              as String?,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      protectedAssets: null == protectedAssets
          ? _value.protectedAssets
          : protectedAssets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bypassTechniques: null == bypassTechniques
          ? _value.bypassTechniques
          : bypassTechniques // ignore: cast_nullable_to_non_nullable
              as List<String>,
      settings: freezed == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      installedAt: freezed == installedAt
          ? _value.installedAt
          : installedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SecurityControlImplCopyWith<$Res>
    implements $SecurityControlCopyWith<$Res> {
  factory _$$SecurityControlImplCopyWith(_$SecurityControlImpl value,
          $Res Function(_$SecurityControlImpl) then) =
      __$$SecurityControlImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String hostAssetId,
      String? description,
      String? version,
      String? configuration,
      bool enabled,
      List<String> protectedAssets,
      List<String> bypassTechniques,
      Map<String, String>? settings,
      DateTime? installedAt,
      DateTime? lastUpdated});
}

/// @nodoc
class __$$SecurityControlImplCopyWithImpl<$Res>
    extends _$SecurityControlCopyWithImpl<$Res, _$SecurityControlImpl>
    implements _$$SecurityControlImplCopyWith<$Res> {
  __$$SecurityControlImplCopyWithImpl(
      _$SecurityControlImpl _value, $Res Function(_$SecurityControlImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? hostAssetId = null,
    Object? description = freezed,
    Object? version = freezed,
    Object? configuration = freezed,
    Object? enabled = null,
    Object? protectedAssets = null,
    Object? bypassTechniques = null,
    Object? settings = freezed,
    Object? installedAt = freezed,
    Object? lastUpdated = freezed,
  }) {
    return _then(_$SecurityControlImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      hostAssetId: null == hostAssetId
          ? _value.hostAssetId
          : hostAssetId // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      configuration: freezed == configuration
          ? _value.configuration
          : configuration // ignore: cast_nullable_to_non_nullable
              as String?,
      enabled: null == enabled
          ? _value.enabled
          : enabled // ignore: cast_nullable_to_non_nullable
              as bool,
      protectedAssets: null == protectedAssets
          ? _value._protectedAssets
          : protectedAssets // ignore: cast_nullable_to_non_nullable
              as List<String>,
      bypassTechniques: null == bypassTechniques
          ? _value._bypassTechniques
          : bypassTechniques // ignore: cast_nullable_to_non_nullable
              as List<String>,
      settings: freezed == settings
          ? _value._settings
          : settings // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      installedAt: freezed == installedAt
          ? _value.installedAt
          : installedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SecurityControlImpl implements _SecurityControl {
  const _$SecurityControlImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.hostAssetId,
      this.description,
      this.version,
      this.configuration,
      this.enabled = true,
      final List<String> protectedAssets = const [],
      final List<String> bypassTechniques = const [],
      final Map<String, String>? settings,
      this.installedAt,
      this.lastUpdated})
      : _protectedAssets = protectedAssets,
        _bypassTechniques = bypassTechniques,
        _settings = settings;

  factory _$SecurityControlImpl.fromJson(Map<String, dynamic> json) =>
      _$$SecurityControlImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
// "appLocker", "sandbox", etc.
  @override
  final String hostAssetId;
  @override
  final String? description;
  @override
  final String? version;
  @override
  final String? configuration;
  @override
  @JsonKey()
  final bool enabled;
  final List<String> _protectedAssets;
  @override
  @JsonKey()
  List<String> get protectedAssets {
    if (_protectedAssets is EqualUnmodifiableListView) return _protectedAssets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_protectedAssets);
  }

  final List<String> _bypassTechniques;
  @override
  @JsonKey()
  List<String> get bypassTechniques {
    if (_bypassTechniques is EqualUnmodifiableListView)
      return _bypassTechniques;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_bypassTechniques);
  }

  final Map<String, String>? _settings;
  @override
  Map<String, String>? get settings {
    final value = _settings;
    if (value == null) return null;
    if (_settings is EqualUnmodifiableMapView) return _settings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? installedAt;
  @override
  final DateTime? lastUpdated;

  @override
  String toString() {
    return 'SecurityControl(id: $id, name: $name, type: $type, hostAssetId: $hostAssetId, description: $description, version: $version, configuration: $configuration, enabled: $enabled, protectedAssets: $protectedAssets, bypassTechniques: $bypassTechniques, settings: $settings, installedAt: $installedAt, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SecurityControlImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.hostAssetId, hostAssetId) ||
                other.hostAssetId == hostAssetId) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.configuration, configuration) ||
                other.configuration == configuration) &&
            (identical(other.enabled, enabled) || other.enabled == enabled) &&
            const DeepCollectionEquality()
                .equals(other._protectedAssets, _protectedAssets) &&
            const DeepCollectionEquality()
                .equals(other._bypassTechniques, _bypassTechniques) &&
            const DeepCollectionEquality().equals(other._settings, _settings) &&
            (identical(other.installedAt, installedAt) ||
                other.installedAt == installedAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      hostAssetId,
      description,
      version,
      configuration,
      enabled,
      const DeepCollectionEquality().hash(_protectedAssets),
      const DeepCollectionEquality().hash(_bypassTechniques),
      const DeepCollectionEquality().hash(_settings),
      installedAt,
      lastUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SecurityControlImplCopyWith<_$SecurityControlImpl> get copyWith =>
      __$$SecurityControlImplCopyWithImpl<_$SecurityControlImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SecurityControlImplToJson(
      this,
    );
  }
}

abstract class _SecurityControl implements SecurityControl {
  const factory _SecurityControl(
      {required final String id,
      required final String name,
      required final String type,
      required final String hostAssetId,
      final String? description,
      final String? version,
      final String? configuration,
      final bool enabled,
      final List<String> protectedAssets,
      final List<String> bypassTechniques,
      final Map<String, String>? settings,
      final DateTime? installedAt,
      final DateTime? lastUpdated}) = _$SecurityControlImpl;

  factory _SecurityControl.fromJson(Map<String, dynamic> json) =
      _$SecurityControlImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override // "appLocker", "sandbox", etc.
  String get hostAssetId;
  @override
  String? get description;
  @override
  String? get version;
  @override
  String? get configuration;
  @override
  bool get enabled;
  @override
  List<String> get protectedAssets;
  @override
  List<String> get bypassTechniques;
  @override
  Map<String, String>? get settings;
  @override
  DateTime? get installedAt;
  @override
  DateTime? get lastUpdated;
  @override
  @JsonKey(ignore: true)
  _$$SecurityControlImplCopyWith<_$SecurityControlImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AssetPropertyValue _$AssetPropertyValueFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'string':
      return StringAssetProperty.fromJson(json);
    case 'integer':
      return IntegerAssetProperty.fromJson(json);
    case 'double':
      return DoubleAssetProperty.fromJson(json);
    case 'boolean':
      return BooleanAssetProperty.fromJson(json);
    case 'stringList':
      return StringListAssetProperty.fromJson(json);
    case 'dateTime':
      return DateTimeAssetProperty.fromJson(json);
    case 'map':
      return MapAssetProperty.fromJson(json);
    case 'objectList':
      return ObjectListAssetProperty.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'AssetPropertyValue',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$AssetPropertyValue {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(double value) double,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(DateTime value) dateTime,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(double value)? double,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(DateTime value)? dateTime,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(double value)? double,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(DateTime value)? dateTime,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringAssetProperty value) string,
    required TResult Function(IntegerAssetProperty value) integer,
    required TResult Function(DoubleAssetProperty value) double,
    required TResult Function(BooleanAssetProperty value) boolean,
    required TResult Function(StringListAssetProperty value) stringList,
    required TResult Function(DateTimeAssetProperty value) dateTime,
    required TResult Function(MapAssetProperty value) map,
    required TResult Function(ObjectListAssetProperty value) objectList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringAssetProperty value)? string,
    TResult? Function(IntegerAssetProperty value)? integer,
    TResult? Function(DoubleAssetProperty value)? double,
    TResult? Function(BooleanAssetProperty value)? boolean,
    TResult? Function(StringListAssetProperty value)? stringList,
    TResult? Function(DateTimeAssetProperty value)? dateTime,
    TResult? Function(MapAssetProperty value)? map,
    TResult? Function(ObjectListAssetProperty value)? objectList,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringAssetProperty value)? string,
    TResult Function(IntegerAssetProperty value)? integer,
    TResult Function(DoubleAssetProperty value)? double,
    TResult Function(BooleanAssetProperty value)? boolean,
    TResult Function(StringListAssetProperty value)? stringList,
    TResult Function(DateTimeAssetProperty value)? dateTime,
    TResult Function(MapAssetProperty value)? map,
    TResult Function(ObjectListAssetProperty value)? objectList,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetPropertyValueCopyWith<$Res> {
  factory $AssetPropertyValueCopyWith(
          AssetPropertyValue value, $Res Function(AssetPropertyValue) then) =
      _$AssetPropertyValueCopyWithImpl<$Res, AssetPropertyValue>;
}

/// @nodoc
class _$AssetPropertyValueCopyWithImpl<$Res, $Val extends AssetPropertyValue>
    implements $AssetPropertyValueCopyWith<$Res> {
  _$AssetPropertyValueCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$StringAssetPropertyImplCopyWith<$Res> {
  factory _$$StringAssetPropertyImplCopyWith(_$StringAssetPropertyImpl value,
          $Res Function(_$StringAssetPropertyImpl) then) =
      __$$StringAssetPropertyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String value});
}

/// @nodoc
class __$$StringAssetPropertyImplCopyWithImpl<$Res>
    extends _$AssetPropertyValueCopyWithImpl<$Res, _$StringAssetPropertyImpl>
    implements _$$StringAssetPropertyImplCopyWith<$Res> {
  __$$StringAssetPropertyImplCopyWithImpl(_$StringAssetPropertyImpl _value,
      $Res Function(_$StringAssetPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$StringAssetPropertyImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StringAssetPropertyImpl implements StringAssetProperty {
  const _$StringAssetPropertyImpl(this.value, {final String? $type})
      : $type = $type ?? 'string';

  factory _$StringAssetPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$StringAssetPropertyImplFromJson(json);

  @override
  final String value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AssetPropertyValue.string(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StringAssetPropertyImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StringAssetPropertyImplCopyWith<_$StringAssetPropertyImpl> get copyWith =>
      __$$StringAssetPropertyImplCopyWithImpl<_$StringAssetPropertyImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(double value) double,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(DateTime value) dateTime,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) {
    return string(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(double value)? double,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(DateTime value)? dateTime,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) {
    return string?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(double value)? double,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(DateTime value)? dateTime,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) {
    if (string != null) {
      return string(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringAssetProperty value) string,
    required TResult Function(IntegerAssetProperty value) integer,
    required TResult Function(DoubleAssetProperty value) double,
    required TResult Function(BooleanAssetProperty value) boolean,
    required TResult Function(StringListAssetProperty value) stringList,
    required TResult Function(DateTimeAssetProperty value) dateTime,
    required TResult Function(MapAssetProperty value) map,
    required TResult Function(ObjectListAssetProperty value) objectList,
  }) {
    return string(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringAssetProperty value)? string,
    TResult? Function(IntegerAssetProperty value)? integer,
    TResult? Function(DoubleAssetProperty value)? double,
    TResult? Function(BooleanAssetProperty value)? boolean,
    TResult? Function(StringListAssetProperty value)? stringList,
    TResult? Function(DateTimeAssetProperty value)? dateTime,
    TResult? Function(MapAssetProperty value)? map,
    TResult? Function(ObjectListAssetProperty value)? objectList,
  }) {
    return string?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringAssetProperty value)? string,
    TResult Function(IntegerAssetProperty value)? integer,
    TResult Function(DoubleAssetProperty value)? double,
    TResult Function(BooleanAssetProperty value)? boolean,
    TResult Function(StringListAssetProperty value)? stringList,
    TResult Function(DateTimeAssetProperty value)? dateTime,
    TResult Function(MapAssetProperty value)? map,
    TResult Function(ObjectListAssetProperty value)? objectList,
    required TResult orElse(),
  }) {
    if (string != null) {
      return string(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StringAssetPropertyImplToJson(
      this,
    );
  }
}

abstract class StringAssetProperty implements AssetPropertyValue {
  const factory StringAssetProperty(final String value) =
      _$StringAssetPropertyImpl;

  factory StringAssetProperty.fromJson(Map<String, dynamic> json) =
      _$StringAssetPropertyImpl.fromJson;

  String get value;
  @JsonKey(ignore: true)
  _$$StringAssetPropertyImplCopyWith<_$StringAssetPropertyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$IntegerAssetPropertyImplCopyWith<$Res> {
  factory _$$IntegerAssetPropertyImplCopyWith(_$IntegerAssetPropertyImpl value,
          $Res Function(_$IntegerAssetPropertyImpl) then) =
      __$$IntegerAssetPropertyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int value});
}

/// @nodoc
class __$$IntegerAssetPropertyImplCopyWithImpl<$Res>
    extends _$AssetPropertyValueCopyWithImpl<$Res, _$IntegerAssetPropertyImpl>
    implements _$$IntegerAssetPropertyImplCopyWith<$Res> {
  __$$IntegerAssetPropertyImplCopyWithImpl(_$IntegerAssetPropertyImpl _value,
      $Res Function(_$IntegerAssetPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$IntegerAssetPropertyImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IntegerAssetPropertyImpl implements IntegerAssetProperty {
  const _$IntegerAssetPropertyImpl(this.value, {final String? $type})
      : $type = $type ?? 'integer';

  factory _$IntegerAssetPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$IntegerAssetPropertyImplFromJson(json);

  @override
  final int value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AssetPropertyValue.integer(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IntegerAssetPropertyImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$IntegerAssetPropertyImplCopyWith<_$IntegerAssetPropertyImpl>
      get copyWith =>
          __$$IntegerAssetPropertyImplCopyWithImpl<_$IntegerAssetPropertyImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(double value) double,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(DateTime value) dateTime,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) {
    return integer(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(double value)? double,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(DateTime value)? dateTime,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) {
    return integer?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(double value)? double,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(DateTime value)? dateTime,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) {
    if (integer != null) {
      return integer(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringAssetProperty value) string,
    required TResult Function(IntegerAssetProperty value) integer,
    required TResult Function(DoubleAssetProperty value) double,
    required TResult Function(BooleanAssetProperty value) boolean,
    required TResult Function(StringListAssetProperty value) stringList,
    required TResult Function(DateTimeAssetProperty value) dateTime,
    required TResult Function(MapAssetProperty value) map,
    required TResult Function(ObjectListAssetProperty value) objectList,
  }) {
    return integer(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringAssetProperty value)? string,
    TResult? Function(IntegerAssetProperty value)? integer,
    TResult? Function(DoubleAssetProperty value)? double,
    TResult? Function(BooleanAssetProperty value)? boolean,
    TResult? Function(StringListAssetProperty value)? stringList,
    TResult? Function(DateTimeAssetProperty value)? dateTime,
    TResult? Function(MapAssetProperty value)? map,
    TResult? Function(ObjectListAssetProperty value)? objectList,
  }) {
    return integer?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringAssetProperty value)? string,
    TResult Function(IntegerAssetProperty value)? integer,
    TResult Function(DoubleAssetProperty value)? double,
    TResult Function(BooleanAssetProperty value)? boolean,
    TResult Function(StringListAssetProperty value)? stringList,
    TResult Function(DateTimeAssetProperty value)? dateTime,
    TResult Function(MapAssetProperty value)? map,
    TResult Function(ObjectListAssetProperty value)? objectList,
    required TResult orElse(),
  }) {
    if (integer != null) {
      return integer(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$IntegerAssetPropertyImplToJson(
      this,
    );
  }
}

abstract class IntegerAssetProperty implements AssetPropertyValue {
  const factory IntegerAssetProperty(final int value) =
      _$IntegerAssetPropertyImpl;

  factory IntegerAssetProperty.fromJson(Map<String, dynamic> json) =
      _$IntegerAssetPropertyImpl.fromJson;

  int get value;
  @JsonKey(ignore: true)
  _$$IntegerAssetPropertyImplCopyWith<_$IntegerAssetPropertyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DoubleAssetPropertyImplCopyWith<$Res> {
  factory _$$DoubleAssetPropertyImplCopyWith(_$DoubleAssetPropertyImpl value,
          $Res Function(_$DoubleAssetPropertyImpl) then) =
      __$$DoubleAssetPropertyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double value});
}

/// @nodoc
class __$$DoubleAssetPropertyImplCopyWithImpl<$Res>
    extends _$AssetPropertyValueCopyWithImpl<$Res, _$DoubleAssetPropertyImpl>
    implements _$$DoubleAssetPropertyImplCopyWith<$Res> {
  __$$DoubleAssetPropertyImplCopyWithImpl(_$DoubleAssetPropertyImpl _value,
      $Res Function(_$DoubleAssetPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$DoubleAssetPropertyImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DoubleAssetPropertyImpl implements DoubleAssetProperty {
  const _$DoubleAssetPropertyImpl(this.value, {final String? $type})
      : $type = $type ?? 'double';

  factory _$DoubleAssetPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$DoubleAssetPropertyImplFromJson(json);

  @override
  final double value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AssetPropertyValue.double(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DoubleAssetPropertyImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DoubleAssetPropertyImplCopyWith<_$DoubleAssetPropertyImpl> get copyWith =>
      __$$DoubleAssetPropertyImplCopyWithImpl<_$DoubleAssetPropertyImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(double value) double,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(DateTime value) dateTime,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) {
    return double(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(double value)? double,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(DateTime value)? dateTime,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) {
    return double?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(double value)? double,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(DateTime value)? dateTime,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) {
    if (double != null) {
      return double(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringAssetProperty value) string,
    required TResult Function(IntegerAssetProperty value) integer,
    required TResult Function(DoubleAssetProperty value) double,
    required TResult Function(BooleanAssetProperty value) boolean,
    required TResult Function(StringListAssetProperty value) stringList,
    required TResult Function(DateTimeAssetProperty value) dateTime,
    required TResult Function(MapAssetProperty value) map,
    required TResult Function(ObjectListAssetProperty value) objectList,
  }) {
    return double(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringAssetProperty value)? string,
    TResult? Function(IntegerAssetProperty value)? integer,
    TResult? Function(DoubleAssetProperty value)? double,
    TResult? Function(BooleanAssetProperty value)? boolean,
    TResult? Function(StringListAssetProperty value)? stringList,
    TResult? Function(DateTimeAssetProperty value)? dateTime,
    TResult? Function(MapAssetProperty value)? map,
    TResult? Function(ObjectListAssetProperty value)? objectList,
  }) {
    return double?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringAssetProperty value)? string,
    TResult Function(IntegerAssetProperty value)? integer,
    TResult Function(DoubleAssetProperty value)? double,
    TResult Function(BooleanAssetProperty value)? boolean,
    TResult Function(StringListAssetProperty value)? stringList,
    TResult Function(DateTimeAssetProperty value)? dateTime,
    TResult Function(MapAssetProperty value)? map,
    TResult Function(ObjectListAssetProperty value)? objectList,
    required TResult orElse(),
  }) {
    if (double != null) {
      return double(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DoubleAssetPropertyImplToJson(
      this,
    );
  }
}

abstract class DoubleAssetProperty implements AssetPropertyValue {
  const factory DoubleAssetProperty(final double value) =
      _$DoubleAssetPropertyImpl;

  factory DoubleAssetProperty.fromJson(Map<String, dynamic> json) =
      _$DoubleAssetPropertyImpl.fromJson;

  double get value;
  @JsonKey(ignore: true)
  _$$DoubleAssetPropertyImplCopyWith<_$DoubleAssetPropertyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$BooleanAssetPropertyImplCopyWith<$Res> {
  factory _$$BooleanAssetPropertyImplCopyWith(_$BooleanAssetPropertyImpl value,
          $Res Function(_$BooleanAssetPropertyImpl) then) =
      __$$BooleanAssetPropertyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({bool value});
}

/// @nodoc
class __$$BooleanAssetPropertyImplCopyWithImpl<$Res>
    extends _$AssetPropertyValueCopyWithImpl<$Res, _$BooleanAssetPropertyImpl>
    implements _$$BooleanAssetPropertyImplCopyWith<$Res> {
  __$$BooleanAssetPropertyImplCopyWithImpl(_$BooleanAssetPropertyImpl _value,
      $Res Function(_$BooleanAssetPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$BooleanAssetPropertyImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BooleanAssetPropertyImpl implements BooleanAssetProperty {
  const _$BooleanAssetPropertyImpl(this.value, {final String? $type})
      : $type = $type ?? 'boolean';

  factory _$BooleanAssetPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$BooleanAssetPropertyImplFromJson(json);

  @override
  final bool value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AssetPropertyValue.boolean(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BooleanAssetPropertyImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BooleanAssetPropertyImplCopyWith<_$BooleanAssetPropertyImpl>
      get copyWith =>
          __$$BooleanAssetPropertyImplCopyWithImpl<_$BooleanAssetPropertyImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(double value) double,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(DateTime value) dateTime,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) {
    return boolean(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(double value)? double,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(DateTime value)? dateTime,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) {
    return boolean?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(double value)? double,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(DateTime value)? dateTime,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) {
    if (boolean != null) {
      return boolean(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringAssetProperty value) string,
    required TResult Function(IntegerAssetProperty value) integer,
    required TResult Function(DoubleAssetProperty value) double,
    required TResult Function(BooleanAssetProperty value) boolean,
    required TResult Function(StringListAssetProperty value) stringList,
    required TResult Function(DateTimeAssetProperty value) dateTime,
    required TResult Function(MapAssetProperty value) map,
    required TResult Function(ObjectListAssetProperty value) objectList,
  }) {
    return boolean(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringAssetProperty value)? string,
    TResult? Function(IntegerAssetProperty value)? integer,
    TResult? Function(DoubleAssetProperty value)? double,
    TResult? Function(BooleanAssetProperty value)? boolean,
    TResult? Function(StringListAssetProperty value)? stringList,
    TResult? Function(DateTimeAssetProperty value)? dateTime,
    TResult? Function(MapAssetProperty value)? map,
    TResult? Function(ObjectListAssetProperty value)? objectList,
  }) {
    return boolean?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringAssetProperty value)? string,
    TResult Function(IntegerAssetProperty value)? integer,
    TResult Function(DoubleAssetProperty value)? double,
    TResult Function(BooleanAssetProperty value)? boolean,
    TResult Function(StringListAssetProperty value)? stringList,
    TResult Function(DateTimeAssetProperty value)? dateTime,
    TResult Function(MapAssetProperty value)? map,
    TResult Function(ObjectListAssetProperty value)? objectList,
    required TResult orElse(),
  }) {
    if (boolean != null) {
      return boolean(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$BooleanAssetPropertyImplToJson(
      this,
    );
  }
}

abstract class BooleanAssetProperty implements AssetPropertyValue {
  const factory BooleanAssetProperty(final bool value) =
      _$BooleanAssetPropertyImpl;

  factory BooleanAssetProperty.fromJson(Map<String, dynamic> json) =
      _$BooleanAssetPropertyImpl.fromJson;

  bool get value;
  @JsonKey(ignore: true)
  _$$BooleanAssetPropertyImplCopyWith<_$BooleanAssetPropertyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StringListAssetPropertyImplCopyWith<$Res> {
  factory _$$StringListAssetPropertyImplCopyWith(
          _$StringListAssetPropertyImpl value,
          $Res Function(_$StringListAssetPropertyImpl) then) =
      __$$StringListAssetPropertyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<String> values});
}

/// @nodoc
class __$$StringListAssetPropertyImplCopyWithImpl<$Res>
    extends _$AssetPropertyValueCopyWithImpl<$Res,
        _$StringListAssetPropertyImpl>
    implements _$$StringListAssetPropertyImplCopyWith<$Res> {
  __$$StringListAssetPropertyImplCopyWithImpl(
      _$StringListAssetPropertyImpl _value,
      $Res Function(_$StringListAssetPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? values = null,
  }) {
    return _then(_$StringListAssetPropertyImpl(
      null == values
          ? _value._values
          : values // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StringListAssetPropertyImpl implements StringListAssetProperty {
  const _$StringListAssetPropertyImpl(final List<String> values,
      {final String? $type})
      : _values = values,
        $type = $type ?? 'stringList';

  factory _$StringListAssetPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$StringListAssetPropertyImplFromJson(json);

  final List<String> _values;
  @override
  List<String> get values {
    if (_values is EqualUnmodifiableListView) return _values;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_values);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AssetPropertyValue.stringList(values: $values)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StringListAssetPropertyImpl &&
            const DeepCollectionEquality().equals(other._values, _values));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_values));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StringListAssetPropertyImplCopyWith<_$StringListAssetPropertyImpl>
      get copyWith => __$$StringListAssetPropertyImplCopyWithImpl<
          _$StringListAssetPropertyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(double value) double,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(DateTime value) dateTime,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) {
    return stringList(values);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(double value)? double,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(DateTime value)? dateTime,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) {
    return stringList?.call(values);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(double value)? double,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(DateTime value)? dateTime,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) {
    if (stringList != null) {
      return stringList(values);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringAssetProperty value) string,
    required TResult Function(IntegerAssetProperty value) integer,
    required TResult Function(DoubleAssetProperty value) double,
    required TResult Function(BooleanAssetProperty value) boolean,
    required TResult Function(StringListAssetProperty value) stringList,
    required TResult Function(DateTimeAssetProperty value) dateTime,
    required TResult Function(MapAssetProperty value) map,
    required TResult Function(ObjectListAssetProperty value) objectList,
  }) {
    return stringList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringAssetProperty value)? string,
    TResult? Function(IntegerAssetProperty value)? integer,
    TResult? Function(DoubleAssetProperty value)? double,
    TResult? Function(BooleanAssetProperty value)? boolean,
    TResult? Function(StringListAssetProperty value)? stringList,
    TResult? Function(DateTimeAssetProperty value)? dateTime,
    TResult? Function(MapAssetProperty value)? map,
    TResult? Function(ObjectListAssetProperty value)? objectList,
  }) {
    return stringList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringAssetProperty value)? string,
    TResult Function(IntegerAssetProperty value)? integer,
    TResult Function(DoubleAssetProperty value)? double,
    TResult Function(BooleanAssetProperty value)? boolean,
    TResult Function(StringListAssetProperty value)? stringList,
    TResult Function(DateTimeAssetProperty value)? dateTime,
    TResult Function(MapAssetProperty value)? map,
    TResult Function(ObjectListAssetProperty value)? objectList,
    required TResult orElse(),
  }) {
    if (stringList != null) {
      return stringList(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StringListAssetPropertyImplToJson(
      this,
    );
  }
}

abstract class StringListAssetProperty implements AssetPropertyValue {
  const factory StringListAssetProperty(final List<String> values) =
      _$StringListAssetPropertyImpl;

  factory StringListAssetProperty.fromJson(Map<String, dynamic> json) =
      _$StringListAssetPropertyImpl.fromJson;

  List<String> get values;
  @JsonKey(ignore: true)
  _$$StringListAssetPropertyImplCopyWith<_$StringListAssetPropertyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DateTimeAssetPropertyImplCopyWith<$Res> {
  factory _$$DateTimeAssetPropertyImplCopyWith(
          _$DateTimeAssetPropertyImpl value,
          $Res Function(_$DateTimeAssetPropertyImpl) then) =
      __$$DateTimeAssetPropertyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({DateTime value});
}

/// @nodoc
class __$$DateTimeAssetPropertyImplCopyWithImpl<$Res>
    extends _$AssetPropertyValueCopyWithImpl<$Res, _$DateTimeAssetPropertyImpl>
    implements _$$DateTimeAssetPropertyImplCopyWith<$Res> {
  __$$DateTimeAssetPropertyImplCopyWithImpl(_$DateTimeAssetPropertyImpl _value,
      $Res Function(_$DateTimeAssetPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$DateTimeAssetPropertyImpl(
      null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$DateTimeAssetPropertyImpl implements DateTimeAssetProperty {
  const _$DateTimeAssetPropertyImpl(this.value, {final String? $type})
      : $type = $type ?? 'dateTime';

  factory _$DateTimeAssetPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$DateTimeAssetPropertyImplFromJson(json);

  @override
  final DateTime value;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AssetPropertyValue.dateTime(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DateTimeAssetPropertyImpl &&
            (identical(other.value, value) || other.value == value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DateTimeAssetPropertyImplCopyWith<_$DateTimeAssetPropertyImpl>
      get copyWith => __$$DateTimeAssetPropertyImplCopyWithImpl<
          _$DateTimeAssetPropertyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(double value) double,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(DateTime value) dateTime,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) {
    return dateTime(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(double value)? double,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(DateTime value)? dateTime,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) {
    return dateTime?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(double value)? double,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(DateTime value)? dateTime,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) {
    if (dateTime != null) {
      return dateTime(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringAssetProperty value) string,
    required TResult Function(IntegerAssetProperty value) integer,
    required TResult Function(DoubleAssetProperty value) double,
    required TResult Function(BooleanAssetProperty value) boolean,
    required TResult Function(StringListAssetProperty value) stringList,
    required TResult Function(DateTimeAssetProperty value) dateTime,
    required TResult Function(MapAssetProperty value) map,
    required TResult Function(ObjectListAssetProperty value) objectList,
  }) {
    return dateTime(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringAssetProperty value)? string,
    TResult? Function(IntegerAssetProperty value)? integer,
    TResult? Function(DoubleAssetProperty value)? double,
    TResult? Function(BooleanAssetProperty value)? boolean,
    TResult? Function(StringListAssetProperty value)? stringList,
    TResult? Function(DateTimeAssetProperty value)? dateTime,
    TResult? Function(MapAssetProperty value)? map,
    TResult? Function(ObjectListAssetProperty value)? objectList,
  }) {
    return dateTime?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringAssetProperty value)? string,
    TResult Function(IntegerAssetProperty value)? integer,
    TResult Function(DoubleAssetProperty value)? double,
    TResult Function(BooleanAssetProperty value)? boolean,
    TResult Function(StringListAssetProperty value)? stringList,
    TResult Function(DateTimeAssetProperty value)? dateTime,
    TResult Function(MapAssetProperty value)? map,
    TResult Function(ObjectListAssetProperty value)? objectList,
    required TResult orElse(),
  }) {
    if (dateTime != null) {
      return dateTime(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$DateTimeAssetPropertyImplToJson(
      this,
    );
  }
}

abstract class DateTimeAssetProperty implements AssetPropertyValue {
  const factory DateTimeAssetProperty(final DateTime value) =
      _$DateTimeAssetPropertyImpl;

  factory DateTimeAssetProperty.fromJson(Map<String, dynamic> json) =
      _$DateTimeAssetPropertyImpl.fromJson;

  DateTime get value;
  @JsonKey(ignore: true)
  _$$DateTimeAssetPropertyImplCopyWith<_$DateTimeAssetPropertyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MapAssetPropertyImplCopyWith<$Res> {
  factory _$$MapAssetPropertyImplCopyWith(_$MapAssetPropertyImpl value,
          $Res Function(_$MapAssetPropertyImpl) then) =
      __$$MapAssetPropertyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Map<String, dynamic> value});
}

/// @nodoc
class __$$MapAssetPropertyImplCopyWithImpl<$Res>
    extends _$AssetPropertyValueCopyWithImpl<$Res, _$MapAssetPropertyImpl>
    implements _$$MapAssetPropertyImplCopyWith<$Res> {
  __$$MapAssetPropertyImplCopyWithImpl(_$MapAssetPropertyImpl _value,
      $Res Function(_$MapAssetPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? value = null,
  }) {
    return _then(_$MapAssetPropertyImpl(
      null == value
          ? _value._value
          : value // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MapAssetPropertyImpl implements MapAssetProperty {
  const _$MapAssetPropertyImpl(final Map<String, dynamic> value,
      {final String? $type})
      : _value = value,
        $type = $type ?? 'map';

  factory _$MapAssetPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$MapAssetPropertyImplFromJson(json);

  final Map<String, dynamic> _value;
  @override
  Map<String, dynamic> get value {
    if (_value is EqualUnmodifiableMapView) return _value;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_value);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AssetPropertyValue.map(value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MapAssetPropertyImpl &&
            const DeepCollectionEquality().equals(other._value, _value));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_value));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MapAssetPropertyImplCopyWith<_$MapAssetPropertyImpl> get copyWith =>
      __$$MapAssetPropertyImplCopyWithImpl<_$MapAssetPropertyImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(double value) double,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(DateTime value) dateTime,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) {
    return map(value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(double value)? double,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(DateTime value)? dateTime,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) {
    return map?.call(value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(double value)? double,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(DateTime value)? dateTime,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) {
    if (map != null) {
      return map(value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringAssetProperty value) string,
    required TResult Function(IntegerAssetProperty value) integer,
    required TResult Function(DoubleAssetProperty value) double,
    required TResult Function(BooleanAssetProperty value) boolean,
    required TResult Function(StringListAssetProperty value) stringList,
    required TResult Function(DateTimeAssetProperty value) dateTime,
    required TResult Function(MapAssetProperty value) map,
    required TResult Function(ObjectListAssetProperty value) objectList,
  }) {
    return map(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringAssetProperty value)? string,
    TResult? Function(IntegerAssetProperty value)? integer,
    TResult? Function(DoubleAssetProperty value)? double,
    TResult? Function(BooleanAssetProperty value)? boolean,
    TResult? Function(StringListAssetProperty value)? stringList,
    TResult? Function(DateTimeAssetProperty value)? dateTime,
    TResult? Function(MapAssetProperty value)? map,
    TResult? Function(ObjectListAssetProperty value)? objectList,
  }) {
    return map?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringAssetProperty value)? string,
    TResult Function(IntegerAssetProperty value)? integer,
    TResult Function(DoubleAssetProperty value)? double,
    TResult Function(BooleanAssetProperty value)? boolean,
    TResult Function(StringListAssetProperty value)? stringList,
    TResult Function(DateTimeAssetProperty value)? dateTime,
    TResult Function(MapAssetProperty value)? map,
    TResult Function(ObjectListAssetProperty value)? objectList,
    required TResult orElse(),
  }) {
    if (map != null) {
      return map(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$MapAssetPropertyImplToJson(
      this,
    );
  }
}

abstract class MapAssetProperty implements AssetPropertyValue {
  const factory MapAssetProperty(final Map<String, dynamic> value) =
      _$MapAssetPropertyImpl;

  factory MapAssetProperty.fromJson(Map<String, dynamic> json) =
      _$MapAssetPropertyImpl.fromJson;

  Map<String, dynamic> get value;
  @JsonKey(ignore: true)
  _$$MapAssetPropertyImplCopyWith<_$MapAssetPropertyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ObjectListAssetPropertyImplCopyWith<$Res> {
  factory _$$ObjectListAssetPropertyImplCopyWith(
          _$ObjectListAssetPropertyImpl value,
          $Res Function(_$ObjectListAssetPropertyImpl) then) =
      __$$ObjectListAssetPropertyImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<Map<String, dynamic>> objects});
}

/// @nodoc
class __$$ObjectListAssetPropertyImplCopyWithImpl<$Res>
    extends _$AssetPropertyValueCopyWithImpl<$Res,
        _$ObjectListAssetPropertyImpl>
    implements _$$ObjectListAssetPropertyImplCopyWith<$Res> {
  __$$ObjectListAssetPropertyImplCopyWithImpl(
      _$ObjectListAssetPropertyImpl _value,
      $Res Function(_$ObjectListAssetPropertyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? objects = null,
  }) {
    return _then(_$ObjectListAssetPropertyImpl(
      null == objects
          ? _value._objects
          : objects // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ObjectListAssetPropertyImpl implements ObjectListAssetProperty {
  const _$ObjectListAssetPropertyImpl(final List<Map<String, dynamic>> objects,
      {final String? $type})
      : _objects = objects,
        $type = $type ?? 'objectList';

  factory _$ObjectListAssetPropertyImpl.fromJson(Map<String, dynamic> json) =>
      _$$ObjectListAssetPropertyImplFromJson(json);

  final List<Map<String, dynamic>> _objects;
  @override
  List<Map<String, dynamic>> get objects {
    if (_objects is EqualUnmodifiableListView) return _objects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_objects);
  }

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'AssetPropertyValue.objectList(objects: $objects)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ObjectListAssetPropertyImpl &&
            const DeepCollectionEquality().equals(other._objects, _objects));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_objects));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ObjectListAssetPropertyImplCopyWith<_$ObjectListAssetPropertyImpl>
      get copyWith => __$$ObjectListAssetPropertyImplCopyWithImpl<
          _$ObjectListAssetPropertyImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String value) string,
    required TResult Function(int value) integer,
    required TResult Function(double value) double,
    required TResult Function(bool value) boolean,
    required TResult Function(List<String> values) stringList,
    required TResult Function(DateTime value) dateTime,
    required TResult Function(Map<String, dynamic> value) map,
    required TResult Function(List<Map<String, dynamic>> objects) objectList,
  }) {
    return objectList(objects);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String value)? string,
    TResult? Function(int value)? integer,
    TResult? Function(double value)? double,
    TResult? Function(bool value)? boolean,
    TResult? Function(List<String> values)? stringList,
    TResult? Function(DateTime value)? dateTime,
    TResult? Function(Map<String, dynamic> value)? map,
    TResult? Function(List<Map<String, dynamic>> objects)? objectList,
  }) {
    return objectList?.call(objects);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String value)? string,
    TResult Function(int value)? integer,
    TResult Function(double value)? double,
    TResult Function(bool value)? boolean,
    TResult Function(List<String> values)? stringList,
    TResult Function(DateTime value)? dateTime,
    TResult Function(Map<String, dynamic> value)? map,
    TResult Function(List<Map<String, dynamic>> objects)? objectList,
    required TResult orElse(),
  }) {
    if (objectList != null) {
      return objectList(objects);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(StringAssetProperty value) string,
    required TResult Function(IntegerAssetProperty value) integer,
    required TResult Function(DoubleAssetProperty value) double,
    required TResult Function(BooleanAssetProperty value) boolean,
    required TResult Function(StringListAssetProperty value) stringList,
    required TResult Function(DateTimeAssetProperty value) dateTime,
    required TResult Function(MapAssetProperty value) map,
    required TResult Function(ObjectListAssetProperty value) objectList,
  }) {
    return objectList(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(StringAssetProperty value)? string,
    TResult? Function(IntegerAssetProperty value)? integer,
    TResult? Function(DoubleAssetProperty value)? double,
    TResult? Function(BooleanAssetProperty value)? boolean,
    TResult? Function(StringListAssetProperty value)? stringList,
    TResult? Function(DateTimeAssetProperty value)? dateTime,
    TResult? Function(MapAssetProperty value)? map,
    TResult? Function(ObjectListAssetProperty value)? objectList,
  }) {
    return objectList?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(StringAssetProperty value)? string,
    TResult Function(IntegerAssetProperty value)? integer,
    TResult Function(DoubleAssetProperty value)? double,
    TResult Function(BooleanAssetProperty value)? boolean,
    TResult Function(StringListAssetProperty value)? stringList,
    TResult Function(DateTimeAssetProperty value)? dateTime,
    TResult Function(MapAssetProperty value)? map,
    TResult Function(ObjectListAssetProperty value)? objectList,
    required TResult orElse(),
  }) {
    if (objectList != null) {
      return objectList(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$ObjectListAssetPropertyImplToJson(
      this,
    );
  }
}

abstract class ObjectListAssetProperty implements AssetPropertyValue {
  const factory ObjectListAssetProperty(
      final List<Map<String, dynamic>> objects) = _$ObjectListAssetPropertyImpl;

  factory ObjectListAssetProperty.fromJson(Map<String, dynamic> json) =
      _$ObjectListAssetPropertyImpl.fromJson;

  List<Map<String, dynamic>> get objects;
  @JsonKey(ignore: true)
  _$$ObjectListAssetPropertyImplCopyWith<_$ObjectListAssetPropertyImpl>
      get copyWith => throw _privateConstructorUsedError;
}

Asset _$AssetFromJson(Map<String, dynamic> json) {
  return _Asset.fromJson(json);
}

/// @nodoc
mixin _$Asset {
  String get id => throw _privateConstructorUsedError;
  AssetType get type => throw _privateConstructorUsedError;
  String get projectId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description =>
      throw _privateConstructorUsedError; // Rich property system - contains all asset-specific data
  Map<String, AssetPropertyValue> get properties =>
      throw _privateConstructorUsedError; // Discovery and status
  AssetDiscoveryStatus get discoveryStatus =>
      throw _privateConstructorUsedError;
  DateTime get discoveredAt => throw _privateConstructorUsedError;
  DateTime? get lastUpdated => throw _privateConstructorUsedError;
  String? get discoveryMethod => throw _privateConstructorUsedError;
  double get confidence =>
      throw _privateConstructorUsedError; // Hierarchical relationships
  List<String> get parentAssetIds => throw _privateConstructorUsedError;
  List<String> get childAssetIds => throw _privateConstructorUsedError;
  List<String> get relatedAssetIds =>
      throw _privateConstructorUsedError; // Cross-references
// Methodology integration
  List<String> get completedTriggers => throw _privateConstructorUsedError;
  Map<String, TriggerExecutionResult> get triggerResults =>
      throw _privateConstructorUsedError; // Organization and filtering
  List<String> get tags => throw _privateConstructorUsedError;
  Map<String, String>? get metadata =>
      throw _privateConstructorUsedError; // Security context
  AccessLevel? get accessLevel => throw _privateConstructorUsedError;
  List<String>? get securityControls => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AssetCopyWith<Asset> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssetCopyWith<$Res> {
  factory $AssetCopyWith(Asset value, $Res Function(Asset) then) =
      _$AssetCopyWithImpl<$Res, Asset>;
  @useResult
  $Res call(
      {String id,
      AssetType type,
      String projectId,
      String name,
      String? description,
      Map<String, AssetPropertyValue> properties,
      AssetDiscoveryStatus discoveryStatus,
      DateTime discoveredAt,
      DateTime? lastUpdated,
      String? discoveryMethod,
      double confidence,
      List<String> parentAssetIds,
      List<String> childAssetIds,
      List<String> relatedAssetIds,
      List<String> completedTriggers,
      Map<String, TriggerExecutionResult> triggerResults,
      List<String> tags,
      Map<String, String>? metadata,
      AccessLevel? accessLevel,
      List<String>? securityControls});
}

/// @nodoc
class _$AssetCopyWithImpl<$Res, $Val extends Asset>
    implements $AssetCopyWith<$Res> {
  _$AssetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? projectId = null,
    Object? name = null,
    Object? description = freezed,
    Object? properties = null,
    Object? discoveryStatus = null,
    Object? discoveredAt = null,
    Object? lastUpdated = freezed,
    Object? discoveryMethod = freezed,
    Object? confidence = null,
    Object? parentAssetIds = null,
    Object? childAssetIds = null,
    Object? relatedAssetIds = null,
    Object? completedTriggers = null,
    Object? triggerResults = null,
    Object? tags = null,
    Object? metadata = freezed,
    Object? accessLevel = freezed,
    Object? securityControls = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AssetType,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      properties: null == properties
          ? _value.properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, AssetPropertyValue>,
      discoveryStatus: null == discoveryStatus
          ? _value.discoveryStatus
          : discoveryStatus // ignore: cast_nullable_to_non_nullable
              as AssetDiscoveryStatus,
      discoveredAt: null == discoveredAt
          ? _value.discoveredAt
          : discoveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      discoveryMethod: freezed == discoveryMethod
          ? _value.discoveryMethod
          : discoveryMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      parentAssetIds: null == parentAssetIds
          ? _value.parentAssetIds
          : parentAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      childAssetIds: null == childAssetIds
          ? _value.childAssetIds
          : childAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      relatedAssetIds: null == relatedAssetIds
          ? _value.relatedAssetIds
          : relatedAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedTriggers: null == completedTriggers
          ? _value.completedTriggers
          : completedTriggers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      triggerResults: null == triggerResults
          ? _value.triggerResults
          : triggerResults // ignore: cast_nullable_to_non_nullable
              as Map<String, TriggerExecutionResult>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      accessLevel: freezed == accessLevel
          ? _value.accessLevel
          : accessLevel // ignore: cast_nullable_to_non_nullable
              as AccessLevel?,
      securityControls: freezed == securityControls
          ? _value.securityControls
          : securityControls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AssetImplCopyWith<$Res> implements $AssetCopyWith<$Res> {
  factory _$$AssetImplCopyWith(
          _$AssetImpl value, $Res Function(_$AssetImpl) then) =
      __$$AssetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      AssetType type,
      String projectId,
      String name,
      String? description,
      Map<String, AssetPropertyValue> properties,
      AssetDiscoveryStatus discoveryStatus,
      DateTime discoveredAt,
      DateTime? lastUpdated,
      String? discoveryMethod,
      double confidence,
      List<String> parentAssetIds,
      List<String> childAssetIds,
      List<String> relatedAssetIds,
      List<String> completedTriggers,
      Map<String, TriggerExecutionResult> triggerResults,
      List<String> tags,
      Map<String, String>? metadata,
      AccessLevel? accessLevel,
      List<String>? securityControls});
}

/// @nodoc
class __$$AssetImplCopyWithImpl<$Res>
    extends _$AssetCopyWithImpl<$Res, _$AssetImpl>
    implements _$$AssetImplCopyWith<$Res> {
  __$$AssetImplCopyWithImpl(
      _$AssetImpl _value, $Res Function(_$AssetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? projectId = null,
    Object? name = null,
    Object? description = freezed,
    Object? properties = null,
    Object? discoveryStatus = null,
    Object? discoveredAt = null,
    Object? lastUpdated = freezed,
    Object? discoveryMethod = freezed,
    Object? confidence = null,
    Object? parentAssetIds = null,
    Object? childAssetIds = null,
    Object? relatedAssetIds = null,
    Object? completedTriggers = null,
    Object? triggerResults = null,
    Object? tags = null,
    Object? metadata = freezed,
    Object? accessLevel = freezed,
    Object? securityControls = freezed,
  }) {
    return _then(_$AssetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as AssetType,
      projectId: null == projectId
          ? _value.projectId
          : projectId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      properties: null == properties
          ? _value._properties
          : properties // ignore: cast_nullable_to_non_nullable
              as Map<String, AssetPropertyValue>,
      discoveryStatus: null == discoveryStatus
          ? _value.discoveryStatus
          : discoveryStatus // ignore: cast_nullable_to_non_nullable
              as AssetDiscoveryStatus,
      discoveredAt: null == discoveredAt
          ? _value.discoveredAt
          : discoveredAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      lastUpdated: freezed == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      discoveryMethod: freezed == discoveryMethod
          ? _value.discoveryMethod
          : discoveryMethod // ignore: cast_nullable_to_non_nullable
              as String?,
      confidence: null == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as double,
      parentAssetIds: null == parentAssetIds
          ? _value._parentAssetIds
          : parentAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      childAssetIds: null == childAssetIds
          ? _value._childAssetIds
          : childAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      relatedAssetIds: null == relatedAssetIds
          ? _value._relatedAssetIds
          : relatedAssetIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      completedTriggers: null == completedTriggers
          ? _value._completedTriggers
          : completedTriggers // ignore: cast_nullable_to_non_nullable
              as List<String>,
      triggerResults: null == triggerResults
          ? _value._triggerResults
          : triggerResults // ignore: cast_nullable_to_non_nullable
              as Map<String, TriggerExecutionResult>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      accessLevel: freezed == accessLevel
          ? _value.accessLevel
          : accessLevel // ignore: cast_nullable_to_non_nullable
              as AccessLevel?,
      securityControls: freezed == securityControls
          ? _value._securityControls
          : securityControls // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AssetImpl implements _Asset {
  const _$AssetImpl(
      {required this.id,
      required this.type,
      required this.projectId,
      required this.name,
      this.description,
      required final Map<String, AssetPropertyValue> properties,
      required this.discoveryStatus,
      required this.discoveredAt,
      this.lastUpdated,
      this.discoveryMethod,
      this.confidence = 1.0,
      required final List<String> parentAssetIds,
      required final List<String> childAssetIds,
      required final List<String> relatedAssetIds,
      required final List<String> completedTriggers,
      required final Map<String, TriggerExecutionResult> triggerResults,
      required final List<String> tags,
      final Map<String, String>? metadata,
      this.accessLevel,
      final List<String>? securityControls})
      : _properties = properties,
        _parentAssetIds = parentAssetIds,
        _childAssetIds = childAssetIds,
        _relatedAssetIds = relatedAssetIds,
        _completedTriggers = completedTriggers,
        _triggerResults = triggerResults,
        _tags = tags,
        _metadata = metadata,
        _securityControls = securityControls;

  factory _$AssetImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssetImplFromJson(json);

  @override
  final String id;
  @override
  final AssetType type;
  @override
  final String projectId;
  @override
  final String name;
  @override
  final String? description;
// Rich property system - contains all asset-specific data
  final Map<String, AssetPropertyValue> _properties;
// Rich property system - contains all asset-specific data
  @override
  Map<String, AssetPropertyValue> get properties {
    if (_properties is EqualUnmodifiableMapView) return _properties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_properties);
  }

// Discovery and status
  @override
  final AssetDiscoveryStatus discoveryStatus;
  @override
  final DateTime discoveredAt;
  @override
  final DateTime? lastUpdated;
  @override
  final String? discoveryMethod;
  @override
  @JsonKey()
  final double confidence;
// Hierarchical relationships
  final List<String> _parentAssetIds;
// Hierarchical relationships
  @override
  List<String> get parentAssetIds {
    if (_parentAssetIds is EqualUnmodifiableListView) return _parentAssetIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_parentAssetIds);
  }

  final List<String> _childAssetIds;
  @override
  List<String> get childAssetIds {
    if (_childAssetIds is EqualUnmodifiableListView) return _childAssetIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_childAssetIds);
  }

  final List<String> _relatedAssetIds;
  @override
  List<String> get relatedAssetIds {
    if (_relatedAssetIds is EqualUnmodifiableListView) return _relatedAssetIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_relatedAssetIds);
  }

// Cross-references
// Methodology integration
  final List<String> _completedTriggers;
// Cross-references
// Methodology integration
  @override
  List<String> get completedTriggers {
    if (_completedTriggers is EqualUnmodifiableListView)
      return _completedTriggers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completedTriggers);
  }

  final Map<String, TriggerExecutionResult> _triggerResults;
  @override
  Map<String, TriggerExecutionResult> get triggerResults {
    if (_triggerResults is EqualUnmodifiableMapView) return _triggerResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_triggerResults);
  }

// Organization and filtering
  final List<String> _tags;
// Organization and filtering
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  final Map<String, String>? _metadata;
  @override
  Map<String, String>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Security context
  @override
  final AccessLevel? accessLevel;
  final List<String>? _securityControls;
  @override
  List<String>? get securityControls {
    final value = _securityControls;
    if (value == null) return null;
    if (_securityControls is EqualUnmodifiableListView)
      return _securityControls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'Asset(id: $id, type: $type, projectId: $projectId, name: $name, description: $description, properties: $properties, discoveryStatus: $discoveryStatus, discoveredAt: $discoveredAt, lastUpdated: $lastUpdated, discoveryMethod: $discoveryMethod, confidence: $confidence, parentAssetIds: $parentAssetIds, childAssetIds: $childAssetIds, relatedAssetIds: $relatedAssetIds, completedTriggers: $completedTriggers, triggerResults: $triggerResults, tags: $tags, metadata: $metadata, accessLevel: $accessLevel, securityControls: $securityControls)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.projectId, projectId) ||
                other.projectId == projectId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._properties, _properties) &&
            (identical(other.discoveryStatus, discoveryStatus) ||
                other.discoveryStatus == discoveryStatus) &&
            (identical(other.discoveredAt, discoveredAt) ||
                other.discoveredAt == discoveredAt) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.discoveryMethod, discoveryMethod) ||
                other.discoveryMethod == discoveryMethod) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence) &&
            const DeepCollectionEquality()
                .equals(other._parentAssetIds, _parentAssetIds) &&
            const DeepCollectionEquality()
                .equals(other._childAssetIds, _childAssetIds) &&
            const DeepCollectionEquality()
                .equals(other._relatedAssetIds, _relatedAssetIds) &&
            const DeepCollectionEquality()
                .equals(other._completedTriggers, _completedTriggers) &&
            const DeepCollectionEquality()
                .equals(other._triggerResults, _triggerResults) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.accessLevel, accessLevel) ||
                other.accessLevel == accessLevel) &&
            const DeepCollectionEquality()
                .equals(other._securityControls, _securityControls));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        type,
        projectId,
        name,
        description,
        const DeepCollectionEquality().hash(_properties),
        discoveryStatus,
        discoveredAt,
        lastUpdated,
        discoveryMethod,
        confidence,
        const DeepCollectionEquality().hash(_parentAssetIds),
        const DeepCollectionEquality().hash(_childAssetIds),
        const DeepCollectionEquality().hash(_relatedAssetIds),
        const DeepCollectionEquality().hash(_completedTriggers),
        const DeepCollectionEquality().hash(_triggerResults),
        const DeepCollectionEquality().hash(_tags),
        const DeepCollectionEquality().hash(_metadata),
        accessLevel,
        const DeepCollectionEquality().hash(_securityControls)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AssetImplCopyWith<_$AssetImpl> get copyWith =>
      __$$AssetImplCopyWithImpl<_$AssetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AssetImplToJson(
      this,
    );
  }
}

abstract class _Asset implements Asset {
  const factory _Asset(
      {required final String id,
      required final AssetType type,
      required final String projectId,
      required final String name,
      final String? description,
      required final Map<String, AssetPropertyValue> properties,
      required final AssetDiscoveryStatus discoveryStatus,
      required final DateTime discoveredAt,
      final DateTime? lastUpdated,
      final String? discoveryMethod,
      final double confidence,
      required final List<String> parentAssetIds,
      required final List<String> childAssetIds,
      required final List<String> relatedAssetIds,
      required final List<String> completedTriggers,
      required final Map<String, TriggerExecutionResult> triggerResults,
      required final List<String> tags,
      final Map<String, String>? metadata,
      final AccessLevel? accessLevel,
      final List<String>? securityControls}) = _$AssetImpl;

  factory _Asset.fromJson(Map<String, dynamic> json) = _$AssetImpl.fromJson;

  @override
  String get id;
  @override
  AssetType get type;
  @override
  String get projectId;
  @override
  String get name;
  @override
  String? get description;
  @override // Rich property system - contains all asset-specific data
  Map<String, AssetPropertyValue> get properties;
  @override // Discovery and status
  AssetDiscoveryStatus get discoveryStatus;
  @override
  DateTime get discoveredAt;
  @override
  DateTime? get lastUpdated;
  @override
  String? get discoveryMethod;
  @override
  double get confidence;
  @override // Hierarchical relationships
  List<String> get parentAssetIds;
  @override
  List<String> get childAssetIds;
  @override
  List<String> get relatedAssetIds;
  @override // Cross-references
// Methodology integration
  List<String> get completedTriggers;
  @override
  Map<String, TriggerExecutionResult> get triggerResults;
  @override // Organization and filtering
  List<String> get tags;
  @override
  Map<String, String>? get metadata;
  @override // Security context
  AccessLevel? get accessLevel;
  @override
  List<String>? get securityControls;
  @override
  @JsonKey(ignore: true)
  _$$AssetImplCopyWith<_$AssetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TriggerExecutionResult _$TriggerExecutionResultFromJson(
    Map<String, dynamic> json) {
  return _TriggerExecutionResult.fromJson(json);
}

/// @nodoc
mixin _$TriggerExecutionResult {
  String get triggerId => throw _privateConstructorUsedError;
  String get methodologyId => throw _privateConstructorUsedError;
  DateTime get executedAt => throw _privateConstructorUsedError;
  bool get success => throw _privateConstructorUsedError;
  String? get output => throw _privateConstructorUsedError;
  String? get error => throw _privateConstructorUsedError;
  Map<String, AssetPropertyValue>? get discoveredProperties =>
      throw _privateConstructorUsedError;
  List<Asset>? get discoveredAssets => throw _privateConstructorUsedError;
  List<String>? get triggeredMethodologies =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TriggerExecutionResultCopyWith<TriggerExecutionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TriggerExecutionResultCopyWith<$Res> {
  factory $TriggerExecutionResultCopyWith(TriggerExecutionResult value,
          $Res Function(TriggerExecutionResult) then) =
      _$TriggerExecutionResultCopyWithImpl<$Res, TriggerExecutionResult>;
  @useResult
  $Res call(
      {String triggerId,
      String methodologyId,
      DateTime executedAt,
      bool success,
      String? output,
      String? error,
      Map<String, AssetPropertyValue>? discoveredProperties,
      List<Asset>? discoveredAssets,
      List<String>? triggeredMethodologies});
}

/// @nodoc
class _$TriggerExecutionResultCopyWithImpl<$Res,
        $Val extends TriggerExecutionResult>
    implements $TriggerExecutionResultCopyWith<$Res> {
  _$TriggerExecutionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? triggerId = null,
    Object? methodologyId = null,
    Object? executedAt = null,
    Object? success = null,
    Object? output = freezed,
    Object? error = freezed,
    Object? discoveredProperties = freezed,
    Object? discoveredAssets = freezed,
    Object? triggeredMethodologies = freezed,
  }) {
    return _then(_value.copyWith(
      triggerId: null == triggerId
          ? _value.triggerId
          : triggerId // ignore: cast_nullable_to_non_nullable
              as String,
      methodologyId: null == methodologyId
          ? _value.methodologyId
          : methodologyId // ignore: cast_nullable_to_non_nullable
              as String,
      executedAt: null == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      output: freezed == output
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      discoveredProperties: freezed == discoveredProperties
          ? _value.discoveredProperties
          : discoveredProperties // ignore: cast_nullable_to_non_nullable
              as Map<String, AssetPropertyValue>?,
      discoveredAssets: freezed == discoveredAssets
          ? _value.discoveredAssets
          : discoveredAssets // ignore: cast_nullable_to_non_nullable
              as List<Asset>?,
      triggeredMethodologies: freezed == triggeredMethodologies
          ? _value.triggeredMethodologies
          : triggeredMethodologies // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TriggerExecutionResultImplCopyWith<$Res>
    implements $TriggerExecutionResultCopyWith<$Res> {
  factory _$$TriggerExecutionResultImplCopyWith(
          _$TriggerExecutionResultImpl value,
          $Res Function(_$TriggerExecutionResultImpl) then) =
      __$$TriggerExecutionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String triggerId,
      String methodologyId,
      DateTime executedAt,
      bool success,
      String? output,
      String? error,
      Map<String, AssetPropertyValue>? discoveredProperties,
      List<Asset>? discoveredAssets,
      List<String>? triggeredMethodologies});
}

/// @nodoc
class __$$TriggerExecutionResultImplCopyWithImpl<$Res>
    extends _$TriggerExecutionResultCopyWithImpl<$Res,
        _$TriggerExecutionResultImpl>
    implements _$$TriggerExecutionResultImplCopyWith<$Res> {
  __$$TriggerExecutionResultImplCopyWithImpl(
      _$TriggerExecutionResultImpl _value,
      $Res Function(_$TriggerExecutionResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? triggerId = null,
    Object? methodologyId = null,
    Object? executedAt = null,
    Object? success = null,
    Object? output = freezed,
    Object? error = freezed,
    Object? discoveredProperties = freezed,
    Object? discoveredAssets = freezed,
    Object? triggeredMethodologies = freezed,
  }) {
    return _then(_$TriggerExecutionResultImpl(
      triggerId: null == triggerId
          ? _value.triggerId
          : triggerId // ignore: cast_nullable_to_non_nullable
              as String,
      methodologyId: null == methodologyId
          ? _value.methodologyId
          : methodologyId // ignore: cast_nullable_to_non_nullable
              as String,
      executedAt: null == executedAt
          ? _value.executedAt
          : executedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      success: null == success
          ? _value.success
          : success // ignore: cast_nullable_to_non_nullable
              as bool,
      output: freezed == output
          ? _value.output
          : output // ignore: cast_nullable_to_non_nullable
              as String?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as String?,
      discoveredProperties: freezed == discoveredProperties
          ? _value._discoveredProperties
          : discoveredProperties // ignore: cast_nullable_to_non_nullable
              as Map<String, AssetPropertyValue>?,
      discoveredAssets: freezed == discoveredAssets
          ? _value._discoveredAssets
          : discoveredAssets // ignore: cast_nullable_to_non_nullable
              as List<Asset>?,
      triggeredMethodologies: freezed == triggeredMethodologies
          ? _value._triggeredMethodologies
          : triggeredMethodologies // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TriggerExecutionResultImpl implements _TriggerExecutionResult {
  const _$TriggerExecutionResultImpl(
      {required this.triggerId,
      required this.methodologyId,
      required this.executedAt,
      required this.success,
      this.output,
      this.error,
      final Map<String, AssetPropertyValue>? discoveredProperties,
      final List<Asset>? discoveredAssets,
      final List<String>? triggeredMethodologies})
      : _discoveredProperties = discoveredProperties,
        _discoveredAssets = discoveredAssets,
        _triggeredMethodologies = triggeredMethodologies;

  factory _$TriggerExecutionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$TriggerExecutionResultImplFromJson(json);

  @override
  final String triggerId;
  @override
  final String methodologyId;
  @override
  final DateTime executedAt;
  @override
  final bool success;
  @override
  final String? output;
  @override
  final String? error;
  final Map<String, AssetPropertyValue>? _discoveredProperties;
  @override
  Map<String, AssetPropertyValue>? get discoveredProperties {
    final value = _discoveredProperties;
    if (value == null) return null;
    if (_discoveredProperties is EqualUnmodifiableMapView)
      return _discoveredProperties;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<Asset>? _discoveredAssets;
  @override
  List<Asset>? get discoveredAssets {
    final value = _discoveredAssets;
    if (value == null) return null;
    if (_discoveredAssets is EqualUnmodifiableListView)
      return _discoveredAssets;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _triggeredMethodologies;
  @override
  List<String>? get triggeredMethodologies {
    final value = _triggeredMethodologies;
    if (value == null) return null;
    if (_triggeredMethodologies is EqualUnmodifiableListView)
      return _triggeredMethodologies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'TriggerExecutionResult(triggerId: $triggerId, methodologyId: $methodologyId, executedAt: $executedAt, success: $success, output: $output, error: $error, discoveredProperties: $discoveredProperties, discoveredAssets: $discoveredAssets, triggeredMethodologies: $triggeredMethodologies)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggerExecutionResultImpl &&
            (identical(other.triggerId, triggerId) ||
                other.triggerId == triggerId) &&
            (identical(other.methodologyId, methodologyId) ||
                other.methodologyId == methodologyId) &&
            (identical(other.executedAt, executedAt) ||
                other.executedAt == executedAt) &&
            (identical(other.success, success) || other.success == success) &&
            (identical(other.output, output) || other.output == output) &&
            (identical(other.error, error) || other.error == error) &&
            const DeepCollectionEquality()
                .equals(other._discoveredProperties, _discoveredProperties) &&
            const DeepCollectionEquality()
                .equals(other._discoveredAssets, _discoveredAssets) &&
            const DeepCollectionEquality().equals(
                other._triggeredMethodologies, _triggeredMethodologies));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      triggerId,
      methodologyId,
      executedAt,
      success,
      output,
      error,
      const DeepCollectionEquality().hash(_discoveredProperties),
      const DeepCollectionEquality().hash(_discoveredAssets),
      const DeepCollectionEquality().hash(_triggeredMethodologies));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggerExecutionResultImplCopyWith<_$TriggerExecutionResultImpl>
      get copyWith => __$$TriggerExecutionResultImplCopyWithImpl<
          _$TriggerExecutionResultImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TriggerExecutionResultImplToJson(
      this,
    );
  }
}

abstract class _TriggerExecutionResult implements TriggerExecutionResult {
  const factory _TriggerExecutionResult(
          {required final String triggerId,
          required final String methodologyId,
          required final DateTime executedAt,
          required final bool success,
          final String? output,
          final String? error,
          final Map<String, AssetPropertyValue>? discoveredProperties,
          final List<Asset>? discoveredAssets,
          final List<String>? triggeredMethodologies}) =
      _$TriggerExecutionResultImpl;

  factory _TriggerExecutionResult.fromJson(Map<String, dynamic> json) =
      _$TriggerExecutionResultImpl.fromJson;

  @override
  String get triggerId;
  @override
  String get methodologyId;
  @override
  DateTime get executedAt;
  @override
  bool get success;
  @override
  String? get output;
  @override
  String? get error;
  @override
  Map<String, AssetPropertyValue>? get discoveredProperties;
  @override
  List<Asset>? get discoveredAssets;
  @override
  List<String>? get triggeredMethodologies;
  @override
  @JsonKey(ignore: true)
  _$$TriggerExecutionResultImplCopyWith<_$TriggerExecutionResultImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SoftwareVersion _$SoftwareVersionFromJson(Map<String, dynamic> json) {
  return _SoftwareVersion.fromJson(json);
}

/// @nodoc
mixin _$SoftwareVersion {
  int get major => throw _privateConstructorUsedError;
  int get minor => throw _privateConstructorUsedError;
  int get patch => throw _privateConstructorUsedError;
  String? get build => throw _privateConstructorUsedError;
  String? get edition => throw _privateConstructorUsedError;
  DateTime? get releaseDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SoftwareVersionCopyWith<SoftwareVersion> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SoftwareVersionCopyWith<$Res> {
  factory $SoftwareVersionCopyWith(
          SoftwareVersion value, $Res Function(SoftwareVersion) then) =
      _$SoftwareVersionCopyWithImpl<$Res, SoftwareVersion>;
  @useResult
  $Res call(
      {int major,
      int minor,
      int patch,
      String? build,
      String? edition,
      DateTime? releaseDate});
}

/// @nodoc
class _$SoftwareVersionCopyWithImpl<$Res, $Val extends SoftwareVersion>
    implements $SoftwareVersionCopyWith<$Res> {
  _$SoftwareVersionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? major = null,
    Object? minor = null,
    Object? patch = null,
    Object? build = freezed,
    Object? edition = freezed,
    Object? releaseDate = freezed,
  }) {
    return _then(_value.copyWith(
      major: null == major
          ? _value.major
          : major // ignore: cast_nullable_to_non_nullable
              as int,
      minor: null == minor
          ? _value.minor
          : minor // ignore: cast_nullable_to_non_nullable
              as int,
      patch: null == patch
          ? _value.patch
          : patch // ignore: cast_nullable_to_non_nullable
              as int,
      build: freezed == build
          ? _value.build
          : build // ignore: cast_nullable_to_non_nullable
              as String?,
      edition: freezed == edition
          ? _value.edition
          : edition // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SoftwareVersionImplCopyWith<$Res>
    implements $SoftwareVersionCopyWith<$Res> {
  factory _$$SoftwareVersionImplCopyWith(_$SoftwareVersionImpl value,
          $Res Function(_$SoftwareVersionImpl) then) =
      __$$SoftwareVersionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int major,
      int minor,
      int patch,
      String? build,
      String? edition,
      DateTime? releaseDate});
}

/// @nodoc
class __$$SoftwareVersionImplCopyWithImpl<$Res>
    extends _$SoftwareVersionCopyWithImpl<$Res, _$SoftwareVersionImpl>
    implements _$$SoftwareVersionImplCopyWith<$Res> {
  __$$SoftwareVersionImplCopyWithImpl(
      _$SoftwareVersionImpl _value, $Res Function(_$SoftwareVersionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? major = null,
    Object? minor = null,
    Object? patch = null,
    Object? build = freezed,
    Object? edition = freezed,
    Object? releaseDate = freezed,
  }) {
    return _then(_$SoftwareVersionImpl(
      major: null == major
          ? _value.major
          : major // ignore: cast_nullable_to_non_nullable
              as int,
      minor: null == minor
          ? _value.minor
          : minor // ignore: cast_nullable_to_non_nullable
              as int,
      patch: null == patch
          ? _value.patch
          : patch // ignore: cast_nullable_to_non_nullable
              as int,
      build: freezed == build
          ? _value.build
          : build // ignore: cast_nullable_to_non_nullable
              as String?,
      edition: freezed == edition
          ? _value.edition
          : edition // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SoftwareVersionImpl implements _SoftwareVersion {
  const _$SoftwareVersionImpl(
      {required this.major,
      required this.minor,
      required this.patch,
      this.build,
      this.edition,
      this.releaseDate});

  factory _$SoftwareVersionImpl.fromJson(Map<String, dynamic> json) =>
      _$$SoftwareVersionImplFromJson(json);

  @override
  final int major;
  @override
  final int minor;
  @override
  final int patch;
  @override
  final String? build;
  @override
  final String? edition;
  @override
  final DateTime? releaseDate;

  @override
  String toString() {
    return 'SoftwareVersion(major: $major, minor: $minor, patch: $patch, build: $build, edition: $edition, releaseDate: $releaseDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SoftwareVersionImpl &&
            (identical(other.major, major) || other.major == major) &&
            (identical(other.minor, minor) || other.minor == minor) &&
            (identical(other.patch, patch) || other.patch == patch) &&
            (identical(other.build, build) || other.build == build) &&
            (identical(other.edition, edition) || other.edition == edition) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, major, minor, patch, build, edition, releaseDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SoftwareVersionImplCopyWith<_$SoftwareVersionImpl> get copyWith =>
      __$$SoftwareVersionImplCopyWithImpl<_$SoftwareVersionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SoftwareVersionImplToJson(
      this,
    );
  }
}

abstract class _SoftwareVersion implements SoftwareVersion {
  const factory _SoftwareVersion(
      {required final int major,
      required final int minor,
      required final int patch,
      final String? build,
      final String? edition,
      final DateTime? releaseDate}) = _$SoftwareVersionImpl;

  factory _SoftwareVersion.fromJson(Map<String, dynamic> json) =
      _$SoftwareVersionImpl.fromJson;

  @override
  int get major;
  @override
  int get minor;
  @override
  int get patch;
  @override
  String? get build;
  @override
  String? get edition;
  @override
  DateTime? get releaseDate;
  @override
  @JsonKey(ignore: true)
  _$$SoftwareVersionImplCopyWith<_$SoftwareVersionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NetworkAddress _$NetworkAddressFromJson(Map<String, dynamic> json) {
  return _NetworkAddress.fromJson(json);
}

/// @nodoc
mixin _$NetworkAddress {
  String get ip => throw _privateConstructorUsedError;
  String? get subnet => throw _privateConstructorUsedError;
  String? get gateway => throw _privateConstructorUsedError;
  List<String>? get dnsServers => throw _privateConstructorUsedError;
  String? get macAddress => throw _privateConstructorUsedError;
  bool? get isStatic => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NetworkAddressCopyWith<NetworkAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkAddressCopyWith<$Res> {
  factory $NetworkAddressCopyWith(
          NetworkAddress value, $Res Function(NetworkAddress) then) =
      _$NetworkAddressCopyWithImpl<$Res, NetworkAddress>;
  @useResult
  $Res call(
      {String ip,
      String? subnet,
      String? gateway,
      List<String>? dnsServers,
      String? macAddress,
      bool? isStatic});
}

/// @nodoc
class _$NetworkAddressCopyWithImpl<$Res, $Val extends NetworkAddress>
    implements $NetworkAddressCopyWith<$Res> {
  _$NetworkAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = null,
    Object? subnet = freezed,
    Object? gateway = freezed,
    Object? dnsServers = freezed,
    Object? macAddress = freezed,
    Object? isStatic = freezed,
  }) {
    return _then(_value.copyWith(
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      subnet: freezed == subnet
          ? _value.subnet
          : subnet // ignore: cast_nullable_to_non_nullable
              as String?,
      gateway: freezed == gateway
          ? _value.gateway
          : gateway // ignore: cast_nullable_to_non_nullable
              as String?,
      dnsServers: freezed == dnsServers
          ? _value.dnsServers
          : dnsServers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      macAddress: freezed == macAddress
          ? _value.macAddress
          : macAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      isStatic: freezed == isStatic
          ? _value.isStatic
          : isStatic // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkAddressImplCopyWith<$Res>
    implements $NetworkAddressCopyWith<$Res> {
  factory _$$NetworkAddressImplCopyWith(_$NetworkAddressImpl value,
          $Res Function(_$NetworkAddressImpl) then) =
      __$$NetworkAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String ip,
      String? subnet,
      String? gateway,
      List<String>? dnsServers,
      String? macAddress,
      bool? isStatic});
}

/// @nodoc
class __$$NetworkAddressImplCopyWithImpl<$Res>
    extends _$NetworkAddressCopyWithImpl<$Res, _$NetworkAddressImpl>
    implements _$$NetworkAddressImplCopyWith<$Res> {
  __$$NetworkAddressImplCopyWithImpl(
      _$NetworkAddressImpl _value, $Res Function(_$NetworkAddressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? ip = null,
    Object? subnet = freezed,
    Object? gateway = freezed,
    Object? dnsServers = freezed,
    Object? macAddress = freezed,
    Object? isStatic = freezed,
  }) {
    return _then(_$NetworkAddressImpl(
      ip: null == ip
          ? _value.ip
          : ip // ignore: cast_nullable_to_non_nullable
              as String,
      subnet: freezed == subnet
          ? _value.subnet
          : subnet // ignore: cast_nullable_to_non_nullable
              as String?,
      gateway: freezed == gateway
          ? _value.gateway
          : gateway // ignore: cast_nullable_to_non_nullable
              as String?,
      dnsServers: freezed == dnsServers
          ? _value._dnsServers
          : dnsServers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      macAddress: freezed == macAddress
          ? _value.macAddress
          : macAddress // ignore: cast_nullable_to_non_nullable
              as String?,
      isStatic: freezed == isStatic
          ? _value.isStatic
          : isStatic // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NetworkAddressImpl implements _NetworkAddress {
  const _$NetworkAddressImpl(
      {required this.ip,
      this.subnet,
      this.gateway,
      final List<String>? dnsServers,
      this.macAddress,
      this.isStatic})
      : _dnsServers = dnsServers;

  factory _$NetworkAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetworkAddressImplFromJson(json);

  @override
  final String ip;
  @override
  final String? subnet;
  @override
  final String? gateway;
  final List<String>? _dnsServers;
  @override
  List<String>? get dnsServers {
    final value = _dnsServers;
    if (value == null) return null;
    if (_dnsServers is EqualUnmodifiableListView) return _dnsServers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? macAddress;
  @override
  final bool? isStatic;

  @override
  String toString() {
    return 'NetworkAddress(ip: $ip, subnet: $subnet, gateway: $gateway, dnsServers: $dnsServers, macAddress: $macAddress, isStatic: $isStatic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkAddressImpl &&
            (identical(other.ip, ip) || other.ip == ip) &&
            (identical(other.subnet, subnet) || other.subnet == subnet) &&
            (identical(other.gateway, gateway) || other.gateway == gateway) &&
            const DeepCollectionEquality()
                .equals(other._dnsServers, _dnsServers) &&
            (identical(other.macAddress, macAddress) ||
                other.macAddress == macAddress) &&
            (identical(other.isStatic, isStatic) ||
                other.isStatic == isStatic));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, ip, subnet, gateway,
      const DeepCollectionEquality().hash(_dnsServers), macAddress, isStatic);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkAddressImplCopyWith<_$NetworkAddressImpl> get copyWith =>
      __$$NetworkAddressImplCopyWithImpl<_$NetworkAddressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NetworkAddressImplToJson(
      this,
    );
  }
}

abstract class _NetworkAddress implements NetworkAddress {
  const factory _NetworkAddress(
      {required final String ip,
      final String? subnet,
      final String? gateway,
      final List<String>? dnsServers,
      final String? macAddress,
      final bool? isStatic}) = _$NetworkAddressImpl;

  factory _NetworkAddress.fromJson(Map<String, dynamic> json) =
      _$NetworkAddressImpl.fromJson;

  @override
  String get ip;
  @override
  String? get subnet;
  @override
  String? get gateway;
  @override
  List<String>? get dnsServers;
  @override
  String? get macAddress;
  @override
  bool? get isStatic;
  @override
  @JsonKey(ignore: true)
  _$$NetworkAddressImplCopyWith<_$NetworkAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PhysicalLocation _$PhysicalLocationFromJson(Map<String, dynamic> json) {
  return _PhysicalLocation.fromJson(json);
}

/// @nodoc
mixin _$PhysicalLocation {
  String? get address => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  String? get postalCode => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get building => throw _privateConstructorUsedError;
  String? get floor => throw _privateConstructorUsedError;
  String? get room => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PhysicalLocationCopyWith<PhysicalLocation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhysicalLocationCopyWith<$Res> {
  factory $PhysicalLocationCopyWith(
          PhysicalLocation value, $Res Function(PhysicalLocation) then) =
      _$PhysicalLocationCopyWithImpl<$Res, PhysicalLocation>;
  @useResult
  $Res call(
      {String? address,
      String? city,
      String? state,
      String? country,
      String? postalCode,
      double? latitude,
      double? longitude,
      String? building,
      String? floor,
      String? room});
}

/// @nodoc
class _$PhysicalLocationCopyWithImpl<$Res, $Val extends PhysicalLocation>
    implements $PhysicalLocationCopyWith<$Res> {
  _$PhysicalLocationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? country = freezed,
    Object? postalCode = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? building = freezed,
    Object? floor = freezed,
    Object? room = freezed,
  }) {
    return _then(_value.copyWith(
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      building: freezed == building
          ? _value.building
          : building // ignore: cast_nullable_to_non_nullable
              as String?,
      floor: freezed == floor
          ? _value.floor
          : floor // ignore: cast_nullable_to_non_nullable
              as String?,
      room: freezed == room
          ? _value.room
          : room // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PhysicalLocationImplCopyWith<$Res>
    implements $PhysicalLocationCopyWith<$Res> {
  factory _$$PhysicalLocationImplCopyWith(_$PhysicalLocationImpl value,
          $Res Function(_$PhysicalLocationImpl) then) =
      __$$PhysicalLocationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? address,
      String? city,
      String? state,
      String? country,
      String? postalCode,
      double? latitude,
      double? longitude,
      String? building,
      String? floor,
      String? room});
}

/// @nodoc
class __$$PhysicalLocationImplCopyWithImpl<$Res>
    extends _$PhysicalLocationCopyWithImpl<$Res, _$PhysicalLocationImpl>
    implements _$$PhysicalLocationImplCopyWith<$Res> {
  __$$PhysicalLocationImplCopyWithImpl(_$PhysicalLocationImpl _value,
      $Res Function(_$PhysicalLocationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? address = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? country = freezed,
    Object? postalCode = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? building = freezed,
    Object? floor = freezed,
    Object? room = freezed,
  }) {
    return _then(_$PhysicalLocationImpl(
      address: freezed == address
          ? _value.address
          : address // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      building: freezed == building
          ? _value.building
          : building // ignore: cast_nullable_to_non_nullable
              as String?,
      floor: freezed == floor
          ? _value.floor
          : floor // ignore: cast_nullable_to_non_nullable
              as String?,
      room: freezed == room
          ? _value.room
          : room // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PhysicalLocationImpl implements _PhysicalLocation {
  const _$PhysicalLocationImpl(
      {this.address,
      this.city,
      this.state,
      this.country,
      this.postalCode,
      this.latitude,
      this.longitude,
      this.building,
      this.floor,
      this.room});

  factory _$PhysicalLocationImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhysicalLocationImplFromJson(json);

  @override
  final String? address;
  @override
  final String? city;
  @override
  final String? state;
  @override
  final String? country;
  @override
  final String? postalCode;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? building;
  @override
  final String? floor;
  @override
  final String? room;

  @override
  String toString() {
    return 'PhysicalLocation(address: $address, city: $city, state: $state, country: $country, postalCode: $postalCode, latitude: $latitude, longitude: $longitude, building: $building, floor: $floor, room: $room)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhysicalLocationImpl &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.building, building) ||
                other.building == building) &&
            (identical(other.floor, floor) || other.floor == floor) &&
            (identical(other.room, room) || other.room == room));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, address, city, state, country,
      postalCode, latitude, longitude, building, floor, room);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PhysicalLocationImplCopyWith<_$PhysicalLocationImpl> get copyWith =>
      __$$PhysicalLocationImplCopyWithImpl<_$PhysicalLocationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PhysicalLocationImplToJson(
      this,
    );
  }
}

abstract class _PhysicalLocation implements PhysicalLocation {
  const factory _PhysicalLocation(
      {final String? address,
      final String? city,
      final String? state,
      final String? country,
      final String? postalCode,
      final double? latitude,
      final double? longitude,
      final String? building,
      final String? floor,
      final String? room}) = _$PhysicalLocationImpl;

  factory _PhysicalLocation.fromJson(Map<String, dynamic> json) =
      _$PhysicalLocationImpl.fromJson;

  @override
  String? get address;
  @override
  String? get city;
  @override
  String? get state;
  @override
  String? get country;
  @override
  String? get postalCode;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get building;
  @override
  String? get floor;
  @override
  String? get room;
  @override
  @JsonKey(ignore: true)
  _$$PhysicalLocationImplCopyWith<_$PhysicalLocationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NetworkInterface _$NetworkInterfaceFromJson(Map<String, dynamic> json) {
  return _NetworkInterface.fromJson(json);
}

/// @nodoc
mixin _$NetworkInterface {
  String get id => throw _privateConstructorUsedError;
  String get name =>
      throw _privateConstructorUsedError; // "eth0", "Ethernet", "Wi-Fi"
  String get type =>
      throw _privateConstructorUsedError; // "ethernet", "wireless", "loopback", "virtual"
  String get macAddress => throw _privateConstructorUsedError;
  bool get isEnabled => throw _privateConstructorUsedError;
  List<NetworkAddress> get addresses => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  String? get vendor => throw _privateConstructorUsedError;
  String? get driver => throw _privateConstructorUsedError;
  int? get speedMbps => throw _privateConstructorUsedError;
  bool? get isConnected => throw _privateConstructorUsedError;
  String? get connectedSwitchPort => throw _privateConstructorUsedError;
  String? get vlanId => throw _privateConstructorUsedError;
  Map<String, String>? get driverInfo => throw _privateConstructorUsedError;
  DateTime? get lastSeen => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NetworkInterfaceCopyWith<NetworkInterface> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NetworkInterfaceCopyWith<$Res> {
  factory $NetworkInterfaceCopyWith(
          NetworkInterface value, $Res Function(NetworkInterface) then) =
      _$NetworkInterfaceCopyWithImpl<$Res, NetworkInterface>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String macAddress,
      bool isEnabled,
      List<NetworkAddress> addresses,
      String? description,
      String? vendor,
      String? driver,
      int? speedMbps,
      bool? isConnected,
      String? connectedSwitchPort,
      String? vlanId,
      Map<String, String>? driverInfo,
      DateTime? lastSeen});
}

/// @nodoc
class _$NetworkInterfaceCopyWithImpl<$Res, $Val extends NetworkInterface>
    implements $NetworkInterfaceCopyWith<$Res> {
  _$NetworkInterfaceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? macAddress = null,
    Object? isEnabled = null,
    Object? addresses = null,
    Object? description = freezed,
    Object? vendor = freezed,
    Object? driver = freezed,
    Object? speedMbps = freezed,
    Object? isConnected = freezed,
    Object? connectedSwitchPort = freezed,
    Object? vlanId = freezed,
    Object? driverInfo = freezed,
    Object? lastSeen = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      macAddress: null == macAddress
          ? _value.macAddress
          : macAddress // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      addresses: null == addresses
          ? _value.addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<NetworkAddress>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      vendor: freezed == vendor
          ? _value.vendor
          : vendor // ignore: cast_nullable_to_non_nullable
              as String?,
      driver: freezed == driver
          ? _value.driver
          : driver // ignore: cast_nullable_to_non_nullable
              as String?,
      speedMbps: freezed == speedMbps
          ? _value.speedMbps
          : speedMbps // ignore: cast_nullable_to_non_nullable
              as int?,
      isConnected: freezed == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool?,
      connectedSwitchPort: freezed == connectedSwitchPort
          ? _value.connectedSwitchPort
          : connectedSwitchPort // ignore: cast_nullable_to_non_nullable
              as String?,
      vlanId: freezed == vlanId
          ? _value.vlanId
          : vlanId // ignore: cast_nullable_to_non_nullable
              as String?,
      driverInfo: freezed == driverInfo
          ? _value.driverInfo
          : driverInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkInterfaceImplCopyWith<$Res>
    implements $NetworkInterfaceCopyWith<$Res> {
  factory _$$NetworkInterfaceImplCopyWith(_$NetworkInterfaceImpl value,
          $Res Function(_$NetworkInterfaceImpl) then) =
      __$$NetworkInterfaceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String macAddress,
      bool isEnabled,
      List<NetworkAddress> addresses,
      String? description,
      String? vendor,
      String? driver,
      int? speedMbps,
      bool? isConnected,
      String? connectedSwitchPort,
      String? vlanId,
      Map<String, String>? driverInfo,
      DateTime? lastSeen});
}

/// @nodoc
class __$$NetworkInterfaceImplCopyWithImpl<$Res>
    extends _$NetworkInterfaceCopyWithImpl<$Res, _$NetworkInterfaceImpl>
    implements _$$NetworkInterfaceImplCopyWith<$Res> {
  __$$NetworkInterfaceImplCopyWithImpl(_$NetworkInterfaceImpl _value,
      $Res Function(_$NetworkInterfaceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? macAddress = null,
    Object? isEnabled = null,
    Object? addresses = null,
    Object? description = freezed,
    Object? vendor = freezed,
    Object? driver = freezed,
    Object? speedMbps = freezed,
    Object? isConnected = freezed,
    Object? connectedSwitchPort = freezed,
    Object? vlanId = freezed,
    Object? driverInfo = freezed,
    Object? lastSeen = freezed,
  }) {
    return _then(_$NetworkInterfaceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      macAddress: null == macAddress
          ? _value.macAddress
          : macAddress // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      addresses: null == addresses
          ? _value._addresses
          : addresses // ignore: cast_nullable_to_non_nullable
              as List<NetworkAddress>,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      vendor: freezed == vendor
          ? _value.vendor
          : vendor // ignore: cast_nullable_to_non_nullable
              as String?,
      driver: freezed == driver
          ? _value.driver
          : driver // ignore: cast_nullable_to_non_nullable
              as String?,
      speedMbps: freezed == speedMbps
          ? _value.speedMbps
          : speedMbps // ignore: cast_nullable_to_non_nullable
              as int?,
      isConnected: freezed == isConnected
          ? _value.isConnected
          : isConnected // ignore: cast_nullable_to_non_nullable
              as bool?,
      connectedSwitchPort: freezed == connectedSwitchPort
          ? _value.connectedSwitchPort
          : connectedSwitchPort // ignore: cast_nullable_to_non_nullable
              as String?,
      vlanId: freezed == vlanId
          ? _value.vlanId
          : vlanId // ignore: cast_nullable_to_non_nullable
              as String?,
      driverInfo: freezed == driverInfo
          ? _value._driverInfo
          : driverInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      lastSeen: freezed == lastSeen
          ? _value.lastSeen
          : lastSeen // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$NetworkInterfaceImpl implements _NetworkInterface {
  const _$NetworkInterfaceImpl(
      {required this.id,
      required this.name,
      required this.type,
      required this.macAddress,
      required this.isEnabled,
      required final List<NetworkAddress> addresses,
      this.description,
      this.vendor,
      this.driver,
      this.speedMbps,
      this.isConnected,
      this.connectedSwitchPort,
      this.vlanId,
      final Map<String, String>? driverInfo,
      this.lastSeen})
      : _addresses = addresses,
        _driverInfo = driverInfo;

  factory _$NetworkInterfaceImpl.fromJson(Map<String, dynamic> json) =>
      _$$NetworkInterfaceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
// "eth0", "Ethernet", "Wi-Fi"
  @override
  final String type;
// "ethernet", "wireless", "loopback", "virtual"
  @override
  final String macAddress;
  @override
  final bool isEnabled;
  final List<NetworkAddress> _addresses;
  @override
  List<NetworkAddress> get addresses {
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_addresses);
  }

  @override
  final String? description;
  @override
  final String? vendor;
  @override
  final String? driver;
  @override
  final int? speedMbps;
  @override
  final bool? isConnected;
  @override
  final String? connectedSwitchPort;
  @override
  final String? vlanId;
  final Map<String, String>? _driverInfo;
  @override
  Map<String, String>? get driverInfo {
    final value = _driverInfo;
    if (value == null) return null;
    if (_driverInfo is EqualUnmodifiableMapView) return _driverInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? lastSeen;

  @override
  String toString() {
    return 'NetworkInterface(id: $id, name: $name, type: $type, macAddress: $macAddress, isEnabled: $isEnabled, addresses: $addresses, description: $description, vendor: $vendor, driver: $driver, speedMbps: $speedMbps, isConnected: $isConnected, connectedSwitchPort: $connectedSwitchPort, vlanId: $vlanId, driverInfo: $driverInfo, lastSeen: $lastSeen)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkInterfaceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.macAddress, macAddress) ||
                other.macAddress == macAddress) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            const DeepCollectionEquality()
                .equals(other._addresses, _addresses) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.vendor, vendor) || other.vendor == vendor) &&
            (identical(other.driver, driver) || other.driver == driver) &&
            (identical(other.speedMbps, speedMbps) ||
                other.speedMbps == speedMbps) &&
            (identical(other.isConnected, isConnected) ||
                other.isConnected == isConnected) &&
            (identical(other.connectedSwitchPort, connectedSwitchPort) ||
                other.connectedSwitchPort == connectedSwitchPort) &&
            (identical(other.vlanId, vlanId) || other.vlanId == vlanId) &&
            const DeepCollectionEquality()
                .equals(other._driverInfo, _driverInfo) &&
            (identical(other.lastSeen, lastSeen) ||
                other.lastSeen == lastSeen));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      type,
      macAddress,
      isEnabled,
      const DeepCollectionEquality().hash(_addresses),
      description,
      vendor,
      driver,
      speedMbps,
      isConnected,
      connectedSwitchPort,
      vlanId,
      const DeepCollectionEquality().hash(_driverInfo),
      lastSeen);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkInterfaceImplCopyWith<_$NetworkInterfaceImpl> get copyWith =>
      __$$NetworkInterfaceImplCopyWithImpl<_$NetworkInterfaceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NetworkInterfaceImplToJson(
      this,
    );
  }
}

abstract class _NetworkInterface implements NetworkInterface {
  const factory _NetworkInterface(
      {required final String id,
      required final String name,
      required final String type,
      required final String macAddress,
      required final bool isEnabled,
      required final List<NetworkAddress> addresses,
      final String? description,
      final String? vendor,
      final String? driver,
      final int? speedMbps,
      final bool? isConnected,
      final String? connectedSwitchPort,
      final String? vlanId,
      final Map<String, String>? driverInfo,
      final DateTime? lastSeen}) = _$NetworkInterfaceImpl;

  factory _NetworkInterface.fromJson(Map<String, dynamic> json) =
      _$NetworkInterfaceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override // "eth0", "Ethernet", "Wi-Fi"
  String get type;
  @override // "ethernet", "wireless", "loopback", "virtual"
  String get macAddress;
  @override
  bool get isEnabled;
  @override
  List<NetworkAddress> get addresses;
  @override
  String? get description;
  @override
  String? get vendor;
  @override
  String? get driver;
  @override
  int? get speedMbps;
  @override
  bool? get isConnected;
  @override
  String? get connectedSwitchPort;
  @override
  String? get vlanId;
  @override
  Map<String, String>? get driverInfo;
  @override
  DateTime? get lastSeen;
  @override
  @JsonKey(ignore: true)
  _$$NetworkInterfaceImplCopyWith<_$NetworkInterfaceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HostService _$HostServiceFromJson(Map<String, dynamic> json) {
  return _HostService.fromJson(json);
}

/// @nodoc
mixin _$HostService {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get port => throw _privateConstructorUsedError;
  String get protocol => throw _privateConstructorUsedError; // "tcp", "udp"
  String get state =>
      throw _privateConstructorUsedError; // "open", "filtered", "closed"
  String? get version => throw _privateConstructorUsedError;
  String? get banner => throw _privateConstructorUsedError;
  String? get productName => throw _privateConstructorUsedError;
  String? get productVersion => throw _privateConstructorUsedError;
  Map<String, String>? get extraInfo => throw _privateConstructorUsedError;
  List<String>? get vulnerabilities => throw _privateConstructorUsedError;
  bool? get requiresAuthentication => throw _privateConstructorUsedError;
  List<String>? get authenticationMethods => throw _privateConstructorUsedError;
  String? get sslVersion => throw _privateConstructorUsedError;
  List<String>? get sslCiphers => throw _privateConstructorUsedError;
  DateTime? get lastChecked => throw _privateConstructorUsedError;
  String? get confidence => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HostServiceCopyWith<HostService> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HostServiceCopyWith<$Res> {
  factory $HostServiceCopyWith(
          HostService value, $Res Function(HostService) then) =
      _$HostServiceCopyWithImpl<$Res, HostService>;
  @useResult
  $Res call(
      {String id,
      String name,
      int port,
      String protocol,
      String state,
      String? version,
      String? banner,
      String? productName,
      String? productVersion,
      Map<String, String>? extraInfo,
      List<String>? vulnerabilities,
      bool? requiresAuthentication,
      List<String>? authenticationMethods,
      String? sslVersion,
      List<String>? sslCiphers,
      DateTime? lastChecked,
      String? confidence});
}

/// @nodoc
class _$HostServiceCopyWithImpl<$Res, $Val extends HostService>
    implements $HostServiceCopyWith<$Res> {
  _$HostServiceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? port = null,
    Object? protocol = null,
    Object? state = null,
    Object? version = freezed,
    Object? banner = freezed,
    Object? productName = freezed,
    Object? productVersion = freezed,
    Object? extraInfo = freezed,
    Object? vulnerabilities = freezed,
    Object? requiresAuthentication = freezed,
    Object? authenticationMethods = freezed,
    Object? sslVersion = freezed,
    Object? sslCiphers = freezed,
    Object? lastChecked = freezed,
    Object? confidence = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      protocol: null == protocol
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      productVersion: freezed == productVersion
          ? _value.productVersion
          : productVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      extraInfo: freezed == extraInfo
          ? _value.extraInfo
          : extraInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      vulnerabilities: freezed == vulnerabilities
          ? _value.vulnerabilities
          : vulnerabilities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      requiresAuthentication: freezed == requiresAuthentication
          ? _value.requiresAuthentication
          : requiresAuthentication // ignore: cast_nullable_to_non_nullable
              as bool?,
      authenticationMethods: freezed == authenticationMethods
          ? _value.authenticationMethods
          : authenticationMethods // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      sslVersion: freezed == sslVersion
          ? _value.sslVersion
          : sslVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      sslCiphers: freezed == sslCiphers
          ? _value.sslCiphers
          : sslCiphers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastChecked: freezed == lastChecked
          ? _value.lastChecked
          : lastChecked // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HostServiceImplCopyWith<$Res>
    implements $HostServiceCopyWith<$Res> {
  factory _$$HostServiceImplCopyWith(
          _$HostServiceImpl value, $Res Function(_$HostServiceImpl) then) =
      __$$HostServiceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      int port,
      String protocol,
      String state,
      String? version,
      String? banner,
      String? productName,
      String? productVersion,
      Map<String, String>? extraInfo,
      List<String>? vulnerabilities,
      bool? requiresAuthentication,
      List<String>? authenticationMethods,
      String? sslVersion,
      List<String>? sslCiphers,
      DateTime? lastChecked,
      String? confidence});
}

/// @nodoc
class __$$HostServiceImplCopyWithImpl<$Res>
    extends _$HostServiceCopyWithImpl<$Res, _$HostServiceImpl>
    implements _$$HostServiceImplCopyWith<$Res> {
  __$$HostServiceImplCopyWithImpl(
      _$HostServiceImpl _value, $Res Function(_$HostServiceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? port = null,
    Object? protocol = null,
    Object? state = null,
    Object? version = freezed,
    Object? banner = freezed,
    Object? productName = freezed,
    Object? productVersion = freezed,
    Object? extraInfo = freezed,
    Object? vulnerabilities = freezed,
    Object? requiresAuthentication = freezed,
    Object? authenticationMethods = freezed,
    Object? sslVersion = freezed,
    Object? sslCiphers = freezed,
    Object? lastChecked = freezed,
    Object? confidence = freezed,
  }) {
    return _then(_$HostServiceImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      port: null == port
          ? _value.port
          : port // ignore: cast_nullable_to_non_nullable
              as int,
      protocol: null == protocol
          ? _value.protocol
          : protocol // ignore: cast_nullable_to_non_nullable
              as String,
      state: null == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String?,
      productName: freezed == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String?,
      productVersion: freezed == productVersion
          ? _value.productVersion
          : productVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      extraInfo: freezed == extraInfo
          ? _value._extraInfo
          : extraInfo // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      vulnerabilities: freezed == vulnerabilities
          ? _value._vulnerabilities
          : vulnerabilities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      requiresAuthentication: freezed == requiresAuthentication
          ? _value.requiresAuthentication
          : requiresAuthentication // ignore: cast_nullable_to_non_nullable
              as bool?,
      authenticationMethods: freezed == authenticationMethods
          ? _value._authenticationMethods
          : authenticationMethods // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      sslVersion: freezed == sslVersion
          ? _value.sslVersion
          : sslVersion // ignore: cast_nullable_to_non_nullable
              as String?,
      sslCiphers: freezed == sslCiphers
          ? _value._sslCiphers
          : sslCiphers // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastChecked: freezed == lastChecked
          ? _value.lastChecked
          : lastChecked // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      confidence: freezed == confidence
          ? _value.confidence
          : confidence // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HostServiceImpl implements _HostService {
  const _$HostServiceImpl(
      {required this.id,
      required this.name,
      required this.port,
      required this.protocol,
      required this.state,
      this.version,
      this.banner,
      this.productName,
      this.productVersion,
      final Map<String, String>? extraInfo,
      final List<String>? vulnerabilities,
      this.requiresAuthentication,
      final List<String>? authenticationMethods,
      this.sslVersion,
      final List<String>? sslCiphers,
      this.lastChecked,
      this.confidence})
      : _extraInfo = extraInfo,
        _vulnerabilities = vulnerabilities,
        _authenticationMethods = authenticationMethods,
        _sslCiphers = sslCiphers;

  factory _$HostServiceImpl.fromJson(Map<String, dynamic> json) =>
      _$$HostServiceImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int port;
  @override
  final String protocol;
// "tcp", "udp"
  @override
  final String state;
// "open", "filtered", "closed"
  @override
  final String? version;
  @override
  final String? banner;
  @override
  final String? productName;
  @override
  final String? productVersion;
  final Map<String, String>? _extraInfo;
  @override
  Map<String, String>? get extraInfo {
    final value = _extraInfo;
    if (value == null) return null;
    if (_extraInfo is EqualUnmodifiableMapView) return _extraInfo;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String>? _vulnerabilities;
  @override
  List<String>? get vulnerabilities {
    final value = _vulnerabilities;
    if (value == null) return null;
    if (_vulnerabilities is EqualUnmodifiableListView) return _vulnerabilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? requiresAuthentication;
  final List<String>? _authenticationMethods;
  @override
  List<String>? get authenticationMethods {
    final value = _authenticationMethods;
    if (value == null) return null;
    if (_authenticationMethods is EqualUnmodifiableListView)
      return _authenticationMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? sslVersion;
  final List<String>? _sslCiphers;
  @override
  List<String>? get sslCiphers {
    final value = _sslCiphers;
    if (value == null) return null;
    if (_sslCiphers is EqualUnmodifiableListView) return _sslCiphers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? lastChecked;
  @override
  final String? confidence;

  @override
  String toString() {
    return 'HostService(id: $id, name: $name, port: $port, protocol: $protocol, state: $state, version: $version, banner: $banner, productName: $productName, productVersion: $productVersion, extraInfo: $extraInfo, vulnerabilities: $vulnerabilities, requiresAuthentication: $requiresAuthentication, authenticationMethods: $authenticationMethods, sslVersion: $sslVersion, sslCiphers: $sslCiphers, lastChecked: $lastChecked, confidence: $confidence)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HostServiceImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.port, port) || other.port == port) &&
            (identical(other.protocol, protocol) ||
                other.protocol == protocol) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.banner, banner) || other.banner == banner) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.productVersion, productVersion) ||
                other.productVersion == productVersion) &&
            const DeepCollectionEquality()
                .equals(other._extraInfo, _extraInfo) &&
            const DeepCollectionEquality()
                .equals(other._vulnerabilities, _vulnerabilities) &&
            (identical(other.requiresAuthentication, requiresAuthentication) ||
                other.requiresAuthentication == requiresAuthentication) &&
            const DeepCollectionEquality()
                .equals(other._authenticationMethods, _authenticationMethods) &&
            (identical(other.sslVersion, sslVersion) ||
                other.sslVersion == sslVersion) &&
            const DeepCollectionEquality()
                .equals(other._sslCiphers, _sslCiphers) &&
            (identical(other.lastChecked, lastChecked) ||
                other.lastChecked == lastChecked) &&
            (identical(other.confidence, confidence) ||
                other.confidence == confidence));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      port,
      protocol,
      state,
      version,
      banner,
      productName,
      productVersion,
      const DeepCollectionEquality().hash(_extraInfo),
      const DeepCollectionEquality().hash(_vulnerabilities),
      requiresAuthentication,
      const DeepCollectionEquality().hash(_authenticationMethods),
      sslVersion,
      const DeepCollectionEquality().hash(_sslCiphers),
      lastChecked,
      confidence);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HostServiceImplCopyWith<_$HostServiceImpl> get copyWith =>
      __$$HostServiceImplCopyWithImpl<_$HostServiceImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HostServiceImplToJson(
      this,
    );
  }
}

abstract class _HostService implements HostService {
  const factory _HostService(
      {required final String id,
      required final String name,
      required final int port,
      required final String protocol,
      required final String state,
      final String? version,
      final String? banner,
      final String? productName,
      final String? productVersion,
      final Map<String, String>? extraInfo,
      final List<String>? vulnerabilities,
      final bool? requiresAuthentication,
      final List<String>? authenticationMethods,
      final String? sslVersion,
      final List<String>? sslCiphers,
      final DateTime? lastChecked,
      final String? confidence}) = _$HostServiceImpl;

  factory _HostService.fromJson(Map<String, dynamic> json) =
      _$HostServiceImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get port;
  @override
  String get protocol;
  @override // "tcp", "udp"
  String get state;
  @override // "open", "filtered", "closed"
  String? get version;
  @override
  String? get banner;
  @override
  String? get productName;
  @override
  String? get productVersion;
  @override
  Map<String, String>? get extraInfo;
  @override
  List<String>? get vulnerabilities;
  @override
  bool? get requiresAuthentication;
  @override
  List<String>? get authenticationMethods;
  @override
  String? get sslVersion;
  @override
  List<String>? get sslCiphers;
  @override
  DateTime? get lastChecked;
  @override
  String? get confidence;
  @override
  @JsonKey(ignore: true)
  _$$HostServiceImplCopyWith<_$HostServiceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HostApplication _$HostApplicationFromJson(Map<String, dynamic> json) {
  return _HostApplication.fromJson(json);
}

/// @nodoc
mixin _$HostApplication {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // "system", "user", "service", "driver"
  String? get version => throw _privateConstructorUsedError;
  String? get vendor => throw _privateConstructorUsedError;
  String? get architecture =>
      throw _privateConstructorUsedError; // "x64", "x86", "any"
  String? get installLocation => throw _privateConstructorUsedError;
  DateTime? get installDate => throw _privateConstructorUsedError;
  int? get sizeMB => throw _privateConstructorUsedError;
  List<String>? get configFiles => throw _privateConstructorUsedError;
  List<String>? get dataDirectories => throw _privateConstructorUsedError;
  List<String>? get registryKeys => throw _privateConstructorUsedError;
  List<String>? get associatedServices =>
      throw _privateConstructorUsedError; // HostService IDs
  List<String>? get networkPorts => throw _privateConstructorUsedError;
  List<String>? get vulnerabilities => throw _privateConstructorUsedError;
  bool? get isSystemCritical => throw _privateConstructorUsedError;
  bool? get hasUpdateAvailable => throw _privateConstructorUsedError;
  String? get licenseType => throw _privateConstructorUsedError;
  String? get licenseKey => throw _privateConstructorUsedError;
  Map<String, String>? get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HostApplicationCopyWith<HostApplication> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HostApplicationCopyWith<$Res> {
  factory $HostApplicationCopyWith(
          HostApplication value, $Res Function(HostApplication) then) =
      _$HostApplicationCopyWithImpl<$Res, HostApplication>;
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String? version,
      String? vendor,
      String? architecture,
      String? installLocation,
      DateTime? installDate,
      int? sizeMB,
      List<String>? configFiles,
      List<String>? dataDirectories,
      List<String>? registryKeys,
      List<String>? associatedServices,
      List<String>? networkPorts,
      List<String>? vulnerabilities,
      bool? isSystemCritical,
      bool? hasUpdateAvailable,
      String? licenseType,
      String? licenseKey,
      Map<String, String>? metadata});
}

/// @nodoc
class _$HostApplicationCopyWithImpl<$Res, $Val extends HostApplication>
    implements $HostApplicationCopyWith<$Res> {
  _$HostApplicationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? version = freezed,
    Object? vendor = freezed,
    Object? architecture = freezed,
    Object? installLocation = freezed,
    Object? installDate = freezed,
    Object? sizeMB = freezed,
    Object? configFiles = freezed,
    Object? dataDirectories = freezed,
    Object? registryKeys = freezed,
    Object? associatedServices = freezed,
    Object? networkPorts = freezed,
    Object? vulnerabilities = freezed,
    Object? isSystemCritical = freezed,
    Object? hasUpdateAvailable = freezed,
    Object? licenseType = freezed,
    Object? licenseKey = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      vendor: freezed == vendor
          ? _value.vendor
          : vendor // ignore: cast_nullable_to_non_nullable
              as String?,
      architecture: freezed == architecture
          ? _value.architecture
          : architecture // ignore: cast_nullable_to_non_nullable
              as String?,
      installLocation: freezed == installLocation
          ? _value.installLocation
          : installLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      installDate: freezed == installDate
          ? _value.installDate
          : installDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sizeMB: freezed == sizeMB
          ? _value.sizeMB
          : sizeMB // ignore: cast_nullable_to_non_nullable
              as int?,
      configFiles: freezed == configFiles
          ? _value.configFiles
          : configFiles // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dataDirectories: freezed == dataDirectories
          ? _value.dataDirectories
          : dataDirectories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      registryKeys: freezed == registryKeys
          ? _value.registryKeys
          : registryKeys // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      associatedServices: freezed == associatedServices
          ? _value.associatedServices
          : associatedServices // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      networkPorts: freezed == networkPorts
          ? _value.networkPorts
          : networkPorts // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      vulnerabilities: freezed == vulnerabilities
          ? _value.vulnerabilities
          : vulnerabilities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isSystemCritical: freezed == isSystemCritical
          ? _value.isSystemCritical
          : isSystemCritical // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasUpdateAvailable: freezed == hasUpdateAvailable
          ? _value.hasUpdateAvailable
          : hasUpdateAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      licenseType: freezed == licenseType
          ? _value.licenseType
          : licenseType // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseKey: freezed == licenseKey
          ? _value.licenseKey
          : licenseKey // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HostApplicationImplCopyWith<$Res>
    implements $HostApplicationCopyWith<$Res> {
  factory _$$HostApplicationImplCopyWith(_$HostApplicationImpl value,
          $Res Function(_$HostApplicationImpl) then) =
      __$$HostApplicationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String type,
      String? version,
      String? vendor,
      String? architecture,
      String? installLocation,
      DateTime? installDate,
      int? sizeMB,
      List<String>? configFiles,
      List<String>? dataDirectories,
      List<String>? registryKeys,
      List<String>? associatedServices,
      List<String>? networkPorts,
      List<String>? vulnerabilities,
      bool? isSystemCritical,
      bool? hasUpdateAvailable,
      String? licenseType,
      String? licenseKey,
      Map<String, String>? metadata});
}

/// @nodoc
class __$$HostApplicationImplCopyWithImpl<$Res>
    extends _$HostApplicationCopyWithImpl<$Res, _$HostApplicationImpl>
    implements _$$HostApplicationImplCopyWith<$Res> {
  __$$HostApplicationImplCopyWithImpl(
      _$HostApplicationImpl _value, $Res Function(_$HostApplicationImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? type = null,
    Object? version = freezed,
    Object? vendor = freezed,
    Object? architecture = freezed,
    Object? installLocation = freezed,
    Object? installDate = freezed,
    Object? sizeMB = freezed,
    Object? configFiles = freezed,
    Object? dataDirectories = freezed,
    Object? registryKeys = freezed,
    Object? associatedServices = freezed,
    Object? networkPorts = freezed,
    Object? vulnerabilities = freezed,
    Object? isSystemCritical = freezed,
    Object? hasUpdateAvailable = freezed,
    Object? licenseType = freezed,
    Object? licenseKey = freezed,
    Object? metadata = freezed,
  }) {
    return _then(_$HostApplicationImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      vendor: freezed == vendor
          ? _value.vendor
          : vendor // ignore: cast_nullable_to_non_nullable
              as String?,
      architecture: freezed == architecture
          ? _value.architecture
          : architecture // ignore: cast_nullable_to_non_nullable
              as String?,
      installLocation: freezed == installLocation
          ? _value.installLocation
          : installLocation // ignore: cast_nullable_to_non_nullable
              as String?,
      installDate: freezed == installDate
          ? _value.installDate
          : installDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sizeMB: freezed == sizeMB
          ? _value.sizeMB
          : sizeMB // ignore: cast_nullable_to_non_nullable
              as int?,
      configFiles: freezed == configFiles
          ? _value._configFiles
          : configFiles // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      dataDirectories: freezed == dataDirectories
          ? _value._dataDirectories
          : dataDirectories // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      registryKeys: freezed == registryKeys
          ? _value._registryKeys
          : registryKeys // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      associatedServices: freezed == associatedServices
          ? _value._associatedServices
          : associatedServices // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      networkPorts: freezed == networkPorts
          ? _value._networkPorts
          : networkPorts // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      vulnerabilities: freezed == vulnerabilities
          ? _value._vulnerabilities
          : vulnerabilities // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      isSystemCritical: freezed == isSystemCritical
          ? _value.isSystemCritical
          : isSystemCritical // ignore: cast_nullable_to_non_nullable
              as bool?,
      hasUpdateAvailable: freezed == hasUpdateAvailable
          ? _value.hasUpdateAvailable
          : hasUpdateAvailable // ignore: cast_nullable_to_non_nullable
              as bool?,
      licenseType: freezed == licenseType
          ? _value.licenseType
          : licenseType // ignore: cast_nullable_to_non_nullable
              as String?,
      licenseKey: freezed == licenseKey
          ? _value.licenseKey
          : licenseKey // ignore: cast_nullable_to_non_nullable
              as String?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HostApplicationImpl implements _HostApplication {
  const _$HostApplicationImpl(
      {required this.id,
      required this.name,
      required this.type,
      this.version,
      this.vendor,
      this.architecture,
      this.installLocation,
      this.installDate,
      this.sizeMB,
      final List<String>? configFiles,
      final List<String>? dataDirectories,
      final List<String>? registryKeys,
      final List<String>? associatedServices,
      final List<String>? networkPorts,
      final List<String>? vulnerabilities,
      this.isSystemCritical,
      this.hasUpdateAvailable,
      this.licenseType,
      this.licenseKey,
      final Map<String, String>? metadata})
      : _configFiles = configFiles,
        _dataDirectories = dataDirectories,
        _registryKeys = registryKeys,
        _associatedServices = associatedServices,
        _networkPorts = networkPorts,
        _vulnerabilities = vulnerabilities,
        _metadata = metadata;

  factory _$HostApplicationImpl.fromJson(Map<String, dynamic> json) =>
      _$$HostApplicationImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String type;
// "system", "user", "service", "driver"
  @override
  final String? version;
  @override
  final String? vendor;
  @override
  final String? architecture;
// "x64", "x86", "any"
  @override
  final String? installLocation;
  @override
  final DateTime? installDate;
  @override
  final int? sizeMB;
  final List<String>? _configFiles;
  @override
  List<String>? get configFiles {
    final value = _configFiles;
    if (value == null) return null;
    if (_configFiles is EqualUnmodifiableListView) return _configFiles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _dataDirectories;
  @override
  List<String>? get dataDirectories {
    final value = _dataDirectories;
    if (value == null) return null;
    if (_dataDirectories is EqualUnmodifiableListView) return _dataDirectories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _registryKeys;
  @override
  List<String>? get registryKeys {
    final value = _registryKeys;
    if (value == null) return null;
    if (_registryKeys is EqualUnmodifiableListView) return _registryKeys;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _associatedServices;
  @override
  List<String>? get associatedServices {
    final value = _associatedServices;
    if (value == null) return null;
    if (_associatedServices is EqualUnmodifiableListView)
      return _associatedServices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// HostService IDs
  final List<String>? _networkPorts;
// HostService IDs
  @override
  List<String>? get networkPorts {
    final value = _networkPorts;
    if (value == null) return null;
    if (_networkPorts is EqualUnmodifiableListView) return _networkPorts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<String>? _vulnerabilities;
  @override
  List<String>? get vulnerabilities {
    final value = _vulnerabilities;
    if (value == null) return null;
    if (_vulnerabilities is EqualUnmodifiableListView) return _vulnerabilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? isSystemCritical;
  @override
  final bool? hasUpdateAvailable;
  @override
  final String? licenseType;
  @override
  final String? licenseKey;
  final Map<String, String>? _metadata;
  @override
  Map<String, String>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'HostApplication(id: $id, name: $name, type: $type, version: $version, vendor: $vendor, architecture: $architecture, installLocation: $installLocation, installDate: $installDate, sizeMB: $sizeMB, configFiles: $configFiles, dataDirectories: $dataDirectories, registryKeys: $registryKeys, associatedServices: $associatedServices, networkPorts: $networkPorts, vulnerabilities: $vulnerabilities, isSystemCritical: $isSystemCritical, hasUpdateAvailable: $hasUpdateAvailable, licenseType: $licenseType, licenseKey: $licenseKey, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HostApplicationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.version, version) || other.version == version) &&
            (identical(other.vendor, vendor) || other.vendor == vendor) &&
            (identical(other.architecture, architecture) ||
                other.architecture == architecture) &&
            (identical(other.installLocation, installLocation) ||
                other.installLocation == installLocation) &&
            (identical(other.installDate, installDate) ||
                other.installDate == installDate) &&
            (identical(other.sizeMB, sizeMB) || other.sizeMB == sizeMB) &&
            const DeepCollectionEquality()
                .equals(other._configFiles, _configFiles) &&
            const DeepCollectionEquality()
                .equals(other._dataDirectories, _dataDirectories) &&
            const DeepCollectionEquality()
                .equals(other._registryKeys, _registryKeys) &&
            const DeepCollectionEquality()
                .equals(other._associatedServices, _associatedServices) &&
            const DeepCollectionEquality()
                .equals(other._networkPorts, _networkPorts) &&
            const DeepCollectionEquality()
                .equals(other._vulnerabilities, _vulnerabilities) &&
            (identical(other.isSystemCritical, isSystemCritical) ||
                other.isSystemCritical == isSystemCritical) &&
            (identical(other.hasUpdateAvailable, hasUpdateAvailable) ||
                other.hasUpdateAvailable == hasUpdateAvailable) &&
            (identical(other.licenseType, licenseType) ||
                other.licenseType == licenseType) &&
            (identical(other.licenseKey, licenseKey) ||
                other.licenseKey == licenseKey) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        type,
        version,
        vendor,
        architecture,
        installLocation,
        installDate,
        sizeMB,
        const DeepCollectionEquality().hash(_configFiles),
        const DeepCollectionEquality().hash(_dataDirectories),
        const DeepCollectionEquality().hash(_registryKeys),
        const DeepCollectionEquality().hash(_associatedServices),
        const DeepCollectionEquality().hash(_networkPorts),
        const DeepCollectionEquality().hash(_vulnerabilities),
        isSystemCritical,
        hasUpdateAvailable,
        licenseType,
        licenseKey,
        const DeepCollectionEquality().hash(_metadata)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HostApplicationImplCopyWith<_$HostApplicationImpl> get copyWith =>
      __$$HostApplicationImplCopyWithImpl<_$HostApplicationImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HostApplicationImplToJson(
      this,
    );
  }
}

abstract class _HostApplication implements HostApplication {
  const factory _HostApplication(
      {required final String id,
      required final String name,
      required final String type,
      final String? version,
      final String? vendor,
      final String? architecture,
      final String? installLocation,
      final DateTime? installDate,
      final int? sizeMB,
      final List<String>? configFiles,
      final List<String>? dataDirectories,
      final List<String>? registryKeys,
      final List<String>? associatedServices,
      final List<String>? networkPorts,
      final List<String>? vulnerabilities,
      final bool? isSystemCritical,
      final bool? hasUpdateAvailable,
      final String? licenseType,
      final String? licenseKey,
      final Map<String, String>? metadata}) = _$HostApplicationImpl;

  factory _HostApplication.fromJson(Map<String, dynamic> json) =
      _$HostApplicationImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get type;
  @override // "system", "user", "service", "driver"
  String? get version;
  @override
  String? get vendor;
  @override
  String? get architecture;
  @override // "x64", "x86", "any"
  String? get installLocation;
  @override
  DateTime? get installDate;
  @override
  int? get sizeMB;
  @override
  List<String>? get configFiles;
  @override
  List<String>? get dataDirectories;
  @override
  List<String>? get registryKeys;
  @override
  List<String>? get associatedServices;
  @override // HostService IDs
  List<String>? get networkPorts;
  @override
  List<String>? get vulnerabilities;
  @override
  bool? get isSystemCritical;
  @override
  bool? get hasUpdateAvailable;
  @override
  String? get licenseType;
  @override
  String? get licenseKey;
  @override
  Map<String, String>? get metadata;
  @override
  @JsonKey(ignore: true)
  _$$HostApplicationImplCopyWith<_$HostApplicationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HostAccount _$HostAccountFromJson(Map<String, dynamic> json) {
  return _HostAccount.fromJson(json);
}

/// @nodoc
mixin _$HostAccount {
  String get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // "local", "domain", "service", "system"
  bool get isEnabled => throw _privateConstructorUsedError;
  String? get fullName => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get groups => throw _privateConstructorUsedError;
  String? get homeDirectory => throw _privateConstructorUsedError;
  String? get shell => throw _privateConstructorUsedError;
  DateTime? get lastLogin => throw _privateConstructorUsedError;
  DateTime? get passwordLastSet => throw _privateConstructorUsedError;
  bool? get passwordNeverExpires => throw _privateConstructorUsedError;
  bool? get accountLocked => throw _privateConstructorUsedError;
  bool? get isAdmin => throw _privateConstructorUsedError;
  List<String>? get privileges => throw _privateConstructorUsedError;
  Map<String, String>? get environment => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HostAccountCopyWith<HostAccount> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HostAccountCopyWith<$Res> {
  factory $HostAccountCopyWith(
          HostAccount value, $Res Function(HostAccount) then) =
      _$HostAccountCopyWithImpl<$Res, HostAccount>;
  @useResult
  $Res call(
      {String id,
      String username,
      String type,
      bool isEnabled,
      String? fullName,
      String? description,
      List<String>? groups,
      String? homeDirectory,
      String? shell,
      DateTime? lastLogin,
      DateTime? passwordLastSet,
      bool? passwordNeverExpires,
      bool? accountLocked,
      bool? isAdmin,
      List<String>? privileges,
      Map<String, String>? environment});
}

/// @nodoc
class _$HostAccountCopyWithImpl<$Res, $Val extends HostAccount>
    implements $HostAccountCopyWith<$Res> {
  _$HostAccountCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? type = null,
    Object? isEnabled = null,
    Object? fullName = freezed,
    Object? description = freezed,
    Object? groups = freezed,
    Object? homeDirectory = freezed,
    Object? shell = freezed,
    Object? lastLogin = freezed,
    Object? passwordLastSet = freezed,
    Object? passwordNeverExpires = freezed,
    Object? accountLocked = freezed,
    Object? isAdmin = freezed,
    Object? privileges = freezed,
    Object? environment = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      groups: freezed == groups
          ? _value.groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      homeDirectory: freezed == homeDirectory
          ? _value.homeDirectory
          : homeDirectory // ignore: cast_nullable_to_non_nullable
              as String?,
      shell: freezed == shell
          ? _value.shell
          : shell // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLogin: freezed == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      passwordLastSet: freezed == passwordLastSet
          ? _value.passwordLastSet
          : passwordLastSet // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      passwordNeverExpires: freezed == passwordNeverExpires
          ? _value.passwordNeverExpires
          : passwordNeverExpires // ignore: cast_nullable_to_non_nullable
              as bool?,
      accountLocked: freezed == accountLocked
          ? _value.accountLocked
          : accountLocked // ignore: cast_nullable_to_non_nullable
              as bool?,
      isAdmin: freezed == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool?,
      privileges: freezed == privileges
          ? _value.privileges
          : privileges // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      environment: freezed == environment
          ? _value.environment
          : environment // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HostAccountImplCopyWith<$Res>
    implements $HostAccountCopyWith<$Res> {
  factory _$$HostAccountImplCopyWith(
          _$HostAccountImpl value, $Res Function(_$HostAccountImpl) then) =
      __$$HostAccountImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String username,
      String type,
      bool isEnabled,
      String? fullName,
      String? description,
      List<String>? groups,
      String? homeDirectory,
      String? shell,
      DateTime? lastLogin,
      DateTime? passwordLastSet,
      bool? passwordNeverExpires,
      bool? accountLocked,
      bool? isAdmin,
      List<String>? privileges,
      Map<String, String>? environment});
}

/// @nodoc
class __$$HostAccountImplCopyWithImpl<$Res>
    extends _$HostAccountCopyWithImpl<$Res, _$HostAccountImpl>
    implements _$$HostAccountImplCopyWith<$Res> {
  __$$HostAccountImplCopyWithImpl(
      _$HostAccountImpl _value, $Res Function(_$HostAccountImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
    Object? type = null,
    Object? isEnabled = null,
    Object? fullName = freezed,
    Object? description = freezed,
    Object? groups = freezed,
    Object? homeDirectory = freezed,
    Object? shell = freezed,
    Object? lastLogin = freezed,
    Object? passwordLastSet = freezed,
    Object? passwordNeverExpires = freezed,
    Object? accountLocked = freezed,
    Object? isAdmin = freezed,
    Object? privileges = freezed,
    Object? environment = freezed,
  }) {
    return _then(_$HostAccountImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      groups: freezed == groups
          ? _value._groups
          : groups // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      homeDirectory: freezed == homeDirectory
          ? _value.homeDirectory
          : homeDirectory // ignore: cast_nullable_to_non_nullable
              as String?,
      shell: freezed == shell
          ? _value.shell
          : shell // ignore: cast_nullable_to_non_nullable
              as String?,
      lastLogin: freezed == lastLogin
          ? _value.lastLogin
          : lastLogin // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      passwordLastSet: freezed == passwordLastSet
          ? _value.passwordLastSet
          : passwordLastSet // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      passwordNeverExpires: freezed == passwordNeverExpires
          ? _value.passwordNeverExpires
          : passwordNeverExpires // ignore: cast_nullable_to_non_nullable
              as bool?,
      accountLocked: freezed == accountLocked
          ? _value.accountLocked
          : accountLocked // ignore: cast_nullable_to_non_nullable
              as bool?,
      isAdmin: freezed == isAdmin
          ? _value.isAdmin
          : isAdmin // ignore: cast_nullable_to_non_nullable
              as bool?,
      privileges: freezed == privileges
          ? _value._privileges
          : privileges // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      environment: freezed == environment
          ? _value._environment
          : environment // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HostAccountImpl implements _HostAccount {
  const _$HostAccountImpl(
      {required this.id,
      required this.username,
      required this.type,
      required this.isEnabled,
      this.fullName,
      this.description,
      final List<String>? groups,
      this.homeDirectory,
      this.shell,
      this.lastLogin,
      this.passwordLastSet,
      this.passwordNeverExpires,
      this.accountLocked,
      this.isAdmin,
      final List<String>? privileges,
      final Map<String, String>? environment})
      : _groups = groups,
        _privileges = privileges,
        _environment = environment;

  factory _$HostAccountImpl.fromJson(Map<String, dynamic> json) =>
      _$$HostAccountImplFromJson(json);

  @override
  final String id;
  @override
  final String username;
  @override
  final String type;
// "local", "domain", "service", "system"
  @override
  final bool isEnabled;
  @override
  final String? fullName;
  @override
  final String? description;
  final List<String>? _groups;
  @override
  List<String>? get groups {
    final value = _groups;
    if (value == null) return null;
    if (_groups is EqualUnmodifiableListView) return _groups;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? homeDirectory;
  @override
  final String? shell;
  @override
  final DateTime? lastLogin;
  @override
  final DateTime? passwordLastSet;
  @override
  final bool? passwordNeverExpires;
  @override
  final bool? accountLocked;
  @override
  final bool? isAdmin;
  final List<String>? _privileges;
  @override
  List<String>? get privileges {
    final value = _privileges;
    if (value == null) return null;
    if (_privileges is EqualUnmodifiableListView) return _privileges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, String>? _environment;
  @override
  Map<String, String>? get environment {
    final value = _environment;
    if (value == null) return null;
    if (_environment is EqualUnmodifiableMapView) return _environment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  String toString() {
    return 'HostAccount(id: $id, username: $username, type: $type, isEnabled: $isEnabled, fullName: $fullName, description: $description, groups: $groups, homeDirectory: $homeDirectory, shell: $shell, lastLogin: $lastLogin, passwordLastSet: $passwordLastSet, passwordNeverExpires: $passwordNeverExpires, accountLocked: $accountLocked, isAdmin: $isAdmin, privileges: $privileges, environment: $environment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HostAccountImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(other._groups, _groups) &&
            (identical(other.homeDirectory, homeDirectory) ||
                other.homeDirectory == homeDirectory) &&
            (identical(other.shell, shell) || other.shell == shell) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin) &&
            (identical(other.passwordLastSet, passwordLastSet) ||
                other.passwordLastSet == passwordLastSet) &&
            (identical(other.passwordNeverExpires, passwordNeverExpires) ||
                other.passwordNeverExpires == passwordNeverExpires) &&
            (identical(other.accountLocked, accountLocked) ||
                other.accountLocked == accountLocked) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            const DeepCollectionEquality()
                .equals(other._privileges, _privileges) &&
            const DeepCollectionEquality()
                .equals(other._environment, _environment));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      username,
      type,
      isEnabled,
      fullName,
      description,
      const DeepCollectionEquality().hash(_groups),
      homeDirectory,
      shell,
      lastLogin,
      passwordLastSet,
      passwordNeverExpires,
      accountLocked,
      isAdmin,
      const DeepCollectionEquality().hash(_privileges),
      const DeepCollectionEquality().hash(_environment));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HostAccountImplCopyWith<_$HostAccountImpl> get copyWith =>
      __$$HostAccountImplCopyWithImpl<_$HostAccountImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HostAccountImplToJson(
      this,
    );
  }
}

abstract class _HostAccount implements HostAccount {
  const factory _HostAccount(
      {required final String id,
      required final String username,
      required final String type,
      required final bool isEnabled,
      final String? fullName,
      final String? description,
      final List<String>? groups,
      final String? homeDirectory,
      final String? shell,
      final DateTime? lastLogin,
      final DateTime? passwordLastSet,
      final bool? passwordNeverExpires,
      final bool? accountLocked,
      final bool? isAdmin,
      final List<String>? privileges,
      final Map<String, String>? environment}) = _$HostAccountImpl;

  factory _HostAccount.fromJson(Map<String, dynamic> json) =
      _$HostAccountImpl.fromJson;

  @override
  String get id;
  @override
  String get username;
  @override
  String get type;
  @override // "local", "domain", "service", "system"
  bool get isEnabled;
  @override
  String? get fullName;
  @override
  String? get description;
  @override
  List<String>? get groups;
  @override
  String? get homeDirectory;
  @override
  String? get shell;
  @override
  DateTime? get lastLogin;
  @override
  DateTime? get passwordLastSet;
  @override
  bool? get passwordNeverExpires;
  @override
  bool? get accountLocked;
  @override
  bool? get isAdmin;
  @override
  List<String>? get privileges;
  @override
  Map<String, String>? get environment;
  @override
  @JsonKey(ignore: true)
  _$$HostAccountImplCopyWith<_$HostAccountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HardwareComponent _$HardwareComponentFromJson(Map<String, dynamic> json) {
  return _HardwareComponent.fromJson(json);
}

/// @nodoc
mixin _$HardwareComponent {
  String get id => throw _privateConstructorUsedError;
  String get type =>
      throw _privateConstructorUsedError; // "cpu", "memory", "disk", "gpu", "motherboard"
  String get name => throw _privateConstructorUsedError;
  String? get manufacturer => throw _privateConstructorUsedError;
  String? get model => throw _privateConstructorUsedError;
  String? get serialNumber => throw _privateConstructorUsedError;
  String? get version => throw _privateConstructorUsedError;
  Map<String, String>? get specifications => throw _privateConstructorUsedError;
  String? get health =>
      throw _privateConstructorUsedError; // "good", "warning", "critical", "unknown"
  DateTime? get lastChecked => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $HardwareComponentCopyWith<HardwareComponent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HardwareComponentCopyWith<$Res> {
  factory $HardwareComponentCopyWith(
          HardwareComponent value, $Res Function(HardwareComponent) then) =
      _$HardwareComponentCopyWithImpl<$Res, HardwareComponent>;
  @useResult
  $Res call(
      {String id,
      String type,
      String name,
      String? manufacturer,
      String? model,
      String? serialNumber,
      String? version,
      Map<String, String>? specifications,
      String? health,
      DateTime? lastChecked});
}

/// @nodoc
class _$HardwareComponentCopyWithImpl<$Res, $Val extends HardwareComponent>
    implements $HardwareComponentCopyWith<$Res> {
  _$HardwareComponentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = null,
    Object? manufacturer = freezed,
    Object? model = freezed,
    Object? serialNumber = freezed,
    Object? version = freezed,
    Object? specifications = freezed,
    Object? health = freezed,
    Object? lastChecked = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      serialNumber: freezed == serialNumber
          ? _value.serialNumber
          : serialNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      specifications: freezed == specifications
          ? _value.specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      health: freezed == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as String?,
      lastChecked: freezed == lastChecked
          ? _value.lastChecked
          : lastChecked // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HardwareComponentImplCopyWith<$Res>
    implements $HardwareComponentCopyWith<$Res> {
  factory _$$HardwareComponentImplCopyWith(_$HardwareComponentImpl value,
          $Res Function(_$HardwareComponentImpl) then) =
      __$$HardwareComponentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String type,
      String name,
      String? manufacturer,
      String? model,
      String? serialNumber,
      String? version,
      Map<String, String>? specifications,
      String? health,
      DateTime? lastChecked});
}

/// @nodoc
class __$$HardwareComponentImplCopyWithImpl<$Res>
    extends _$HardwareComponentCopyWithImpl<$Res, _$HardwareComponentImpl>
    implements _$$HardwareComponentImplCopyWith<$Res> {
  __$$HardwareComponentImplCopyWithImpl(_$HardwareComponentImpl _value,
      $Res Function(_$HardwareComponentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? name = null,
    Object? manufacturer = freezed,
    Object? model = freezed,
    Object? serialNumber = freezed,
    Object? version = freezed,
    Object? specifications = freezed,
    Object? health = freezed,
    Object? lastChecked = freezed,
  }) {
    return _then(_$HardwareComponentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
      model: freezed == model
          ? _value.model
          : model // ignore: cast_nullable_to_non_nullable
              as String?,
      serialNumber: freezed == serialNumber
          ? _value.serialNumber
          : serialNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      version: freezed == version
          ? _value.version
          : version // ignore: cast_nullable_to_non_nullable
              as String?,
      specifications: freezed == specifications
          ? _value._specifications
          : specifications // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      health: freezed == health
          ? _value.health
          : health // ignore: cast_nullable_to_non_nullable
              as String?,
      lastChecked: freezed == lastChecked
          ? _value.lastChecked
          : lastChecked // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HardwareComponentImpl implements _HardwareComponent {
  const _$HardwareComponentImpl(
      {required this.id,
      required this.type,
      required this.name,
      this.manufacturer,
      this.model,
      this.serialNumber,
      this.version,
      final Map<String, String>? specifications,
      this.health,
      this.lastChecked})
      : _specifications = specifications;

  factory _$HardwareComponentImpl.fromJson(Map<String, dynamic> json) =>
      _$$HardwareComponentImplFromJson(json);

  @override
  final String id;
  @override
  final String type;
// "cpu", "memory", "disk", "gpu", "motherboard"
  @override
  final String name;
  @override
  final String? manufacturer;
  @override
  final String? model;
  @override
  final String? serialNumber;
  @override
  final String? version;
  final Map<String, String>? _specifications;
  @override
  Map<String, String>? get specifications {
    final value = _specifications;
    if (value == null) return null;
    if (_specifications is EqualUnmodifiableMapView) return _specifications;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final String? health;
// "good", "warning", "critical", "unknown"
  @override
  final DateTime? lastChecked;

  @override
  String toString() {
    return 'HardwareComponent(id: $id, type: $type, name: $name, manufacturer: $manufacturer, model: $model, serialNumber: $serialNumber, version: $version, specifications: $specifications, health: $health, lastChecked: $lastChecked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HardwareComponentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.serialNumber, serialNumber) ||
                other.serialNumber == serialNumber) &&
            (identical(other.version, version) || other.version == version) &&
            const DeepCollectionEquality()
                .equals(other._specifications, _specifications) &&
            (identical(other.health, health) || other.health == health) &&
            (identical(other.lastChecked, lastChecked) ||
                other.lastChecked == lastChecked));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      name,
      manufacturer,
      model,
      serialNumber,
      version,
      const DeepCollectionEquality().hash(_specifications),
      health,
      lastChecked);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HardwareComponentImplCopyWith<_$HardwareComponentImpl> get copyWith =>
      __$$HardwareComponentImplCopyWithImpl<_$HardwareComponentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HardwareComponentImplToJson(
      this,
    );
  }
}

abstract class _HardwareComponent implements HardwareComponent {
  const factory _HardwareComponent(
      {required final String id,
      required final String type,
      required final String name,
      final String? manufacturer,
      final String? model,
      final String? serialNumber,
      final String? version,
      final Map<String, String>? specifications,
      final String? health,
      final DateTime? lastChecked}) = _$HardwareComponentImpl;

  factory _HardwareComponent.fromJson(Map<String, dynamic> json) =
      _$HardwareComponentImpl.fromJson;

  @override
  String get id;
  @override
  String get type;
  @override // "cpu", "memory", "disk", "gpu", "motherboard"
  String get name;
  @override
  String? get manufacturer;
  @override
  String? get model;
  @override
  String? get serialNumber;
  @override
  String? get version;
  @override
  Map<String, String>? get specifications;
  @override
  String? get health;
  @override // "good", "warning", "critical", "unknown"
  DateTime? get lastChecked;
  @override
  @JsonKey(ignore: true)
  _$$HardwareComponentImplCopyWith<_$HardwareComponentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthenticationInfo _$AuthenticationInfoFromJson(Map<String, dynamic> json) {
  return _AuthenticationInfo.fromJson(json);
}

/// @nodoc
mixin _$AuthenticationInfo {
  String get mechanism =>
      throw _privateConstructorUsedError; // "password", "certificate", "kerberos", etc.
  Map<String, String>? get details => throw _privateConstructorUsedError;
  bool? get isMultiFactor => throw _privateConstructorUsedError;
  List<String>? get mfaMethods => throw _privateConstructorUsedError;
  DateTime? get lastAuthentication => throw _privateConstructorUsedError;
  bool? get isServiceAccount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AuthenticationInfoCopyWith<AuthenticationInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthenticationInfoCopyWith<$Res> {
  factory $AuthenticationInfoCopyWith(
          AuthenticationInfo value, $Res Function(AuthenticationInfo) then) =
      _$AuthenticationInfoCopyWithImpl<$Res, AuthenticationInfo>;
  @useResult
  $Res call(
      {String mechanism,
      Map<String, String>? details,
      bool? isMultiFactor,
      List<String>? mfaMethods,
      DateTime? lastAuthentication,
      bool? isServiceAccount});
}

/// @nodoc
class _$AuthenticationInfoCopyWithImpl<$Res, $Val extends AuthenticationInfo>
    implements $AuthenticationInfoCopyWith<$Res> {
  _$AuthenticationInfoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mechanism = null,
    Object? details = freezed,
    Object? isMultiFactor = freezed,
    Object? mfaMethods = freezed,
    Object? lastAuthentication = freezed,
    Object? isServiceAccount = freezed,
  }) {
    return _then(_value.copyWith(
      mechanism: null == mechanism
          ? _value.mechanism
          : mechanism // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      isMultiFactor: freezed == isMultiFactor
          ? _value.isMultiFactor
          : isMultiFactor // ignore: cast_nullable_to_non_nullable
              as bool?,
      mfaMethods: freezed == mfaMethods
          ? _value.mfaMethods
          : mfaMethods // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastAuthentication: freezed == lastAuthentication
          ? _value.lastAuthentication
          : lastAuthentication // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isServiceAccount: freezed == isServiceAccount
          ? _value.isServiceAccount
          : isServiceAccount // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AuthenticationInfoImplCopyWith<$Res>
    implements $AuthenticationInfoCopyWith<$Res> {
  factory _$$AuthenticationInfoImplCopyWith(_$AuthenticationInfoImpl value,
          $Res Function(_$AuthenticationInfoImpl) then) =
      __$$AuthenticationInfoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String mechanism,
      Map<String, String>? details,
      bool? isMultiFactor,
      List<String>? mfaMethods,
      DateTime? lastAuthentication,
      bool? isServiceAccount});
}

/// @nodoc
class __$$AuthenticationInfoImplCopyWithImpl<$Res>
    extends _$AuthenticationInfoCopyWithImpl<$Res, _$AuthenticationInfoImpl>
    implements _$$AuthenticationInfoImplCopyWith<$Res> {
  __$$AuthenticationInfoImplCopyWithImpl(_$AuthenticationInfoImpl _value,
      $Res Function(_$AuthenticationInfoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? mechanism = null,
    Object? details = freezed,
    Object? isMultiFactor = freezed,
    Object? mfaMethods = freezed,
    Object? lastAuthentication = freezed,
    Object? isServiceAccount = freezed,
  }) {
    return _then(_$AuthenticationInfoImpl(
      mechanism: null == mechanism
          ? _value.mechanism
          : mechanism // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value._details
          : details // ignore: cast_nullable_to_non_nullable
              as Map<String, String>?,
      isMultiFactor: freezed == isMultiFactor
          ? _value.isMultiFactor
          : isMultiFactor // ignore: cast_nullable_to_non_nullable
              as bool?,
      mfaMethods: freezed == mfaMethods
          ? _value._mfaMethods
          : mfaMethods // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      lastAuthentication: freezed == lastAuthentication
          ? _value.lastAuthentication
          : lastAuthentication // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isServiceAccount: freezed == isServiceAccount
          ? _value.isServiceAccount
          : isServiceAccount // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthenticationInfoImpl implements _AuthenticationInfo {
  const _$AuthenticationInfoImpl(
      {required this.mechanism,
      final Map<String, String>? details,
      this.isMultiFactor,
      final List<String>? mfaMethods,
      this.lastAuthentication,
      this.isServiceAccount})
      : _details = details,
        _mfaMethods = mfaMethods;

  factory _$AuthenticationInfoImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthenticationInfoImplFromJson(json);

  @override
  final String mechanism;
// "password", "certificate", "kerberos", etc.
  final Map<String, String>? _details;
// "password", "certificate", "kerberos", etc.
  @override
  Map<String, String>? get details {
    final value = _details;
    if (value == null) return null;
    if (_details is EqualUnmodifiableMapView) return _details;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final bool? isMultiFactor;
  final List<String>? _mfaMethods;
  @override
  List<String>? get mfaMethods {
    final value = _mfaMethods;
    if (value == null) return null;
    if (_mfaMethods is EqualUnmodifiableListView) return _mfaMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final DateTime? lastAuthentication;
  @override
  final bool? isServiceAccount;

  @override
  String toString() {
    return 'AuthenticationInfo(mechanism: $mechanism, details: $details, isMultiFactor: $isMultiFactor, mfaMethods: $mfaMethods, lastAuthentication: $lastAuthentication, isServiceAccount: $isServiceAccount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthenticationInfoImpl &&
            (identical(other.mechanism, mechanism) ||
                other.mechanism == mechanism) &&
            const DeepCollectionEquality().equals(other._details, _details) &&
            (identical(other.isMultiFactor, isMultiFactor) ||
                other.isMultiFactor == isMultiFactor) &&
            const DeepCollectionEquality()
                .equals(other._mfaMethods, _mfaMethods) &&
            (identical(other.lastAuthentication, lastAuthentication) ||
                other.lastAuthentication == lastAuthentication) &&
            (identical(other.isServiceAccount, isServiceAccount) ||
                other.isServiceAccount == isServiceAccount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      mechanism,
      const DeepCollectionEquality().hash(_details),
      isMultiFactor,
      const DeepCollectionEquality().hash(_mfaMethods),
      lastAuthentication,
      isServiceAccount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthenticationInfoImplCopyWith<_$AuthenticationInfoImpl> get copyWith =>
      __$$AuthenticationInfoImplCopyWithImpl<_$AuthenticationInfoImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthenticationInfoImplToJson(
      this,
    );
  }
}

abstract class _AuthenticationInfo implements AuthenticationInfo {
  const factory _AuthenticationInfo(
      {required final String mechanism,
      final Map<String, String>? details,
      final bool? isMultiFactor,
      final List<String>? mfaMethods,
      final DateTime? lastAuthentication,
      final bool? isServiceAccount}) = _$AuthenticationInfoImpl;

  factory _AuthenticationInfo.fromJson(Map<String, dynamic> json) =
      _$AuthenticationInfoImpl.fromJson;

  @override
  String get mechanism;
  @override // "password", "certificate", "kerberos", etc.
  Map<String, String>? get details;
  @override
  bool? get isMultiFactor;
  @override
  List<String>? get mfaMethods;
  @override
  DateTime? get lastAuthentication;
  @override
  bool? get isServiceAccount;
  @override
  @JsonKey(ignore: true)
  _$$AuthenticationInfoImplCopyWith<_$AuthenticationInfoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
