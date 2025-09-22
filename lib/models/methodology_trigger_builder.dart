import 'package:freezed_annotation/freezed_annotation.dart';
import 'asset.dart';

part 'methodology_trigger_builder.freezed.dart';
part 'methodology_trigger_builder.g.dart';

// Trigger builder models for the visual trigger editor

@freezed
class TriggerCondition with _$TriggerCondition {
  const factory TriggerCondition({
    required String id,
    required AssetType assetType,
    required String property,
    required TriggerOperator operator,
    required TriggerValue value,
    String? logicalOperator, // AND, OR, NOT
  }) = _TriggerCondition;

  factory TriggerCondition.fromJson(Map<String, dynamic> json) =>
      _$TriggerConditionFromJson(json);
}

@freezed
class TriggerValue with _$TriggerValue {
  const factory TriggerValue.string(String value) = StringTriggerValue;
  const factory TriggerValue.boolean(bool value) = BooleanTriggerValue;
  const factory TriggerValue.number(double value) = NumberTriggerValue;
  const factory TriggerValue.list(List<String> values) = ListTriggerValue;
  const factory TriggerValue.isNull() = NullTriggerValue;
  const factory TriggerValue.notNull() = NotNullTriggerValue;

  factory TriggerValue.fromJson(Map<String, dynamic> json) =>
      _$TriggerValueFromJson(json);
}

enum TriggerOperator {
  equals,
  notEquals,
  contains,
  notContains,
  startsWith,
  endsWith,
  greaterThan,
  lessThan,
  greaterThanOrEqual,
  lessThanOrEqual,
  in_,
  notIn,
  exists,
  notExists,
  isNull,
  isNotNull,
  regex,
  notRegex;

  String get symbol {
    switch (this) {
      case TriggerOperator.equals:
        return '==';
      case TriggerOperator.notEquals:
        return '!=';
      case TriggerOperator.contains:
        return 'CONTAINS';
      case TriggerOperator.notContains:
        return 'NOT CONTAINS';
      case TriggerOperator.startsWith:
        return 'STARTS WITH';
      case TriggerOperator.endsWith:
        return 'ENDS WITH';
      case TriggerOperator.greaterThan:
        return '>';
      case TriggerOperator.lessThan:
        return '<';
      case TriggerOperator.greaterThanOrEqual:
        return '>=';
      case TriggerOperator.lessThanOrEqual:
        return '<=';
      case TriggerOperator.in_:
        return 'IN';
      case TriggerOperator.notIn:
        return 'NOT IN';
      case TriggerOperator.exists:
        return 'EXISTS';
      case TriggerOperator.notExists:
        return 'NOT EXISTS';
      case TriggerOperator.isNull:
        return 'IS NULL';
      case TriggerOperator.isNotNull:
        return 'IS NOT NULL';
      case TriggerOperator.regex:
        return 'REGEX';
      case TriggerOperator.notRegex:
        return 'NOT REGEX';
    }
  }
}

@freezed
class TriggerGroup with _$TriggerGroup {
  const factory TriggerGroup({
    required String id,
    required List<TriggerCondition> conditions,
    @Default('AND') String logicalOperator,
  }) = _TriggerGroup;

  factory TriggerGroup.fromJson(Map<String, dynamic> json) =>
      _$TriggerGroupFromJson(json);

  factory TriggerGroup.empty() => TriggerGroup(
    id: 'group_${DateTime.now().millisecondsSinceEpoch}',
    conditions: [],
  );
}

@freezed
class MethodologyTriggerDefinition with _$MethodologyTriggerDefinition {
  const factory MethodologyTriggerDefinition({
    required String id,
    required String name,
    required String description,
    @Default(5) int priority,
    @Default(true) bool enabled,
    required List<TriggerGroup> conditionGroups,
    @Default('AND') String groupLogicalOperator,
    Map<String, String>? parameterMappings,
    Map<String, dynamic>? defaultParameters,
  }) = _MethodologyTriggerDefinition;

  factory MethodologyTriggerDefinition.fromJson(Map<String, dynamic> json) =>
      _$MethodologyTriggerDefinitionFromJson(json);

  factory MethodologyTriggerDefinition.empty() => MethodologyTriggerDefinition(
    id: 'trigger_${DateTime.now().millisecondsSinceEpoch}',
    name: '',
    description: '',
    conditionGroups: [],
  );
}

