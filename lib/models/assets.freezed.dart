// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assets.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NetworkFirewallRule {

 String get id; String get name; FirewallAction get action; String get sourceNetwork;// CIDR or "any"
 String get destinationNetwork;// CIDR or "any"
 String get protocol;// tcp/udp/icmp/any
 String get ports;// "80", "80-443", "any"
 String? get description; bool get enabled; DateTime? get lastModified;
/// Create a copy of NetworkFirewallRule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkFirewallRuleCopyWith<NetworkFirewallRule> get copyWith => _$NetworkFirewallRuleCopyWithImpl<NetworkFirewallRule>(this as NetworkFirewallRule, _$identity);

  /// Serializes this NetworkFirewallRule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkFirewallRule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.action, action) || other.action == action)&&(identical(other.sourceNetwork, sourceNetwork) || other.sourceNetwork == sourceNetwork)&&(identical(other.destinationNetwork, destinationNetwork) || other.destinationNetwork == destinationNetwork)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.ports, ports) || other.ports == ports)&&(identical(other.description, description) || other.description == description)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,action,sourceNetwork,destinationNetwork,protocol,ports,description,enabled,lastModified);

@override
String toString() {
  return 'NetworkFirewallRule(id: $id, name: $name, action: $action, sourceNetwork: $sourceNetwork, destinationNetwork: $destinationNetwork, protocol: $protocol, ports: $ports, description: $description, enabled: $enabled, lastModified: $lastModified)';
}


}