// Asset property types
enum PropertyType {
  string,
  number,
  boolean,
  list;
}

@freezed
class AssetProperty with _$AssetProperty {
  const factory AssetProperty({
    required String name,
    required String displayName,
    required PropertyType type,
    List<String>? allowedValues,
    String? description,
  }) = _AssetProperty;

  factory AssetProperty.fromJson(Map<String, dynamic> json) =>
      _$AssetPropertyFromJson(json);
}

// Asset property definitions for different asset types
class AssetPropertyDefinition {
  static const Map<AssetType, List<AssetProperty>> _properties = {
    AssetType.host: [
      AssetProperty(
        name: 'ip_address',
        displayName: 'IP Address',
        type: PropertyType.string,
        description: 'IPv4 or IPv6 address of the host',
      ),
      AssetProperty(
        name: 'hostname',
        displayName: 'Hostname',
        type: PropertyType.string,
        description: 'Network hostname of the system',
      ),
      AssetProperty(
        name: 'operating_system',
        displayName: 'Operating System',
        type: PropertyType.string,
        allowedValues: ['Windows', 'Linux', 'macOS', 'Unix', 'Other'],
        description: 'Host operating system type',
      ),
      AssetProperty(
        name: 'os_version',
        displayName: 'OS Version',
        type: PropertyType.string,
        description: 'Specific version of the operating system',
      ),
      AssetProperty(
        name: 'domain_joined',
        displayName: 'Domain Joined',
        type: PropertyType.boolean,
        description: 'Whether host is joined to a Windows domain',
      ),
      AssetProperty(
        name: 'open_ports',
        displayName: 'Open Ports',
        type: PropertyType.list,
        description: 'List of open TCP/UDP ports',
      ),
      AssetProperty(
        name: 'services',
        displayName: 'Running Services',
        type: PropertyType.list,
        description: 'Services running on the host',
      ),
      AssetProperty(
        name: 'software_installed',
        displayName: 'Installed Software',
        type: PropertyType.list,
        allowedValues: ['citrix', 'vmware', 'rdp', 'ssh', 'smb', 'ftp', 'http', 'https'],
        description: 'Software packages installed on the host',
      ),
      AssetProperty(
        name: 'privilege_level',
        displayName: 'Access Level',
        type: PropertyType.string,
        allowedValues: ['guest', 'user', 'admin', 'system'],
        description: 'Current privilege level on the host',
      ),
      AssetProperty(
        name: 'rdp_enabled',
        displayName: 'RDP Enabled',
        type: PropertyType.boolean,
        description: 'Remote Desktop Protocol enabled',
      ),
      AssetProperty(
        name: 'ssh_enabled',
        displayName: 'SSH Enabled',
        type: PropertyType.boolean,
        description: 'Secure Shell access enabled',
      ),
      AssetProperty(
        name: 'antivirus_installed',
        displayName: 'Antivirus Installed',
        type: PropertyType.boolean,
        description: 'Antivirus software detected',
      ),
    ],
    AssetType.service: [
      AssetProperty(
        name: 'service_name',
        displayName: 'Service Name',
        type: PropertyType.string,
        allowedValues: ['http', 'https', 'ftp', 'ssh', 'rdp', 'smb', 'ldap', 'dns', 'dhcp'],
        description: 'Name of the network service',
      ),
      AssetProperty(
        name: 'port',
        displayName: 'Port Number',
        type: PropertyType.number,
        description: 'TCP or UDP port number',
      ),
      AssetProperty(
        name: 'protocol',
        displayName: 'Protocol',
        type: PropertyType.string,
        allowedValues: ['tcp', 'udp'],
        description: 'Network protocol used',
      ),
      AssetProperty(
        name: 'version',
        displayName: 'Service Version',
        type: PropertyType.string,
        description: 'Version of the service software',
      ),
      AssetProperty(
        name: 'authentication_required',
        displayName: 'Authentication Required',
        type: PropertyType.boolean,
        description: 'Whether service requires authentication',
      ),
      AssetProperty(
        name: 'authentication_type',
        displayName: 'Authentication Type',
        type: PropertyType.string,
        allowedValues: ['none', 'basic', 'ntlm', 'kerberos', 'oauth', 'token'],
        description: 'Type of authentication mechanism',
      ),
      AssetProperty(
        name: 'encryption_enabled',
        displayName: 'Encryption Enabled',
        type: PropertyType.boolean,
        description: 'Traffic encryption enabled',
      ),
      AssetProperty(
        name: 'web_technologies',
        displayName: 'Web Technologies',
        type: PropertyType.list,
        allowedValues: ['asp.net', 'php', 'nodejs', 'java', 'python', 'vdi', 'citrix'],
        description: 'Web technologies detected',
      ),
    ],
    AssetType.credential: [
      AssetProperty(
        name: 'username',
        displayName: 'Username',
        type: PropertyType.string,
        description: 'Account username',
      ),
      AssetProperty(
        name: 'credential_type',
        displayName: 'Credential Type',
        type: PropertyType.string,
        allowedValues: ['password', 'ntlm', 'kerberos', 'ssh_key', 'api_key', 'token'],
        description: 'Type of credential',
      ),
      AssetProperty(
        name: 'domain',
        displayName: 'Domain',
        type: PropertyType.string,
        description: 'Authentication domain',
      ),
      AssetProperty(
        name: 'valid_services',
        displayName: 'Valid Services',
        type: PropertyType.list,
        allowedValues: ['smb', 'rdp', 'ssh', 'ldap', 'web', 'ftp'],
        description: 'Services where credential is valid',
      ),
      AssetProperty(
        name: 'privilege_level',
        displayName: 'Privilege Level',
        type: PropertyType.string,
        allowedValues: ['low', 'medium', 'high', 'admin'],
        description: 'Privilege level of the credential',
      ),
      AssetProperty(
        name: 'is_expired',
        displayName: 'Is Expired',
        type: PropertyType.boolean,
        description: 'Whether credential has expired',
      ),
    ],
    AssetType.networkSegment: [
      AssetProperty(
        name: 'subnet',
        displayName: 'Subnet',
        type: PropertyType.string,
        description: 'Network subnet (e.g., 192.168.1.0/24)',
      ),
      AssetProperty(
        name: 'vlan_id',
        displayName: 'VLAN ID',
        type: PropertyType.number,
        description: 'Virtual LAN identifier',
      ),
      AssetProperty(
        name: 'network_type',
        displayName: 'Network Type',
        type: PropertyType.string,
        allowedValues: ['internal', 'dmz', 'external', 'guest', 'management'],
        description: 'Type of network segment',
      ),
      AssetProperty(
        name: 'nac_enabled',
        displayName: 'NAC Enabled',
        type: PropertyType.boolean,
        description: 'Network Access Control enabled',
      ),
      AssetProperty(
        name: 'nac_status',
        displayName: 'NAC Status',
        type: PropertyType.string,
        allowedValues: ['active', 'inactive', 'bypassed', 'unknown'],
        description: 'Status of Network Access Control',
      ),
      AssetProperty(
        name: 'gateway',
        displayName: 'Gateway',
        type: PropertyType.string,
        description: 'Network gateway IP address',
      ),
      AssetProperty(
        name: 'dns_servers',
        displayName: 'DNS Servers',
        type: PropertyType.list,
        description: 'DNS server addresses',
      ),
      AssetProperty(
        name: 'dhcp_enabled',
        displayName: 'DHCP Enabled',
        type: PropertyType.boolean,
        description: 'Dynamic Host Configuration Protocol enabled',
      ),
    ],
  };

  static List<AssetProperty> getPropertiesForAssetType(AssetType assetType) {
    return _properties[assetType] ?? [];
  }

  static AssetProperty? getProperty(AssetType assetType, String propertyName) {
    final properties = getPropertiesForAssetType(assetType);
    try {
      return properties.firstWhere((p) => p.name == propertyName);
    } catch (e) {
      return null;
    }
  }
}

// Predefined trigger templates for common scenarios
@freezed
class TriggerTemplate with _$TriggerTemplate {
  const factory TriggerTemplate({
    required String name,
    required String description,
    required MethodologyTriggerDefinition trigger,
  }) = _TriggerTemplate;

  factory TriggerTemplate.fromJson(Map<String, dynamic> json) =>
      _$TriggerTemplateFromJson(json);

  static List<TriggerTemplate> getAllTemplates() {
    return [
      // VDI + Valid Credentials
      TriggerTemplate(
        name: 'VDI + Valid Credentials',
        description: 'Trigger when VDI software detected and valid credentials available',
        trigger: MethodologyTriggerDefinition(
          id: 'vdi_credential_template',
          name: 'VDI + Valid Credentials',
          description: 'Detected VDI software with working credentials',
          priority: 9,
          conditionGroups: [
            TriggerGroup(
              id: 'vdi_group',
              conditions: [
                TriggerCondition(
                  id: 'vdi_software',
                  assetType: AssetType.host,
                  property: 'software_installed',
                  operator: TriggerOperator.contains,
                  value: const TriggerValue.string('citrix'),
                ),
                TriggerCondition(
                  id: 'valid_rdp',
                  assetType: AssetType.credential,
                  property: 'valid_services',
                  operator: TriggerOperator.contains,
                  value: const TriggerValue.string('rdp'),
                ),
              ],
            ),
          ],
        ),
      ),

      // SMB + NTLM Hash
      TriggerTemplate(
        name: 'SMB + NTLM Hash',
        description: 'Test NTLM hashes against SMB services',
        trigger: MethodologyTriggerDefinition(
          id: 'smb_ntlm_template',
          name: 'SMB + NTLM Hash',
          description: 'NTLM credential available for SMB service',
          priority: 7,
          conditionGroups: [
            TriggerGroup(
              id: 'smb_ntlm_group',
              conditions: [
                TriggerCondition(
                  id: 'ntlm_cred',
                  assetType: AssetType.credential,
                  property: 'credential_type',
                  operator: TriggerOperator.equals,
                  value: const TriggerValue.string('ntlm'),
                ),
                TriggerCondition(
                  id: 'smb_service',
                  assetType: AssetType.service,
                  property: 'service_name',
                  operator: TriggerOperator.equals,
                  value: const TriggerValue.string('smb'),
                ),
              ],
            ),
          ],
        ),
      ),

      // Network Without NAC
      TriggerTemplate(
        name: 'Network Without NAC',
        description: 'Target networks without NAC protection',
        trigger: MethodologyTriggerDefinition(
          id: 'no_nac_template',
          name: 'Network Without NAC',
          description: 'Network segment without Network Access Control',
          priority: 6,
          conditionGroups: [
            TriggerGroup(
              id: 'nac_group',
              logicalOperator: 'OR',
              conditions: [
                TriggerCondition(
                  id: 'nac_disabled',
                  assetType: AssetType.networkSegment,
                  property: 'nac_enabled',
                  operator: TriggerOperator.equals,
                  value: const TriggerValue.boolean(false),
                ),
                TriggerCondition(
                  id: 'nac_null',
                  assetType: AssetType.networkSegment,
                  property: 'nac_status',
                  operator: TriggerOperator.isNull,
                  value: const TriggerValue.isNull(),
                ),
              ],
            ),
          ],
        ),
      ),

      // Domain Controller Access
      TriggerTemplate(
        name: 'Domain Controller Access',
        description: 'High-privilege access to domain controller',
        trigger: MethodologyTriggerDefinition(
          id: 'dc_access_template',
          name: 'Domain Controller Access',
          description: 'Administrative access to domain controller detected',
          priority: 10,
          conditionGroups: [
            TriggerGroup(
              id: 'dc_group',
              conditions: [
                TriggerCondition(
                  id: 'dc_service',
                  assetType: AssetType.service,
                  property: 'service_name',
                  operator: TriggerOperator.equals,
                  value: const TriggerValue.string('ldap'),
                ),
                TriggerCondition(
                  id: 'admin_cred',
                  assetType: AssetType.credential,
                  property: 'privilege_level',
                  operator: TriggerOperator.equals,
                  value: const TriggerValue.string('admin'),
                ),
              ],
            ),
          ],
        ),
      ),
    ];
  }
}

// Parameter mapping for methodology execution
@freezed
class MethodologyParameter with _$MethodologyParameter {
  const factory MethodologyParameter({
    required String name,
    required String type,
    required String source, // 'asset_property', 'static_value', 'user_input'
    String? defaultValue,
    String? description,
  }) = _MethodologyParameter;

  factory MethodologyParameter.fromJson(Map<String, dynamic> json) =>
      _$MethodologyParameterFromJson(json);
}