/// @nodoc
abstract mixin class $NetworkFirewallRuleCopyWith<$Res>  {
  factory $NetworkFirewallRuleCopyWith(NetworkFirewallRule value, $Res Function(NetworkFirewallRule) _then) = _$NetworkFirewallRuleCopyWithImpl;
@useResult
$Res call({
 String id, String name, FirewallAction action, String sourceNetwork, String destinationNetwork, String protocol, String ports, String? description, bool enabled, DateTime? lastModified
});




}
/// @nodoc
class _$NetworkFirewallRuleCopyWithImpl<$Res>
    implements $NetworkFirewallRuleCopyWith<$Res> {
  _$NetworkFirewallRuleCopyWithImpl(this._self, this._then);

  final NetworkFirewallRule _self;
  final $Res Function(NetworkFirewallRule) _then;

/// Create a copy of NetworkFirewallRule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? action = null,Object? sourceNetwork = null,Object? destinationNetwork = null,Object? protocol = null,Object? ports = null,Object? description = freezed,Object? enabled = null,Object? lastModified = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as FirewallAction,sourceNetwork: null == sourceNetwork ? _self.sourceNetwork : sourceNetwork // ignore: cast_nullable_to_non_nullable
as String,destinationNetwork: null == destinationNetwork ? _self.destinationNetwork : destinationNetwork // ignore: cast_nullable_to_non_nullable
as String,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String,ports: null == ports ? _self.ports : ports // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NetworkFirewallRule].
extension NetworkFirewallRulePatterns on NetworkFirewallRule {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetworkFirewallRule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetworkFirewallRule() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetworkFirewallRule value)  $default,){
final _that = this;
switch (_that) {
case _NetworkFirewallRule():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetworkFirewallRule value)?  $default,){
final _that = this;
switch (_that) {
case _NetworkFirewallRule() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  FirewallAction action,  String sourceNetwork,  String destinationNetwork,  String protocol,  String ports,  String? description,  bool enabled,  DateTime? lastModified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetworkFirewallRule() when $default != null:
return $default(_that.id,_that.name,_that.action,_that.sourceNetwork,_that.destinationNetwork,_that.protocol,_that.ports,_that.description,_that.enabled,_that.lastModified);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  FirewallAction action,  String sourceNetwork,  String destinationNetwork,  String protocol,  String ports,  String? description,  bool enabled,  DateTime? lastModified)  $default,) {final _that = this;
switch (_that) {
case _NetworkFirewallRule():
return $default(_that.id,_that.name,_that.action,_that.sourceNetwork,_that.destinationNetwork,_that.protocol,_that.ports,_that.description,_that.enabled,_that.lastModified);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  FirewallAction action,  String sourceNetwork,  String destinationNetwork,  String protocol,  String ports,  String? description,  bool enabled,  DateTime? lastModified)?  $default,) {final _that = this;
switch (_that) {
case _NetworkFirewallRule() when $default != null:
return $default(_that.id,_that.name,_that.action,_that.sourceNetwork,_that.destinationNetwork,_that.protocol,_that.ports,_that.description,_that.enabled,_that.lastModified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NetworkFirewallRule implements NetworkFirewallRule {
  const _NetworkFirewallRule({required this.id, required this.name, required this.action, required this.sourceNetwork, required this.destinationNetwork, required this.protocol, required this.ports, this.description, this.enabled = true, this.lastModified});
  factory _NetworkFirewallRule.fromJson(Map<String, dynamic> json) => _$NetworkFirewallRuleFromJson(json);

@override final  String id;
@override final  String name;
@override final  FirewallAction action;
@override final  String sourceNetwork;
// CIDR or "any"
@override final  String destinationNetwork;
// CIDR or "any"
@override final  String protocol;
// tcp/udp/icmp/any
@override final  String ports;
// "80", "80-443", "any"
@override final  String? description;
@override@JsonKey() final  bool enabled;
@override final  DateTime? lastModified;

/// Create a copy of NetworkFirewallRule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkFirewallRuleCopyWith<_NetworkFirewallRule> get copyWith => __$NetworkFirewallRuleCopyWithImpl<_NetworkFirewallRule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NetworkFirewallRuleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkFirewallRule&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.action, action) || other.action == action)&&(identical(other.sourceNetwork, sourceNetwork) || other.sourceNetwork == sourceNetwork)&&(identical(other.destinationNetwork, destinationNetwork) || other.destinationNetwork == destinationNetwork)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.ports, ports) || other.ports == ports)&&(identical(other.description, description) || other.description == description)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.lastModified, lastModified) || other.lastModified == lastModified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,action,sourceNetwork,destinationNetwork,protocol,ports,description,enabled,lastModified);

@override
String toString() {
  return 'NetworkFirewallRule(id: $id, name: $name, action: $action, sourceNetwork: $sourceNetwork, destinationNetwork: $destinationNetwork, protocol: $protocol, ports: $ports, description: $description, enabled: $enabled, lastModified: $lastModified)';
}


}

/// @nodoc
abstract mixin class _$NetworkFirewallRuleCopyWith<$Res> implements $NetworkFirewallRuleCopyWith<$Res> {
  factory _$NetworkFirewallRuleCopyWith(_NetworkFirewallRule value, $Res Function(_NetworkFirewallRule) _then) = __$NetworkFirewallRuleCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, FirewallAction action, String sourceNetwork, String destinationNetwork, String protocol, String ports, String? description, bool enabled, DateTime? lastModified
});




}
/// @nodoc
class __$NetworkFirewallRuleCopyWithImpl<$Res>
    implements _$NetworkFirewallRuleCopyWith<$Res> {
  __$NetworkFirewallRuleCopyWithImpl(this._self, this._then);

  final _NetworkFirewallRule _self;
  final $Res Function(_NetworkFirewallRule) _then;

/// Create a copy of NetworkFirewallRule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? action = null,Object? sourceNetwork = null,Object? destinationNetwork = null,Object? protocol = null,Object? ports = null,Object? description = freezed,Object? enabled = null,Object? lastModified = freezed,}) {
  return _then(_NetworkFirewallRule(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as FirewallAction,sourceNetwork: null == sourceNetwork ? _self.sourceNetwork : sourceNetwork // ignore: cast_nullable_to_non_nullable
as String,destinationNetwork: null == destinationNetwork ? _self.destinationNetwork : destinationNetwork // ignore: cast_nullable_to_non_nullable
as String,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String,ports: null == ports ? _self.ports : ports // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,lastModified: freezed == lastModified ? _self.lastModified : lastModified // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$NetworkRoute {

 String get id; String get destinationNetwork;// Target network CIDR
 String get nextHop;// Gateway IP
 int get metric; bool get active; String? get description;
/// Create a copy of NetworkRoute
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkRouteCopyWith<NetworkRoute> get copyWith => _$NetworkRouteCopyWithImpl<NetworkRoute>(this as NetworkRoute, _$identity);

  /// Serializes this NetworkRoute to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkRoute&&(identical(other.id, id) || other.id == id)&&(identical(other.destinationNetwork, destinationNetwork) || other.destinationNetwork == destinationNetwork)&&(identical(other.nextHop, nextHop) || other.nextHop == nextHop)&&(identical(other.metric, metric) || other.metric == metric)&&(identical(other.active, active) || other.active == active)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,destinationNetwork,nextHop,metric,active,description);

@override
String toString() {
  return 'NetworkRoute(id: $id, destinationNetwork: $destinationNetwork, nextHop: $nextHop, metric: $metric, active: $active, description: $description)';
}


}

/// @nodoc
abstract mixin class $NetworkRouteCopyWith<$Res>  {
  factory $NetworkRouteCopyWith(NetworkRoute value, $Res Function(NetworkRoute) _then) = _$NetworkRouteCopyWithImpl;
@useResult
$Res call({
 String id, String destinationNetwork, String nextHop, int metric, bool active, String? description
});




}
/// @nodoc
class _$NetworkRouteCopyWithImpl<$Res>
    implements $NetworkRouteCopyWith<$Res> {
  _$NetworkRouteCopyWithImpl(this._self, this._then);

  final NetworkRoute _self;
  final $Res Function(NetworkRoute) _then;

/// Create a copy of NetworkRoute
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? destinationNetwork = null,Object? nextHop = null,Object? metric = null,Object? active = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,destinationNetwork: null == destinationNetwork ? _self.destinationNetwork : destinationNetwork // ignore: cast_nullable_to_non_nullable
as String,nextHop: null == nextHop ? _self.nextHop : nextHop // ignore: cast_nullable_to_non_nullable
as String,metric: null == metric ? _self.metric : metric // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NetworkRoute].
extension NetworkRoutePatterns on NetworkRoute {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetworkRoute value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetworkRoute() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetworkRoute value)  $default,){
final _that = this;
switch (_that) {
case _NetworkRoute():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetworkRoute value)?  $default,){
final _that = this;
switch (_that) {
case _NetworkRoute() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String destinationNetwork,  String nextHop,  int metric,  bool active,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetworkRoute() when $default != null:
return $default(_that.id,_that.destinationNetwork,_that.nextHop,_that.metric,_that.active,_that.description);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String destinationNetwork,  String nextHop,  int metric,  bool active,  String? description)  $default,) {final _that = this;
switch (_that) {
case _NetworkRoute():
return $default(_that.id,_that.destinationNetwork,_that.nextHop,_that.metric,_that.active,_that.description);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String destinationNetwork,  String nextHop,  int metric,  bool active,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _NetworkRoute() when $default != null:
return $default(_that.id,_that.destinationNetwork,_that.nextHop,_that.metric,_that.active,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NetworkRoute implements NetworkRoute {
  const _NetworkRoute({required this.id, required this.destinationNetwork, required this.nextHop, required this.metric, this.active = true, this.description});
  factory _NetworkRoute.fromJson(Map<String, dynamic> json) => _$NetworkRouteFromJson(json);

@override final  String id;
@override final  String destinationNetwork;
// Target network CIDR
@override final  String nextHop;
// Gateway IP
@override final  int metric;
@override@JsonKey() final  bool active;
@override final  String? description;

/// Create a copy of NetworkRoute
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkRouteCopyWith<_NetworkRoute> get copyWith => __$NetworkRouteCopyWithImpl<_NetworkRoute>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NetworkRouteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkRoute&&(identical(other.id, id) || other.id == id)&&(identical(other.destinationNetwork, destinationNetwork) || other.destinationNetwork == destinationNetwork)&&(identical(other.nextHop, nextHop) || other.nextHop == nextHop)&&(identical(other.metric, metric) || other.metric == metric)&&(identical(other.active, active) || other.active == active)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,destinationNetwork,nextHop,metric,active,description);

@override
String toString() {
  return 'NetworkRoute(id: $id, destinationNetwork: $destinationNetwork, nextHop: $nextHop, metric: $metric, active: $active, description: $description)';
}


}

/// @nodoc
abstract mixin class _$NetworkRouteCopyWith<$Res> implements $NetworkRouteCopyWith<$Res> {
  factory _$NetworkRouteCopyWith(_NetworkRoute value, $Res Function(_NetworkRoute) _then) = __$NetworkRouteCopyWithImpl;
@override @useResult
$Res call({
 String id, String destinationNetwork, String nextHop, int metric, bool active, String? description
});




}
/// @nodoc
class __$NetworkRouteCopyWithImpl<$Res>
    implements _$NetworkRouteCopyWith<$Res> {
  __$NetworkRouteCopyWithImpl(this._self, this._then);

  final _NetworkRoute _self;
  final $Res Function(_NetworkRoute) _then;

/// Create a copy of NetworkRoute
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? destinationNetwork = null,Object? nextHop = null,Object? metric = null,Object? active = null,Object? description = freezed,}) {
  return _then(_NetworkRoute(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,destinationNetwork: null == destinationNetwork ? _self.destinationNetwork : destinationNetwork // ignore: cast_nullable_to_non_nullable
as String,nextHop: null == nextHop ? _self.nextHop : nextHop // ignore: cast_nullable_to_non_nullable
as String,metric: null == metric ? _self.metric : metric // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NetworkAccessPoint {

 String get id; String get name; NetworkAccessType get accessType; String? get sourceAssetId;// Host/device we're accessing from
 String? get sourceNetworkId;// Network segment we're coming from
 String? get description; bool get active; String? get credentials;// Reference to credential asset
 Map<String, String>? get accessDetails;// Protocol-specific details
 DateTime? get discoveredAt; DateTime? get lastTested;
/// Create a copy of NetworkAccessPoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkAccessPointCopyWith<NetworkAccessPoint> get copyWith => _$NetworkAccessPointCopyWithImpl<NetworkAccessPoint>(this as NetworkAccessPoint, _$identity);

  /// Serializes this NetworkAccessPoint to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkAccessPoint&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.accessType, accessType) || other.accessType == accessType)&&(identical(other.sourceAssetId, sourceAssetId) || other.sourceAssetId == sourceAssetId)&&(identical(other.sourceNetworkId, sourceNetworkId) || other.sourceNetworkId == sourceNetworkId)&&(identical(other.description, description) || other.description == description)&&(identical(other.active, active) || other.active == active)&&(identical(other.credentials, credentials) || other.credentials == credentials)&&const DeepCollectionEquality().equals(other.accessDetails, accessDetails)&&(identical(other.discoveredAt, discoveredAt) || other.discoveredAt == discoveredAt)&&(identical(other.lastTested, lastTested) || other.lastTested == lastTested));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,accessType,sourceAssetId,sourceNetworkId,description,active,credentials,const DeepCollectionEquality().hash(accessDetails),discoveredAt,lastTested);

@override
String toString() {
  return 'NetworkAccessPoint(id: $id, name: $name, accessType: $accessType, sourceAssetId: $sourceAssetId, sourceNetworkId: $sourceNetworkId, description: $description, active: $active, credentials: $credentials, accessDetails: $accessDetails, discoveredAt: $discoveredAt, lastTested: $lastTested)';
}


}

/// @nodoc
abstract mixin class $NetworkAccessPointCopyWith<$Res>  {
  factory $NetworkAccessPointCopyWith(NetworkAccessPoint value, $Res Function(NetworkAccessPoint) _then) = _$NetworkAccessPointCopyWithImpl;
@useResult
$Res call({
 String id, String name, NetworkAccessType accessType, String? sourceAssetId, String? sourceNetworkId, String? description, bool active, String? credentials, Map<String, String>? accessDetails, DateTime? discoveredAt, DateTime? lastTested
});




}
/// @nodoc
class _$NetworkAccessPointCopyWithImpl<$Res>
    implements $NetworkAccessPointCopyWith<$Res> {
  _$NetworkAccessPointCopyWithImpl(this._self, this._then);

  final NetworkAccessPoint _self;
  final $Res Function(NetworkAccessPoint) _then;

/// Create a copy of NetworkAccessPoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? accessType = null,Object? sourceAssetId = freezed,Object? sourceNetworkId = freezed,Object? description = freezed,Object? active = null,Object? credentials = freezed,Object? accessDetails = freezed,Object? discoveredAt = freezed,Object? lastTested = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,accessType: null == accessType ? _self.accessType : accessType // ignore: cast_nullable_to_non_nullable
as NetworkAccessType,sourceAssetId: freezed == sourceAssetId ? _self.sourceAssetId : sourceAssetId // ignore: cast_nullable_to_non_nullable
as String?,sourceNetworkId: freezed == sourceNetworkId ? _self.sourceNetworkId : sourceNetworkId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,credentials: freezed == credentials ? _self.credentials : credentials // ignore: cast_nullable_to_non_nullable
as String?,accessDetails: freezed == accessDetails ? _self.accessDetails : accessDetails // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,discoveredAt: freezed == discoveredAt ? _self.discoveredAt : discoveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastTested: freezed == lastTested ? _self.lastTested : lastTested // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NetworkAccessPoint].
extension NetworkAccessPointPatterns on NetworkAccessPoint {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetworkAccessPoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetworkAccessPoint() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetworkAccessPoint value)  $default,){
final _that = this;
switch (_that) {
case _NetworkAccessPoint():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetworkAccessPoint value)?  $default,){
final _that = this;
switch (_that) {
case _NetworkAccessPoint() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  NetworkAccessType accessType,  String? sourceAssetId,  String? sourceNetworkId,  String? description,  bool active,  String? credentials,  Map<String, String>? accessDetails,  DateTime? discoveredAt,  DateTime? lastTested)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetworkAccessPoint() when $default != null:
return $default(_that.id,_that.name,_that.accessType,_that.sourceAssetId,_that.sourceNetworkId,_that.description,_that.active,_that.credentials,_that.accessDetails,_that.discoveredAt,_that.lastTested);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  NetworkAccessType accessType,  String? sourceAssetId,  String? sourceNetworkId,  String? description,  bool active,  String? credentials,  Map<String, String>? accessDetails,  DateTime? discoveredAt,  DateTime? lastTested)  $default,) {final _that = this;
switch (_that) {
case _NetworkAccessPoint():
return $default(_that.id,_that.name,_that.accessType,_that.sourceAssetId,_that.sourceNetworkId,_that.description,_that.active,_that.credentials,_that.accessDetails,_that.discoveredAt,_that.lastTested);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  NetworkAccessType accessType,  String? sourceAssetId,  String? sourceNetworkId,  String? description,  bool active,  String? credentials,  Map<String, String>? accessDetails,  DateTime? discoveredAt,  DateTime? lastTested)?  $default,) {final _that = this;
switch (_that) {
case _NetworkAccessPoint() when $default != null:
return $default(_that.id,_that.name,_that.accessType,_that.sourceAssetId,_that.sourceNetworkId,_that.description,_that.active,_that.credentials,_that.accessDetails,_that.discoveredAt,_that.lastTested);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NetworkAccessPoint implements NetworkAccessPoint {
  const _NetworkAccessPoint({required this.id, required this.name, required this.accessType, this.sourceAssetId, this.sourceNetworkId, this.description, this.active = true, this.credentials, final  Map<String, String>? accessDetails, this.discoveredAt, this.lastTested}): _accessDetails = accessDetails;
  factory _NetworkAccessPoint.fromJson(Map<String, dynamic> json) => _$NetworkAccessPointFromJson(json);

@override final  String id;
@override final  String name;
@override final  NetworkAccessType accessType;
@override final  String? sourceAssetId;
// Host/device we're accessing from
@override final  String? sourceNetworkId;
// Network segment we're coming from
@override final  String? description;
@override@JsonKey() final  bool active;
@override final  String? credentials;
// Reference to credential asset
 final  Map<String, String>? _accessDetails;
// Reference to credential asset
@override Map<String, String>? get accessDetails {
  final value = _accessDetails;
  if (value == null) return null;
  if (_accessDetails is EqualUnmodifiableMapView) return _accessDetails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// Protocol-specific details
@override final  DateTime? discoveredAt;
@override final  DateTime? lastTested;

/// Create a copy of NetworkAccessPoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkAccessPointCopyWith<_NetworkAccessPoint> get copyWith => __$NetworkAccessPointCopyWithImpl<_NetworkAccessPoint>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NetworkAccessPointToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkAccessPoint&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.accessType, accessType) || other.accessType == accessType)&&(identical(other.sourceAssetId, sourceAssetId) || other.sourceAssetId == sourceAssetId)&&(identical(other.sourceNetworkId, sourceNetworkId) || other.sourceNetworkId == sourceNetworkId)&&(identical(other.description, description) || other.description == description)&&(identical(other.active, active) || other.active == active)&&(identical(other.credentials, credentials) || other.credentials == credentials)&&const DeepCollectionEquality().equals(other._accessDetails, _accessDetails)&&(identical(other.discoveredAt, discoveredAt) || other.discoveredAt == discoveredAt)&&(identical(other.lastTested, lastTested) || other.lastTested == lastTested));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,accessType,sourceAssetId,sourceNetworkId,description,active,credentials,const DeepCollectionEquality().hash(_accessDetails),discoveredAt,lastTested);

@override
String toString() {
  return 'NetworkAccessPoint(id: $id, name: $name, accessType: $accessType, sourceAssetId: $sourceAssetId, sourceNetworkId: $sourceNetworkId, description: $description, active: $active, credentials: $credentials, accessDetails: $accessDetails, discoveredAt: $discoveredAt, lastTested: $lastTested)';
}


}

/// @nodoc
abstract mixin class _$NetworkAccessPointCopyWith<$Res> implements $NetworkAccessPointCopyWith<$Res> {
  factory _$NetworkAccessPointCopyWith(_NetworkAccessPoint value, $Res Function(_NetworkAccessPoint) _then) = __$NetworkAccessPointCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, NetworkAccessType accessType, String? sourceAssetId, String? sourceNetworkId, String? description, bool active, String? credentials, Map<String, String>? accessDetails, DateTime? discoveredAt, DateTime? lastTested
});




}
/// @nodoc
class __$NetworkAccessPointCopyWithImpl<$Res>
    implements _$NetworkAccessPointCopyWith<$Res> {
  __$NetworkAccessPointCopyWithImpl(this._self, this._then);

  final _NetworkAccessPoint _self;
  final $Res Function(_NetworkAccessPoint) _then;

/// Create a copy of NetworkAccessPoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? accessType = null,Object? sourceAssetId = freezed,Object? sourceNetworkId = freezed,Object? description = freezed,Object? active = null,Object? credentials = freezed,Object? accessDetails = freezed,Object? discoveredAt = freezed,Object? lastTested = freezed,}) {
  return _then(_NetworkAccessPoint(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,accessType: null == accessType ? _self.accessType : accessType // ignore: cast_nullable_to_non_nullable
as NetworkAccessType,sourceAssetId: freezed == sourceAssetId ? _self.sourceAssetId : sourceAssetId // ignore: cast_nullable_to_non_nullable
as String?,sourceNetworkId: freezed == sourceNetworkId ? _self.sourceNetworkId : sourceNetworkId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,credentials: freezed == credentials ? _self.credentials : credentials // ignore: cast_nullable_to_non_nullable
as String?,accessDetails: freezed == accessDetails ? _self._accessDetails : accessDetails // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,discoveredAt: freezed == discoveredAt ? _self.discoveredAt : discoveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastTested: freezed == lastTested ? _self.lastTested : lastTested // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$NetworkHostReference {

 String get hostAssetId; String get ipAddress; String? get hostname; String? get macAddress; bool get isGateway; bool get isDhcpServer; bool get isDnsServer; bool get isCompromised; List<String>? get openPorts; DateTime? get lastSeen;
/// Create a copy of NetworkHostReference
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkHostReferenceCopyWith<NetworkHostReference> get copyWith => _$NetworkHostReferenceCopyWithImpl<NetworkHostReference>(this as NetworkHostReference, _$identity);

  /// Serializes this NetworkHostReference to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkHostReference&&(identical(other.hostAssetId, hostAssetId) || other.hostAssetId == hostAssetId)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.hostname, hostname) || other.hostname == hostname)&&(identical(other.macAddress, macAddress) || other.macAddress == macAddress)&&(identical(other.isGateway, isGateway) || other.isGateway == isGateway)&&(identical(other.isDhcpServer, isDhcpServer) || other.isDhcpServer == isDhcpServer)&&(identical(other.isDnsServer, isDnsServer) || other.isDnsServer == isDnsServer)&&(identical(other.isCompromised, isCompromised) || other.isCompromised == isCompromised)&&const DeepCollectionEquality().equals(other.openPorts, openPorts)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostAssetId,ipAddress,hostname,macAddress,isGateway,isDhcpServer,isDnsServer,isCompromised,const DeepCollectionEquality().hash(openPorts),lastSeen);

@override
String toString() {
  return 'NetworkHostReference(hostAssetId: $hostAssetId, ipAddress: $ipAddress, hostname: $hostname, macAddress: $macAddress, isGateway: $isGateway, isDhcpServer: $isDhcpServer, isDnsServer: $isDnsServer, isCompromised: $isCompromised, openPorts: $openPorts, lastSeen: $lastSeen)';
}


}

/// @nodoc
abstract mixin class $NetworkHostReferenceCopyWith<$Res>  {
  factory $NetworkHostReferenceCopyWith(NetworkHostReference value, $Res Function(NetworkHostReference) _then) = _$NetworkHostReferenceCopyWithImpl;
@useResult
$Res call({
 String hostAssetId, String ipAddress, String? hostname, String? macAddress, bool isGateway, bool isDhcpServer, bool isDnsServer, bool isCompromised, List<String>? openPorts, DateTime? lastSeen
});




}
/// @nodoc
class _$NetworkHostReferenceCopyWithImpl<$Res>
    implements $NetworkHostReferenceCopyWith<$Res> {
  _$NetworkHostReferenceCopyWithImpl(this._self, this._then);

  final NetworkHostReference _self;
  final $Res Function(NetworkHostReference) _then;

/// Create a copy of NetworkHostReference
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hostAssetId = null,Object? ipAddress = null,Object? hostname = freezed,Object? macAddress = freezed,Object? isGateway = null,Object? isDhcpServer = null,Object? isDnsServer = null,Object? isCompromised = null,Object? openPorts = freezed,Object? lastSeen = freezed,}) {
  return _then(_self.copyWith(
hostAssetId: null == hostAssetId ? _self.hostAssetId : hostAssetId // ignore: cast_nullable_to_non_nullable
as String,ipAddress: null == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String,hostname: freezed == hostname ? _self.hostname : hostname // ignore: cast_nullable_to_non_nullable
as String?,macAddress: freezed == macAddress ? _self.macAddress : macAddress // ignore: cast_nullable_to_non_nullable
as String?,isGateway: null == isGateway ? _self.isGateway : isGateway // ignore: cast_nullable_to_non_nullable
as bool,isDhcpServer: null == isDhcpServer ? _self.isDhcpServer : isDhcpServer // ignore: cast_nullable_to_non_nullable
as bool,isDnsServer: null == isDnsServer ? _self.isDnsServer : isDnsServer // ignore: cast_nullable_to_non_nullable
as bool,isCompromised: null == isCompromised ? _self.isCompromised : isCompromised // ignore: cast_nullable_to_non_nullable
as bool,openPorts: freezed == openPorts ? _self.openPorts : openPorts // ignore: cast_nullable_to_non_nullable
as List<String>?,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NetworkHostReference].
extension NetworkHostReferencePatterns on NetworkHostReference {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetworkHostReference value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetworkHostReference() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetworkHostReference value)  $default,){
final _that = this;
switch (_that) {
case _NetworkHostReference():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetworkHostReference value)?  $default,){
final _that = this;
switch (_that) {
case _NetworkHostReference() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String hostAssetId,  String ipAddress,  String? hostname,  String? macAddress,  bool isGateway,  bool isDhcpServer,  bool isDnsServer,  bool isCompromised,  List<String>? openPorts,  DateTime? lastSeen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetworkHostReference() when $default != null:
return $default(_that.hostAssetId,_that.ipAddress,_that.hostname,_that.macAddress,_that.isGateway,_that.isDhcpServer,_that.isDnsServer,_that.isCompromised,_that.openPorts,_that.lastSeen);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String hostAssetId,  String ipAddress,  String? hostname,  String? macAddress,  bool isGateway,  bool isDhcpServer,  bool isDnsServer,  bool isCompromised,  List<String>? openPorts,  DateTime? lastSeen)  $default,) {final _that = this;
switch (_that) {
case _NetworkHostReference():
return $default(_that.hostAssetId,_that.ipAddress,_that.hostname,_that.macAddress,_that.isGateway,_that.isDhcpServer,_that.isDnsServer,_that.isCompromised,_that.openPorts,_that.lastSeen);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String hostAssetId,  String ipAddress,  String? hostname,  String? macAddress,  bool isGateway,  bool isDhcpServer,  bool isDnsServer,  bool isCompromised,  List<String>? openPorts,  DateTime? lastSeen)?  $default,) {final _that = this;
switch (_that) {
case _NetworkHostReference() when $default != null:
return $default(_that.hostAssetId,_that.ipAddress,_that.hostname,_that.macAddress,_that.isGateway,_that.isDhcpServer,_that.isDnsServer,_that.isCompromised,_that.openPorts,_that.lastSeen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NetworkHostReference implements NetworkHostReference {
  const _NetworkHostReference({required this.hostAssetId, required this.ipAddress, this.hostname, this.macAddress, this.isGateway = false, this.isDhcpServer = false, this.isDnsServer = false, this.isCompromised = false, final  List<String>? openPorts, this.lastSeen}): _openPorts = openPorts;
  factory _NetworkHostReference.fromJson(Map<String, dynamic> json) => _$NetworkHostReferenceFromJson(json);

@override final  String hostAssetId;
@override final  String ipAddress;
@override final  String? hostname;
@override final  String? macAddress;
@override@JsonKey() final  bool isGateway;
@override@JsonKey() final  bool isDhcpServer;
@override@JsonKey() final  bool isDnsServer;
@override@JsonKey() final  bool isCompromised;
 final  List<String>? _openPorts;
@override List<String>? get openPorts {
  final value = _openPorts;
  if (value == null) return null;
  if (_openPorts is EqualUnmodifiableListView) return _openPorts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? lastSeen;

/// Create a copy of NetworkHostReference
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkHostReferenceCopyWith<_NetworkHostReference> get copyWith => __$NetworkHostReferenceCopyWithImpl<_NetworkHostReference>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NetworkHostReferenceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkHostReference&&(identical(other.hostAssetId, hostAssetId) || other.hostAssetId == hostAssetId)&&(identical(other.ipAddress, ipAddress) || other.ipAddress == ipAddress)&&(identical(other.hostname, hostname) || other.hostname == hostname)&&(identical(other.macAddress, macAddress) || other.macAddress == macAddress)&&(identical(other.isGateway, isGateway) || other.isGateway == isGateway)&&(identical(other.isDhcpServer, isDhcpServer) || other.isDhcpServer == isDhcpServer)&&(identical(other.isDnsServer, isDnsServer) || other.isDnsServer == isDnsServer)&&(identical(other.isCompromised, isCompromised) || other.isCompromised == isCompromised)&&const DeepCollectionEquality().equals(other._openPorts, _openPorts)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hostAssetId,ipAddress,hostname,macAddress,isGateway,isDhcpServer,isDnsServer,isCompromised,const DeepCollectionEquality().hash(_openPorts),lastSeen);

@override
String toString() {
  return 'NetworkHostReference(hostAssetId: $hostAssetId, ipAddress: $ipAddress, hostname: $hostname, macAddress: $macAddress, isGateway: $isGateway, isDhcpServer: $isDhcpServer, isDnsServer: $isDnsServer, isCompromised: $isCompromised, openPorts: $openPorts, lastSeen: $lastSeen)';
}


}

/// @nodoc
abstract mixin class _$NetworkHostReferenceCopyWith<$Res> implements $NetworkHostReferenceCopyWith<$Res> {
  factory _$NetworkHostReferenceCopyWith(_NetworkHostReference value, $Res Function(_NetworkHostReference) _then) = __$NetworkHostReferenceCopyWithImpl;
@override @useResult
$Res call({
 String hostAssetId, String ipAddress, String? hostname, String? macAddress, bool isGateway, bool isDhcpServer, bool isDnsServer, bool isCompromised, List<String>? openPorts, DateTime? lastSeen
});




}
/// @nodoc
class __$NetworkHostReferenceCopyWithImpl<$Res>
    implements _$NetworkHostReferenceCopyWith<$Res> {
  __$NetworkHostReferenceCopyWithImpl(this._self, this._then);

  final _NetworkHostReference _self;
  final $Res Function(_NetworkHostReference) _then;

/// Create a copy of NetworkHostReference
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hostAssetId = null,Object? ipAddress = null,Object? hostname = freezed,Object? macAddress = freezed,Object? isGateway = null,Object? isDhcpServer = null,Object? isDnsServer = null,Object? isCompromised = null,Object? openPorts = freezed,Object? lastSeen = freezed,}) {
  return _then(_NetworkHostReference(
hostAssetId: null == hostAssetId ? _self.hostAssetId : hostAssetId // ignore: cast_nullable_to_non_nullable
as String,ipAddress: null == ipAddress ? _self.ipAddress : ipAddress // ignore: cast_nullable_to_non_nullable
as String,hostname: freezed == hostname ? _self.hostname : hostname // ignore: cast_nullable_to_non_nullable
as String?,macAddress: freezed == macAddress ? _self.macAddress : macAddress // ignore: cast_nullable_to_non_nullable
as String?,isGateway: null == isGateway ? _self.isGateway : isGateway // ignore: cast_nullable_to_non_nullable
as bool,isDhcpServer: null == isDhcpServer ? _self.isDhcpServer : isDhcpServer // ignore: cast_nullable_to_non_nullable
as bool,isDnsServer: null == isDnsServer ? _self.isDnsServer : isDnsServer // ignore: cast_nullable_to_non_nullable
as bool,isCompromised: null == isCompromised ? _self.isCompromised : isCompromised // ignore: cast_nullable_to_non_nullable
as bool,openPorts: freezed == openPorts ? _self._openPorts : openPorts // ignore: cast_nullable_to_non_nullable
as List<String>?,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$RestrictedEnvironment {

 String get id; String get name; EnvironmentType get environmentType; List<RestrictionMechanism> get restrictions; String get hostAssetId;// Host where restriction exists
 String? get applicationAssetId;// Specific app if applicable
 String? get networkAssetId;// Network segment if applicable
 String? get description; List<String> get securityControlIds; List<String> get breakoutAttemptIds; Map<String, String>? get environmentDetails; DateTime? get discoveredAt; DateTime? get lastTested;
/// Create a copy of RestrictedEnvironment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RestrictedEnvironmentCopyWith<RestrictedEnvironment> get copyWith => _$RestrictedEnvironmentCopyWithImpl<RestrictedEnvironment>(this as RestrictedEnvironment, _$identity);

  /// Serializes this RestrictedEnvironment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RestrictedEnvironment&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.environmentType, environmentType) || other.environmentType == environmentType)&&const DeepCollectionEquality().equals(other.restrictions, restrictions)&&(identical(other.hostAssetId, hostAssetId) || other.hostAssetId == hostAssetId)&&(identical(other.applicationAssetId, applicationAssetId) || other.applicationAssetId == applicationAssetId)&&(identical(other.networkAssetId, networkAssetId) || other.networkAssetId == networkAssetId)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.securityControlIds, securityControlIds)&&const DeepCollectionEquality().equals(other.breakoutAttemptIds, breakoutAttemptIds)&&const DeepCollectionEquality().equals(other.environmentDetails, environmentDetails)&&(identical(other.discoveredAt, discoveredAt) || other.discoveredAt == discoveredAt)&&(identical(other.lastTested, lastTested) || other.lastTested == lastTested));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,environmentType,const DeepCollectionEquality().hash(restrictions),hostAssetId,applicationAssetId,networkAssetId,description,const DeepCollectionEquality().hash(securityControlIds),const DeepCollectionEquality().hash(breakoutAttemptIds),const DeepCollectionEquality().hash(environmentDetails),discoveredAt,lastTested);

@override
String toString() {
  return 'RestrictedEnvironment(id: $id, name: $name, environmentType: $environmentType, restrictions: $restrictions, hostAssetId: $hostAssetId, applicationAssetId: $applicationAssetId, networkAssetId: $networkAssetId, description: $description, securityControlIds: $securityControlIds, breakoutAttemptIds: $breakoutAttemptIds, environmentDetails: $environmentDetails, discoveredAt: $discoveredAt, lastTested: $lastTested)';
}


}

/// @nodoc
abstract mixin class $RestrictedEnvironmentCopyWith<$Res>  {
  factory $RestrictedEnvironmentCopyWith(RestrictedEnvironment value, $Res Function(RestrictedEnvironment) _then) = _$RestrictedEnvironmentCopyWithImpl;
@useResult
$Res call({
 String id, String name, EnvironmentType environmentType, List<RestrictionMechanism> restrictions, String hostAssetId, String? applicationAssetId, String? networkAssetId, String? description, List<String> securityControlIds, List<String> breakoutAttemptIds, Map<String, String>? environmentDetails, DateTime? discoveredAt, DateTime? lastTested
});




}
/// @nodoc
class _$RestrictedEnvironmentCopyWithImpl<$Res>
    implements $RestrictedEnvironmentCopyWith<$Res> {
  _$RestrictedEnvironmentCopyWithImpl(this._self, this._then);

  final RestrictedEnvironment _self;
  final $Res Function(RestrictedEnvironment) _then;

/// Create a copy of RestrictedEnvironment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? environmentType = null,Object? restrictions = null,Object? hostAssetId = null,Object? applicationAssetId = freezed,Object? networkAssetId = freezed,Object? description = freezed,Object? securityControlIds = null,Object? breakoutAttemptIds = null,Object? environmentDetails = freezed,Object? discoveredAt = freezed,Object? lastTested = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,environmentType: null == environmentType ? _self.environmentType : environmentType // ignore: cast_nullable_to_non_nullable
as EnvironmentType,restrictions: null == restrictions ? _self.restrictions : restrictions // ignore: cast_nullable_to_non_nullable
as List<RestrictionMechanism>,hostAssetId: null == hostAssetId ? _self.hostAssetId : hostAssetId // ignore: cast_nullable_to_non_nullable
as String,applicationAssetId: freezed == applicationAssetId ? _self.applicationAssetId : applicationAssetId // ignore: cast_nullable_to_non_nullable
as String?,networkAssetId: freezed == networkAssetId ? _self.networkAssetId : networkAssetId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,securityControlIds: null == securityControlIds ? _self.securityControlIds : securityControlIds // ignore: cast_nullable_to_non_nullable
as List<String>,breakoutAttemptIds: null == breakoutAttemptIds ? _self.breakoutAttemptIds : breakoutAttemptIds // ignore: cast_nullable_to_non_nullable
as List<String>,environmentDetails: freezed == environmentDetails ? _self.environmentDetails : environmentDetails // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,discoveredAt: freezed == discoveredAt ? _self.discoveredAt : discoveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastTested: freezed == lastTested ? _self.lastTested : lastTested // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RestrictedEnvironment].
extension RestrictedEnvironmentPatterns on RestrictedEnvironment {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RestrictedEnvironment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RestrictedEnvironment() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RestrictedEnvironment value)  $default,){
final _that = this;
switch (_that) {
case _RestrictedEnvironment():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RestrictedEnvironment value)?  $default,){
final _that = this;
switch (_that) {
case _RestrictedEnvironment() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  EnvironmentType environmentType,  List<RestrictionMechanism> restrictions,  String hostAssetId,  String? applicationAssetId,  String? networkAssetId,  String? description,  List<String> securityControlIds,  List<String> breakoutAttemptIds,  Map<String, String>? environmentDetails,  DateTime? discoveredAt,  DateTime? lastTested)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RestrictedEnvironment() when $default != null:
return $default(_that.id,_that.name,_that.environmentType,_that.restrictions,_that.hostAssetId,_that.applicationAssetId,_that.networkAssetId,_that.description,_that.securityControlIds,_that.breakoutAttemptIds,_that.environmentDetails,_that.discoveredAt,_that.lastTested);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  EnvironmentType environmentType,  List<RestrictionMechanism> restrictions,  String hostAssetId,  String? applicationAssetId,  String? networkAssetId,  String? description,  List<String> securityControlIds,  List<String> breakoutAttemptIds,  Map<String, String>? environmentDetails,  DateTime? discoveredAt,  DateTime? lastTested)  $default,) {final _that = this;
switch (_that) {
case _RestrictedEnvironment():
return $default(_that.id,_that.name,_that.environmentType,_that.restrictions,_that.hostAssetId,_that.applicationAssetId,_that.networkAssetId,_that.description,_that.securityControlIds,_that.breakoutAttemptIds,_that.environmentDetails,_that.discoveredAt,_that.lastTested);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  EnvironmentType environmentType,  List<RestrictionMechanism> restrictions,  String hostAssetId,  String? applicationAssetId,  String? networkAssetId,  String? description,  List<String> securityControlIds,  List<String> breakoutAttemptIds,  Map<String, String>? environmentDetails,  DateTime? discoveredAt,  DateTime? lastTested)?  $default,) {final _that = this;
switch (_that) {
case _RestrictedEnvironment() when $default != null:
return $default(_that.id,_that.name,_that.environmentType,_that.restrictions,_that.hostAssetId,_that.applicationAssetId,_that.networkAssetId,_that.description,_that.securityControlIds,_that.breakoutAttemptIds,_that.environmentDetails,_that.discoveredAt,_that.lastTested);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RestrictedEnvironment implements RestrictedEnvironment {
  const _RestrictedEnvironment({required this.id, required this.name, required this.environmentType, required final  List<RestrictionMechanism> restrictions, required this.hostAssetId, this.applicationAssetId, this.networkAssetId, this.description, final  List<String> securityControlIds = const [], final  List<String> breakoutAttemptIds = const [], final  Map<String, String>? environmentDetails, this.discoveredAt, this.lastTested}): _restrictions = restrictions,_securityControlIds = securityControlIds,_breakoutAttemptIds = breakoutAttemptIds,_environmentDetails = environmentDetails;
  factory _RestrictedEnvironment.fromJson(Map<String, dynamic> json) => _$RestrictedEnvironmentFromJson(json);

@override final  String id;
@override final  String name;
@override final  EnvironmentType environmentType;
 final  List<RestrictionMechanism> _restrictions;
@override List<RestrictionMechanism> get restrictions {
  if (_restrictions is EqualUnmodifiableListView) return _restrictions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_restrictions);
}

@override final  String hostAssetId;
// Host where restriction exists
@override final  String? applicationAssetId;
// Specific app if applicable
@override final  String? networkAssetId;
// Network segment if applicable
@override final  String? description;
 final  List<String> _securityControlIds;
@override@JsonKey() List<String> get securityControlIds {
  if (_securityControlIds is EqualUnmodifiableListView) return _securityControlIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_securityControlIds);
}

 final  List<String> _breakoutAttemptIds;
@override@JsonKey() List<String> get breakoutAttemptIds {
  if (_breakoutAttemptIds is EqualUnmodifiableListView) return _breakoutAttemptIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_breakoutAttemptIds);
}

 final  Map<String, String>? _environmentDetails;
@override Map<String, String>? get environmentDetails {
  final value = _environmentDetails;
  if (value == null) return null;
  if (_environmentDetails is EqualUnmodifiableMapView) return _environmentDetails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? discoveredAt;
@override final  DateTime? lastTested;

/// Create a copy of RestrictedEnvironment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RestrictedEnvironmentCopyWith<_RestrictedEnvironment> get copyWith => __$RestrictedEnvironmentCopyWithImpl<_RestrictedEnvironment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RestrictedEnvironmentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RestrictedEnvironment&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.environmentType, environmentType) || other.environmentType == environmentType)&&const DeepCollectionEquality().equals(other._restrictions, _restrictions)&&(identical(other.hostAssetId, hostAssetId) || other.hostAssetId == hostAssetId)&&(identical(other.applicationAssetId, applicationAssetId) || other.applicationAssetId == applicationAssetId)&&(identical(other.networkAssetId, networkAssetId) || other.networkAssetId == networkAssetId)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._securityControlIds, _securityControlIds)&&const DeepCollectionEquality().equals(other._breakoutAttemptIds, _breakoutAttemptIds)&&const DeepCollectionEquality().equals(other._environmentDetails, _environmentDetails)&&(identical(other.discoveredAt, discoveredAt) || other.discoveredAt == discoveredAt)&&(identical(other.lastTested, lastTested) || other.lastTested == lastTested));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,environmentType,const DeepCollectionEquality().hash(_restrictions),hostAssetId,applicationAssetId,networkAssetId,description,const DeepCollectionEquality().hash(_securityControlIds),const DeepCollectionEquality().hash(_breakoutAttemptIds),const DeepCollectionEquality().hash(_environmentDetails),discoveredAt,lastTested);

@override
String toString() {
  return 'RestrictedEnvironment(id: $id, name: $name, environmentType: $environmentType, restrictions: $restrictions, hostAssetId: $hostAssetId, applicationAssetId: $applicationAssetId, networkAssetId: $networkAssetId, description: $description, securityControlIds: $securityControlIds, breakoutAttemptIds: $breakoutAttemptIds, environmentDetails: $environmentDetails, discoveredAt: $discoveredAt, lastTested: $lastTested)';
}


}

/// @nodoc
abstract mixin class _$RestrictedEnvironmentCopyWith<$Res> implements $RestrictedEnvironmentCopyWith<$Res> {
  factory _$RestrictedEnvironmentCopyWith(_RestrictedEnvironment value, $Res Function(_RestrictedEnvironment) _then) = __$RestrictedEnvironmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, EnvironmentType environmentType, List<RestrictionMechanism> restrictions, String hostAssetId, String? applicationAssetId, String? networkAssetId, String? description, List<String> securityControlIds, List<String> breakoutAttemptIds, Map<String, String>? environmentDetails, DateTime? discoveredAt, DateTime? lastTested
});




}
/// @nodoc
class __$RestrictedEnvironmentCopyWithImpl<$Res>
    implements _$RestrictedEnvironmentCopyWith<$Res> {
  __$RestrictedEnvironmentCopyWithImpl(this._self, this._then);

  final _RestrictedEnvironment _self;
  final $Res Function(_RestrictedEnvironment) _then;

/// Create a copy of RestrictedEnvironment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? environmentType = null,Object? restrictions = null,Object? hostAssetId = null,Object? applicationAssetId = freezed,Object? networkAssetId = freezed,Object? description = freezed,Object? securityControlIds = null,Object? breakoutAttemptIds = null,Object? environmentDetails = freezed,Object? discoveredAt = freezed,Object? lastTested = freezed,}) {
  return _then(_RestrictedEnvironment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,environmentType: null == environmentType ? _self.environmentType : environmentType // ignore: cast_nullable_to_non_nullable
as EnvironmentType,restrictions: null == restrictions ? _self._restrictions : restrictions // ignore: cast_nullable_to_non_nullable
as List<RestrictionMechanism>,hostAssetId: null == hostAssetId ? _self.hostAssetId : hostAssetId // ignore: cast_nullable_to_non_nullable
as String,applicationAssetId: freezed == applicationAssetId ? _self.applicationAssetId : applicationAssetId // ignore: cast_nullable_to_non_nullable
as String?,networkAssetId: freezed == networkAssetId ? _self.networkAssetId : networkAssetId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,securityControlIds: null == securityControlIds ? _self._securityControlIds : securityControlIds // ignore: cast_nullable_to_non_nullable
as List<String>,breakoutAttemptIds: null == breakoutAttemptIds ? _self._breakoutAttemptIds : breakoutAttemptIds // ignore: cast_nullable_to_non_nullable
as List<String>,environmentDetails: freezed == environmentDetails ? _self._environmentDetails : environmentDetails // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,discoveredAt: freezed == discoveredAt ? _self.discoveredAt : discoveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastTested: freezed == lastTested ? _self.lastTested : lastTested // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$BreakoutAttempt {

 String get id; String get name; String get restrictedEnvironmentId; String get techniqueId; BreakoutStatus get status; DateTime get attemptedAt; String? get testerAssetId;// Person performing test
 String? get description; String? get command;// Command/payload used
 String? get output;// Command output
 String? get evidence;// Screenshots, logs, etc.
 BreakoutImpact? get impact; List<String>? get assetsGained;// New assets accessed
 List<String>? get credentialsGained;// New credentials obtained
 Map<String, String>? get attemptDetails;// Tool-specific data
 String? get blockedBy;// Security control that blocked
 DateTime? get completedAt; String? get notes;
/// Create a copy of BreakoutAttempt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreakoutAttemptCopyWith<BreakoutAttempt> get copyWith => _$BreakoutAttemptCopyWithImpl<BreakoutAttempt>(this as BreakoutAttempt, _$identity);

  /// Serializes this BreakoutAttempt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreakoutAttempt&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.restrictedEnvironmentId, restrictedEnvironmentId) || other.restrictedEnvironmentId == restrictedEnvironmentId)&&(identical(other.techniqueId, techniqueId) || other.techniqueId == techniqueId)&&(identical(other.status, status) || other.status == status)&&(identical(other.attemptedAt, attemptedAt) || other.attemptedAt == attemptedAt)&&(identical(other.testerAssetId, testerAssetId) || other.testerAssetId == testerAssetId)&&(identical(other.description, description) || other.description == description)&&(identical(other.command, command) || other.command == command)&&(identical(other.output, output) || other.output == output)&&(identical(other.evidence, evidence) || other.evidence == evidence)&&(identical(other.impact, impact) || other.impact == impact)&&const DeepCollectionEquality().equals(other.assetsGained, assetsGained)&&const DeepCollectionEquality().equals(other.credentialsGained, credentialsGained)&&const DeepCollectionEquality().equals(other.attemptDetails, attemptDetails)&&(identical(other.blockedBy, blockedBy) || other.blockedBy == blockedBy)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,restrictedEnvironmentId,techniqueId,status,attemptedAt,testerAssetId,description,command,output,evidence,impact,const DeepCollectionEquality().hash(assetsGained),const DeepCollectionEquality().hash(credentialsGained),const DeepCollectionEquality().hash(attemptDetails),blockedBy,completedAt,notes);

@override
String toString() {
  return 'BreakoutAttempt(id: $id, name: $name, restrictedEnvironmentId: $restrictedEnvironmentId, techniqueId: $techniqueId, status: $status, attemptedAt: $attemptedAt, testerAssetId: $testerAssetId, description: $description, command: $command, output: $output, evidence: $evidence, impact: $impact, assetsGained: $assetsGained, credentialsGained: $credentialsGained, attemptDetails: $attemptDetails, blockedBy: $blockedBy, completedAt: $completedAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class $BreakoutAttemptCopyWith<$Res>  {
  factory $BreakoutAttemptCopyWith(BreakoutAttempt value, $Res Function(BreakoutAttempt) _then) = _$BreakoutAttemptCopyWithImpl;
@useResult
$Res call({
 String id, String name, String restrictedEnvironmentId, String techniqueId, BreakoutStatus status, DateTime attemptedAt, String? testerAssetId, String? description, String? command, String? output, String? evidence, BreakoutImpact? impact, List<String>? assetsGained, List<String>? credentialsGained, Map<String, String>? attemptDetails, String? blockedBy, DateTime? completedAt, String? notes
});




}
/// @nodoc
class _$BreakoutAttemptCopyWithImpl<$Res>
    implements $BreakoutAttemptCopyWith<$Res> {
  _$BreakoutAttemptCopyWithImpl(this._self, this._then);

  final BreakoutAttempt _self;
  final $Res Function(BreakoutAttempt) _then;

/// Create a copy of BreakoutAttempt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? restrictedEnvironmentId = null,Object? techniqueId = null,Object? status = null,Object? attemptedAt = null,Object? testerAssetId = freezed,Object? description = freezed,Object? command = freezed,Object? output = freezed,Object? evidence = freezed,Object? impact = freezed,Object? assetsGained = freezed,Object? credentialsGained = freezed,Object? attemptDetails = freezed,Object? blockedBy = freezed,Object? completedAt = freezed,Object? notes = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,restrictedEnvironmentId: null == restrictedEnvironmentId ? _self.restrictedEnvironmentId : restrictedEnvironmentId // ignore: cast_nullable_to_non_nullable
as String,techniqueId: null == techniqueId ? _self.techniqueId : techniqueId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BreakoutStatus,attemptedAt: null == attemptedAt ? _self.attemptedAt : attemptedAt // ignore: cast_nullable_to_non_nullable
as DateTime,testerAssetId: freezed == testerAssetId ? _self.testerAssetId : testerAssetId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,command: freezed == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String?,output: freezed == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String?,evidence: freezed == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as String?,impact: freezed == impact ? _self.impact : impact // ignore: cast_nullable_to_non_nullable
as BreakoutImpact?,assetsGained: freezed == assetsGained ? _self.assetsGained : assetsGained // ignore: cast_nullable_to_non_nullable
as List<String>?,credentialsGained: freezed == credentialsGained ? _self.credentialsGained : credentialsGained // ignore: cast_nullable_to_non_nullable
as List<String>?,attemptDetails: freezed == attemptDetails ? _self.attemptDetails : attemptDetails // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,blockedBy: freezed == blockedBy ? _self.blockedBy : blockedBy // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BreakoutAttempt].
extension BreakoutAttemptPatterns on BreakoutAttempt {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreakoutAttempt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreakoutAttempt() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreakoutAttempt value)  $default,){
final _that = this;
switch (_that) {
case _BreakoutAttempt():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreakoutAttempt value)?  $default,){
final _that = this;
switch (_that) {
case _BreakoutAttempt() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String restrictedEnvironmentId,  String techniqueId,  BreakoutStatus status,  DateTime attemptedAt,  String? testerAssetId,  String? description,  String? command,  String? output,  String? evidence,  BreakoutImpact? impact,  List<String>? assetsGained,  List<String>? credentialsGained,  Map<String, String>? attemptDetails,  String? blockedBy,  DateTime? completedAt,  String? notes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreakoutAttempt() when $default != null:
return $default(_that.id,_that.name,_that.restrictedEnvironmentId,_that.techniqueId,_that.status,_that.attemptedAt,_that.testerAssetId,_that.description,_that.command,_that.output,_that.evidence,_that.impact,_that.assetsGained,_that.credentialsGained,_that.attemptDetails,_that.blockedBy,_that.completedAt,_that.notes);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String restrictedEnvironmentId,  String techniqueId,  BreakoutStatus status,  DateTime attemptedAt,  String? testerAssetId,  String? description,  String? command,  String? output,  String? evidence,  BreakoutImpact? impact,  List<String>? assetsGained,  List<String>? credentialsGained,  Map<String, String>? attemptDetails,  String? blockedBy,  DateTime? completedAt,  String? notes)  $default,) {final _that = this;
switch (_that) {
case _BreakoutAttempt():
return $default(_that.id,_that.name,_that.restrictedEnvironmentId,_that.techniqueId,_that.status,_that.attemptedAt,_that.testerAssetId,_that.description,_that.command,_that.output,_that.evidence,_that.impact,_that.assetsGained,_that.credentialsGained,_that.attemptDetails,_that.blockedBy,_that.completedAt,_that.notes);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String restrictedEnvironmentId,  String techniqueId,  BreakoutStatus status,  DateTime attemptedAt,  String? testerAssetId,  String? description,  String? command,  String? output,  String? evidence,  BreakoutImpact? impact,  List<String>? assetsGained,  List<String>? credentialsGained,  Map<String, String>? attemptDetails,  String? blockedBy,  DateTime? completedAt,  String? notes)?  $default,) {final _that = this;
switch (_that) {
case _BreakoutAttempt() when $default != null:
return $default(_that.id,_that.name,_that.restrictedEnvironmentId,_that.techniqueId,_that.status,_that.attemptedAt,_that.testerAssetId,_that.description,_that.command,_that.output,_that.evidence,_that.impact,_that.assetsGained,_that.credentialsGained,_that.attemptDetails,_that.blockedBy,_that.completedAt,_that.notes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BreakoutAttempt implements BreakoutAttempt {
  const _BreakoutAttempt({required this.id, required this.name, required this.restrictedEnvironmentId, required this.techniqueId, required this.status, required this.attemptedAt, this.testerAssetId, this.description, this.command, this.output, this.evidence, this.impact, final  List<String>? assetsGained, final  List<String>? credentialsGained, final  Map<String, String>? attemptDetails, this.blockedBy, this.completedAt, this.notes}): _assetsGained = assetsGained,_credentialsGained = credentialsGained,_attemptDetails = attemptDetails;
  factory _BreakoutAttempt.fromJson(Map<String, dynamic> json) => _$BreakoutAttemptFromJson(json);

@override final  String id;
@override final  String name;
@override final  String restrictedEnvironmentId;
@override final  String techniqueId;
@override final  BreakoutStatus status;
@override final  DateTime attemptedAt;
@override final  String? testerAssetId;
// Person performing test
@override final  String? description;
@override final  String? command;
// Command/payload used
@override final  String? output;
// Command output
@override final  String? evidence;
// Screenshots, logs, etc.
@override final  BreakoutImpact? impact;
 final  List<String>? _assetsGained;
@override List<String>? get assetsGained {
  final value = _assetsGained;
  if (value == null) return null;
  if (_assetsGained is EqualUnmodifiableListView) return _assetsGained;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// New assets accessed
 final  List<String>? _credentialsGained;
// New assets accessed
@override List<String>? get credentialsGained {
  final value = _credentialsGained;
  if (value == null) return null;
  if (_credentialsGained is EqualUnmodifiableListView) return _credentialsGained;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// New credentials obtained
 final  Map<String, String>? _attemptDetails;
// New credentials obtained
@override Map<String, String>? get attemptDetails {
  final value = _attemptDetails;
  if (value == null) return null;
  if (_attemptDetails is EqualUnmodifiableMapView) return _attemptDetails;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// Tool-specific data
@override final  String? blockedBy;
// Security control that blocked
@override final  DateTime? completedAt;
@override final  String? notes;

/// Create a copy of BreakoutAttempt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreakoutAttemptCopyWith<_BreakoutAttempt> get copyWith => __$BreakoutAttemptCopyWithImpl<_BreakoutAttempt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreakoutAttemptToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreakoutAttempt&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.restrictedEnvironmentId, restrictedEnvironmentId) || other.restrictedEnvironmentId == restrictedEnvironmentId)&&(identical(other.techniqueId, techniqueId) || other.techniqueId == techniqueId)&&(identical(other.status, status) || other.status == status)&&(identical(other.attemptedAt, attemptedAt) || other.attemptedAt == attemptedAt)&&(identical(other.testerAssetId, testerAssetId) || other.testerAssetId == testerAssetId)&&(identical(other.description, description) || other.description == description)&&(identical(other.command, command) || other.command == command)&&(identical(other.output, output) || other.output == output)&&(identical(other.evidence, evidence) || other.evidence == evidence)&&(identical(other.impact, impact) || other.impact == impact)&&const DeepCollectionEquality().equals(other._assetsGained, _assetsGained)&&const DeepCollectionEquality().equals(other._credentialsGained, _credentialsGained)&&const DeepCollectionEquality().equals(other._attemptDetails, _attemptDetails)&&(identical(other.blockedBy, blockedBy) || other.blockedBy == blockedBy)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.notes, notes) || other.notes == notes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,restrictedEnvironmentId,techniqueId,status,attemptedAt,testerAssetId,description,command,output,evidence,impact,const DeepCollectionEquality().hash(_assetsGained),const DeepCollectionEquality().hash(_credentialsGained),const DeepCollectionEquality().hash(_attemptDetails),blockedBy,completedAt,notes);

@override
String toString() {
  return 'BreakoutAttempt(id: $id, name: $name, restrictedEnvironmentId: $restrictedEnvironmentId, techniqueId: $techniqueId, status: $status, attemptedAt: $attemptedAt, testerAssetId: $testerAssetId, description: $description, command: $command, output: $output, evidence: $evidence, impact: $impact, assetsGained: $assetsGained, credentialsGained: $credentialsGained, attemptDetails: $attemptDetails, blockedBy: $blockedBy, completedAt: $completedAt, notes: $notes)';
}


}

/// @nodoc
abstract mixin class _$BreakoutAttemptCopyWith<$Res> implements $BreakoutAttemptCopyWith<$Res> {
  factory _$BreakoutAttemptCopyWith(_BreakoutAttempt value, $Res Function(_BreakoutAttempt) _then) = __$BreakoutAttemptCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String restrictedEnvironmentId, String techniqueId, BreakoutStatus status, DateTime attemptedAt, String? testerAssetId, String? description, String? command, String? output, String? evidence, BreakoutImpact? impact, List<String>? assetsGained, List<String>? credentialsGained, Map<String, String>? attemptDetails, String? blockedBy, DateTime? completedAt, String? notes
});




}
/// @nodoc
class __$BreakoutAttemptCopyWithImpl<$Res>
    implements _$BreakoutAttemptCopyWith<$Res> {
  __$BreakoutAttemptCopyWithImpl(this._self, this._then);

  final _BreakoutAttempt _self;
  final $Res Function(_BreakoutAttempt) _then;

/// Create a copy of BreakoutAttempt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? restrictedEnvironmentId = null,Object? techniqueId = null,Object? status = null,Object? attemptedAt = null,Object? testerAssetId = freezed,Object? description = freezed,Object? command = freezed,Object? output = freezed,Object? evidence = freezed,Object? impact = freezed,Object? assetsGained = freezed,Object? credentialsGained = freezed,Object? attemptDetails = freezed,Object? blockedBy = freezed,Object? completedAt = freezed,Object? notes = freezed,}) {
  return _then(_BreakoutAttempt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,restrictedEnvironmentId: null == restrictedEnvironmentId ? _self.restrictedEnvironmentId : restrictedEnvironmentId // ignore: cast_nullable_to_non_nullable
as String,techniqueId: null == techniqueId ? _self.techniqueId : techniqueId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BreakoutStatus,attemptedAt: null == attemptedAt ? _self.attemptedAt : attemptedAt // ignore: cast_nullable_to_non_nullable
as DateTime,testerAssetId: freezed == testerAssetId ? _self.testerAssetId : testerAssetId // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,command: freezed == command ? _self.command : command // ignore: cast_nullable_to_non_nullable
as String?,output: freezed == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String?,evidence: freezed == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as String?,impact: freezed == impact ? _self.impact : impact // ignore: cast_nullable_to_non_nullable
as BreakoutImpact?,assetsGained: freezed == assetsGained ? _self._assetsGained : assetsGained // ignore: cast_nullable_to_non_nullable
as List<String>?,credentialsGained: freezed == credentialsGained ? _self._credentialsGained : credentialsGained // ignore: cast_nullable_to_non_nullable
as List<String>?,attemptDetails: freezed == attemptDetails ? _self._attemptDetails : attemptDetails // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,blockedBy: freezed == blockedBy ? _self.blockedBy : blockedBy // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$BreakoutTechnique {

 String get id; String get name; TechniqueCategory get category; List<EnvironmentType> get applicableEnvironments; List<RestrictionMechanism> get targetsRestrictions; String? get description; String? get methodology;// Step-by-step process
 String? get payload;// Example command/code
 List<String>? get prerequisites;// Required conditions
 List<String>? get indicators;// Signs of success
 List<String>? get mitigations;// How to prevent
 String? get cveReference;// CVE if applicable
 String? get source;// Where technique came from
 Map<String, String>? get metadata;// MITRE ATT&CK, etc.
 DateTime? get discoveredAt; DateTime? get lastUpdated;
/// Create a copy of BreakoutTechnique
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BreakoutTechniqueCopyWith<BreakoutTechnique> get copyWith => _$BreakoutTechniqueCopyWithImpl<BreakoutTechnique>(this as BreakoutTechnique, _$identity);

  /// Serializes this BreakoutTechnique to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BreakoutTechnique&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other.applicableEnvironments, applicableEnvironments)&&const DeepCollectionEquality().equals(other.targetsRestrictions, targetsRestrictions)&&(identical(other.description, description) || other.description == description)&&(identical(other.methodology, methodology) || other.methodology == methodology)&&(identical(other.payload, payload) || other.payload == payload)&&const DeepCollectionEquality().equals(other.prerequisites, prerequisites)&&const DeepCollectionEquality().equals(other.indicators, indicators)&&const DeepCollectionEquality().equals(other.mitigations, mitigations)&&(identical(other.cveReference, cveReference) || other.cveReference == cveReference)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.discoveredAt, discoveredAt) || other.discoveredAt == discoveredAt)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,const DeepCollectionEquality().hash(applicableEnvironments),const DeepCollectionEquality().hash(targetsRestrictions),description,methodology,payload,const DeepCollectionEquality().hash(prerequisites),const DeepCollectionEquality().hash(indicators),const DeepCollectionEquality().hash(mitigations),cveReference,source,const DeepCollectionEquality().hash(metadata),discoveredAt,lastUpdated);

@override
String toString() {
  return 'BreakoutTechnique(id: $id, name: $name, category: $category, applicableEnvironments: $applicableEnvironments, targetsRestrictions: $targetsRestrictions, description: $description, methodology: $methodology, payload: $payload, prerequisites: $prerequisites, indicators: $indicators, mitigations: $mitigations, cveReference: $cveReference, source: $source, metadata: $metadata, discoveredAt: $discoveredAt, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $BreakoutTechniqueCopyWith<$Res>  {
  factory $BreakoutTechniqueCopyWith(BreakoutTechnique value, $Res Function(BreakoutTechnique) _then) = _$BreakoutTechniqueCopyWithImpl;
@useResult
$Res call({
 String id, String name, TechniqueCategory category, List<EnvironmentType> applicableEnvironments, List<RestrictionMechanism> targetsRestrictions, String? description, String? methodology, String? payload, List<String>? prerequisites, List<String>? indicators, List<String>? mitigations, String? cveReference, String? source, Map<String, String>? metadata, DateTime? discoveredAt, DateTime? lastUpdated
});




}
/// @nodoc
class _$BreakoutTechniqueCopyWithImpl<$Res>
    implements $BreakoutTechniqueCopyWith<$Res> {
  _$BreakoutTechniqueCopyWithImpl(this._self, this._then);

  final BreakoutTechnique _self;
  final $Res Function(BreakoutTechnique) _then;

/// Create a copy of BreakoutTechnique
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? applicableEnvironments = null,Object? targetsRestrictions = null,Object? description = freezed,Object? methodology = freezed,Object? payload = freezed,Object? prerequisites = freezed,Object? indicators = freezed,Object? mitigations = freezed,Object? cveReference = freezed,Object? source = freezed,Object? metadata = freezed,Object? discoveredAt = freezed,Object? lastUpdated = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TechniqueCategory,applicableEnvironments: null == applicableEnvironments ? _self.applicableEnvironments : applicableEnvironments // ignore: cast_nullable_to_non_nullable
as List<EnvironmentType>,targetsRestrictions: null == targetsRestrictions ? _self.targetsRestrictions : targetsRestrictions // ignore: cast_nullable_to_non_nullable
as List<RestrictionMechanism>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,methodology: freezed == methodology ? _self.methodology : methodology // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String?,prerequisites: freezed == prerequisites ? _self.prerequisites : prerequisites // ignore: cast_nullable_to_non_nullable
as List<String>?,indicators: freezed == indicators ? _self.indicators : indicators // ignore: cast_nullable_to_non_nullable
as List<String>?,mitigations: freezed == mitigations ? _self.mitigations : mitigations // ignore: cast_nullable_to_non_nullable
as List<String>?,cveReference: freezed == cveReference ? _self.cveReference : cveReference // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,discoveredAt: freezed == discoveredAt ? _self.discoveredAt : discoveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BreakoutTechnique].
extension BreakoutTechniquePatterns on BreakoutTechnique {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BreakoutTechnique value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BreakoutTechnique() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BreakoutTechnique value)  $default,){
final _that = this;
switch (_that) {
case _BreakoutTechnique():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BreakoutTechnique value)?  $default,){
final _that = this;
switch (_that) {
case _BreakoutTechnique() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  TechniqueCategory category,  List<EnvironmentType> applicableEnvironments,  List<RestrictionMechanism> targetsRestrictions,  String? description,  String? methodology,  String? payload,  List<String>? prerequisites,  List<String>? indicators,  List<String>? mitigations,  String? cveReference,  String? source,  Map<String, String>? metadata,  DateTime? discoveredAt,  DateTime? lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BreakoutTechnique() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.applicableEnvironments,_that.targetsRestrictions,_that.description,_that.methodology,_that.payload,_that.prerequisites,_that.indicators,_that.mitigations,_that.cveReference,_that.source,_that.metadata,_that.discoveredAt,_that.lastUpdated);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  TechniqueCategory category,  List<EnvironmentType> applicableEnvironments,  List<RestrictionMechanism> targetsRestrictions,  String? description,  String? methodology,  String? payload,  List<String>? prerequisites,  List<String>? indicators,  List<String>? mitigations,  String? cveReference,  String? source,  Map<String, String>? metadata,  DateTime? discoveredAt,  DateTime? lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _BreakoutTechnique():
return $default(_that.id,_that.name,_that.category,_that.applicableEnvironments,_that.targetsRestrictions,_that.description,_that.methodology,_that.payload,_that.prerequisites,_that.indicators,_that.mitigations,_that.cveReference,_that.source,_that.metadata,_that.discoveredAt,_that.lastUpdated);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  TechniqueCategory category,  List<EnvironmentType> applicableEnvironments,  List<RestrictionMechanism> targetsRestrictions,  String? description,  String? methodology,  String? payload,  List<String>? prerequisites,  List<String>? indicators,  List<String>? mitigations,  String? cveReference,  String? source,  Map<String, String>? metadata,  DateTime? discoveredAt,  DateTime? lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _BreakoutTechnique() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.applicableEnvironments,_that.targetsRestrictions,_that.description,_that.methodology,_that.payload,_that.prerequisites,_that.indicators,_that.mitigations,_that.cveReference,_that.source,_that.metadata,_that.discoveredAt,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BreakoutTechnique implements BreakoutTechnique {
  const _BreakoutTechnique({required this.id, required this.name, required this.category, required final  List<EnvironmentType> applicableEnvironments, required final  List<RestrictionMechanism> targetsRestrictions, this.description, this.methodology, this.payload, final  List<String>? prerequisites, final  List<String>? indicators, final  List<String>? mitigations, this.cveReference, this.source, final  Map<String, String>? metadata, this.discoveredAt, this.lastUpdated}): _applicableEnvironments = applicableEnvironments,_targetsRestrictions = targetsRestrictions,_prerequisites = prerequisites,_indicators = indicators,_mitigations = mitigations,_metadata = metadata;
  factory _BreakoutTechnique.fromJson(Map<String, dynamic> json) => _$BreakoutTechniqueFromJson(json);

@override final  String id;
@override final  String name;
@override final  TechniqueCategory category;
 final  List<EnvironmentType> _applicableEnvironments;
@override List<EnvironmentType> get applicableEnvironments {
  if (_applicableEnvironments is EqualUnmodifiableListView) return _applicableEnvironments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_applicableEnvironments);
}

 final  List<RestrictionMechanism> _targetsRestrictions;
@override List<RestrictionMechanism> get targetsRestrictions {
  if (_targetsRestrictions is EqualUnmodifiableListView) return _targetsRestrictions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_targetsRestrictions);
}

@override final  String? description;
@override final  String? methodology;
// Step-by-step process
@override final  String? payload;
// Example command/code
 final  List<String>? _prerequisites;
// Example command/code
@override List<String>? get prerequisites {
  final value = _prerequisites;
  if (value == null) return null;
  if (_prerequisites is EqualUnmodifiableListView) return _prerequisites;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// Required conditions
 final  List<String>? _indicators;
// Required conditions
@override List<String>? get indicators {
  final value = _indicators;
  if (value == null) return null;
  if (_indicators is EqualUnmodifiableListView) return _indicators;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// Signs of success
 final  List<String>? _mitigations;
// Signs of success
@override List<String>? get mitigations {
  final value = _mitigations;
  if (value == null) return null;
  if (_mitigations is EqualUnmodifiableListView) return _mitigations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// How to prevent
@override final  String? cveReference;
// CVE if applicable
@override final  String? source;
// Where technique came from
 final  Map<String, String>? _metadata;
// Where technique came from
@override Map<String, String>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// MITRE ATT&CK, etc.
@override final  DateTime? discoveredAt;
@override final  DateTime? lastUpdated;

/// Create a copy of BreakoutTechnique
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BreakoutTechniqueCopyWith<_BreakoutTechnique> get copyWith => __$BreakoutTechniqueCopyWithImpl<_BreakoutTechnique>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BreakoutTechniqueToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BreakoutTechnique&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&const DeepCollectionEquality().equals(other._applicableEnvironments, _applicableEnvironments)&&const DeepCollectionEquality().equals(other._targetsRestrictions, _targetsRestrictions)&&(identical(other.description, description) || other.description == description)&&(identical(other.methodology, methodology) || other.methodology == methodology)&&(identical(other.payload, payload) || other.payload == payload)&&const DeepCollectionEquality().equals(other._prerequisites, _prerequisites)&&const DeepCollectionEquality().equals(other._indicators, _indicators)&&const DeepCollectionEquality().equals(other._mitigations, _mitigations)&&(identical(other.cveReference, cveReference) || other.cveReference == cveReference)&&(identical(other.source, source) || other.source == source)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.discoveredAt, discoveredAt) || other.discoveredAt == discoveredAt)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,const DeepCollectionEquality().hash(_applicableEnvironments),const DeepCollectionEquality().hash(_targetsRestrictions),description,methodology,payload,const DeepCollectionEquality().hash(_prerequisites),const DeepCollectionEquality().hash(_indicators),const DeepCollectionEquality().hash(_mitigations),cveReference,source,const DeepCollectionEquality().hash(_metadata),discoveredAt,lastUpdated);

@override
String toString() {
  return 'BreakoutTechnique(id: $id, name: $name, category: $category, applicableEnvironments: $applicableEnvironments, targetsRestrictions: $targetsRestrictions, description: $description, methodology: $methodology, payload: $payload, prerequisites: $prerequisites, indicators: $indicators, mitigations: $mitigations, cveReference: $cveReference, source: $source, metadata: $metadata, discoveredAt: $discoveredAt, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$BreakoutTechniqueCopyWith<$Res> implements $BreakoutTechniqueCopyWith<$Res> {
  factory _$BreakoutTechniqueCopyWith(_BreakoutTechnique value, $Res Function(_BreakoutTechnique) _then) = __$BreakoutTechniqueCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, TechniqueCategory category, List<EnvironmentType> applicableEnvironments, List<RestrictionMechanism> targetsRestrictions, String? description, String? methodology, String? payload, List<String>? prerequisites, List<String>? indicators, List<String>? mitigations, String? cveReference, String? source, Map<String, String>? metadata, DateTime? discoveredAt, DateTime? lastUpdated
});




}
/// @nodoc
class __$BreakoutTechniqueCopyWithImpl<$Res>
    implements _$BreakoutTechniqueCopyWith<$Res> {
  __$BreakoutTechniqueCopyWithImpl(this._self, this._then);

  final _BreakoutTechnique _self;
  final $Res Function(_BreakoutTechnique) _then;

/// Create a copy of BreakoutTechnique
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? applicableEnvironments = null,Object? targetsRestrictions = null,Object? description = freezed,Object? methodology = freezed,Object? payload = freezed,Object? prerequisites = freezed,Object? indicators = freezed,Object? mitigations = freezed,Object? cveReference = freezed,Object? source = freezed,Object? metadata = freezed,Object? discoveredAt = freezed,Object? lastUpdated = freezed,}) {
  return _then(_BreakoutTechnique(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as TechniqueCategory,applicableEnvironments: null == applicableEnvironments ? _self._applicableEnvironments : applicableEnvironments // ignore: cast_nullable_to_non_nullable
as List<EnvironmentType>,targetsRestrictions: null == targetsRestrictions ? _self._targetsRestrictions : targetsRestrictions // ignore: cast_nullable_to_non_nullable
as List<RestrictionMechanism>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,methodology: freezed == methodology ? _self.methodology : methodology // ignore: cast_nullable_to_non_nullable
as String?,payload: freezed == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String?,prerequisites: freezed == prerequisites ? _self._prerequisites : prerequisites // ignore: cast_nullable_to_non_nullable
as List<String>?,indicators: freezed == indicators ? _self._indicators : indicators // ignore: cast_nullable_to_non_nullable
as List<String>?,mitigations: freezed == mitigations ? _self._mitigations : mitigations // ignore: cast_nullable_to_non_nullable
as List<String>?,cveReference: freezed == cveReference ? _self.cveReference : cveReference // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,discoveredAt: freezed == discoveredAt ? _self.discoveredAt : discoveredAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$SecurityControl {

 String get id; String get name; String get type;// "appLocker", "sandbox", etc.
 String get hostAssetId; String? get description; String? get version; String? get configuration; bool get enabled; List<String> get protectedAssets; List<String> get bypassTechniques; Map<String, String>? get settings; DateTime? get installedAt; DateTime? get lastUpdated;
/// Create a copy of SecurityControl
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecurityControlCopyWith<SecurityControl> get copyWith => _$SecurityControlCopyWithImpl<SecurityControl>(this as SecurityControl, _$identity);

  /// Serializes this SecurityControl to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecurityControl&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.hostAssetId, hostAssetId) || other.hostAssetId == hostAssetId)&&(identical(other.description, description) || other.description == description)&&(identical(other.version, version) || other.version == version)&&(identical(other.configuration, configuration) || other.configuration == configuration)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other.protectedAssets, protectedAssets)&&const DeepCollectionEquality().equals(other.bypassTechniques, bypassTechniques)&&const DeepCollectionEquality().equals(other.settings, settings)&&(identical(other.installedAt, installedAt) || other.installedAt == installedAt)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,hostAssetId,description,version,configuration,enabled,const DeepCollectionEquality().hash(protectedAssets),const DeepCollectionEquality().hash(bypassTechniques),const DeepCollectionEquality().hash(settings),installedAt,lastUpdated);

@override
String toString() {
  return 'SecurityControl(id: $id, name: $name, type: $type, hostAssetId: $hostAssetId, description: $description, version: $version, configuration: $configuration, enabled: $enabled, protectedAssets: $protectedAssets, bypassTechniques: $bypassTechniques, settings: $settings, installedAt: $installedAt, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class $SecurityControlCopyWith<$Res>  {
  factory $SecurityControlCopyWith(SecurityControl value, $Res Function(SecurityControl) _then) = _$SecurityControlCopyWithImpl;
@useResult
$Res call({
 String id, String name, String type, String hostAssetId, String? description, String? version, String? configuration, bool enabled, List<String> protectedAssets, List<String> bypassTechniques, Map<String, String>? settings, DateTime? installedAt, DateTime? lastUpdated
});




}
/// @nodoc
class _$SecurityControlCopyWithImpl<$Res>
    implements $SecurityControlCopyWith<$Res> {
  _$SecurityControlCopyWithImpl(this._self, this._then);

  final SecurityControl _self;
  final $Res Function(SecurityControl) _then;

/// Create a copy of SecurityControl
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? hostAssetId = null,Object? description = freezed,Object? version = freezed,Object? configuration = freezed,Object? enabled = null,Object? protectedAssets = null,Object? bypassTechniques = null,Object? settings = freezed,Object? installedAt = freezed,Object? lastUpdated = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,hostAssetId: null == hostAssetId ? _self.hostAssetId : hostAssetId // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,configuration: freezed == configuration ? _self.configuration : configuration // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,protectedAssets: null == protectedAssets ? _self.protectedAssets : protectedAssets // ignore: cast_nullable_to_non_nullable
as List<String>,bypassTechniques: null == bypassTechniques ? _self.bypassTechniques : bypassTechniques // ignore: cast_nullable_to_non_nullable
as List<String>,settings: freezed == settings ? _self.settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,installedAt: freezed == installedAt ? _self.installedAt : installedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SecurityControl].
extension SecurityControlPatterns on SecurityControl {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SecurityControl value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SecurityControl() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SecurityControl value)  $default,){
final _that = this;
switch (_that) {
case _SecurityControl():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SecurityControl value)?  $default,){
final _that = this;
switch (_that) {
case _SecurityControl() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String type,  String hostAssetId,  String? description,  String? version,  String? configuration,  bool enabled,  List<String> protectedAssets,  List<String> bypassTechniques,  Map<String, String>? settings,  DateTime? installedAt,  DateTime? lastUpdated)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SecurityControl() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.hostAssetId,_that.description,_that.version,_that.configuration,_that.enabled,_that.protectedAssets,_that.bypassTechniques,_that.settings,_that.installedAt,_that.lastUpdated);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String type,  String hostAssetId,  String? description,  String? version,  String? configuration,  bool enabled,  List<String> protectedAssets,  List<String> bypassTechniques,  Map<String, String>? settings,  DateTime? installedAt,  DateTime? lastUpdated)  $default,) {final _that = this;
switch (_that) {
case _SecurityControl():
return $default(_that.id,_that.name,_that.type,_that.hostAssetId,_that.description,_that.version,_that.configuration,_that.enabled,_that.protectedAssets,_that.bypassTechniques,_that.settings,_that.installedAt,_that.lastUpdated);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String type,  String hostAssetId,  String? description,  String? version,  String? configuration,  bool enabled,  List<String> protectedAssets,  List<String> bypassTechniques,  Map<String, String>? settings,  DateTime? installedAt,  DateTime? lastUpdated)?  $default,) {final _that = this;
switch (_that) {
case _SecurityControl() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.hostAssetId,_that.description,_that.version,_that.configuration,_that.enabled,_that.protectedAssets,_that.bypassTechniques,_that.settings,_that.installedAt,_that.lastUpdated);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SecurityControl implements SecurityControl {
  const _SecurityControl({required this.id, required this.name, required this.type, required this.hostAssetId, this.description, this.version, this.configuration, this.enabled = true, final  List<String> protectedAssets = const [], final  List<String> bypassTechniques = const [], final  Map<String, String>? settings, this.installedAt, this.lastUpdated}): _protectedAssets = protectedAssets,_bypassTechniques = bypassTechniques,_settings = settings;
  factory _SecurityControl.fromJson(Map<String, dynamic> json) => _$SecurityControlFromJson(json);

@override final  String id;
@override final  String name;
@override final  String type;
// "appLocker", "sandbox", etc.
@override final  String hostAssetId;
@override final  String? description;
@override final  String? version;
@override final  String? configuration;
@override@JsonKey() final  bool enabled;
 final  List<String> _protectedAssets;
@override@JsonKey() List<String> get protectedAssets {
  if (_protectedAssets is EqualUnmodifiableListView) return _protectedAssets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_protectedAssets);
}

 final  List<String> _bypassTechniques;
@override@JsonKey() List<String> get bypassTechniques {
  if (_bypassTechniques is EqualUnmodifiableListView) return _bypassTechniques;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_bypassTechniques);
}

 final  Map<String, String>? _settings;
@override Map<String, String>? get settings {
  final value = _settings;
  if (value == null) return null;
  if (_settings is EqualUnmodifiableMapView) return _settings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? installedAt;
@override final  DateTime? lastUpdated;

/// Create a copy of SecurityControl
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SecurityControlCopyWith<_SecurityControl> get copyWith => __$SecurityControlCopyWithImpl<_SecurityControl>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SecurityControlToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SecurityControl&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.hostAssetId, hostAssetId) || other.hostAssetId == hostAssetId)&&(identical(other.description, description) || other.description == description)&&(identical(other.version, version) || other.version == version)&&(identical(other.configuration, configuration) || other.configuration == configuration)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&const DeepCollectionEquality().equals(other._protectedAssets, _protectedAssets)&&const DeepCollectionEquality().equals(other._bypassTechniques, _bypassTechniques)&&const DeepCollectionEquality().equals(other._settings, _settings)&&(identical(other.installedAt, installedAt) || other.installedAt == installedAt)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,hostAssetId,description,version,configuration,enabled,const DeepCollectionEquality().hash(_protectedAssets),const DeepCollectionEquality().hash(_bypassTechniques),const DeepCollectionEquality().hash(_settings),installedAt,lastUpdated);

@override
String toString() {
  return 'SecurityControl(id: $id, name: $name, type: $type, hostAssetId: $hostAssetId, description: $description, version: $version, configuration: $configuration, enabled: $enabled, protectedAssets: $protectedAssets, bypassTechniques: $bypassTechniques, settings: $settings, installedAt: $installedAt, lastUpdated: $lastUpdated)';
}


}

/// @nodoc
abstract mixin class _$SecurityControlCopyWith<$Res> implements $SecurityControlCopyWith<$Res> {
  factory _$SecurityControlCopyWith(_SecurityControl value, $Res Function(_SecurityControl) _then) = __$SecurityControlCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String type, String hostAssetId, String? description, String? version, String? configuration, bool enabled, List<String> protectedAssets, List<String> bypassTechniques, Map<String, String>? settings, DateTime? installedAt, DateTime? lastUpdated
});




}
/// @nodoc
class __$SecurityControlCopyWithImpl<$Res>
    implements _$SecurityControlCopyWith<$Res> {
  __$SecurityControlCopyWithImpl(this._self, this._then);

  final _SecurityControl _self;
  final $Res Function(_SecurityControl) _then;

/// Create a copy of SecurityControl
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? hostAssetId = null,Object? description = freezed,Object? version = freezed,Object? configuration = freezed,Object? enabled = null,Object? protectedAssets = null,Object? bypassTechniques = null,Object? settings = freezed,Object? installedAt = freezed,Object? lastUpdated = freezed,}) {
  return _then(_SecurityControl(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,hostAssetId: null == hostAssetId ? _self.hostAssetId : hostAssetId // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,configuration: freezed == configuration ? _self.configuration : configuration // ignore: cast_nullable_to_non_nullable
as String?,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,protectedAssets: null == protectedAssets ? _self._protectedAssets : protectedAssets // ignore: cast_nullable_to_non_nullable
as List<String>,bypassTechniques: null == bypassTechniques ? _self._bypassTechniques : bypassTechniques // ignore: cast_nullable_to_non_nullable
as List<String>,settings: freezed == settings ? _self._settings : settings // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,installedAt: freezed == installedAt ? _self.installedAt : installedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

AssetPropertyValue _$AssetPropertyValueFromJson(
  Map<String, dynamic> json
) {
        switch (json['runtimeType']) {
                  case 'string':
          return StringAssetProperty.fromJson(
            json
          );
                case 'integer':
          return IntegerAssetProperty.fromJson(
            json
          );
                case 'double':
          return DoubleAssetProperty.fromJson(
            json
          );
                case 'boolean':
          return BooleanAssetProperty.fromJson(
            json
          );
                case 'stringList':
          return StringListAssetProperty.fromJson(
            json
          );
                case 'dateTime':
          return DateTimeAssetProperty.fromJson(
            json
          );
                case 'map':
          return MapAssetProperty.fromJson(
            json
          );
                case 'objectList':
          return ObjectListAssetProperty.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'runtimeType',
  'AssetPropertyValue',
  'Invalid union type "${json['runtimeType']}"!'
);
        }
      
}

/// @nodoc
mixin _$AssetPropertyValue {



  /// Serializes this AssetPropertyValue to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssetPropertyValue);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AssetPropertyValue()';
}


}

/// @nodoc
class $AssetPropertyValueCopyWith<$Res>  {
$AssetPropertyValueCopyWith(AssetPropertyValue _, $Res Function(AssetPropertyValue) __);
}


/// Adds pattern-matching-related methods to [AssetPropertyValue].
extension AssetPropertyValuePatterns on AssetPropertyValue {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( StringAssetProperty value)?  string,TResult Function( IntegerAssetProperty value)?  integer,TResult Function( DoubleAssetProperty value)?  double,TResult Function( BooleanAssetProperty value)?  boolean,TResult Function( StringListAssetProperty value)?  stringList,TResult Function( DateTimeAssetProperty value)?  dateTime,TResult Function( MapAssetProperty value)?  map,TResult Function( ObjectListAssetProperty value)?  objectList,required TResult orElse(),}){
final _that = this;
switch (_that) {
case StringAssetProperty() when string != null:
return string(_that);case IntegerAssetProperty() when integer != null:
return integer(_that);case DoubleAssetProperty() when double != null:
return double(_that);case BooleanAssetProperty() when boolean != null:
return boolean(_that);case StringListAssetProperty() when stringList != null:
return stringList(_that);case DateTimeAssetProperty() when dateTime != null:
return dateTime(_that);case MapAssetProperty() when map != null:
return map(_that);case ObjectListAssetProperty() when objectList != null:
return objectList(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( StringAssetProperty value)  string,required TResult Function( IntegerAssetProperty value)  integer,required TResult Function( DoubleAssetProperty value)  double,required TResult Function( BooleanAssetProperty value)  boolean,required TResult Function( StringListAssetProperty value)  stringList,required TResult Function( DateTimeAssetProperty value)  dateTime,required TResult Function( MapAssetProperty value)  map,required TResult Function( ObjectListAssetProperty value)  objectList,}){
final _that = this;
switch (_that) {
case StringAssetProperty():
return string(_that);case IntegerAssetProperty():
return integer(_that);case DoubleAssetProperty():
return double(_that);case BooleanAssetProperty():
return boolean(_that);case StringListAssetProperty():
return stringList(_that);case DateTimeAssetProperty():
return dateTime(_that);case MapAssetProperty():
return map(_that);case ObjectListAssetProperty():
return objectList(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( StringAssetProperty value)?  string,TResult? Function( IntegerAssetProperty value)?  integer,TResult? Function( DoubleAssetProperty value)?  double,TResult? Function( BooleanAssetProperty value)?  boolean,TResult? Function( StringListAssetProperty value)?  stringList,TResult? Function( DateTimeAssetProperty value)?  dateTime,TResult? Function( MapAssetProperty value)?  map,TResult? Function( ObjectListAssetProperty value)?  objectList,}){
final _that = this;
switch (_that) {
case StringAssetProperty() when string != null:
return string(_that);case IntegerAssetProperty() when integer != null:
return integer(_that);case DoubleAssetProperty() when double != null:
return double(_that);case BooleanAssetProperty() when boolean != null:
return boolean(_that);case StringListAssetProperty() when stringList != null:
return stringList(_that);case DateTimeAssetProperty() when dateTime != null:
return dateTime(_that);case MapAssetProperty() when map != null:
return map(_that);case ObjectListAssetProperty() when objectList != null:
return objectList(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String value)?  string,TResult Function( int value)?  integer,TResult Function( double value)?  double,TResult Function( bool value)?  boolean,TResult Function( List<String> values)?  stringList,TResult Function( DateTime value)?  dateTime,TResult Function( Map<String, dynamic> value)?  map,TResult Function( List<Map<String, dynamic>> objects)?  objectList,required TResult orElse(),}) {final _that = this;
switch (_that) {
case StringAssetProperty() when string != null:
return string(_that.value);case IntegerAssetProperty() when integer != null:
return integer(_that.value);case DoubleAssetProperty() when double != null:
return double(_that.value);case BooleanAssetProperty() when boolean != null:
return boolean(_that.value);case StringListAssetProperty() when stringList != null:
return stringList(_that.values);case DateTimeAssetProperty() when dateTime != null:
return dateTime(_that.value);case MapAssetProperty() when map != null:
return map(_that.value);case ObjectListAssetProperty() when objectList != null:
return objectList(_that.objects);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String value)  string,required TResult Function( int value)  integer,required TResult Function( double value)  double,required TResult Function( bool value)  boolean,required TResult Function( List<String> values)  stringList,required TResult Function( DateTime value)  dateTime,required TResult Function( Map<String, dynamic> value)  map,required TResult Function( List<Map<String, dynamic>> objects)  objectList,}) {final _that = this;
switch (_that) {
case StringAssetProperty():
return string(_that.value);case IntegerAssetProperty():
return integer(_that.value);case DoubleAssetProperty():
return double(_that.value);case BooleanAssetProperty():
return boolean(_that.value);case StringListAssetProperty():
return stringList(_that.values);case DateTimeAssetProperty():
return dateTime(_that.value);case MapAssetProperty():
return map(_that.value);case ObjectListAssetProperty():
return objectList(_that.objects);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String value)?  string,TResult? Function( int value)?  integer,TResult? Function( double value)?  double,TResult? Function( bool value)?  boolean,TResult? Function( List<String> values)?  stringList,TResult? Function( DateTime value)?  dateTime,TResult? Function( Map<String, dynamic> value)?  map,TResult? Function( List<Map<String, dynamic>> objects)?  objectList,}) {final _that = this;
switch (_that) {
case StringAssetProperty() when string != null:
return string(_that.value);case IntegerAssetProperty() when integer != null:
return integer(_that.value);case DoubleAssetProperty() when double != null:
return double(_that.value);case BooleanAssetProperty() when boolean != null:
return boolean(_that.value);case StringListAssetProperty() when stringList != null:
return stringList(_that.values);case DateTimeAssetProperty() when dateTime != null:
return dateTime(_that.value);case MapAssetProperty() when map != null:
return map(_that.value);case ObjectListAssetProperty() when objectList != null:
return objectList(_that.objects);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class StringAssetProperty implements AssetPropertyValue {
  const StringAssetProperty(this.value, {final  String? $type}): $type = $type ?? 'string';
  factory StringAssetProperty.fromJson(Map<String, dynamic> json) => _$StringAssetPropertyFromJson(json);

 final  String value;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringAssetPropertyCopyWith<StringAssetProperty> get copyWith => _$StringAssetPropertyCopyWithImpl<StringAssetProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StringAssetPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StringAssetProperty&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'AssetPropertyValue.string(value: $value)';
}


}

/// @nodoc
abstract mixin class $StringAssetPropertyCopyWith<$Res> implements $AssetPropertyValueCopyWith<$Res> {
  factory $StringAssetPropertyCopyWith(StringAssetProperty value, $Res Function(StringAssetProperty) _then) = _$StringAssetPropertyCopyWithImpl;
@useResult
$Res call({
 String value
});




}
/// @nodoc
class _$StringAssetPropertyCopyWithImpl<$Res>
    implements $StringAssetPropertyCopyWith<$Res> {
  _$StringAssetPropertyCopyWithImpl(this._self, this._then);

  final StringAssetProperty _self;
  final $Res Function(StringAssetProperty) _then;

/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(StringAssetProperty(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
@JsonSerializable()

class IntegerAssetProperty implements AssetPropertyValue {
  const IntegerAssetProperty(this.value, {final  String? $type}): $type = $type ?? 'integer';
  factory IntegerAssetProperty.fromJson(Map<String, dynamic> json) => _$IntegerAssetPropertyFromJson(json);

 final  int value;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntegerAssetPropertyCopyWith<IntegerAssetProperty> get copyWith => _$IntegerAssetPropertyCopyWithImpl<IntegerAssetProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IntegerAssetPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IntegerAssetProperty&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'AssetPropertyValue.integer(value: $value)';
}


}

/// @nodoc
abstract mixin class $IntegerAssetPropertyCopyWith<$Res> implements $AssetPropertyValueCopyWith<$Res> {
  factory $IntegerAssetPropertyCopyWith(IntegerAssetProperty value, $Res Function(IntegerAssetProperty) _then) = _$IntegerAssetPropertyCopyWithImpl;
@useResult
$Res call({
 int value
});




}
/// @nodoc
class _$IntegerAssetPropertyCopyWithImpl<$Res>
    implements $IntegerAssetPropertyCopyWith<$Res> {
  _$IntegerAssetPropertyCopyWithImpl(this._self, this._then);

  final IntegerAssetProperty _self;
  final $Res Function(IntegerAssetProperty) _then;

/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(IntegerAssetProperty(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
@JsonSerializable()

class DoubleAssetProperty implements AssetPropertyValue {
  const DoubleAssetProperty(this.value, {final  String? $type}): $type = $type ?? 'double';
  factory DoubleAssetProperty.fromJson(Map<String, dynamic> json) => _$DoubleAssetPropertyFromJson(json);

 final  double value;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DoubleAssetPropertyCopyWith<DoubleAssetProperty> get copyWith => _$DoubleAssetPropertyCopyWithImpl<DoubleAssetProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DoubleAssetPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DoubleAssetProperty&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'AssetPropertyValue.double(value: $value)';
}


}

/// @nodoc
abstract mixin class $DoubleAssetPropertyCopyWith<$Res> implements $AssetPropertyValueCopyWith<$Res> {
  factory $DoubleAssetPropertyCopyWith(DoubleAssetProperty value, $Res Function(DoubleAssetProperty) _then) = _$DoubleAssetPropertyCopyWithImpl;
@useResult
$Res call({
 double value
});




}
/// @nodoc
class _$DoubleAssetPropertyCopyWithImpl<$Res>
    implements $DoubleAssetPropertyCopyWith<$Res> {
  _$DoubleAssetPropertyCopyWithImpl(this._self, this._then);

  final DoubleAssetProperty _self;
  final $Res Function(DoubleAssetProperty) _then;

/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(DoubleAssetProperty(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc
@JsonSerializable()

class BooleanAssetProperty implements AssetPropertyValue {
  const BooleanAssetProperty(this.value, {final  String? $type}): $type = $type ?? 'boolean';
  factory BooleanAssetProperty.fromJson(Map<String, dynamic> json) => _$BooleanAssetPropertyFromJson(json);

 final  bool value;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BooleanAssetPropertyCopyWith<BooleanAssetProperty> get copyWith => _$BooleanAssetPropertyCopyWithImpl<BooleanAssetProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BooleanAssetPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BooleanAssetProperty&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'AssetPropertyValue.boolean(value: $value)';
}


}

/// @nodoc
abstract mixin class $BooleanAssetPropertyCopyWith<$Res> implements $AssetPropertyValueCopyWith<$Res> {
  factory $BooleanAssetPropertyCopyWith(BooleanAssetProperty value, $Res Function(BooleanAssetProperty) _then) = _$BooleanAssetPropertyCopyWithImpl;
@useResult
$Res call({
 bool value
});




}
/// @nodoc
class _$BooleanAssetPropertyCopyWithImpl<$Res>
    implements $BooleanAssetPropertyCopyWith<$Res> {
  _$BooleanAssetPropertyCopyWithImpl(this._self, this._then);

  final BooleanAssetProperty _self;
  final $Res Function(BooleanAssetProperty) _then;

/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(BooleanAssetProperty(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
@JsonSerializable()

class StringListAssetProperty implements AssetPropertyValue {
  const StringListAssetProperty(final  List<String> values, {final  String? $type}): _values = values,$type = $type ?? 'stringList';
  factory StringListAssetProperty.fromJson(Map<String, dynamic> json) => _$StringListAssetPropertyFromJson(json);

 final  List<String> _values;
 List<String> get values {
  if (_values is EqualUnmodifiableListView) return _values;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_values);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StringListAssetPropertyCopyWith<StringListAssetProperty> get copyWith => _$StringListAssetPropertyCopyWithImpl<StringListAssetProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StringListAssetPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StringListAssetProperty&&const DeepCollectionEquality().equals(other._values, _values));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_values));

@override
String toString() {
  return 'AssetPropertyValue.stringList(values: $values)';
}


}

/// @nodoc
abstract mixin class $StringListAssetPropertyCopyWith<$Res> implements $AssetPropertyValueCopyWith<$Res> {
  factory $StringListAssetPropertyCopyWith(StringListAssetProperty value, $Res Function(StringListAssetProperty) _then) = _$StringListAssetPropertyCopyWithImpl;
@useResult
$Res call({
 List<String> values
});




}
/// @nodoc
class _$StringListAssetPropertyCopyWithImpl<$Res>
    implements $StringListAssetPropertyCopyWith<$Res> {
  _$StringListAssetPropertyCopyWithImpl(this._self, this._then);

  final StringListAssetProperty _self;
  final $Res Function(StringListAssetProperty) _then;

/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? values = null,}) {
  return _then(StringListAssetProperty(
null == values ? _self._values : values // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class DateTimeAssetProperty implements AssetPropertyValue {
  const DateTimeAssetProperty(this.value, {final  String? $type}): $type = $type ?? 'dateTime';
  factory DateTimeAssetProperty.fromJson(Map<String, dynamic> json) => _$DateTimeAssetPropertyFromJson(json);

 final  DateTime value;

@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateTimeAssetPropertyCopyWith<DateTimeAssetProperty> get copyWith => _$DateTimeAssetPropertyCopyWithImpl<DateTimeAssetProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DateTimeAssetPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateTimeAssetProperty&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,value);

@override
String toString() {
  return 'AssetPropertyValue.dateTime(value: $value)';
}


}

/// @nodoc
abstract mixin class $DateTimeAssetPropertyCopyWith<$Res> implements $AssetPropertyValueCopyWith<$Res> {
  factory $DateTimeAssetPropertyCopyWith(DateTimeAssetProperty value, $Res Function(DateTimeAssetProperty) _then) = _$DateTimeAssetPropertyCopyWithImpl;
@useResult
$Res call({
 DateTime value
});




}
/// @nodoc
class _$DateTimeAssetPropertyCopyWithImpl<$Res>
    implements $DateTimeAssetPropertyCopyWith<$Res> {
  _$DateTimeAssetPropertyCopyWithImpl(this._self, this._then);

  final DateTimeAssetProperty _self;
  final $Res Function(DateTimeAssetProperty) _then;

/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(DateTimeAssetProperty(
null == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc
@JsonSerializable()

class MapAssetProperty implements AssetPropertyValue {
  const MapAssetProperty(final  Map<String, dynamic> value, {final  String? $type}): _value = value,$type = $type ?? 'map';
  factory MapAssetProperty.fromJson(Map<String, dynamic> json) => _$MapAssetPropertyFromJson(json);

 final  Map<String, dynamic> _value;
 Map<String, dynamic> get value {
  if (_value is EqualUnmodifiableMapView) return _value;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_value);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MapAssetPropertyCopyWith<MapAssetProperty> get copyWith => _$MapAssetPropertyCopyWithImpl<MapAssetProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MapAssetPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MapAssetProperty&&const DeepCollectionEquality().equals(other._value, _value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_value));

@override
String toString() {
  return 'AssetPropertyValue.map(value: $value)';
}


}

/// @nodoc
abstract mixin class $MapAssetPropertyCopyWith<$Res> implements $AssetPropertyValueCopyWith<$Res> {
  factory $MapAssetPropertyCopyWith(MapAssetProperty value, $Res Function(MapAssetProperty) _then) = _$MapAssetPropertyCopyWithImpl;
@useResult
$Res call({
 Map<String, dynamic> value
});




}
/// @nodoc
class _$MapAssetPropertyCopyWithImpl<$Res>
    implements $MapAssetPropertyCopyWith<$Res> {
  _$MapAssetPropertyCopyWithImpl(this._self, this._then);

  final MapAssetProperty _self;
  final $Res Function(MapAssetProperty) _then;

/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? value = null,}) {
  return _then(MapAssetProperty(
null == value ? _self._value : value // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,
  ));
}


}

/// @nodoc
@JsonSerializable()

class ObjectListAssetProperty implements AssetPropertyValue {
  const ObjectListAssetProperty(final  List<Map<String, dynamic>> objects, {final  String? $type}): _objects = objects,$type = $type ?? 'objectList';
  factory ObjectListAssetProperty.fromJson(Map<String, dynamic> json) => _$ObjectListAssetPropertyFromJson(json);

 final  List<Map<String, dynamic>> _objects;
 List<Map<String, dynamic>> get objects {
  if (_objects is EqualUnmodifiableListView) return _objects;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_objects);
}


@JsonKey(name: 'runtimeType')
final String $type;


/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ObjectListAssetPropertyCopyWith<ObjectListAssetProperty> get copyWith => _$ObjectListAssetPropertyCopyWithImpl<ObjectListAssetProperty>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ObjectListAssetPropertyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ObjectListAssetProperty&&const DeepCollectionEquality().equals(other._objects, _objects));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_objects));

@override
String toString() {
  return 'AssetPropertyValue.objectList(objects: $objects)';
}


}

/// @nodoc
abstract mixin class $ObjectListAssetPropertyCopyWith<$Res> implements $AssetPropertyValueCopyWith<$Res> {
  factory $ObjectListAssetPropertyCopyWith(ObjectListAssetProperty value, $Res Function(ObjectListAssetProperty) _then) = _$ObjectListAssetPropertyCopyWithImpl;
@useResult
$Res call({
 List<Map<String, dynamic>> objects
});




}
/// @nodoc
class _$ObjectListAssetPropertyCopyWithImpl<$Res>
    implements $ObjectListAssetPropertyCopyWith<$Res> {
  _$ObjectListAssetPropertyCopyWithImpl(this._self, this._then);

  final ObjectListAssetProperty _self;
  final $Res Function(ObjectListAssetProperty) _then;

/// Create a copy of AssetPropertyValue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? objects = null,}) {
  return _then(ObjectListAssetProperty(
null == objects ? _self._objects : objects // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,
  ));
}


}


/// @nodoc
mixin _$Asset {

 String get id; AssetType get type; String get projectId; String get name; String? get description;// Rich property system - contains all asset-specific data
 Map<String, AssetPropertyValue> get properties;// Discovery and status
 AssetDiscoveryStatus get discoveryStatus; DateTime get discoveredAt; DateTime? get lastUpdated; String? get discoveryMethod; double get confidence;// Hierarchical relationships
 List<String> get parentAssetIds; List<String> get childAssetIds; List<String> get relatedAssetIds;// Cross-references
// Methodology integration
 List<String> get completedTriggers; Map<String, TriggerExecutionResult> get triggerResults;// Organization and filtering
 List<String> get tags; Map<String, String>? get metadata;// Security context
 AccessLevel? get accessLevel; List<String>? get securityControls;
/// Create a copy of Asset
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssetCopyWith<Asset> get copyWith => _$AssetCopyWithImpl<Asset>(this as Asset, _$identity);

  /// Serializes this Asset to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Asset&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.properties, properties)&&(identical(other.discoveryStatus, discoveryStatus) || other.discoveryStatus == discoveryStatus)&&(identical(other.discoveredAt, discoveredAt) || other.discoveredAt == discoveredAt)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.discoveryMethod, discoveryMethod) || other.discoveryMethod == discoveryMethod)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other.parentAssetIds, parentAssetIds)&&const DeepCollectionEquality().equals(other.childAssetIds, childAssetIds)&&const DeepCollectionEquality().equals(other.relatedAssetIds, relatedAssetIds)&&const DeepCollectionEquality().equals(other.completedTriggers, completedTriggers)&&const DeepCollectionEquality().equals(other.triggerResults, triggerResults)&&const DeepCollectionEquality().equals(other.tags, tags)&&const DeepCollectionEquality().equals(other.metadata, metadata)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&const DeepCollectionEquality().equals(other.securityControls, securityControls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,type,projectId,name,description,const DeepCollectionEquality().hash(properties),discoveryStatus,discoveredAt,lastUpdated,discoveryMethod,confidence,const DeepCollectionEquality().hash(parentAssetIds),const DeepCollectionEquality().hash(childAssetIds),const DeepCollectionEquality().hash(relatedAssetIds),const DeepCollectionEquality().hash(completedTriggers),const DeepCollectionEquality().hash(triggerResults),const DeepCollectionEquality().hash(tags),const DeepCollectionEquality().hash(metadata),accessLevel,const DeepCollectionEquality().hash(securityControls)]);

@override
String toString() {
  return 'Asset(id: $id, type: $type, projectId: $projectId, name: $name, description: $description, properties: $properties, discoveryStatus: $discoveryStatus, discoveredAt: $discoveredAt, lastUpdated: $lastUpdated, discoveryMethod: $discoveryMethod, confidence: $confidence, parentAssetIds: $parentAssetIds, childAssetIds: $childAssetIds, relatedAssetIds: $relatedAssetIds, completedTriggers: $completedTriggers, triggerResults: $triggerResults, tags: $tags, metadata: $metadata, accessLevel: $accessLevel, securityControls: $securityControls)';
}


}

/// @nodoc
abstract mixin class $AssetCopyWith<$Res>  {
  factory $AssetCopyWith(Asset value, $Res Function(Asset) _then) = _$AssetCopyWithImpl;
@useResult
$Res call({
 String id, AssetType type, String projectId, String name, String? description, Map<String, AssetPropertyValue> properties, AssetDiscoveryStatus discoveryStatus, DateTime discoveredAt, DateTime? lastUpdated, String? discoveryMethod, double confidence, List<String> parentAssetIds, List<String> childAssetIds, List<String> relatedAssetIds, List<String> completedTriggers, Map<String, TriggerExecutionResult> triggerResults, List<String> tags, Map<String, String>? metadata, AccessLevel? accessLevel, List<String>? securityControls
});




}
/// @nodoc
class _$AssetCopyWithImpl<$Res>
    implements $AssetCopyWith<$Res> {
  _$AssetCopyWithImpl(this._self, this._then);

  final Asset _self;
  final $Res Function(Asset) _then;

/// Create a copy of Asset
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? projectId = null,Object? name = null,Object? description = freezed,Object? properties = null,Object? discoveryStatus = null,Object? discoveredAt = null,Object? lastUpdated = freezed,Object? discoveryMethod = freezed,Object? confidence = null,Object? parentAssetIds = null,Object? childAssetIds = null,Object? relatedAssetIds = null,Object? completedTriggers = null,Object? triggerResults = null,Object? tags = null,Object? metadata = freezed,Object? accessLevel = freezed,Object? securityControls = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AssetType,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,properties: null == properties ? _self.properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, AssetPropertyValue>,discoveryStatus: null == discoveryStatus ? _self.discoveryStatus : discoveryStatus // ignore: cast_nullable_to_non_nullable
as AssetDiscoveryStatus,discoveredAt: null == discoveredAt ? _self.discoveredAt : discoveredAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,discoveryMethod: freezed == discoveryMethod ? _self.discoveryMethod : discoveryMethod // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,parentAssetIds: null == parentAssetIds ? _self.parentAssetIds : parentAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,childAssetIds: null == childAssetIds ? _self.childAssetIds : childAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,relatedAssetIds: null == relatedAssetIds ? _self.relatedAssetIds : relatedAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,completedTriggers: null == completedTriggers ? _self.completedTriggers : completedTriggers // ignore: cast_nullable_to_non_nullable
as List<String>,triggerResults: null == triggerResults ? _self.triggerResults : triggerResults // ignore: cast_nullable_to_non_nullable
as Map<String, TriggerExecutionResult>,tags: null == tags ? _self.tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,accessLevel: freezed == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as AccessLevel?,securityControls: freezed == securityControls ? _self.securityControls : securityControls // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [Asset].
extension AssetPatterns on Asset {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Asset value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Asset() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Asset value)  $default,){
final _that = this;
switch (_that) {
case _Asset():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Asset value)?  $default,){
final _that = this;
switch (_that) {
case _Asset() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AssetType type,  String projectId,  String name,  String? description,  Map<String, AssetPropertyValue> properties,  AssetDiscoveryStatus discoveryStatus,  DateTime discoveredAt,  DateTime? lastUpdated,  String? discoveryMethod,  double confidence,  List<String> parentAssetIds,  List<String> childAssetIds,  List<String> relatedAssetIds,  List<String> completedTriggers,  Map<String, TriggerExecutionResult> triggerResults,  List<String> tags,  Map<String, String>? metadata,  AccessLevel? accessLevel,  List<String>? securityControls)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Asset() when $default != null:
return $default(_that.id,_that.type,_that.projectId,_that.name,_that.description,_that.properties,_that.discoveryStatus,_that.discoveredAt,_that.lastUpdated,_that.discoveryMethod,_that.confidence,_that.parentAssetIds,_that.childAssetIds,_that.relatedAssetIds,_that.completedTriggers,_that.triggerResults,_that.tags,_that.metadata,_that.accessLevel,_that.securityControls);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AssetType type,  String projectId,  String name,  String? description,  Map<String, AssetPropertyValue> properties,  AssetDiscoveryStatus discoveryStatus,  DateTime discoveredAt,  DateTime? lastUpdated,  String? discoveryMethod,  double confidence,  List<String> parentAssetIds,  List<String> childAssetIds,  List<String> relatedAssetIds,  List<String> completedTriggers,  Map<String, TriggerExecutionResult> triggerResults,  List<String> tags,  Map<String, String>? metadata,  AccessLevel? accessLevel,  List<String>? securityControls)  $default,) {final _that = this;
switch (_that) {
case _Asset():
return $default(_that.id,_that.type,_that.projectId,_that.name,_that.description,_that.properties,_that.discoveryStatus,_that.discoveredAt,_that.lastUpdated,_that.discoveryMethod,_that.confidence,_that.parentAssetIds,_that.childAssetIds,_that.relatedAssetIds,_that.completedTriggers,_that.triggerResults,_that.tags,_that.metadata,_that.accessLevel,_that.securityControls);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AssetType type,  String projectId,  String name,  String? description,  Map<String, AssetPropertyValue> properties,  AssetDiscoveryStatus discoveryStatus,  DateTime discoveredAt,  DateTime? lastUpdated,  String? discoveryMethod,  double confidence,  List<String> parentAssetIds,  List<String> childAssetIds,  List<String> relatedAssetIds,  List<String> completedTriggers,  Map<String, TriggerExecutionResult> triggerResults,  List<String> tags,  Map<String, String>? metadata,  AccessLevel? accessLevel,  List<String>? securityControls)?  $default,) {final _that = this;
switch (_that) {
case _Asset() when $default != null:
return $default(_that.id,_that.type,_that.projectId,_that.name,_that.description,_that.properties,_that.discoveryStatus,_that.discoveredAt,_that.lastUpdated,_that.discoveryMethod,_that.confidence,_that.parentAssetIds,_that.childAssetIds,_that.relatedAssetIds,_that.completedTriggers,_that.triggerResults,_that.tags,_that.metadata,_that.accessLevel,_that.securityControls);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Asset implements Asset {
  const _Asset({required this.id, required this.type, required this.projectId, required this.name, this.description, required final  Map<String, AssetPropertyValue> properties, required this.discoveryStatus, required this.discoveredAt, this.lastUpdated, this.discoveryMethod, this.confidence = 1.0, required final  List<String> parentAssetIds, required final  List<String> childAssetIds, required final  List<String> relatedAssetIds, required final  List<String> completedTriggers, required final  Map<String, TriggerExecutionResult> triggerResults, required final  List<String> tags, final  Map<String, String>? metadata, this.accessLevel, final  List<String>? securityControls}): _properties = properties,_parentAssetIds = parentAssetIds,_childAssetIds = childAssetIds,_relatedAssetIds = relatedAssetIds,_completedTriggers = completedTriggers,_triggerResults = triggerResults,_tags = tags,_metadata = metadata,_securityControls = securityControls;
  factory _Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);

@override final  String id;
@override final  AssetType type;
@override final  String projectId;
@override final  String name;
@override final  String? description;
// Rich property system - contains all asset-specific data
 final  Map<String, AssetPropertyValue> _properties;
// Rich property system - contains all asset-specific data
@override Map<String, AssetPropertyValue> get properties {
  if (_properties is EqualUnmodifiableMapView) return _properties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_properties);
}

// Discovery and status
@override final  AssetDiscoveryStatus discoveryStatus;
@override final  DateTime discoveredAt;
@override final  DateTime? lastUpdated;
@override final  String? discoveryMethod;
@override@JsonKey() final  double confidence;
// Hierarchical relationships
 final  List<String> _parentAssetIds;
// Hierarchical relationships
@override List<String> get parentAssetIds {
  if (_parentAssetIds is EqualUnmodifiableListView) return _parentAssetIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parentAssetIds);
}

 final  List<String> _childAssetIds;
@override List<String> get childAssetIds {
  if (_childAssetIds is EqualUnmodifiableListView) return _childAssetIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_childAssetIds);
}

 final  List<String> _relatedAssetIds;
@override List<String> get relatedAssetIds {
  if (_relatedAssetIds is EqualUnmodifiableListView) return _relatedAssetIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relatedAssetIds);
}

// Cross-references
// Methodology integration
 final  List<String> _completedTriggers;
// Cross-references
// Methodology integration
@override List<String> get completedTriggers {
  if (_completedTriggers is EqualUnmodifiableListView) return _completedTriggers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedTriggers);
}

 final  Map<String, TriggerExecutionResult> _triggerResults;
@override Map<String, TriggerExecutionResult> get triggerResults {
  if (_triggerResults is EqualUnmodifiableMapView) return _triggerResults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_triggerResults);
}

// Organization and filtering
 final  List<String> _tags;
// Organization and filtering
@override List<String> get tags {
  if (_tags is EqualUnmodifiableListView) return _tags;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tags);
}

 final  Map<String, String>? _metadata;
@override Map<String, String>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// Security context
@override final  AccessLevel? accessLevel;
 final  List<String>? _securityControls;
@override List<String>? get securityControls {
  final value = _securityControls;
  if (value == null) return null;
  if (_securityControls is EqualUnmodifiableListView) return _securityControls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of Asset
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssetCopyWith<_Asset> get copyWith => __$AssetCopyWithImpl<_Asset>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssetToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Asset&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._properties, _properties)&&(identical(other.discoveryStatus, discoveryStatus) || other.discoveryStatus == discoveryStatus)&&(identical(other.discoveredAt, discoveredAt) || other.discoveredAt == discoveredAt)&&(identical(other.lastUpdated, lastUpdated) || other.lastUpdated == lastUpdated)&&(identical(other.discoveryMethod, discoveryMethod) || other.discoveryMethod == discoveryMethod)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&const DeepCollectionEquality().equals(other._parentAssetIds, _parentAssetIds)&&const DeepCollectionEquality().equals(other._childAssetIds, _childAssetIds)&&const DeepCollectionEquality().equals(other._relatedAssetIds, _relatedAssetIds)&&const DeepCollectionEquality().equals(other._completedTriggers, _completedTriggers)&&const DeepCollectionEquality().equals(other._triggerResults, _triggerResults)&&const DeepCollectionEquality().equals(other._tags, _tags)&&const DeepCollectionEquality().equals(other._metadata, _metadata)&&(identical(other.accessLevel, accessLevel) || other.accessLevel == accessLevel)&&const DeepCollectionEquality().equals(other._securityControls, _securityControls));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,type,projectId,name,description,const DeepCollectionEquality().hash(_properties),discoveryStatus,discoveredAt,lastUpdated,discoveryMethod,confidence,const DeepCollectionEquality().hash(_parentAssetIds),const DeepCollectionEquality().hash(_childAssetIds),const DeepCollectionEquality().hash(_relatedAssetIds),const DeepCollectionEquality().hash(_completedTriggers),const DeepCollectionEquality().hash(_triggerResults),const DeepCollectionEquality().hash(_tags),const DeepCollectionEquality().hash(_metadata),accessLevel,const DeepCollectionEquality().hash(_securityControls)]);

@override
String toString() {
  return 'Asset(id: $id, type: $type, projectId: $projectId, name: $name, description: $description, properties: $properties, discoveryStatus: $discoveryStatus, discoveredAt: $discoveredAt, lastUpdated: $lastUpdated, discoveryMethod: $discoveryMethod, confidence: $confidence, parentAssetIds: $parentAssetIds, childAssetIds: $childAssetIds, relatedAssetIds: $relatedAssetIds, completedTriggers: $completedTriggers, triggerResults: $triggerResults, tags: $tags, metadata: $metadata, accessLevel: $accessLevel, securityControls: $securityControls)';
}


}

/// @nodoc
abstract mixin class _$AssetCopyWith<$Res> implements $AssetCopyWith<$Res> {
  factory _$AssetCopyWith(_Asset value, $Res Function(_Asset) _then) = __$AssetCopyWithImpl;
@override @useResult
$Res call({
 String id, AssetType type, String projectId, String name, String? description, Map<String, AssetPropertyValue> properties, AssetDiscoveryStatus discoveryStatus, DateTime discoveredAt, DateTime? lastUpdated, String? discoveryMethod, double confidence, List<String> parentAssetIds, List<String> childAssetIds, List<String> relatedAssetIds, List<String> completedTriggers, Map<String, TriggerExecutionResult> triggerResults, List<String> tags, Map<String, String>? metadata, AccessLevel? accessLevel, List<String>? securityControls
});




}
/// @nodoc
class __$AssetCopyWithImpl<$Res>
    implements _$AssetCopyWith<$Res> {
  __$AssetCopyWithImpl(this._self, this._then);

  final _Asset _self;
  final $Res Function(_Asset) _then;

/// Create a copy of Asset
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? projectId = null,Object? name = null,Object? description = freezed,Object? properties = null,Object? discoveryStatus = null,Object? discoveredAt = null,Object? lastUpdated = freezed,Object? discoveryMethod = freezed,Object? confidence = null,Object? parentAssetIds = null,Object? childAssetIds = null,Object? relatedAssetIds = null,Object? completedTriggers = null,Object? triggerResults = null,Object? tags = null,Object? metadata = freezed,Object? accessLevel = freezed,Object? securityControls = freezed,}) {
  return _then(_Asset(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as AssetType,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,properties: null == properties ? _self._properties : properties // ignore: cast_nullable_to_non_nullable
as Map<String, AssetPropertyValue>,discoveryStatus: null == discoveryStatus ? _self.discoveryStatus : discoveryStatus // ignore: cast_nullable_to_non_nullable
as AssetDiscoveryStatus,discoveredAt: null == discoveredAt ? _self.discoveredAt : discoveredAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastUpdated: freezed == lastUpdated ? _self.lastUpdated : lastUpdated // ignore: cast_nullable_to_non_nullable
as DateTime?,discoveryMethod: freezed == discoveryMethod ? _self.discoveryMethod : discoveryMethod // ignore: cast_nullable_to_non_nullable
as String?,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,parentAssetIds: null == parentAssetIds ? _self._parentAssetIds : parentAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,childAssetIds: null == childAssetIds ? _self._childAssetIds : childAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,relatedAssetIds: null == relatedAssetIds ? _self._relatedAssetIds : relatedAssetIds // ignore: cast_nullable_to_non_nullable
as List<String>,completedTriggers: null == completedTriggers ? _self._completedTriggers : completedTriggers // ignore: cast_nullable_to_non_nullable
as List<String>,triggerResults: null == triggerResults ? _self._triggerResults : triggerResults // ignore: cast_nullable_to_non_nullable
as Map<String, TriggerExecutionResult>,tags: null == tags ? _self._tags : tags // ignore: cast_nullable_to_non_nullable
as List<String>,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,accessLevel: freezed == accessLevel ? _self.accessLevel : accessLevel // ignore: cast_nullable_to_non_nullable
as AccessLevel?,securityControls: freezed == securityControls ? _self._securityControls : securityControls // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$TriggerExecutionResult {

 String get triggerId; String get methodologyId; DateTime get executedAt; bool get success; String? get output; String? get error; Map<String, AssetPropertyValue>? get discoveredProperties; List<Asset>? get discoveredAssets; List<String>? get triggeredMethodologies;
/// Create a copy of TriggerExecutionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TriggerExecutionResultCopyWith<TriggerExecutionResult> get copyWith => _$TriggerExecutionResultCopyWithImpl<TriggerExecutionResult>(this as TriggerExecutionResult, _$identity);

  /// Serializes this TriggerExecutionResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriggerExecutionResult&&(identical(other.triggerId, triggerId) || other.triggerId == triggerId)&&(identical(other.methodologyId, methodologyId) || other.methodologyId == methodologyId)&&(identical(other.executedAt, executedAt) || other.executedAt == executedAt)&&(identical(other.success, success) || other.success == success)&&(identical(other.output, output) || other.output == output)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other.discoveredProperties, discoveredProperties)&&const DeepCollectionEquality().equals(other.discoveredAssets, discoveredAssets)&&const DeepCollectionEquality().equals(other.triggeredMethodologies, triggeredMethodologies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,triggerId,methodologyId,executedAt,success,output,error,const DeepCollectionEquality().hash(discoveredProperties),const DeepCollectionEquality().hash(discoveredAssets),const DeepCollectionEquality().hash(triggeredMethodologies));

@override
String toString() {
  return 'TriggerExecutionResult(triggerId: $triggerId, methodologyId: $methodologyId, executedAt: $executedAt, success: $success, output: $output, error: $error, discoveredProperties: $discoveredProperties, discoveredAssets: $discoveredAssets, triggeredMethodologies: $triggeredMethodologies)';
}


}

/// @nodoc
abstract mixin class $TriggerExecutionResultCopyWith<$Res>  {
  factory $TriggerExecutionResultCopyWith(TriggerExecutionResult value, $Res Function(TriggerExecutionResult) _then) = _$TriggerExecutionResultCopyWithImpl;
@useResult
$Res call({
 String triggerId, String methodologyId, DateTime executedAt, bool success, String? output, String? error, Map<String, AssetPropertyValue>? discoveredProperties, List<Asset>? discoveredAssets, List<String>? triggeredMethodologies
});




}
/// @nodoc
class _$TriggerExecutionResultCopyWithImpl<$Res>
    implements $TriggerExecutionResultCopyWith<$Res> {
  _$TriggerExecutionResultCopyWithImpl(this._self, this._then);

  final TriggerExecutionResult _self;
  final $Res Function(TriggerExecutionResult) _then;

/// Create a copy of TriggerExecutionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? triggerId = null,Object? methodologyId = null,Object? executedAt = null,Object? success = null,Object? output = freezed,Object? error = freezed,Object? discoveredProperties = freezed,Object? discoveredAssets = freezed,Object? triggeredMethodologies = freezed,}) {
  return _then(_self.copyWith(
triggerId: null == triggerId ? _self.triggerId : triggerId // ignore: cast_nullable_to_non_nullable
as String,methodologyId: null == methodologyId ? _self.methodologyId : methodologyId // ignore: cast_nullable_to_non_nullable
as String,executedAt: null == executedAt ? _self.executedAt : executedAt // ignore: cast_nullable_to_non_nullable
as DateTime,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,output: freezed == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,discoveredProperties: freezed == discoveredProperties ? _self.discoveredProperties : discoveredProperties // ignore: cast_nullable_to_non_nullable
as Map<String, AssetPropertyValue>?,discoveredAssets: freezed == discoveredAssets ? _self.discoveredAssets : discoveredAssets // ignore: cast_nullable_to_non_nullable
as List<Asset>?,triggeredMethodologies: freezed == triggeredMethodologies ? _self.triggeredMethodologies : triggeredMethodologies // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [TriggerExecutionResult].
extension TriggerExecutionResultPatterns on TriggerExecutionResult {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TriggerExecutionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriggerExecutionResult() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TriggerExecutionResult value)  $default,){
final _that = this;
switch (_that) {
case _TriggerExecutionResult():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TriggerExecutionResult value)?  $default,){
final _that = this;
switch (_that) {
case _TriggerExecutionResult() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String triggerId,  String methodologyId,  DateTime executedAt,  bool success,  String? output,  String? error,  Map<String, AssetPropertyValue>? discoveredProperties,  List<Asset>? discoveredAssets,  List<String>? triggeredMethodologies)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriggerExecutionResult() when $default != null:
return $default(_that.triggerId,_that.methodologyId,_that.executedAt,_that.success,_that.output,_that.error,_that.discoveredProperties,_that.discoveredAssets,_that.triggeredMethodologies);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String triggerId,  String methodologyId,  DateTime executedAt,  bool success,  String? output,  String? error,  Map<String, AssetPropertyValue>? discoveredProperties,  List<Asset>? discoveredAssets,  List<String>? triggeredMethodologies)  $default,) {final _that = this;
switch (_that) {
case _TriggerExecutionResult():
return $default(_that.triggerId,_that.methodologyId,_that.executedAt,_that.success,_that.output,_that.error,_that.discoveredProperties,_that.discoveredAssets,_that.triggeredMethodologies);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String triggerId,  String methodologyId,  DateTime executedAt,  bool success,  String? output,  String? error,  Map<String, AssetPropertyValue>? discoveredProperties,  List<Asset>? discoveredAssets,  List<String>? triggeredMethodologies)?  $default,) {final _that = this;
switch (_that) {
case _TriggerExecutionResult() when $default != null:
return $default(_that.triggerId,_that.methodologyId,_that.executedAt,_that.success,_that.output,_that.error,_that.discoveredProperties,_that.discoveredAssets,_that.triggeredMethodologies);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TriggerExecutionResult implements TriggerExecutionResult {
  const _TriggerExecutionResult({required this.triggerId, required this.methodologyId, required this.executedAt, required this.success, this.output, this.error, final  Map<String, AssetPropertyValue>? discoveredProperties, final  List<Asset>? discoveredAssets, final  List<String>? triggeredMethodologies}): _discoveredProperties = discoveredProperties,_discoveredAssets = discoveredAssets,_triggeredMethodologies = triggeredMethodologies;
  factory _TriggerExecutionResult.fromJson(Map<String, dynamic> json) => _$TriggerExecutionResultFromJson(json);

@override final  String triggerId;
@override final  String methodologyId;
@override final  DateTime executedAt;
@override final  bool success;
@override final  String? output;
@override final  String? error;
 final  Map<String, AssetPropertyValue>? _discoveredProperties;
@override Map<String, AssetPropertyValue>? get discoveredProperties {
  final value = _discoveredProperties;
  if (value == null) return null;
  if (_discoveredProperties is EqualUnmodifiableMapView) return _discoveredProperties;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<Asset>? _discoveredAssets;
@override List<Asset>? get discoveredAssets {
  final value = _discoveredAssets;
  if (value == null) return null;
  if (_discoveredAssets is EqualUnmodifiableListView) return _discoveredAssets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _triggeredMethodologies;
@override List<String>? get triggeredMethodologies {
  final value = _triggeredMethodologies;
  if (value == null) return null;
  if (_triggeredMethodologies is EqualUnmodifiableListView) return _triggeredMethodologies;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}


/// Create a copy of TriggerExecutionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriggerExecutionResultCopyWith<_TriggerExecutionResult> get copyWith => __$TriggerExecutionResultCopyWithImpl<_TriggerExecutionResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TriggerExecutionResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriggerExecutionResult&&(identical(other.triggerId, triggerId) || other.triggerId == triggerId)&&(identical(other.methodologyId, methodologyId) || other.methodologyId == methodologyId)&&(identical(other.executedAt, executedAt) || other.executedAt == executedAt)&&(identical(other.success, success) || other.success == success)&&(identical(other.output, output) || other.output == output)&&(identical(other.error, error) || other.error == error)&&const DeepCollectionEquality().equals(other._discoveredProperties, _discoveredProperties)&&const DeepCollectionEquality().equals(other._discoveredAssets, _discoveredAssets)&&const DeepCollectionEquality().equals(other._triggeredMethodologies, _triggeredMethodologies));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,triggerId,methodologyId,executedAt,success,output,error,const DeepCollectionEquality().hash(_discoveredProperties),const DeepCollectionEquality().hash(_discoveredAssets),const DeepCollectionEquality().hash(_triggeredMethodologies));

@override
String toString() {
  return 'TriggerExecutionResult(triggerId: $triggerId, methodologyId: $methodologyId, executedAt: $executedAt, success: $success, output: $output, error: $error, discoveredProperties: $discoveredProperties, discoveredAssets: $discoveredAssets, triggeredMethodologies: $triggeredMethodologies)';
}


}

/// @nodoc
abstract mixin class _$TriggerExecutionResultCopyWith<$Res> implements $TriggerExecutionResultCopyWith<$Res> {
  factory _$TriggerExecutionResultCopyWith(_TriggerExecutionResult value, $Res Function(_TriggerExecutionResult) _then) = __$TriggerExecutionResultCopyWithImpl;
@override @useResult
$Res call({
 String triggerId, String methodologyId, DateTime executedAt, bool success, String? output, String? error, Map<String, AssetPropertyValue>? discoveredProperties, List<Asset>? discoveredAssets, List<String>? triggeredMethodologies
});




}
/// @nodoc
class __$TriggerExecutionResultCopyWithImpl<$Res>
    implements _$TriggerExecutionResultCopyWith<$Res> {
  __$TriggerExecutionResultCopyWithImpl(this._self, this._then);

  final _TriggerExecutionResult _self;
  final $Res Function(_TriggerExecutionResult) _then;

/// Create a copy of TriggerExecutionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? triggerId = null,Object? methodologyId = null,Object? executedAt = null,Object? success = null,Object? output = freezed,Object? error = freezed,Object? discoveredProperties = freezed,Object? discoveredAssets = freezed,Object? triggeredMethodologies = freezed,}) {
  return _then(_TriggerExecutionResult(
triggerId: null == triggerId ? _self.triggerId : triggerId // ignore: cast_nullable_to_non_nullable
as String,methodologyId: null == methodologyId ? _self.methodologyId : methodologyId // ignore: cast_nullable_to_non_nullable
as String,executedAt: null == executedAt ? _self.executedAt : executedAt // ignore: cast_nullable_to_non_nullable
as DateTime,success: null == success ? _self.success : success // ignore: cast_nullable_to_non_nullable
as bool,output: freezed == output ? _self.output : output // ignore: cast_nullable_to_non_nullable
as String?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,discoveredProperties: freezed == discoveredProperties ? _self._discoveredProperties : discoveredProperties // ignore: cast_nullable_to_non_nullable
as Map<String, AssetPropertyValue>?,discoveredAssets: freezed == discoveredAssets ? _self._discoveredAssets : discoveredAssets // ignore: cast_nullable_to_non_nullable
as List<Asset>?,triggeredMethodologies: freezed == triggeredMethodologies ? _self._triggeredMethodologies : triggeredMethodologies // ignore: cast_nullable_to_non_nullable
as List<String>?,
  ));
}


}


/// @nodoc
mixin _$SoftwareVersion {

 int get major; int get minor; int get patch; String? get build; String? get edition; DateTime? get releaseDate;
/// Create a copy of SoftwareVersion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SoftwareVersionCopyWith<SoftwareVersion> get copyWith => _$SoftwareVersionCopyWithImpl<SoftwareVersion>(this as SoftwareVersion, _$identity);

  /// Serializes this SoftwareVersion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SoftwareVersion&&(identical(other.major, major) || other.major == major)&&(identical(other.minor, minor) || other.minor == minor)&&(identical(other.patch, patch) || other.patch == patch)&&(identical(other.build, build) || other.build == build)&&(identical(other.edition, edition) || other.edition == edition)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,major,minor,patch,build,edition,releaseDate);

@override
String toString() {
  return 'SoftwareVersion(major: $major, minor: $minor, patch: $patch, build: $build, edition: $edition, releaseDate: $releaseDate)';
}


}

/// @nodoc
abstract mixin class $SoftwareVersionCopyWith<$Res>  {
  factory $SoftwareVersionCopyWith(SoftwareVersion value, $Res Function(SoftwareVersion) _then) = _$SoftwareVersionCopyWithImpl;
@useResult
$Res call({
 int major, int minor, int patch, String? build, String? edition, DateTime? releaseDate
});




}
/// @nodoc
class _$SoftwareVersionCopyWithImpl<$Res>
    implements $SoftwareVersionCopyWith<$Res> {
  _$SoftwareVersionCopyWithImpl(this._self, this._then);

  final SoftwareVersion _self;
  final $Res Function(SoftwareVersion) _then;

/// Create a copy of SoftwareVersion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? major = null,Object? minor = null,Object? patch = null,Object? build = freezed,Object? edition = freezed,Object? releaseDate = freezed,}) {
  return _then(_self.copyWith(
major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as int,minor: null == minor ? _self.minor : minor // ignore: cast_nullable_to_non_nullable
as int,patch: null == patch ? _self.patch : patch // ignore: cast_nullable_to_non_nullable
as int,build: freezed == build ? _self.build : build // ignore: cast_nullable_to_non_nullable
as String?,edition: freezed == edition ? _self.edition : edition // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [SoftwareVersion].
extension SoftwareVersionPatterns on SoftwareVersion {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SoftwareVersion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SoftwareVersion() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SoftwareVersion value)  $default,){
final _that = this;
switch (_that) {
case _SoftwareVersion():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SoftwareVersion value)?  $default,){
final _that = this;
switch (_that) {
case _SoftwareVersion() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int major,  int minor,  int patch,  String? build,  String? edition,  DateTime? releaseDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SoftwareVersion() when $default != null:
return $default(_that.major,_that.minor,_that.patch,_that.build,_that.edition,_that.releaseDate);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int major,  int minor,  int patch,  String? build,  String? edition,  DateTime? releaseDate)  $default,) {final _that = this;
switch (_that) {
case _SoftwareVersion():
return $default(_that.major,_that.minor,_that.patch,_that.build,_that.edition,_that.releaseDate);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int major,  int minor,  int patch,  String? build,  String? edition,  DateTime? releaseDate)?  $default,) {final _that = this;
switch (_that) {
case _SoftwareVersion() when $default != null:
return $default(_that.major,_that.minor,_that.patch,_that.build,_that.edition,_that.releaseDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SoftwareVersion implements SoftwareVersion {
  const _SoftwareVersion({required this.major, required this.minor, required this.patch, this.build, this.edition, this.releaseDate});
  factory _SoftwareVersion.fromJson(Map<String, dynamic> json) => _$SoftwareVersionFromJson(json);

@override final  int major;
@override final  int minor;
@override final  int patch;
@override final  String? build;
@override final  String? edition;
@override final  DateTime? releaseDate;

/// Create a copy of SoftwareVersion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SoftwareVersionCopyWith<_SoftwareVersion> get copyWith => __$SoftwareVersionCopyWithImpl<_SoftwareVersion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SoftwareVersionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SoftwareVersion&&(identical(other.major, major) || other.major == major)&&(identical(other.minor, minor) || other.minor == minor)&&(identical(other.patch, patch) || other.patch == patch)&&(identical(other.build, build) || other.build == build)&&(identical(other.edition, edition) || other.edition == edition)&&(identical(other.releaseDate, releaseDate) || other.releaseDate == releaseDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,major,minor,patch,build,edition,releaseDate);

@override
String toString() {
  return 'SoftwareVersion(major: $major, minor: $minor, patch: $patch, build: $build, edition: $edition, releaseDate: $releaseDate)';
}


}

/// @nodoc
abstract mixin class _$SoftwareVersionCopyWith<$Res> implements $SoftwareVersionCopyWith<$Res> {
  factory _$SoftwareVersionCopyWith(_SoftwareVersion value, $Res Function(_SoftwareVersion) _then) = __$SoftwareVersionCopyWithImpl;
@override @useResult
$Res call({
 int major, int minor, int patch, String? build, String? edition, DateTime? releaseDate
});




}
/// @nodoc
class __$SoftwareVersionCopyWithImpl<$Res>
    implements _$SoftwareVersionCopyWith<$Res> {
  __$SoftwareVersionCopyWithImpl(this._self, this._then);

  final _SoftwareVersion _self;
  final $Res Function(_SoftwareVersion) _then;

/// Create a copy of SoftwareVersion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? major = null,Object? minor = null,Object? patch = null,Object? build = freezed,Object? edition = freezed,Object? releaseDate = freezed,}) {
  return _then(_SoftwareVersion(
major: null == major ? _self.major : major // ignore: cast_nullable_to_non_nullable
as int,minor: null == minor ? _self.minor : minor // ignore: cast_nullable_to_non_nullable
as int,patch: null == patch ? _self.patch : patch // ignore: cast_nullable_to_non_nullable
as int,build: freezed == build ? _self.build : build // ignore: cast_nullable_to_non_nullable
as String?,edition: freezed == edition ? _self.edition : edition // ignore: cast_nullable_to_non_nullable
as String?,releaseDate: freezed == releaseDate ? _self.releaseDate : releaseDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$NetworkAddress {

 String get ip; String? get subnet; String? get gateway; List<String>? get dnsServers; String? get macAddress; bool? get isStatic;
/// Create a copy of NetworkAddress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkAddressCopyWith<NetworkAddress> get copyWith => _$NetworkAddressCopyWithImpl<NetworkAddress>(this as NetworkAddress, _$identity);

  /// Serializes this NetworkAddress to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkAddress&&(identical(other.ip, ip) || other.ip == ip)&&(identical(other.subnet, subnet) || other.subnet == subnet)&&(identical(other.gateway, gateway) || other.gateway == gateway)&&const DeepCollectionEquality().equals(other.dnsServers, dnsServers)&&(identical(other.macAddress, macAddress) || other.macAddress == macAddress)&&(identical(other.isStatic, isStatic) || other.isStatic == isStatic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ip,subnet,gateway,const DeepCollectionEquality().hash(dnsServers),macAddress,isStatic);

@override
String toString() {
  return 'NetworkAddress(ip: $ip, subnet: $subnet, gateway: $gateway, dnsServers: $dnsServers, macAddress: $macAddress, isStatic: $isStatic)';
}


}

/// @nodoc
abstract mixin class $NetworkAddressCopyWith<$Res>  {
  factory $NetworkAddressCopyWith(NetworkAddress value, $Res Function(NetworkAddress) _then) = _$NetworkAddressCopyWithImpl;
@useResult
$Res call({
 String ip, String? subnet, String? gateway, List<String>? dnsServers, String? macAddress, bool? isStatic
});




}
/// @nodoc
class _$NetworkAddressCopyWithImpl<$Res>
    implements $NetworkAddressCopyWith<$Res> {
  _$NetworkAddressCopyWithImpl(this._self, this._then);

  final NetworkAddress _self;
  final $Res Function(NetworkAddress) _then;

/// Create a copy of NetworkAddress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ip = null,Object? subnet = freezed,Object? gateway = freezed,Object? dnsServers = freezed,Object? macAddress = freezed,Object? isStatic = freezed,}) {
  return _then(_self.copyWith(
ip: null == ip ? _self.ip : ip // ignore: cast_nullable_to_non_nullable
as String,subnet: freezed == subnet ? _self.subnet : subnet // ignore: cast_nullable_to_non_nullable
as String?,gateway: freezed == gateway ? _self.gateway : gateway // ignore: cast_nullable_to_non_nullable
as String?,dnsServers: freezed == dnsServers ? _self.dnsServers : dnsServers // ignore: cast_nullable_to_non_nullable
as List<String>?,macAddress: freezed == macAddress ? _self.macAddress : macAddress // ignore: cast_nullable_to_non_nullable
as String?,isStatic: freezed == isStatic ? _self.isStatic : isStatic // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [NetworkAddress].
extension NetworkAddressPatterns on NetworkAddress {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetworkAddress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetworkAddress() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetworkAddress value)  $default,){
final _that = this;
switch (_that) {
case _NetworkAddress():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetworkAddress value)?  $default,){
final _that = this;
switch (_that) {
case _NetworkAddress() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ip,  String? subnet,  String? gateway,  List<String>? dnsServers,  String? macAddress,  bool? isStatic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetworkAddress() when $default != null:
return $default(_that.ip,_that.subnet,_that.gateway,_that.dnsServers,_that.macAddress,_that.isStatic);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ip,  String? subnet,  String? gateway,  List<String>? dnsServers,  String? macAddress,  bool? isStatic)  $default,) {final _that = this;
switch (_that) {
case _NetworkAddress():
return $default(_that.ip,_that.subnet,_that.gateway,_that.dnsServers,_that.macAddress,_that.isStatic);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ip,  String? subnet,  String? gateway,  List<String>? dnsServers,  String? macAddress,  bool? isStatic)?  $default,) {final _that = this;
switch (_that) {
case _NetworkAddress() when $default != null:
return $default(_that.ip,_that.subnet,_that.gateway,_that.dnsServers,_that.macAddress,_that.isStatic);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NetworkAddress implements NetworkAddress {
  const _NetworkAddress({required this.ip, this.subnet, this.gateway, final  List<String>? dnsServers, this.macAddress, this.isStatic}): _dnsServers = dnsServers;
  factory _NetworkAddress.fromJson(Map<String, dynamic> json) => _$NetworkAddressFromJson(json);

@override final  String ip;
@override final  String? subnet;
@override final  String? gateway;
 final  List<String>? _dnsServers;
@override List<String>? get dnsServers {
  final value = _dnsServers;
  if (value == null) return null;
  if (_dnsServers is EqualUnmodifiableListView) return _dnsServers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? macAddress;
@override final  bool? isStatic;

/// Create a copy of NetworkAddress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkAddressCopyWith<_NetworkAddress> get copyWith => __$NetworkAddressCopyWithImpl<_NetworkAddress>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NetworkAddressToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkAddress&&(identical(other.ip, ip) || other.ip == ip)&&(identical(other.subnet, subnet) || other.subnet == subnet)&&(identical(other.gateway, gateway) || other.gateway == gateway)&&const DeepCollectionEquality().equals(other._dnsServers, _dnsServers)&&(identical(other.macAddress, macAddress) || other.macAddress == macAddress)&&(identical(other.isStatic, isStatic) || other.isStatic == isStatic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ip,subnet,gateway,const DeepCollectionEquality().hash(_dnsServers),macAddress,isStatic);

@override
String toString() {
  return 'NetworkAddress(ip: $ip, subnet: $subnet, gateway: $gateway, dnsServers: $dnsServers, macAddress: $macAddress, isStatic: $isStatic)';
}


}

/// @nodoc
abstract mixin class _$NetworkAddressCopyWith<$Res> implements $NetworkAddressCopyWith<$Res> {
  factory _$NetworkAddressCopyWith(_NetworkAddress value, $Res Function(_NetworkAddress) _then) = __$NetworkAddressCopyWithImpl;
@override @useResult
$Res call({
 String ip, String? subnet, String? gateway, List<String>? dnsServers, String? macAddress, bool? isStatic
});




}
/// @nodoc
class __$NetworkAddressCopyWithImpl<$Res>
    implements _$NetworkAddressCopyWith<$Res> {
  __$NetworkAddressCopyWithImpl(this._self, this._then);

  final _NetworkAddress _self;
  final $Res Function(_NetworkAddress) _then;

/// Create a copy of NetworkAddress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ip = null,Object? subnet = freezed,Object? gateway = freezed,Object? dnsServers = freezed,Object? macAddress = freezed,Object? isStatic = freezed,}) {
  return _then(_NetworkAddress(
ip: null == ip ? _self.ip : ip // ignore: cast_nullable_to_non_nullable
as String,subnet: freezed == subnet ? _self.subnet : subnet // ignore: cast_nullable_to_non_nullable
as String?,gateway: freezed == gateway ? _self.gateway : gateway // ignore: cast_nullable_to_non_nullable
as String?,dnsServers: freezed == dnsServers ? _self._dnsServers : dnsServers // ignore: cast_nullable_to_non_nullable
as List<String>?,macAddress: freezed == macAddress ? _self.macAddress : macAddress // ignore: cast_nullable_to_non_nullable
as String?,isStatic: freezed == isStatic ? _self.isStatic : isStatic // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$PhysicalLocation {

 String? get address; String? get city; String? get state; String? get country; String? get postalCode; double? get latitude; double? get longitude; String? get building; String? get floor; String? get room;
/// Create a copy of PhysicalLocation
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhysicalLocationCopyWith<PhysicalLocation> get copyWith => _$PhysicalLocationCopyWithImpl<PhysicalLocation>(this as PhysicalLocation, _$identity);

  /// Serializes this PhysicalLocation to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhysicalLocation&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.building, building) || other.building == building)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.room, room) || other.room == room));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,address,city,state,country,postalCode,latitude,longitude,building,floor,room);

@override
String toString() {
  return 'PhysicalLocation(address: $address, city: $city, state: $state, country: $country, postalCode: $postalCode, latitude: $latitude, longitude: $longitude, building: $building, floor: $floor, room: $room)';
}


}

/// @nodoc
abstract mixin class $PhysicalLocationCopyWith<$Res>  {
  factory $PhysicalLocationCopyWith(PhysicalLocation value, $Res Function(PhysicalLocation) _then) = _$PhysicalLocationCopyWithImpl;
@useResult
$Res call({
 String? address, String? city, String? state, String? country, String? postalCode, double? latitude, double? longitude, String? building, String? floor, String? room
});




}
/// @nodoc
class _$PhysicalLocationCopyWithImpl<$Res>
    implements $PhysicalLocationCopyWith<$Res> {
  _$PhysicalLocationCopyWithImpl(this._self, this._then);

  final PhysicalLocation _self;
  final $Res Function(PhysicalLocation) _then;

/// Create a copy of PhysicalLocation
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? address = freezed,Object? city = freezed,Object? state = freezed,Object? country = freezed,Object? postalCode = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? building = freezed,Object? floor = freezed,Object? room = freezed,}) {
  return _then(_self.copyWith(
address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,building: freezed == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String?,floor: freezed == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String?,room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PhysicalLocation].
extension PhysicalLocationPatterns on PhysicalLocation {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhysicalLocation value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhysicalLocation() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhysicalLocation value)  $default,){
final _that = this;
switch (_that) {
case _PhysicalLocation():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhysicalLocation value)?  $default,){
final _that = this;
switch (_that) {
case _PhysicalLocation() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? address,  String? city,  String? state,  String? country,  String? postalCode,  double? latitude,  double? longitude,  String? building,  String? floor,  String? room)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhysicalLocation() when $default != null:
return $default(_that.address,_that.city,_that.state,_that.country,_that.postalCode,_that.latitude,_that.longitude,_that.building,_that.floor,_that.room);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? address,  String? city,  String? state,  String? country,  String? postalCode,  double? latitude,  double? longitude,  String? building,  String? floor,  String? room)  $default,) {final _that = this;
switch (_that) {
case _PhysicalLocation():
return $default(_that.address,_that.city,_that.state,_that.country,_that.postalCode,_that.latitude,_that.longitude,_that.building,_that.floor,_that.room);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? address,  String? city,  String? state,  String? country,  String? postalCode,  double? latitude,  double? longitude,  String? building,  String? floor,  String? room)?  $default,) {final _that = this;
switch (_that) {
case _PhysicalLocation() when $default != null:
return $default(_that.address,_that.city,_that.state,_that.country,_that.postalCode,_that.latitude,_that.longitude,_that.building,_that.floor,_that.room);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhysicalLocation implements PhysicalLocation {
  const _PhysicalLocation({this.address, this.city, this.state, this.country, this.postalCode, this.latitude, this.longitude, this.building, this.floor, this.room});
  factory _PhysicalLocation.fromJson(Map<String, dynamic> json) => _$PhysicalLocationFromJson(json);

@override final  String? address;
@override final  String? city;
@override final  String? state;
@override final  String? country;
@override final  String? postalCode;
@override final  double? latitude;
@override final  double? longitude;
@override final  String? building;
@override final  String? floor;
@override final  String? room;

/// Create a copy of PhysicalLocation
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhysicalLocationCopyWith<_PhysicalLocation> get copyWith => __$PhysicalLocationCopyWithImpl<_PhysicalLocation>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhysicalLocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhysicalLocation&&(identical(other.address, address) || other.address == address)&&(identical(other.city, city) || other.city == city)&&(identical(other.state, state) || other.state == state)&&(identical(other.country, country) || other.country == country)&&(identical(other.postalCode, postalCode) || other.postalCode == postalCode)&&(identical(other.latitude, latitude) || other.latitude == latitude)&&(identical(other.longitude, longitude) || other.longitude == longitude)&&(identical(other.building, building) || other.building == building)&&(identical(other.floor, floor) || other.floor == floor)&&(identical(other.room, room) || other.room == room));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,address,city,state,country,postalCode,latitude,longitude,building,floor,room);

@override
String toString() {
  return 'PhysicalLocation(address: $address, city: $city, state: $state, country: $country, postalCode: $postalCode, latitude: $latitude, longitude: $longitude, building: $building, floor: $floor, room: $room)';
}


}

/// @nodoc
abstract mixin class _$PhysicalLocationCopyWith<$Res> implements $PhysicalLocationCopyWith<$Res> {
  factory _$PhysicalLocationCopyWith(_PhysicalLocation value, $Res Function(_PhysicalLocation) _then) = __$PhysicalLocationCopyWithImpl;
@override @useResult
$Res call({
 String? address, String? city, String? state, String? country, String? postalCode, double? latitude, double? longitude, String? building, String? floor, String? room
});




}
/// @nodoc
class __$PhysicalLocationCopyWithImpl<$Res>
    implements _$PhysicalLocationCopyWith<$Res> {
  __$PhysicalLocationCopyWithImpl(this._self, this._then);

  final _PhysicalLocation _self;
  final $Res Function(_PhysicalLocation) _then;

/// Create a copy of PhysicalLocation
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? address = freezed,Object? city = freezed,Object? state = freezed,Object? country = freezed,Object? postalCode = freezed,Object? latitude = freezed,Object? longitude = freezed,Object? building = freezed,Object? floor = freezed,Object? room = freezed,}) {
  return _then(_PhysicalLocation(
address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,state: freezed == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String?,country: freezed == country ? _self.country : country // ignore: cast_nullable_to_non_nullable
as String?,postalCode: freezed == postalCode ? _self.postalCode : postalCode // ignore: cast_nullable_to_non_nullable
as String?,latitude: freezed == latitude ? _self.latitude : latitude // ignore: cast_nullable_to_non_nullable
as double?,longitude: freezed == longitude ? _self.longitude : longitude // ignore: cast_nullable_to_non_nullable
as double?,building: freezed == building ? _self.building : building // ignore: cast_nullable_to_non_nullable
as String?,floor: freezed == floor ? _self.floor : floor // ignore: cast_nullable_to_non_nullable
as String?,room: freezed == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$NetworkInterface {

 String get id; String get name;// "eth0", "Ethernet", "Wi-Fi"
 String get type;// "ethernet", "wireless", "loopback", "virtual"
 String get macAddress; bool get isEnabled; List<NetworkAddress> get addresses; String? get description; String? get vendor; String? get driver; int? get speedMbps; bool? get isConnected; String? get connectedSwitchPort; String? get vlanId; Map<String, String>? get driverInfo; DateTime? get lastSeen;
/// Create a copy of NetworkInterface
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NetworkInterfaceCopyWith<NetworkInterface> get copyWith => _$NetworkInterfaceCopyWithImpl<NetworkInterface>(this as NetworkInterface, _$identity);

  /// Serializes this NetworkInterface to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkInterface&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.macAddress, macAddress) || other.macAddress == macAddress)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&const DeepCollectionEquality().equals(other.addresses, addresses)&&(identical(other.description, description) || other.description == description)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.driver, driver) || other.driver == driver)&&(identical(other.speedMbps, speedMbps) || other.speedMbps == speedMbps)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.connectedSwitchPort, connectedSwitchPort) || other.connectedSwitchPort == connectedSwitchPort)&&(identical(other.vlanId, vlanId) || other.vlanId == vlanId)&&const DeepCollectionEquality().equals(other.driverInfo, driverInfo)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,macAddress,isEnabled,const DeepCollectionEquality().hash(addresses),description,vendor,driver,speedMbps,isConnected,connectedSwitchPort,vlanId,const DeepCollectionEquality().hash(driverInfo),lastSeen);

@override
String toString() {
  return 'NetworkInterface(id: $id, name: $name, type: $type, macAddress: $macAddress, isEnabled: $isEnabled, addresses: $addresses, description: $description, vendor: $vendor, driver: $driver, speedMbps: $speedMbps, isConnected: $isConnected, connectedSwitchPort: $connectedSwitchPort, vlanId: $vlanId, driverInfo: $driverInfo, lastSeen: $lastSeen)';
}


}

/// @nodoc
abstract mixin class $NetworkInterfaceCopyWith<$Res>  {
  factory $NetworkInterfaceCopyWith(NetworkInterface value, $Res Function(NetworkInterface) _then) = _$NetworkInterfaceCopyWithImpl;
@useResult
$Res call({
 String id, String name, String type, String macAddress, bool isEnabled, List<NetworkAddress> addresses, String? description, String? vendor, String? driver, int? speedMbps, bool? isConnected, String? connectedSwitchPort, String? vlanId, Map<String, String>? driverInfo, DateTime? lastSeen
});




}
/// @nodoc
class _$NetworkInterfaceCopyWithImpl<$Res>
    implements $NetworkInterfaceCopyWith<$Res> {
  _$NetworkInterfaceCopyWithImpl(this._self, this._then);

  final NetworkInterface _self;
  final $Res Function(NetworkInterface) _then;

/// Create a copy of NetworkInterface
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? macAddress = null,Object? isEnabled = null,Object? addresses = null,Object? description = freezed,Object? vendor = freezed,Object? driver = freezed,Object? speedMbps = freezed,Object? isConnected = freezed,Object? connectedSwitchPort = freezed,Object? vlanId = freezed,Object? driverInfo = freezed,Object? lastSeen = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,macAddress: null == macAddress ? _self.macAddress : macAddress // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,addresses: null == addresses ? _self.addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<NetworkAddress>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String?,driver: freezed == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as String?,speedMbps: freezed == speedMbps ? _self.speedMbps : speedMbps // ignore: cast_nullable_to_non_nullable
as int?,isConnected: freezed == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool?,connectedSwitchPort: freezed == connectedSwitchPort ? _self.connectedSwitchPort : connectedSwitchPort // ignore: cast_nullable_to_non_nullable
as String?,vlanId: freezed == vlanId ? _self.vlanId : vlanId // ignore: cast_nullable_to_non_nullable
as String?,driverInfo: freezed == driverInfo ? _self.driverInfo : driverInfo // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [NetworkInterface].
extension NetworkInterfacePatterns on NetworkInterface {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NetworkInterface value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NetworkInterface() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NetworkInterface value)  $default,){
final _that = this;
switch (_that) {
case _NetworkInterface():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NetworkInterface value)?  $default,){
final _that = this;
switch (_that) {
case _NetworkInterface() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String type,  String macAddress,  bool isEnabled,  List<NetworkAddress> addresses,  String? description,  String? vendor,  String? driver,  int? speedMbps,  bool? isConnected,  String? connectedSwitchPort,  String? vlanId,  Map<String, String>? driverInfo,  DateTime? lastSeen)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NetworkInterface() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.macAddress,_that.isEnabled,_that.addresses,_that.description,_that.vendor,_that.driver,_that.speedMbps,_that.isConnected,_that.connectedSwitchPort,_that.vlanId,_that.driverInfo,_that.lastSeen);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String type,  String macAddress,  bool isEnabled,  List<NetworkAddress> addresses,  String? description,  String? vendor,  String? driver,  int? speedMbps,  bool? isConnected,  String? connectedSwitchPort,  String? vlanId,  Map<String, String>? driverInfo,  DateTime? lastSeen)  $default,) {final _that = this;
switch (_that) {
case _NetworkInterface():
return $default(_that.id,_that.name,_that.type,_that.macAddress,_that.isEnabled,_that.addresses,_that.description,_that.vendor,_that.driver,_that.speedMbps,_that.isConnected,_that.connectedSwitchPort,_that.vlanId,_that.driverInfo,_that.lastSeen);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String type,  String macAddress,  bool isEnabled,  List<NetworkAddress> addresses,  String? description,  String? vendor,  String? driver,  int? speedMbps,  bool? isConnected,  String? connectedSwitchPort,  String? vlanId,  Map<String, String>? driverInfo,  DateTime? lastSeen)?  $default,) {final _that = this;
switch (_that) {
case _NetworkInterface() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.macAddress,_that.isEnabled,_that.addresses,_that.description,_that.vendor,_that.driver,_that.speedMbps,_that.isConnected,_that.connectedSwitchPort,_that.vlanId,_that.driverInfo,_that.lastSeen);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NetworkInterface implements NetworkInterface {
  const _NetworkInterface({required this.id, required this.name, required this.type, required this.macAddress, required this.isEnabled, required final  List<NetworkAddress> addresses, this.description, this.vendor, this.driver, this.speedMbps, this.isConnected, this.connectedSwitchPort, this.vlanId, final  Map<String, String>? driverInfo, this.lastSeen}): _addresses = addresses,_driverInfo = driverInfo;
  factory _NetworkInterface.fromJson(Map<String, dynamic> json) => _$NetworkInterfaceFromJson(json);

@override final  String id;
@override final  String name;
// "eth0", "Ethernet", "Wi-Fi"
@override final  String type;
// "ethernet", "wireless", "loopback", "virtual"
@override final  String macAddress;
@override final  bool isEnabled;
 final  List<NetworkAddress> _addresses;
@override List<NetworkAddress> get addresses {
  if (_addresses is EqualUnmodifiableListView) return _addresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_addresses);
}

@override final  String? description;
@override final  String? vendor;
@override final  String? driver;
@override final  int? speedMbps;
@override final  bool? isConnected;
@override final  String? connectedSwitchPort;
@override final  String? vlanId;
 final  Map<String, String>? _driverInfo;
@override Map<String, String>? get driverInfo {
  final value = _driverInfo;
  if (value == null) return null;
  if (_driverInfo is EqualUnmodifiableMapView) return _driverInfo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? lastSeen;

/// Create a copy of NetworkInterface
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NetworkInterfaceCopyWith<_NetworkInterface> get copyWith => __$NetworkInterfaceCopyWithImpl<_NetworkInterface>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NetworkInterfaceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NetworkInterface&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.macAddress, macAddress) || other.macAddress == macAddress)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&const DeepCollectionEquality().equals(other._addresses, _addresses)&&(identical(other.description, description) || other.description == description)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.driver, driver) || other.driver == driver)&&(identical(other.speedMbps, speedMbps) || other.speedMbps == speedMbps)&&(identical(other.isConnected, isConnected) || other.isConnected == isConnected)&&(identical(other.connectedSwitchPort, connectedSwitchPort) || other.connectedSwitchPort == connectedSwitchPort)&&(identical(other.vlanId, vlanId) || other.vlanId == vlanId)&&const DeepCollectionEquality().equals(other._driverInfo, _driverInfo)&&(identical(other.lastSeen, lastSeen) || other.lastSeen == lastSeen));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,type,macAddress,isEnabled,const DeepCollectionEquality().hash(_addresses),description,vendor,driver,speedMbps,isConnected,connectedSwitchPort,vlanId,const DeepCollectionEquality().hash(_driverInfo),lastSeen);

@override
String toString() {
  return 'NetworkInterface(id: $id, name: $name, type: $type, macAddress: $macAddress, isEnabled: $isEnabled, addresses: $addresses, description: $description, vendor: $vendor, driver: $driver, speedMbps: $speedMbps, isConnected: $isConnected, connectedSwitchPort: $connectedSwitchPort, vlanId: $vlanId, driverInfo: $driverInfo, lastSeen: $lastSeen)';
}


}

/// @nodoc
abstract mixin class _$NetworkInterfaceCopyWith<$Res> implements $NetworkInterfaceCopyWith<$Res> {
  factory _$NetworkInterfaceCopyWith(_NetworkInterface value, $Res Function(_NetworkInterface) _then) = __$NetworkInterfaceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String type, String macAddress, bool isEnabled, List<NetworkAddress> addresses, String? description, String? vendor, String? driver, int? speedMbps, bool? isConnected, String? connectedSwitchPort, String? vlanId, Map<String, String>? driverInfo, DateTime? lastSeen
});




}
/// @nodoc
class __$NetworkInterfaceCopyWithImpl<$Res>
    implements _$NetworkInterfaceCopyWith<$Res> {
  __$NetworkInterfaceCopyWithImpl(this._self, this._then);

  final _NetworkInterface _self;
  final $Res Function(_NetworkInterface) _then;

/// Create a copy of NetworkInterface
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? macAddress = null,Object? isEnabled = null,Object? addresses = null,Object? description = freezed,Object? vendor = freezed,Object? driver = freezed,Object? speedMbps = freezed,Object? isConnected = freezed,Object? connectedSwitchPort = freezed,Object? vlanId = freezed,Object? driverInfo = freezed,Object? lastSeen = freezed,}) {
  return _then(_NetworkInterface(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,macAddress: null == macAddress ? _self.macAddress : macAddress // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,addresses: null == addresses ? _self._addresses : addresses // ignore: cast_nullable_to_non_nullable
as List<NetworkAddress>,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String?,driver: freezed == driver ? _self.driver : driver // ignore: cast_nullable_to_non_nullable
as String?,speedMbps: freezed == speedMbps ? _self.speedMbps : speedMbps // ignore: cast_nullable_to_non_nullable
as int?,isConnected: freezed == isConnected ? _self.isConnected : isConnected // ignore: cast_nullable_to_non_nullable
as bool?,connectedSwitchPort: freezed == connectedSwitchPort ? _self.connectedSwitchPort : connectedSwitchPort // ignore: cast_nullable_to_non_nullable
as String?,vlanId: freezed == vlanId ? _self.vlanId : vlanId // ignore: cast_nullable_to_non_nullable
as String?,driverInfo: freezed == driverInfo ? _self._driverInfo : driverInfo // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,lastSeen: freezed == lastSeen ? _self.lastSeen : lastSeen // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$HostService {

 String get id; String get name; int get port; String get protocol;// "tcp", "udp"
 String get state;// "open", "filtered", "closed"
 String? get version; String? get banner; String? get productName; String? get productVersion; Map<String, String>? get extraInfo; List<String>? get vulnerabilities; bool? get requiresAuthentication; List<String>? get authenticationMethods; String? get sslVersion; List<String>? get sslCiphers; DateTime? get lastChecked; String? get confidence;
/// Create a copy of HostService
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HostServiceCopyWith<HostService> get copyWith => _$HostServiceCopyWithImpl<HostService>(this as HostService, _$identity);

  /// Serializes this HostService to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HostService&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.port, port) || other.port == port)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.state, state) || other.state == state)&&(identical(other.version, version) || other.version == version)&&(identical(other.banner, banner) || other.banner == banner)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productVersion, productVersion) || other.productVersion == productVersion)&&const DeepCollectionEquality().equals(other.extraInfo, extraInfo)&&const DeepCollectionEquality().equals(other.vulnerabilities, vulnerabilities)&&(identical(other.requiresAuthentication, requiresAuthentication) || other.requiresAuthentication == requiresAuthentication)&&const DeepCollectionEquality().equals(other.authenticationMethods, authenticationMethods)&&(identical(other.sslVersion, sslVersion) || other.sslVersion == sslVersion)&&const DeepCollectionEquality().equals(other.sslCiphers, sslCiphers)&&(identical(other.lastChecked, lastChecked) || other.lastChecked == lastChecked)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,port,protocol,state,version,banner,productName,productVersion,const DeepCollectionEquality().hash(extraInfo),const DeepCollectionEquality().hash(vulnerabilities),requiresAuthentication,const DeepCollectionEquality().hash(authenticationMethods),sslVersion,const DeepCollectionEquality().hash(sslCiphers),lastChecked,confidence);

@override
String toString() {
  return 'HostService(id: $id, name: $name, port: $port, protocol: $protocol, state: $state, version: $version, banner: $banner, productName: $productName, productVersion: $productVersion, extraInfo: $extraInfo, vulnerabilities: $vulnerabilities, requiresAuthentication: $requiresAuthentication, authenticationMethods: $authenticationMethods, sslVersion: $sslVersion, sslCiphers: $sslCiphers, lastChecked: $lastChecked, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class $HostServiceCopyWith<$Res>  {
  factory $HostServiceCopyWith(HostService value, $Res Function(HostService) _then) = _$HostServiceCopyWithImpl;
@useResult
$Res call({
 String id, String name, int port, String protocol, String state, String? version, String? banner, String? productName, String? productVersion, Map<String, String>? extraInfo, List<String>? vulnerabilities, bool? requiresAuthentication, List<String>? authenticationMethods, String? sslVersion, List<String>? sslCiphers, DateTime? lastChecked, String? confidence
});




}
/// @nodoc
class _$HostServiceCopyWithImpl<$Res>
    implements $HostServiceCopyWith<$Res> {
  _$HostServiceCopyWithImpl(this._self, this._then);

  final HostService _self;
  final $Res Function(HostService) _then;

/// Create a copy of HostService
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? port = null,Object? protocol = null,Object? state = null,Object? version = freezed,Object? banner = freezed,Object? productName = freezed,Object? productVersion = freezed,Object? extraInfo = freezed,Object? vulnerabilities = freezed,Object? requiresAuthentication = freezed,Object? authenticationMethods = freezed,Object? sslVersion = freezed,Object? sslCiphers = freezed,Object? lastChecked = freezed,Object? confidence = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,banner: freezed == banner ? _self.banner : banner // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,productVersion: freezed == productVersion ? _self.productVersion : productVersion // ignore: cast_nullable_to_non_nullable
as String?,extraInfo: freezed == extraInfo ? _self.extraInfo : extraInfo // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,vulnerabilities: freezed == vulnerabilities ? _self.vulnerabilities : vulnerabilities // ignore: cast_nullable_to_non_nullable
as List<String>?,requiresAuthentication: freezed == requiresAuthentication ? _self.requiresAuthentication : requiresAuthentication // ignore: cast_nullable_to_non_nullable
as bool?,authenticationMethods: freezed == authenticationMethods ? _self.authenticationMethods : authenticationMethods // ignore: cast_nullable_to_non_nullable
as List<String>?,sslVersion: freezed == sslVersion ? _self.sslVersion : sslVersion // ignore: cast_nullable_to_non_nullable
as String?,sslCiphers: freezed == sslCiphers ? _self.sslCiphers : sslCiphers // ignore: cast_nullable_to_non_nullable
as List<String>?,lastChecked: freezed == lastChecked ? _self.lastChecked : lastChecked // ignore: cast_nullable_to_non_nullable
as DateTime?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HostService].
extension HostServicePatterns on HostService {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HostService value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HostService() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HostService value)  $default,){
final _that = this;
switch (_that) {
case _HostService():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HostService value)?  $default,){
final _that = this;
switch (_that) {
case _HostService() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int port,  String protocol,  String state,  String? version,  String? banner,  String? productName,  String? productVersion,  Map<String, String>? extraInfo,  List<String>? vulnerabilities,  bool? requiresAuthentication,  List<String>? authenticationMethods,  String? sslVersion,  List<String>? sslCiphers,  DateTime? lastChecked,  String? confidence)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HostService() when $default != null:
return $default(_that.id,_that.name,_that.port,_that.protocol,_that.state,_that.version,_that.banner,_that.productName,_that.productVersion,_that.extraInfo,_that.vulnerabilities,_that.requiresAuthentication,_that.authenticationMethods,_that.sslVersion,_that.sslCiphers,_that.lastChecked,_that.confidence);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int port,  String protocol,  String state,  String? version,  String? banner,  String? productName,  String? productVersion,  Map<String, String>? extraInfo,  List<String>? vulnerabilities,  bool? requiresAuthentication,  List<String>? authenticationMethods,  String? sslVersion,  List<String>? sslCiphers,  DateTime? lastChecked,  String? confidence)  $default,) {final _that = this;
switch (_that) {
case _HostService():
return $default(_that.id,_that.name,_that.port,_that.protocol,_that.state,_that.version,_that.banner,_that.productName,_that.productVersion,_that.extraInfo,_that.vulnerabilities,_that.requiresAuthentication,_that.authenticationMethods,_that.sslVersion,_that.sslCiphers,_that.lastChecked,_that.confidence);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int port,  String protocol,  String state,  String? version,  String? banner,  String? productName,  String? productVersion,  Map<String, String>? extraInfo,  List<String>? vulnerabilities,  bool? requiresAuthentication,  List<String>? authenticationMethods,  String? sslVersion,  List<String>? sslCiphers,  DateTime? lastChecked,  String? confidence)?  $default,) {final _that = this;
switch (_that) {
case _HostService() when $default != null:
return $default(_that.id,_that.name,_that.port,_that.protocol,_that.state,_that.version,_that.banner,_that.productName,_that.productVersion,_that.extraInfo,_that.vulnerabilities,_that.requiresAuthentication,_that.authenticationMethods,_that.sslVersion,_that.sslCiphers,_that.lastChecked,_that.confidence);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HostService implements HostService {
  const _HostService({required this.id, required this.name, required this.port, required this.protocol, required this.state, this.version, this.banner, this.productName, this.productVersion, final  Map<String, String>? extraInfo, final  List<String>? vulnerabilities, this.requiresAuthentication, final  List<String>? authenticationMethods, this.sslVersion, final  List<String>? sslCiphers, this.lastChecked, this.confidence}): _extraInfo = extraInfo,_vulnerabilities = vulnerabilities,_authenticationMethods = authenticationMethods,_sslCiphers = sslCiphers;
  factory _HostService.fromJson(Map<String, dynamic> json) => _$HostServiceFromJson(json);

@override final  String id;
@override final  String name;
@override final  int port;
@override final  String protocol;
// "tcp", "udp"
@override final  String state;
// "open", "filtered", "closed"
@override final  String? version;
@override final  String? banner;
@override final  String? productName;
@override final  String? productVersion;
 final  Map<String, String>? _extraInfo;
@override Map<String, String>? get extraInfo {
  final value = _extraInfo;
  if (value == null) return null;
  if (_extraInfo is EqualUnmodifiableMapView) return _extraInfo;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  List<String>? _vulnerabilities;
@override List<String>? get vulnerabilities {
  final value = _vulnerabilities;
  if (value == null) return null;
  if (_vulnerabilities is EqualUnmodifiableListView) return _vulnerabilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  bool? requiresAuthentication;
 final  List<String>? _authenticationMethods;
@override List<String>? get authenticationMethods {
  final value = _authenticationMethods;
  if (value == null) return null;
  if (_authenticationMethods is EqualUnmodifiableListView) return _authenticationMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? sslVersion;
 final  List<String>? _sslCiphers;
@override List<String>? get sslCiphers {
  final value = _sslCiphers;
  if (value == null) return null;
  if (_sslCiphers is EqualUnmodifiableListView) return _sslCiphers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? lastChecked;
@override final  String? confidence;

/// Create a copy of HostService
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HostServiceCopyWith<_HostService> get copyWith => __$HostServiceCopyWithImpl<_HostService>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HostServiceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HostService&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.port, port) || other.port == port)&&(identical(other.protocol, protocol) || other.protocol == protocol)&&(identical(other.state, state) || other.state == state)&&(identical(other.version, version) || other.version == version)&&(identical(other.banner, banner) || other.banner == banner)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.productVersion, productVersion) || other.productVersion == productVersion)&&const DeepCollectionEquality().equals(other._extraInfo, _extraInfo)&&const DeepCollectionEquality().equals(other._vulnerabilities, _vulnerabilities)&&(identical(other.requiresAuthentication, requiresAuthentication) || other.requiresAuthentication == requiresAuthentication)&&const DeepCollectionEquality().equals(other._authenticationMethods, _authenticationMethods)&&(identical(other.sslVersion, sslVersion) || other.sslVersion == sslVersion)&&const DeepCollectionEquality().equals(other._sslCiphers, _sslCiphers)&&(identical(other.lastChecked, lastChecked) || other.lastChecked == lastChecked)&&(identical(other.confidence, confidence) || other.confidence == confidence));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,port,protocol,state,version,banner,productName,productVersion,const DeepCollectionEquality().hash(_extraInfo),const DeepCollectionEquality().hash(_vulnerabilities),requiresAuthentication,const DeepCollectionEquality().hash(_authenticationMethods),sslVersion,const DeepCollectionEquality().hash(_sslCiphers),lastChecked,confidence);

@override
String toString() {
  return 'HostService(id: $id, name: $name, port: $port, protocol: $protocol, state: $state, version: $version, banner: $banner, productName: $productName, productVersion: $productVersion, extraInfo: $extraInfo, vulnerabilities: $vulnerabilities, requiresAuthentication: $requiresAuthentication, authenticationMethods: $authenticationMethods, sslVersion: $sslVersion, sslCiphers: $sslCiphers, lastChecked: $lastChecked, confidence: $confidence)';
}


}

/// @nodoc
abstract mixin class _$HostServiceCopyWith<$Res> implements $HostServiceCopyWith<$Res> {
  factory _$HostServiceCopyWith(_HostService value, $Res Function(_HostService) _then) = __$HostServiceCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int port, String protocol, String state, String? version, String? banner, String? productName, String? productVersion, Map<String, String>? extraInfo, List<String>? vulnerabilities, bool? requiresAuthentication, List<String>? authenticationMethods, String? sslVersion, List<String>? sslCiphers, DateTime? lastChecked, String? confidence
});




}
/// @nodoc
class __$HostServiceCopyWithImpl<$Res>
    implements _$HostServiceCopyWith<$Res> {
  __$HostServiceCopyWithImpl(this._self, this._then);

  final _HostService _self;
  final $Res Function(_HostService) _then;

/// Create a copy of HostService
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? port = null,Object? protocol = null,Object? state = null,Object? version = freezed,Object? banner = freezed,Object? productName = freezed,Object? productVersion = freezed,Object? extraInfo = freezed,Object? vulnerabilities = freezed,Object? requiresAuthentication = freezed,Object? authenticationMethods = freezed,Object? sslVersion = freezed,Object? sslCiphers = freezed,Object? lastChecked = freezed,Object? confidence = freezed,}) {
  return _then(_HostService(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,port: null == port ? _self.port : port // ignore: cast_nullable_to_non_nullable
as int,protocol: null == protocol ? _self.protocol : protocol // ignore: cast_nullable_to_non_nullable
as String,state: null == state ? _self.state : state // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,banner: freezed == banner ? _self.banner : banner // ignore: cast_nullable_to_non_nullable
as String?,productName: freezed == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String?,productVersion: freezed == productVersion ? _self.productVersion : productVersion // ignore: cast_nullable_to_non_nullable
as String?,extraInfo: freezed == extraInfo ? _self._extraInfo : extraInfo // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,vulnerabilities: freezed == vulnerabilities ? _self._vulnerabilities : vulnerabilities // ignore: cast_nullable_to_non_nullable
as List<String>?,requiresAuthentication: freezed == requiresAuthentication ? _self.requiresAuthentication : requiresAuthentication // ignore: cast_nullable_to_non_nullable
as bool?,authenticationMethods: freezed == authenticationMethods ? _self._authenticationMethods : authenticationMethods // ignore: cast_nullable_to_non_nullable
as List<String>?,sslVersion: freezed == sslVersion ? _self.sslVersion : sslVersion // ignore: cast_nullable_to_non_nullable
as String?,sslCiphers: freezed == sslCiphers ? _self._sslCiphers : sslCiphers // ignore: cast_nullable_to_non_nullable
as List<String>?,lastChecked: freezed == lastChecked ? _self.lastChecked : lastChecked // ignore: cast_nullable_to_non_nullable
as DateTime?,confidence: freezed == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HostApplication {

 String get id; String get name; String get type;// "system", "user", "service", "driver"
 String? get version; String? get vendor; String? get architecture;// "x64", "x86", "any"
 String? get installLocation; DateTime? get installDate; int? get sizeMB; List<String>? get configFiles; List<String>? get dataDirectories; List<String>? get registryKeys; List<String>? get associatedServices;// HostService IDs
 List<String>? get networkPorts; List<String>? get vulnerabilities; bool? get isSystemCritical; bool? get hasUpdateAvailable; String? get licenseType; String? get licenseKey; Map<String, String>? get metadata;
/// Create a copy of HostApplication
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HostApplicationCopyWith<HostApplication> get copyWith => _$HostApplicationCopyWithImpl<HostApplication>(this as HostApplication, _$identity);

  /// Serializes this HostApplication to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HostApplication&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.version, version) || other.version == version)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.architecture, architecture) || other.architecture == architecture)&&(identical(other.installLocation, installLocation) || other.installLocation == installLocation)&&(identical(other.installDate, installDate) || other.installDate == installDate)&&(identical(other.sizeMB, sizeMB) || other.sizeMB == sizeMB)&&const DeepCollectionEquality().equals(other.configFiles, configFiles)&&const DeepCollectionEquality().equals(other.dataDirectories, dataDirectories)&&const DeepCollectionEquality().equals(other.registryKeys, registryKeys)&&const DeepCollectionEquality().equals(other.associatedServices, associatedServices)&&const DeepCollectionEquality().equals(other.networkPorts, networkPorts)&&const DeepCollectionEquality().equals(other.vulnerabilities, vulnerabilities)&&(identical(other.isSystemCritical, isSystemCritical) || other.isSystemCritical == isSystemCritical)&&(identical(other.hasUpdateAvailable, hasUpdateAvailable) || other.hasUpdateAvailable == hasUpdateAvailable)&&(identical(other.licenseType, licenseType) || other.licenseType == licenseType)&&(identical(other.licenseKey, licenseKey) || other.licenseKey == licenseKey)&&const DeepCollectionEquality().equals(other.metadata, metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,type,version,vendor,architecture,installLocation,installDate,sizeMB,const DeepCollectionEquality().hash(configFiles),const DeepCollectionEquality().hash(dataDirectories),const DeepCollectionEquality().hash(registryKeys),const DeepCollectionEquality().hash(associatedServices),const DeepCollectionEquality().hash(networkPorts),const DeepCollectionEquality().hash(vulnerabilities),isSystemCritical,hasUpdateAvailable,licenseType,licenseKey,const DeepCollectionEquality().hash(metadata)]);

@override
String toString() {
  return 'HostApplication(id: $id, name: $name, type: $type, version: $version, vendor: $vendor, architecture: $architecture, installLocation: $installLocation, installDate: $installDate, sizeMB: $sizeMB, configFiles: $configFiles, dataDirectories: $dataDirectories, registryKeys: $registryKeys, associatedServices: $associatedServices, networkPorts: $networkPorts, vulnerabilities: $vulnerabilities, isSystemCritical: $isSystemCritical, hasUpdateAvailable: $hasUpdateAvailable, licenseType: $licenseType, licenseKey: $licenseKey, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class $HostApplicationCopyWith<$Res>  {
  factory $HostApplicationCopyWith(HostApplication value, $Res Function(HostApplication) _then) = _$HostApplicationCopyWithImpl;
@useResult
$Res call({
 String id, String name, String type, String? version, String? vendor, String? architecture, String? installLocation, DateTime? installDate, int? sizeMB, List<String>? configFiles, List<String>? dataDirectories, List<String>? registryKeys, List<String>? associatedServices, List<String>? networkPorts, List<String>? vulnerabilities, bool? isSystemCritical, bool? hasUpdateAvailable, String? licenseType, String? licenseKey, Map<String, String>? metadata
});




}
/// @nodoc
class _$HostApplicationCopyWithImpl<$Res>
    implements $HostApplicationCopyWith<$Res> {
  _$HostApplicationCopyWithImpl(this._self, this._then);

  final HostApplication _self;
  final $Res Function(HostApplication) _then;

/// Create a copy of HostApplication
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? type = null,Object? version = freezed,Object? vendor = freezed,Object? architecture = freezed,Object? installLocation = freezed,Object? installDate = freezed,Object? sizeMB = freezed,Object? configFiles = freezed,Object? dataDirectories = freezed,Object? registryKeys = freezed,Object? associatedServices = freezed,Object? networkPorts = freezed,Object? vulnerabilities = freezed,Object? isSystemCritical = freezed,Object? hasUpdateAvailable = freezed,Object? licenseType = freezed,Object? licenseKey = freezed,Object? metadata = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String?,architecture: freezed == architecture ? _self.architecture : architecture // ignore: cast_nullable_to_non_nullable
as String?,installLocation: freezed == installLocation ? _self.installLocation : installLocation // ignore: cast_nullable_to_non_nullable
as String?,installDate: freezed == installDate ? _self.installDate : installDate // ignore: cast_nullable_to_non_nullable
as DateTime?,sizeMB: freezed == sizeMB ? _self.sizeMB : sizeMB // ignore: cast_nullable_to_non_nullable
as int?,configFiles: freezed == configFiles ? _self.configFiles : configFiles // ignore: cast_nullable_to_non_nullable
as List<String>?,dataDirectories: freezed == dataDirectories ? _self.dataDirectories : dataDirectories // ignore: cast_nullable_to_non_nullable
as List<String>?,registryKeys: freezed == registryKeys ? _self.registryKeys : registryKeys // ignore: cast_nullable_to_non_nullable
as List<String>?,associatedServices: freezed == associatedServices ? _self.associatedServices : associatedServices // ignore: cast_nullable_to_non_nullable
as List<String>?,networkPorts: freezed == networkPorts ? _self.networkPorts : networkPorts // ignore: cast_nullable_to_non_nullable
as List<String>?,vulnerabilities: freezed == vulnerabilities ? _self.vulnerabilities : vulnerabilities // ignore: cast_nullable_to_non_nullable
as List<String>?,isSystemCritical: freezed == isSystemCritical ? _self.isSystemCritical : isSystemCritical // ignore: cast_nullable_to_non_nullable
as bool?,hasUpdateAvailable: freezed == hasUpdateAvailable ? _self.hasUpdateAvailable : hasUpdateAvailable // ignore: cast_nullable_to_non_nullable
as bool?,licenseType: freezed == licenseType ? _self.licenseType : licenseType // ignore: cast_nullable_to_non_nullable
as String?,licenseKey: freezed == licenseKey ? _self.licenseKey : licenseKey // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self.metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [HostApplication].
extension HostApplicationPatterns on HostApplication {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HostApplication value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HostApplication() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HostApplication value)  $default,){
final _that = this;
switch (_that) {
case _HostApplication():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HostApplication value)?  $default,){
final _that = this;
switch (_that) {
case _HostApplication() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String type,  String? version,  String? vendor,  String? architecture,  String? installLocation,  DateTime? installDate,  int? sizeMB,  List<String>? configFiles,  List<String>? dataDirectories,  List<String>? registryKeys,  List<String>? associatedServices,  List<String>? networkPorts,  List<String>? vulnerabilities,  bool? isSystemCritical,  bool? hasUpdateAvailable,  String? licenseType,  String? licenseKey,  Map<String, String>? metadata)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HostApplication() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.version,_that.vendor,_that.architecture,_that.installLocation,_that.installDate,_that.sizeMB,_that.configFiles,_that.dataDirectories,_that.registryKeys,_that.associatedServices,_that.networkPorts,_that.vulnerabilities,_that.isSystemCritical,_that.hasUpdateAvailable,_that.licenseType,_that.licenseKey,_that.metadata);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String type,  String? version,  String? vendor,  String? architecture,  String? installLocation,  DateTime? installDate,  int? sizeMB,  List<String>? configFiles,  List<String>? dataDirectories,  List<String>? registryKeys,  List<String>? associatedServices,  List<String>? networkPorts,  List<String>? vulnerabilities,  bool? isSystemCritical,  bool? hasUpdateAvailable,  String? licenseType,  String? licenseKey,  Map<String, String>? metadata)  $default,) {final _that = this;
switch (_that) {
case _HostApplication():
return $default(_that.id,_that.name,_that.type,_that.version,_that.vendor,_that.architecture,_that.installLocation,_that.installDate,_that.sizeMB,_that.configFiles,_that.dataDirectories,_that.registryKeys,_that.associatedServices,_that.networkPorts,_that.vulnerabilities,_that.isSystemCritical,_that.hasUpdateAvailable,_that.licenseType,_that.licenseKey,_that.metadata);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String type,  String? version,  String? vendor,  String? architecture,  String? installLocation,  DateTime? installDate,  int? sizeMB,  List<String>? configFiles,  List<String>? dataDirectories,  List<String>? registryKeys,  List<String>? associatedServices,  List<String>? networkPorts,  List<String>? vulnerabilities,  bool? isSystemCritical,  bool? hasUpdateAvailable,  String? licenseType,  String? licenseKey,  Map<String, String>? metadata)?  $default,) {final _that = this;
switch (_that) {
case _HostApplication() when $default != null:
return $default(_that.id,_that.name,_that.type,_that.version,_that.vendor,_that.architecture,_that.installLocation,_that.installDate,_that.sizeMB,_that.configFiles,_that.dataDirectories,_that.registryKeys,_that.associatedServices,_that.networkPorts,_that.vulnerabilities,_that.isSystemCritical,_that.hasUpdateAvailable,_that.licenseType,_that.licenseKey,_that.metadata);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HostApplication implements HostApplication {
  const _HostApplication({required this.id, required this.name, required this.type, this.version, this.vendor, this.architecture, this.installLocation, this.installDate, this.sizeMB, final  List<String>? configFiles, final  List<String>? dataDirectories, final  List<String>? registryKeys, final  List<String>? associatedServices, final  List<String>? networkPorts, final  List<String>? vulnerabilities, this.isSystemCritical, this.hasUpdateAvailable, this.licenseType, this.licenseKey, final  Map<String, String>? metadata}): _configFiles = configFiles,_dataDirectories = dataDirectories,_registryKeys = registryKeys,_associatedServices = associatedServices,_networkPorts = networkPorts,_vulnerabilities = vulnerabilities,_metadata = metadata;
  factory _HostApplication.fromJson(Map<String, dynamic> json) => _$HostApplicationFromJson(json);

@override final  String id;
@override final  String name;
@override final  String type;
// "system", "user", "service", "driver"
@override final  String? version;
@override final  String? vendor;
@override final  String? architecture;
// "x64", "x86", "any"
@override final  String? installLocation;
@override final  DateTime? installDate;
@override final  int? sizeMB;
 final  List<String>? _configFiles;
@override List<String>? get configFiles {
  final value = _configFiles;
  if (value == null) return null;
  if (_configFiles is EqualUnmodifiableListView) return _configFiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _dataDirectories;
@override List<String>? get dataDirectories {
  final value = _dataDirectories;
  if (value == null) return null;
  if (_dataDirectories is EqualUnmodifiableListView) return _dataDirectories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _registryKeys;
@override List<String>? get registryKeys {
  final value = _registryKeys;
  if (value == null) return null;
  if (_registryKeys is EqualUnmodifiableListView) return _registryKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _associatedServices;
@override List<String>? get associatedServices {
  final value = _associatedServices;
  if (value == null) return null;
  if (_associatedServices is EqualUnmodifiableListView) return _associatedServices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

// HostService IDs
 final  List<String>? _networkPorts;
// HostService IDs
@override List<String>? get networkPorts {
  final value = _networkPorts;
  if (value == null) return null;
  if (_networkPorts is EqualUnmodifiableListView) return _networkPorts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _vulnerabilities;
@override List<String>? get vulnerabilities {
  final value = _vulnerabilities;
  if (value == null) return null;
  if (_vulnerabilities is EqualUnmodifiableListView) return _vulnerabilities;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  bool? isSystemCritical;
@override final  bool? hasUpdateAvailable;
@override final  String? licenseType;
@override final  String? licenseKey;
 final  Map<String, String>? _metadata;
@override Map<String, String>? get metadata {
  final value = _metadata;
  if (value == null) return null;
  if (_metadata is EqualUnmodifiableMapView) return _metadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of HostApplication
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HostApplicationCopyWith<_HostApplication> get copyWith => __$HostApplicationCopyWithImpl<_HostApplication>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HostApplicationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HostApplication&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.type, type) || other.type == type)&&(identical(other.version, version) || other.version == version)&&(identical(other.vendor, vendor) || other.vendor == vendor)&&(identical(other.architecture, architecture) || other.architecture == architecture)&&(identical(other.installLocation, installLocation) || other.installLocation == installLocation)&&(identical(other.installDate, installDate) || other.installDate == installDate)&&(identical(other.sizeMB, sizeMB) || other.sizeMB == sizeMB)&&const DeepCollectionEquality().equals(other._configFiles, _configFiles)&&const DeepCollectionEquality().equals(other._dataDirectories, _dataDirectories)&&const DeepCollectionEquality().equals(other._registryKeys, _registryKeys)&&const DeepCollectionEquality().equals(other._associatedServices, _associatedServices)&&const DeepCollectionEquality().equals(other._networkPorts, _networkPorts)&&const DeepCollectionEquality().equals(other._vulnerabilities, _vulnerabilities)&&(identical(other.isSystemCritical, isSystemCritical) || other.isSystemCritical == isSystemCritical)&&(identical(other.hasUpdateAvailable, hasUpdateAvailable) || other.hasUpdateAvailable == hasUpdateAvailable)&&(identical(other.licenseType, licenseType) || other.licenseType == licenseType)&&(identical(other.licenseKey, licenseKey) || other.licenseKey == licenseKey)&&const DeepCollectionEquality().equals(other._metadata, _metadata));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,name,type,version,vendor,architecture,installLocation,installDate,sizeMB,const DeepCollectionEquality().hash(_configFiles),const DeepCollectionEquality().hash(_dataDirectories),const DeepCollectionEquality().hash(_registryKeys),const DeepCollectionEquality().hash(_associatedServices),const DeepCollectionEquality().hash(_networkPorts),const DeepCollectionEquality().hash(_vulnerabilities),isSystemCritical,hasUpdateAvailable,licenseType,licenseKey,const DeepCollectionEquality().hash(_metadata)]);

@override
String toString() {
  return 'HostApplication(id: $id, name: $name, type: $type, version: $version, vendor: $vendor, architecture: $architecture, installLocation: $installLocation, installDate: $installDate, sizeMB: $sizeMB, configFiles: $configFiles, dataDirectories: $dataDirectories, registryKeys: $registryKeys, associatedServices: $associatedServices, networkPorts: $networkPorts, vulnerabilities: $vulnerabilities, isSystemCritical: $isSystemCritical, hasUpdateAvailable: $hasUpdateAvailable, licenseType: $licenseType, licenseKey: $licenseKey, metadata: $metadata)';
}


}

/// @nodoc
abstract mixin class _$HostApplicationCopyWith<$Res> implements $HostApplicationCopyWith<$Res> {
  factory _$HostApplicationCopyWith(_HostApplication value, $Res Function(_HostApplication) _then) = __$HostApplicationCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String type, String? version, String? vendor, String? architecture, String? installLocation, DateTime? installDate, int? sizeMB, List<String>? configFiles, List<String>? dataDirectories, List<String>? registryKeys, List<String>? associatedServices, List<String>? networkPorts, List<String>? vulnerabilities, bool? isSystemCritical, bool? hasUpdateAvailable, String? licenseType, String? licenseKey, Map<String, String>? metadata
});




}
/// @nodoc
class __$HostApplicationCopyWithImpl<$Res>
    implements _$HostApplicationCopyWith<$Res> {
  __$HostApplicationCopyWithImpl(this._self, this._then);

  final _HostApplication _self;
  final $Res Function(_HostApplication) _then;

/// Create a copy of HostApplication
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? type = null,Object? version = freezed,Object? vendor = freezed,Object? architecture = freezed,Object? installLocation = freezed,Object? installDate = freezed,Object? sizeMB = freezed,Object? configFiles = freezed,Object? dataDirectories = freezed,Object? registryKeys = freezed,Object? associatedServices = freezed,Object? networkPorts = freezed,Object? vulnerabilities = freezed,Object? isSystemCritical = freezed,Object? hasUpdateAvailable = freezed,Object? licenseType = freezed,Object? licenseKey = freezed,Object? metadata = freezed,}) {
  return _then(_HostApplication(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,vendor: freezed == vendor ? _self.vendor : vendor // ignore: cast_nullable_to_non_nullable
as String?,architecture: freezed == architecture ? _self.architecture : architecture // ignore: cast_nullable_to_non_nullable
as String?,installLocation: freezed == installLocation ? _self.installLocation : installLocation // ignore: cast_nullable_to_non_nullable
as String?,installDate: freezed == installDate ? _self.installDate : installDate // ignore: cast_nullable_to_non_nullable
as DateTime?,sizeMB: freezed == sizeMB ? _self.sizeMB : sizeMB // ignore: cast_nullable_to_non_nullable
as int?,configFiles: freezed == configFiles ? _self._configFiles : configFiles // ignore: cast_nullable_to_non_nullable
as List<String>?,dataDirectories: freezed == dataDirectories ? _self._dataDirectories : dataDirectories // ignore: cast_nullable_to_non_nullable
as List<String>?,registryKeys: freezed == registryKeys ? _self._registryKeys : registryKeys // ignore: cast_nullable_to_non_nullable
as List<String>?,associatedServices: freezed == associatedServices ? _self._associatedServices : associatedServices // ignore: cast_nullable_to_non_nullable
as List<String>?,networkPorts: freezed == networkPorts ? _self._networkPorts : networkPorts // ignore: cast_nullable_to_non_nullable
as List<String>?,vulnerabilities: freezed == vulnerabilities ? _self._vulnerabilities : vulnerabilities // ignore: cast_nullable_to_non_nullable
as List<String>?,isSystemCritical: freezed == isSystemCritical ? _self.isSystemCritical : isSystemCritical // ignore: cast_nullable_to_non_nullable
as bool?,hasUpdateAvailable: freezed == hasUpdateAvailable ? _self.hasUpdateAvailable : hasUpdateAvailable // ignore: cast_nullable_to_non_nullable
as bool?,licenseType: freezed == licenseType ? _self.licenseType : licenseType // ignore: cast_nullable_to_non_nullable
as String?,licenseKey: freezed == licenseKey ? _self.licenseKey : licenseKey // ignore: cast_nullable_to_non_nullable
as String?,metadata: freezed == metadata ? _self._metadata : metadata // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}


/// @nodoc
mixin _$HostAccount {

 String get id; String get username; String get type;// "local", "domain", "service", "system"
 bool get isEnabled; String? get fullName; String? get description; List<String>? get groups; String? get homeDirectory; String? get shell; DateTime? get lastLogin; DateTime? get passwordLastSet; bool? get passwordNeverExpires; bool? get accountLocked; bool? get isAdmin; List<String>? get privileges; Map<String, String>? get environment;
/// Create a copy of HostAccount
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HostAccountCopyWith<HostAccount> get copyWith => _$HostAccountCopyWithImpl<HostAccount>(this as HostAccount, _$identity);

  /// Serializes this HostAccount to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HostAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.type, type) || other.type == type)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other.groups, groups)&&(identical(other.homeDirectory, homeDirectory) || other.homeDirectory == homeDirectory)&&(identical(other.shell, shell) || other.shell == shell)&&(identical(other.lastLogin, lastLogin) || other.lastLogin == lastLogin)&&(identical(other.passwordLastSet, passwordLastSet) || other.passwordLastSet == passwordLastSet)&&(identical(other.passwordNeverExpires, passwordNeverExpires) || other.passwordNeverExpires == passwordNeverExpires)&&(identical(other.accountLocked, accountLocked) || other.accountLocked == accountLocked)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&const DeepCollectionEquality().equals(other.privileges, privileges)&&const DeepCollectionEquality().equals(other.environment, environment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,type,isEnabled,fullName,description,const DeepCollectionEquality().hash(groups),homeDirectory,shell,lastLogin,passwordLastSet,passwordNeverExpires,accountLocked,isAdmin,const DeepCollectionEquality().hash(privileges),const DeepCollectionEquality().hash(environment));

@override
String toString() {
  return 'HostAccount(id: $id, username: $username, type: $type, isEnabled: $isEnabled, fullName: $fullName, description: $description, groups: $groups, homeDirectory: $homeDirectory, shell: $shell, lastLogin: $lastLogin, passwordLastSet: $passwordLastSet, passwordNeverExpires: $passwordNeverExpires, accountLocked: $accountLocked, isAdmin: $isAdmin, privileges: $privileges, environment: $environment)';
}


}

/// @nodoc
abstract mixin class $HostAccountCopyWith<$Res>  {
  factory $HostAccountCopyWith(HostAccount value, $Res Function(HostAccount) _then) = _$HostAccountCopyWithImpl;
@useResult
$Res call({
 String id, String username, String type, bool isEnabled, String? fullName, String? description, List<String>? groups, String? homeDirectory, String? shell, DateTime? lastLogin, DateTime? passwordLastSet, bool? passwordNeverExpires, bool? accountLocked, bool? isAdmin, List<String>? privileges, Map<String, String>? environment
});




}
/// @nodoc
class _$HostAccountCopyWithImpl<$Res>
    implements $HostAccountCopyWith<$Res> {
  _$HostAccountCopyWithImpl(this._self, this._then);

  final HostAccount _self;
  final $Res Function(HostAccount) _then;

/// Create a copy of HostAccount
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? type = null,Object? isEnabled = null,Object? fullName = freezed,Object? description = freezed,Object? groups = freezed,Object? homeDirectory = freezed,Object? shell = freezed,Object? lastLogin = freezed,Object? passwordLastSet = freezed,Object? passwordNeverExpires = freezed,Object? accountLocked = freezed,Object? isAdmin = freezed,Object? privileges = freezed,Object? environment = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,groups: freezed == groups ? _self.groups : groups // ignore: cast_nullable_to_non_nullable
as List<String>?,homeDirectory: freezed == homeDirectory ? _self.homeDirectory : homeDirectory // ignore: cast_nullable_to_non_nullable
as String?,shell: freezed == shell ? _self.shell : shell // ignore: cast_nullable_to_non_nullable
as String?,lastLogin: freezed == lastLogin ? _self.lastLogin : lastLogin // ignore: cast_nullable_to_non_nullable
as DateTime?,passwordLastSet: freezed == passwordLastSet ? _self.passwordLastSet : passwordLastSet // ignore: cast_nullable_to_non_nullable
as DateTime?,passwordNeverExpires: freezed == passwordNeverExpires ? _self.passwordNeverExpires : passwordNeverExpires // ignore: cast_nullable_to_non_nullable
as bool?,accountLocked: freezed == accountLocked ? _self.accountLocked : accountLocked // ignore: cast_nullable_to_non_nullable
as bool?,isAdmin: freezed == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool?,privileges: freezed == privileges ? _self.privileges : privileges // ignore: cast_nullable_to_non_nullable
as List<String>?,environment: freezed == environment ? _self.environment : environment // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [HostAccount].
extension HostAccountPatterns on HostAccount {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HostAccount value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HostAccount() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HostAccount value)  $default,){
final _that = this;
switch (_that) {
case _HostAccount():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HostAccount value)?  $default,){
final _that = this;
switch (_that) {
case _HostAccount() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String type,  bool isEnabled,  String? fullName,  String? description,  List<String>? groups,  String? homeDirectory,  String? shell,  DateTime? lastLogin,  DateTime? passwordLastSet,  bool? passwordNeverExpires,  bool? accountLocked,  bool? isAdmin,  List<String>? privileges,  Map<String, String>? environment)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HostAccount() when $default != null:
return $default(_that.id,_that.username,_that.type,_that.isEnabled,_that.fullName,_that.description,_that.groups,_that.homeDirectory,_that.shell,_that.lastLogin,_that.passwordLastSet,_that.passwordNeverExpires,_that.accountLocked,_that.isAdmin,_that.privileges,_that.environment);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String type,  bool isEnabled,  String? fullName,  String? description,  List<String>? groups,  String? homeDirectory,  String? shell,  DateTime? lastLogin,  DateTime? passwordLastSet,  bool? passwordNeverExpires,  bool? accountLocked,  bool? isAdmin,  List<String>? privileges,  Map<String, String>? environment)  $default,) {final _that = this;
switch (_that) {
case _HostAccount():
return $default(_that.id,_that.username,_that.type,_that.isEnabled,_that.fullName,_that.description,_that.groups,_that.homeDirectory,_that.shell,_that.lastLogin,_that.passwordLastSet,_that.passwordNeverExpires,_that.accountLocked,_that.isAdmin,_that.privileges,_that.environment);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String type,  bool isEnabled,  String? fullName,  String? description,  List<String>? groups,  String? homeDirectory,  String? shell,  DateTime? lastLogin,  DateTime? passwordLastSet,  bool? passwordNeverExpires,  bool? accountLocked,  bool? isAdmin,  List<String>? privileges,  Map<String, String>? environment)?  $default,) {final _that = this;
switch (_that) {
case _HostAccount() when $default != null:
return $default(_that.id,_that.username,_that.type,_that.isEnabled,_that.fullName,_that.description,_that.groups,_that.homeDirectory,_that.shell,_that.lastLogin,_that.passwordLastSet,_that.passwordNeverExpires,_that.accountLocked,_that.isAdmin,_that.privileges,_that.environment);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HostAccount implements HostAccount {
  const _HostAccount({required this.id, required this.username, required this.type, required this.isEnabled, this.fullName, this.description, final  List<String>? groups, this.homeDirectory, this.shell, this.lastLogin, this.passwordLastSet, this.passwordNeverExpires, this.accountLocked, this.isAdmin, final  List<String>? privileges, final  Map<String, String>? environment}): _groups = groups,_privileges = privileges,_environment = environment;
  factory _HostAccount.fromJson(Map<String, dynamic> json) => _$HostAccountFromJson(json);

@override final  String id;
@override final  String username;
@override final  String type;
// "local", "domain", "service", "system"
@override final  bool isEnabled;
@override final  String? fullName;
@override final  String? description;
 final  List<String>? _groups;
@override List<String>? get groups {
  final value = _groups;
  if (value == null) return null;
  if (_groups is EqualUnmodifiableListView) return _groups;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? homeDirectory;
@override final  String? shell;
@override final  DateTime? lastLogin;
@override final  DateTime? passwordLastSet;
@override final  bool? passwordNeverExpires;
@override final  bool? accountLocked;
@override final  bool? isAdmin;
 final  List<String>? _privileges;
@override List<String>? get privileges {
  final value = _privileges;
  if (value == null) return null;
  if (_privileges is EqualUnmodifiableListView) return _privileges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  Map<String, String>? _environment;
@override Map<String, String>? get environment {
  final value = _environment;
  if (value == null) return null;
  if (_environment is EqualUnmodifiableMapView) return _environment;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of HostAccount
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HostAccountCopyWith<_HostAccount> get copyWith => __$HostAccountCopyWithImpl<_HostAccount>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HostAccountToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HostAccount&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.type, type) || other.type == type)&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.description, description) || other.description == description)&&const DeepCollectionEquality().equals(other._groups, _groups)&&(identical(other.homeDirectory, homeDirectory) || other.homeDirectory == homeDirectory)&&(identical(other.shell, shell) || other.shell == shell)&&(identical(other.lastLogin, lastLogin) || other.lastLogin == lastLogin)&&(identical(other.passwordLastSet, passwordLastSet) || other.passwordLastSet == passwordLastSet)&&(identical(other.passwordNeverExpires, passwordNeverExpires) || other.passwordNeverExpires == passwordNeverExpires)&&(identical(other.accountLocked, accountLocked) || other.accountLocked == accountLocked)&&(identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin)&&const DeepCollectionEquality().equals(other._privileges, _privileges)&&const DeepCollectionEquality().equals(other._environment, _environment));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,type,isEnabled,fullName,description,const DeepCollectionEquality().hash(_groups),homeDirectory,shell,lastLogin,passwordLastSet,passwordNeverExpires,accountLocked,isAdmin,const DeepCollectionEquality().hash(_privileges),const DeepCollectionEquality().hash(_environment));

@override
String toString() {
  return 'HostAccount(id: $id, username: $username, type: $type, isEnabled: $isEnabled, fullName: $fullName, description: $description, groups: $groups, homeDirectory: $homeDirectory, shell: $shell, lastLogin: $lastLogin, passwordLastSet: $passwordLastSet, passwordNeverExpires: $passwordNeverExpires, accountLocked: $accountLocked, isAdmin: $isAdmin, privileges: $privileges, environment: $environment)';
}


}

/// @nodoc
abstract mixin class _$HostAccountCopyWith<$Res> implements $HostAccountCopyWith<$Res> {
  factory _$HostAccountCopyWith(_HostAccount value, $Res Function(_HostAccount) _then) = __$HostAccountCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String type, bool isEnabled, String? fullName, String? description, List<String>? groups, String? homeDirectory, String? shell, DateTime? lastLogin, DateTime? passwordLastSet, bool? passwordNeverExpires, bool? accountLocked, bool? isAdmin, List<String>? privileges, Map<String, String>? environment
});




}
/// @nodoc
class __$HostAccountCopyWithImpl<$Res>
    implements _$HostAccountCopyWith<$Res> {
  __$HostAccountCopyWithImpl(this._self, this._then);

  final _HostAccount _self;
  final $Res Function(_HostAccount) _then;

/// Create a copy of HostAccount
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? type = null,Object? isEnabled = null,Object? fullName = freezed,Object? description = freezed,Object? groups = freezed,Object? homeDirectory = freezed,Object? shell = freezed,Object? lastLogin = freezed,Object? passwordLastSet = freezed,Object? passwordNeverExpires = freezed,Object? accountLocked = freezed,Object? isAdmin = freezed,Object? privileges = freezed,Object? environment = freezed,}) {
  return _then(_HostAccount(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,fullName: freezed == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,groups: freezed == groups ? _self._groups : groups // ignore: cast_nullable_to_non_nullable
as List<String>?,homeDirectory: freezed == homeDirectory ? _self.homeDirectory : homeDirectory // ignore: cast_nullable_to_non_nullable
as String?,shell: freezed == shell ? _self.shell : shell // ignore: cast_nullable_to_non_nullable
as String?,lastLogin: freezed == lastLogin ? _self.lastLogin : lastLogin // ignore: cast_nullable_to_non_nullable
as DateTime?,passwordLastSet: freezed == passwordLastSet ? _self.passwordLastSet : passwordLastSet // ignore: cast_nullable_to_non_nullable
as DateTime?,passwordNeverExpires: freezed == passwordNeverExpires ? _self.passwordNeverExpires : passwordNeverExpires // ignore: cast_nullable_to_non_nullable
as bool?,accountLocked: freezed == accountLocked ? _self.accountLocked : accountLocked // ignore: cast_nullable_to_non_nullable
as bool?,isAdmin: freezed == isAdmin ? _self.isAdmin : isAdmin // ignore: cast_nullable_to_non_nullable
as bool?,privileges: freezed == privileges ? _self._privileges : privileges // ignore: cast_nullable_to_non_nullable
as List<String>?,environment: freezed == environment ? _self._environment : environment // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}


/// @nodoc
mixin _$HardwareComponent {

 String get id; String get type;// "cpu", "memory", "disk", "gpu", "motherboard"
 String get name; String? get manufacturer; String? get model; String? get serialNumber; String? get version; Map<String, String>? get specifications; String? get health;// "good", "warning", "critical", "unknown"
 DateTime? get lastChecked;
/// Create a copy of HardwareComponent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HardwareComponentCopyWith<HardwareComponent> get copyWith => _$HardwareComponentCopyWithImpl<HardwareComponent>(this as HardwareComponent, _$identity);

  /// Serializes this HardwareComponent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HardwareComponent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.model, model) || other.model == model)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other.specifications, specifications)&&(identical(other.health, health) || other.health == health)&&(identical(other.lastChecked, lastChecked) || other.lastChecked == lastChecked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,manufacturer,model,serialNumber,version,const DeepCollectionEquality().hash(specifications),health,lastChecked);

@override
String toString() {
  return 'HardwareComponent(id: $id, type: $type, name: $name, manufacturer: $manufacturer, model: $model, serialNumber: $serialNumber, version: $version, specifications: $specifications, health: $health, lastChecked: $lastChecked)';
}


}

/// @nodoc
abstract mixin class $HardwareComponentCopyWith<$Res>  {
  factory $HardwareComponentCopyWith(HardwareComponent value, $Res Function(HardwareComponent) _then) = _$HardwareComponentCopyWithImpl;
@useResult
$Res call({
 String id, String type, String name, String? manufacturer, String? model, String? serialNumber, String? version, Map<String, String>? specifications, String? health, DateTime? lastChecked
});




}
/// @nodoc
class _$HardwareComponentCopyWithImpl<$Res>
    implements $HardwareComponentCopyWith<$Res> {
  _$HardwareComponentCopyWithImpl(this._self, this._then);

  final HardwareComponent _self;
  final $Res Function(HardwareComponent) _then;

/// Create a copy of HardwareComponent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? type = null,Object? name = null,Object? manufacturer = freezed,Object? model = freezed,Object? serialNumber = freezed,Object? version = freezed,Object? specifications = freezed,Object? health = freezed,Object? lastChecked = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,serialNumber: freezed == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,specifications: freezed == specifications ? _self.specifications : specifications // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,health: freezed == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as String?,lastChecked: freezed == lastChecked ? _self.lastChecked : lastChecked // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [HardwareComponent].
extension HardwareComponentPatterns on HardwareComponent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HardwareComponent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HardwareComponent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HardwareComponent value)  $default,){
final _that = this;
switch (_that) {
case _HardwareComponent():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HardwareComponent value)?  $default,){
final _that = this;
switch (_that) {
case _HardwareComponent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String type,  String name,  String? manufacturer,  String? model,  String? serialNumber,  String? version,  Map<String, String>? specifications,  String? health,  DateTime? lastChecked)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HardwareComponent() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.manufacturer,_that.model,_that.serialNumber,_that.version,_that.specifications,_that.health,_that.lastChecked);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String type,  String name,  String? manufacturer,  String? model,  String? serialNumber,  String? version,  Map<String, String>? specifications,  String? health,  DateTime? lastChecked)  $default,) {final _that = this;
switch (_that) {
case _HardwareComponent():
return $default(_that.id,_that.type,_that.name,_that.manufacturer,_that.model,_that.serialNumber,_that.version,_that.specifications,_that.health,_that.lastChecked);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String type,  String name,  String? manufacturer,  String? model,  String? serialNumber,  String? version,  Map<String, String>? specifications,  String? health,  DateTime? lastChecked)?  $default,) {final _that = this;
switch (_that) {
case _HardwareComponent() when $default != null:
return $default(_that.id,_that.type,_that.name,_that.manufacturer,_that.model,_that.serialNumber,_that.version,_that.specifications,_that.health,_that.lastChecked);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HardwareComponent implements HardwareComponent {
  const _HardwareComponent({required this.id, required this.type, required this.name, this.manufacturer, this.model, this.serialNumber, this.version, final  Map<String, String>? specifications, this.health, this.lastChecked}): _specifications = specifications;
  factory _HardwareComponent.fromJson(Map<String, dynamic> json) => _$HardwareComponentFromJson(json);

@override final  String id;
@override final  String type;
// "cpu", "memory", "disk", "gpu", "motherboard"
@override final  String name;
@override final  String? manufacturer;
@override final  String? model;
@override final  String? serialNumber;
@override final  String? version;
 final  Map<String, String>? _specifications;
@override Map<String, String>? get specifications {
  final value = _specifications;
  if (value == null) return null;
  if (_specifications is EqualUnmodifiableMapView) return _specifications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  String? health;
// "good", "warning", "critical", "unknown"
@override final  DateTime? lastChecked;

/// Create a copy of HardwareComponent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HardwareComponentCopyWith<_HardwareComponent> get copyWith => __$HardwareComponentCopyWithImpl<_HardwareComponent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HardwareComponentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HardwareComponent&&(identical(other.id, id) || other.id == id)&&(identical(other.type, type) || other.type == type)&&(identical(other.name, name) || other.name == name)&&(identical(other.manufacturer, manufacturer) || other.manufacturer == manufacturer)&&(identical(other.model, model) || other.model == model)&&(identical(other.serialNumber, serialNumber) || other.serialNumber == serialNumber)&&(identical(other.version, version) || other.version == version)&&const DeepCollectionEquality().equals(other._specifications, _specifications)&&(identical(other.health, health) || other.health == health)&&(identical(other.lastChecked, lastChecked) || other.lastChecked == lastChecked));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,type,name,manufacturer,model,serialNumber,version,const DeepCollectionEquality().hash(_specifications),health,lastChecked);

@override
String toString() {
  return 'HardwareComponent(id: $id, type: $type, name: $name, manufacturer: $manufacturer, model: $model, serialNumber: $serialNumber, version: $version, specifications: $specifications, health: $health, lastChecked: $lastChecked)';
}


}

/// @nodoc
abstract mixin class _$HardwareComponentCopyWith<$Res> implements $HardwareComponentCopyWith<$Res> {
  factory _$HardwareComponentCopyWith(_HardwareComponent value, $Res Function(_HardwareComponent) _then) = __$HardwareComponentCopyWithImpl;
@override @useResult
$Res call({
 String id, String type, String name, String? manufacturer, String? model, String? serialNumber, String? version, Map<String, String>? specifications, String? health, DateTime? lastChecked
});




}
/// @nodoc
class __$HardwareComponentCopyWithImpl<$Res>
    implements _$HardwareComponentCopyWith<$Res> {
  __$HardwareComponentCopyWithImpl(this._self, this._then);

  final _HardwareComponent _self;
  final $Res Function(_HardwareComponent) _then;

/// Create a copy of HardwareComponent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? type = null,Object? name = null,Object? manufacturer = freezed,Object? model = freezed,Object? serialNumber = freezed,Object? version = freezed,Object? specifications = freezed,Object? health = freezed,Object? lastChecked = freezed,}) {
  return _then(_HardwareComponent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,manufacturer: freezed == manufacturer ? _self.manufacturer : manufacturer // ignore: cast_nullable_to_non_nullable
as String?,model: freezed == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String?,serialNumber: freezed == serialNumber ? _self.serialNumber : serialNumber // ignore: cast_nullable_to_non_nullable
as String?,version: freezed == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as String?,specifications: freezed == specifications ? _self._specifications : specifications // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,health: freezed == health ? _self.health : health // ignore: cast_nullable_to_non_nullable
as String?,lastChecked: freezed == lastChecked ? _self.lastChecked : lastChecked // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AuthenticationInfo {

 String get mechanism;// "password", "certificate", "kerberos", etc.
 Map<String, String>? get details; bool? get isMultiFactor; List<String>? get mfaMethods; DateTime? get lastAuthentication; bool? get isServiceAccount;
/// Create a copy of AuthenticationInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticationInfoCopyWith<AuthenticationInfo> get copyWith => _$AuthenticationInfoCopyWithImpl<AuthenticationInfo>(this as AuthenticationInfo, _$identity);

  /// Serializes this AuthenticationInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticationInfo&&(identical(other.mechanism, mechanism) || other.mechanism == mechanism)&&const DeepCollectionEquality().equals(other.details, details)&&(identical(other.isMultiFactor, isMultiFactor) || other.isMultiFactor == isMultiFactor)&&const DeepCollectionEquality().equals(other.mfaMethods, mfaMethods)&&(identical(other.lastAuthentication, lastAuthentication) || other.lastAuthentication == lastAuthentication)&&(identical(other.isServiceAccount, isServiceAccount) || other.isServiceAccount == isServiceAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mechanism,const DeepCollectionEquality().hash(details),isMultiFactor,const DeepCollectionEquality().hash(mfaMethods),lastAuthentication,isServiceAccount);

@override
String toString() {
  return 'AuthenticationInfo(mechanism: $mechanism, details: $details, isMultiFactor: $isMultiFactor, mfaMethods: $mfaMethods, lastAuthentication: $lastAuthentication, isServiceAccount: $isServiceAccount)';
}


}

/// @nodoc
abstract mixin class $AuthenticationInfoCopyWith<$Res>  {
  factory $AuthenticationInfoCopyWith(AuthenticationInfo value, $Res Function(AuthenticationInfo) _then) = _$AuthenticationInfoCopyWithImpl;
@useResult
$Res call({
 String mechanism, Map<String, String>? details, bool? isMultiFactor, List<String>? mfaMethods, DateTime? lastAuthentication, bool? isServiceAccount
});




}
/// @nodoc
class _$AuthenticationInfoCopyWithImpl<$Res>
    implements $AuthenticationInfoCopyWith<$Res> {
  _$AuthenticationInfoCopyWithImpl(this._self, this._then);

  final AuthenticationInfo _self;
  final $Res Function(AuthenticationInfo) _then;

/// Create a copy of AuthenticationInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mechanism = null,Object? details = freezed,Object? isMultiFactor = freezed,Object? mfaMethods = freezed,Object? lastAuthentication = freezed,Object? isServiceAccount = freezed,}) {
  return _then(_self.copyWith(
mechanism: null == mechanism ? _self.mechanism : mechanism // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self.details : details // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,isMultiFactor: freezed == isMultiFactor ? _self.isMultiFactor : isMultiFactor // ignore: cast_nullable_to_non_nullable
as bool?,mfaMethods: freezed == mfaMethods ? _self.mfaMethods : mfaMethods // ignore: cast_nullable_to_non_nullable
as List<String>?,lastAuthentication: freezed == lastAuthentication ? _self.lastAuthentication : lastAuthentication // ignore: cast_nullable_to_non_nullable
as DateTime?,isServiceAccount: freezed == isServiceAccount ? _self.isServiceAccount : isServiceAccount // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthenticationInfo].
extension AuthenticationInfoPatterns on AuthenticationInfo {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthenticationInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthenticationInfo() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthenticationInfo value)  $default,){
final _that = this;
switch (_that) {
case _AuthenticationInfo():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthenticationInfo value)?  $default,){
final _that = this;
switch (_that) {
case _AuthenticationInfo() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String mechanism,  Map<String, String>? details,  bool? isMultiFactor,  List<String>? mfaMethods,  DateTime? lastAuthentication,  bool? isServiceAccount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthenticationInfo() when $default != null:
return $default(_that.mechanism,_that.details,_that.isMultiFactor,_that.mfaMethods,_that.lastAuthentication,_that.isServiceAccount);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String mechanism,  Map<String, String>? details,  bool? isMultiFactor,  List<String>? mfaMethods,  DateTime? lastAuthentication,  bool? isServiceAccount)  $default,) {final _that = this;
switch (_that) {
case _AuthenticationInfo():
return $default(_that.mechanism,_that.details,_that.isMultiFactor,_that.mfaMethods,_that.lastAuthentication,_that.isServiceAccount);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String mechanism,  Map<String, String>? details,  bool? isMultiFactor,  List<String>? mfaMethods,  DateTime? lastAuthentication,  bool? isServiceAccount)?  $default,) {final _that = this;
switch (_that) {
case _AuthenticationInfo() when $default != null:
return $default(_that.mechanism,_that.details,_that.isMultiFactor,_that.mfaMethods,_that.lastAuthentication,_that.isServiceAccount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthenticationInfo implements AuthenticationInfo {
  const _AuthenticationInfo({required this.mechanism, final  Map<String, String>? details, this.isMultiFactor, final  List<String>? mfaMethods, this.lastAuthentication, this.isServiceAccount}): _details = details,_mfaMethods = mfaMethods;
  factory _AuthenticationInfo.fromJson(Map<String, dynamic> json) => _$AuthenticationInfoFromJson(json);

@override final  String mechanism;
// "password", "certificate", "kerberos", etc.
 final  Map<String, String>? _details;
// "password", "certificate", "kerberos", etc.
@override Map<String, String>? get details {
  final value = _details;
  if (value == null) return null;
  if (_details is EqualUnmodifiableMapView) return _details;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  bool? isMultiFactor;
 final  List<String>? _mfaMethods;
@override List<String>? get mfaMethods {
  final value = _mfaMethods;
  if (value == null) return null;
  if (_mfaMethods is EqualUnmodifiableListView) return _mfaMethods;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  DateTime? lastAuthentication;
@override final  bool? isServiceAccount;

/// Create a copy of AuthenticationInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticationInfoCopyWith<_AuthenticationInfo> get copyWith => __$AuthenticationInfoCopyWithImpl<_AuthenticationInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthenticationInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthenticationInfo&&(identical(other.mechanism, mechanism) || other.mechanism == mechanism)&&const DeepCollectionEquality().equals(other._details, _details)&&(identical(other.isMultiFactor, isMultiFactor) || other.isMultiFactor == isMultiFactor)&&const DeepCollectionEquality().equals(other._mfaMethods, _mfaMethods)&&(identical(other.lastAuthentication, lastAuthentication) || other.lastAuthentication == lastAuthentication)&&(identical(other.isServiceAccount, isServiceAccount) || other.isServiceAccount == isServiceAccount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mechanism,const DeepCollectionEquality().hash(_details),isMultiFactor,const DeepCollectionEquality().hash(_mfaMethods),lastAuthentication,isServiceAccount);

@override
String toString() {
  return 'AuthenticationInfo(mechanism: $mechanism, details: $details, isMultiFactor: $isMultiFactor, mfaMethods: $mfaMethods, lastAuthentication: $lastAuthentication, isServiceAccount: $isServiceAccount)';
}


}

/// @nodoc
abstract mixin class _$AuthenticationInfoCopyWith<$Res> implements $AuthenticationInfoCopyWith<$Res> {
  factory _$AuthenticationInfoCopyWith(_AuthenticationInfo value, $Res Function(_AuthenticationInfo) _then) = __$AuthenticationInfoCopyWithImpl;
@override @useResult
$Res call({
 String mechanism, Map<String, String>? details, bool? isMultiFactor, List<String>? mfaMethods, DateTime? lastAuthentication, bool? isServiceAccount
});




}
/// @nodoc
class __$AuthenticationInfoCopyWithImpl<$Res>
    implements _$AuthenticationInfoCopyWith<$Res> {
  __$AuthenticationInfoCopyWithImpl(this._self, this._then);

  final _AuthenticationInfo _self;
  final $Res Function(_AuthenticationInfo) _then;

/// Create a copy of AuthenticationInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mechanism = null,Object? details = freezed,Object? isMultiFactor = freezed,Object? mfaMethods = freezed,Object? lastAuthentication = freezed,Object? isServiceAccount = freezed,}) {
  return _then(_AuthenticationInfo(
mechanism: null == mechanism ? _self.mechanism : mechanism // ignore: cast_nullable_to_non_nullable
as String,details: freezed == details ? _self._details : details // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,isMultiFactor: freezed == isMultiFactor ? _self.isMultiFactor : isMultiFactor // ignore: cast_nullable_to_non_nullable
as bool?,mfaMethods: freezed == mfaMethods ? _self._mfaMethods : mfaMethods // ignore: cast_nullable_to_non_nullable
as List<String>?,lastAuthentication: freezed == lastAuthentication ? _self.lastAuthentication : lastAuthentication // ignore: cast_nullable_to_non_nullable
as DateTime?,isServiceAccount: freezed == isServiceAccount ? _self.isServiceAccount : isServiceAccount // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
