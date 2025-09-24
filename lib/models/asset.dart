import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'asset.freezed.dart';
part 'asset.g.dart';

// Asset types
enum AssetType {
  networkSegment,
  host,
  service,
  credential,
  vulnerability,
  domain,
  wireless_network,
  restrictedEnvironment,
  securityControl,
  // AD-specific asset types
  activeDirectoryDomain,
  domainController,
  adUser,
  adComputer,
  certificateAuthority,
  certificateTemplate,
  sccmServer,
  smbShare,
  kerberosTicket,
  // Azure-specific asset types
  azureTenant,
  azureSubscription,
  azureStorageAccount,
  azureVirtualMachine,
  azureKeyVault,
  azureWebApp,
  azureFunctionApp,
  azureDevOpsOrganization,
  azureSqlDatabase,
  azureContainerRegistry,
  azureLogicApp,
  azureAutomationAccount,
  azureServicePrincipal,
  azureManagedIdentity,
}

// Access levels for network segments
enum AccessLevel {
  blocked,    // No access
  limited,    // Guest/quarantine VLAN
  partial,    // Some access with restrictions
  full,       // Complete network access
}

// Generic property value that can hold different types
@freezed
sealed class PropertyValue with _$PropertyValue {
  const factory PropertyValue.string(String value) = StringProperty;
  const factory PropertyValue.integer(int value) = IntegerProperty;
  const factory PropertyValue.boolean(bool value) = BooleanProperty;
  const factory PropertyValue.stringList(List<String> values) = StringListProperty;
  const factory PropertyValue.map(Map<String, dynamic> value) = MapProperty;
  const factory PropertyValue.objectList(List<Map<String, dynamic>> objects) = ObjectListProperty;

  factory PropertyValue.fromJson(Map<String, dynamic> json) => _$PropertyValueFromJson(json);
}

// Asset model with rich property system
@freezed
sealed class Asset with _$Asset {
  const factory Asset({
    required String id,
    required AssetType type,
    required String projectId,
    required String name,
    String? description,

    // Rich property system
    required Map<String, PropertyValue> properties,

    // Trigger tracking
    required List<String> completedTriggers,  // Deduplication keys
    required Map<String, TriggerResult> triggerResults,

    // Relationships
    required List<String> parentAssetIds,
    required List<String> childAssetIds,

    // Metadata
    required DateTime discoveredAt,
    DateTime? lastUpdated,
    String? discoveryMethod,
    double? confidence,

    // Tags for filtering and grouping
    required List<String> tags,
  }) = _Asset;

  factory Asset.fromJson(Map<String, dynamic> json) => _$AssetFromJson(json);
}

// Result of a trigger execution
@freezed
sealed class TriggerResult with _$TriggerResult {
  const factory TriggerResult({
    required String methodologyId,
    required DateTime executedAt,
    required bool success,
    String? output,
    Map<String, PropertyValue>? propertyUpdates,
    List<Asset>? discoveredAssets,
    String? error,
  }) = _TriggerResult;

  factory TriggerResult.fromJson(Map<String, dynamic> json) => _$TriggerResultFromJson(json);
}

// Pre-defined property schemas for different asset types
class AssetPropertySchemas {
  // Network Segment Properties
  static const networkSegmentProperties = {
    'subnet': 'string',              // e.g., "192.168.1.0/24"
    'gateway': 'string',             // e.g., "192.168.1.1"
    'dns_servers': 'stringList',    // e.g., ["8.8.8.8", "8.8.4.4"]
    'domain_name': 'string',         // e.g., "corp.local"
    'vlan_id': 'integer',           // e.g., 100

    // Security controls
    'nac_enabled': 'boolean',
    'nac_type': 'string',           // "802.1x", "mac_auth", etc.
    'firewall_present': 'boolean',
    'ips_ids_present': 'boolean',
    'access_level': 'string',       // AccessLevel enum as string

    // Discovered assets
    'live_hosts': 'stringList',     // IP addresses
    'web_services': 'objectList',   // [{host, port, service, ssl}]
    'smb_hosts': 'stringList',
    'domain_controllers': 'stringList',
    'dhcp_servers': 'stringList',

    // Available resources
    'credentials_available': 'objectList',  // [{username, password/hash, source}]
    'captured_hashes': 'objectList',        // [{username, hash, type}]

    // Attempted bypasses
    'bypass_methods_attempted': 'stringList',  // ["mac_spoofing", "vlan_hopping"]
    'bypass_methods_successful': 'stringList',
  };

  // Host Properties
  static const hostProperties = {
    'ip_address': 'string',
    'ipv6_address': 'string',
    'hostname': 'string',
    'fqdn': 'string',
    'mac_address': 'string',

    // OS Information
    'os_type': 'string',            // "windows", "linux", "macos"
    'os_version': 'string',
    'os_architecture': 'string',    // "x64", "x86"

    // Services
    'open_ports': 'stringList',     // ["22", "80", "445"]
    'services': 'objectList',       // [{port, service, version, banner}]

    // Security status
    'smb_signing': 'boolean',
    'null_sessions': 'boolean',
    'rdp_enabled': 'boolean',
    'ssh_enabled': 'boolean',
    'web_server': 'boolean',

    // Access status
    'credentials_valid': 'objectList',  // [{username, access_type}]
    'shell_access': 'boolean',
    'privilege_level': 'string',        // "none", "user", "admin", "system"

    // Vulnerabilities
    'vulnerabilities': 'objectList',    // [{cve, severity, exploitable}]
  };

  // Service Properties
  static const serviceProperties = {
    'host': 'string',
    'port': 'integer',
    'protocol': 'string',           // "tcp", "udp"
    'service_name': 'string',       // "http", "smb", "ssh"
    'version': 'string',
    'banner': 'string',

    // Web specific
    'web_technology': 'stringList',  // ["nginx", "php", "wordpress"]
    'ssl_enabled': 'boolean',
    'ssl_vulnerabilities': 'stringList',

    // Authentication
    'auth_required': 'boolean',
    'auth_methods': 'stringList',    // ["basic", "ntlm", "kerberos"]
    'default_creds_tested': 'boolean',
    'weak_creds_found': 'boolean',
  };

  // Credential Properties
  static const credentialProperties = {
    'username': 'string',
    'password': 'string',
    'hash': 'string',
    'hash_type': 'string',          // "ntlm", "sha1", "md5"
    'domain': 'string',
    'source': 'string',              // "llmnr_poisoning", "hash_dump", "brute_force"
    'confirmed_hosts': 'stringList', // Hosts where cred is valid
    'privilege_level': 'string',
    'last_tested': 'string',         // ISO timestamp
  };

  // Active Directory Domain Properties
  static const activeDirectoryDomainProperties = {
    'domain_name': 'string',            // e.g., "corp.local"
    'forest_name': 'string',            // e.g., "corp.local"
    'functional_level': 'string',       // e.g., "2016"
    'domain_controllers': 'stringList', // DC hostnames/IPs
    'trust_relationships': 'objectList', // [{domain, type, direction}]
    'password_policy': 'map',           // {complexity, min_length, max_age, lockout_threshold}
    'fine_grained_password_policies': 'objectList', // PSO configurations
    'valid_credentials_available': 'boolean',
    'enumeration_completed': 'boolean',
    'bloodhound_collected': 'boolean',
  };

  // Domain Controller Properties
  static const domainControllerProperties = {
    'hostname': 'string',
    'ip_address': 'string',
    'domain_name': 'string',
    'operating_system': 'string',
    'roles': 'stringList',             // ["PDC", "RID Master", "Schema Master"]
    'ldap_enabled': 'boolean',
    'ldaps_enabled': 'boolean',
    'global_catalog': 'boolean',
    'smb_signing_required': 'boolean',
    'ldap_anonymous_access': 'boolean',
    'zerologon_vulnerable': 'boolean',
    'printnightmare_vulnerable': 'boolean',
  };

  // AD User Properties
  static const adUserProperties = {
    'username': 'string',
    'display_name': 'string',
    'email': 'string',
    'enabled': 'boolean',
    'password_never_expires': 'boolean',
    'password_not_required': 'boolean',
    'smart_card_required': 'boolean',
    'dont_require_preauth': 'boolean',     // ASREPRoast
    'service_principal_names': 'stringList', // Kerberoast
    'group_memberships': 'stringList',
    'last_logon': 'string',
    'password_last_set': 'string',
    'account_expires': 'string',
    'trusted_for_delegation': 'boolean',
    'trusted_to_auth_for_delegation': 'boolean',
    'unconstrained_delegation': 'boolean',
    'constrained_delegation_targets': 'stringList',
    'admin_count': 'boolean',
    'credentials_obtained': 'objectList',   // [{type, value, method}]
  };

  // AD Computer Properties
  static const adComputerProperties = {
    'hostname': 'string',
    'ip_address': 'string',
    'operating_system': 'string',
    'enabled': 'boolean',
    'trusted_for_delegation': 'boolean',
    'unconstrained_delegation': 'boolean',
    'constrained_delegation_targets': 'stringList',
    'resource_based_constrained_delegation': 'stringList',
    'laps_enabled': 'boolean',
    'ms_sql_services': 'objectList',       // [{instance, version, admin_users}]
    'last_logon': 'string',
    'local_admin_access': 'boolean',
    'domain_admin_sessions': 'stringList', // Logged in DA users
    'certificate_services': 'boolean',
    'sccm_client': 'boolean',
  };

  // Certificate Authority Properties
  static const certificateAuthorityProperties = {
    'ca_name': 'string',
    'ca_server': 'string',
    'web_enrollment_enabled': 'boolean',
    'template_list': 'stringList',
    'vulnerable_templates': 'stringList',   // ESC1, ESC2, etc.
    'ca_permissions': 'objectList',         // [{principal, permissions}]
    'pki_objects': 'objectList',
    'ca_certificate': 'string',
    'ca_private_key_accessible': 'boolean',
    'esc8_vulnerable': 'boolean',           // Web enrollment + relay
    'esc11_vulnerable': 'boolean',          // RPC interface
  };

  // Certificate Template Properties
  static const certificateTemplateProperties = {
    'template_name': 'string',
    'ca_name': 'string',
    'client_authentication': 'boolean',
    'enrollee_supplies_subject': 'boolean',
    'require_manager_approval': 'boolean',
    'authorized_signatures_required': 'integer',
    'template_permissions': 'objectList',   // [{principal, permissions}]
    'application_policies': 'stringList',
    'extended_key_usage': 'stringList',
    'version': 'integer',
    'vulnerability_type': 'string',         // "ESC1", "ESC2", etc.
    'exploitable': 'boolean',
  };

  // SCCM Server Properties
  static const sccmServerProperties = {
    'server_hostname': 'string',
    'management_point': 'string',
    'distribution_points': 'stringList',
    'site_code': 'string',
    'site_systems': 'stringList',
    'sql_server': 'string',
    'pxe_enabled': 'boolean',
    'client_push_enabled': 'boolean',
    'automatic_client_push': 'boolean',
    'network_access_account': 'string',
    'naa_credentials_extracted': 'boolean',
    'admin_access': 'boolean',
    'device_collection_access': 'boolean',
    'vulnerable_to_relay': 'boolean',
  };

  // SMB Share Properties
  static const smbShareProperties = {
    'hostname': 'string',
    'share_name': 'string',
    'path': 'string',
    'anonymous_access': 'boolean',
    'guest_access': 'boolean',
    'permissions': 'objectList',           // [{principal, permissions}]
    'readable': 'boolean',
    'writable': 'boolean',
    'files_enumerated': 'boolean',
    'sensitive_files': 'objectList',       // [{filename, type, content_preview}]
    'credentials_found': 'objectList',     // Creds found in files
  };

  // Kerberos Ticket Properties
  static const kerberosTicketProperties = {
    'ticket_type': 'string',              // "TGT", "TGS"
    'username': 'string',
    'service_name': 'string',
    'encryption_type': 'string',          // "RC4", "AES128", "AES256"
    'forwardable': 'boolean',
    'renewable': 'boolean',
    'expires': 'string',                  // ISO timestamp
    'ticket_data': 'string',              // Base64 encoded ticket
    'source': 'string',                   // "kerberoast", "asreproast", "golden", "silver"
    'cracked': 'boolean',
    'cleartext_password': 'string',
  };

  // Azure Tenant Properties
  static const azureTenantProperties = {
    'tenant_id': 'string',
    'tenant_name': 'string',
    'domain_names': 'stringList',         // Primary and verified domains
    'directory_type': 'string',           // "AzureAD", "Hybrid", "OnPrem"
    'mfa_enabled': 'boolean',
    'conditional_access_enabled': 'boolean',
    'password_protection_enabled': 'boolean',
    'security_defaults_enabled': 'boolean',
    'users_enumerated': 'boolean',
    'groups_enumerated': 'boolean',
    'applications_enumerated': 'boolean',
    'privileged_users': 'stringList',
    'external_users': 'stringList',
    'password_spray_attempted': 'boolean',
    'phishing_attempted': 'boolean',
  };

  // Azure Subscription Properties
  static const azureSubscriptionProperties = {
    'subscription_id': 'string',
    'subscription_name': 'string',
    'tenant_id': 'string',
    'subscription_type': 'string',        // "Free", "Pay-As-You-Go", "Enterprise"
    'state': 'string',                    // "Enabled", "Disabled", "Warned"
    'owner_principals': 'stringList',
    'contributor_principals': 'stringList',
    'resource_groups': 'stringList',
    'key_vaults': 'stringList',
    'storage_accounts': 'stringList',
    'virtual_machines': 'stringList',
    'web_apps': 'stringList',
    'cost_management_access': 'boolean',
    'security_center_enabled': 'boolean',
  };

  // Azure Storage Account Properties
  static const azureStorageAccountProperties = {
    'account_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'location': 'string',
    'account_type': 'string',             // "Standard_LRS", "Premium_LRS", etc.
    'access_tier': 'string',              // "Hot", "Cool", "Archive"
    'allow_blob_public_access': 'boolean',
    'requires_secure_transfer': 'boolean',
    'min_tls_version': 'string',
    'containers': 'objectList',           // [{name, access_level, blob_count}]
    'file_shares': 'objectList',          // [{name, access_level, size}]
    'access_keys': 'stringList',          // Retrieved keys
    'connection_strings': 'stringList',
    'sensitive_data_found': 'objectList', // [{container, blob, data_type}]
    'anonymous_access_containers': 'stringList',
  };

  // Azure Virtual Machine Properties
  static const azureVirtualMachineProperties = {
    'vm_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'vm_size': 'string',                  // "Standard_D2s_v3", etc.
    'os_type': 'string',                  // "Windows", "Linux"
    'os_version': 'string',
    'public_ip': 'string',
    'private_ip': 'string',
    'network_security_group': 'string',
    'open_ports': 'stringList',
    'extensions_installed': 'stringList',
    'managed_identity': 'string',
    'boot_diagnostics_enabled': 'boolean',
    'antimalware_enabled': 'boolean',
    'backup_enabled': 'boolean',
    'vm_agent_status': 'string',          // "Ready", "NotReady"
    'admin_credentials': 'objectList',    // Retrieved admin creds
    'lateral_movement_potential': 'boolean',
  };

  // Azure Key Vault Properties
  static const azureKeyVaultProperties = {
    'vault_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'vault_uri': 'string',
    'location': 'string',
    'access_policies': 'objectList',      // [{principal, permissions}]
    'network_acls': 'map',                // Network access restrictions
    'rbac_enabled': 'boolean',
    'soft_delete_enabled': 'boolean',
    'purge_protection_enabled': 'boolean',
    'secrets': 'objectList',              // [{name, content_type, enabled}]
    'keys': 'objectList',                 // [{name, key_type, operations}]
    'certificates': 'objectList',         // [{name, issuer, expires}]
    'accessible_secrets': 'objectList',   // Retrieved secrets
    'certificate_private_keys': 'objectList',
  };

  // Azure Web App Properties
  static const azureWebAppProperties = {
    'app_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'app_service_plan': 'string',
    'site_url': 'string',
    'runtime_stack': 'string',            // ".NET", "Node.js", "Python"
    'scm_site_url': 'string',             // Kudu URL
    'https_only': 'boolean',
    'client_affinity_enabled': 'boolean',
    'authentication_enabled': 'boolean',
    'identity_provider': 'string',        // "AzureAD", "Microsoft", etc.
    'app_settings': 'map',                // Application settings
    'connection_strings': 'map',          // DB connection strings
    'deployment_credentials': 'objectList', // FTP, Git credentials
    'scm_credentials': 'objectList',      // Kudu access
    'source_control': 'string',           // "GitHub", "Azure DevOps"
    'custom_domains': 'stringList',
  };

  // Azure Function App Properties
  static const azureFunctionAppProperties = {
    'function_app_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'runtime': 'string',                  // "dotnet", "node", "python"
    'functions': 'objectList',            // [{name, trigger_type, auth_level}]
    'consumption_plan': 'boolean',
    'storage_account': 'string',
    'app_insights_enabled': 'boolean',
    'identity_enabled': 'boolean',
    'cors_settings': 'map',
    'host_keys': 'objectList',            // Function host keys
    'function_keys': 'objectList',        // Individual function keys
    'deployment_source': 'string',
    'environment_variables': 'map',
  };

  // Azure DevOps Organization Properties
  static const azureDevOpsOrganizationProperties = {
    'organization_name': 'string',
    'organization_url': 'string',
    'projects': 'objectList',             // [{name, visibility, description}]
    'users': 'objectList',                // [{display_name, mail, access_level}]
    'service_connections': 'objectList',  // [{name, type, authorized}]
    'variable_groups': 'objectList',      // [{name, variables, key_vault}]
    'build_definitions': 'objectList',    // [{name, repo, triggers}]
    'release_definitions': 'objectList',  // [{name, environments, approvals}]
    'repositories': 'objectList',         // [{name, type, remote_url}]
    'artifacts': 'objectList',            // [{name, type, location}]
    'personal_access_tokens': 'stringList', // Retrieved PATs
    'sensitive_variables': 'objectList',  // Found in pipelines/variables
    'source_code_access': 'boolean',
  };

  // Azure SQL Database Properties
  static const azureSqlDatabaseProperties = {
    'server_name': 'string',
    'database_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'server_fqdn': 'string',
    'sql_version': 'string',
    'pricing_tier': 'string',
    'firewall_rules': 'objectList',       // [{name, start_ip, end_ip}]
    'azure_services_access': 'boolean',
    'aad_authentication': 'boolean',
    'aad_admin': 'string',
    'transparent_data_encryption': 'boolean',
    'auditing_enabled': 'boolean',
    'threat_detection_enabled': 'boolean',
    'database_users': 'stringList',
    'accessible_databases': 'stringList',
    'sensitive_tables': 'objectList',     // [{db, table, column, data_type}]
    'sql_injection_tested': 'boolean',
  };

  // Azure Container Registry Properties
  static const azureContainerRegistryProperties = {
    'registry_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'login_server': 'string',
    'sku': 'string',                      // "Basic", "Standard", "Premium"
    'admin_enabled': 'boolean',
    'public_network_access': 'string',    // "Enabled", "Disabled"
    'repositories': 'objectList',         // [{name, tag_count, created_time}]
    'webhooks': 'objectList',             // [{name, service_uri, actions}]
    'replications': 'stringList',         // Geographic replications
    'admin_credentials': 'objectList',    // Retrieved admin creds
    'vulnerable_images': 'objectList',    // [{repository, tag, vulnerabilities}]
    'exposed_secrets': 'objectList',      // Found in container images
  };

  // Azure Logic App Properties
  static const azureLogicAppProperties = {
    'logic_app_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'state': 'string',                    // "Enabled", "Disabled"
    'location': 'string',
    'triggers': 'objectList',             // [{name, type, recurrence}]
    'actions': 'objectList',              // [{name, type, settings}]
    'connections': 'objectList',          // [{name, api, connection_string}]
    'run_history': 'objectList',          // [{status, start_time, duration}]
    'parameters': 'map',                  // Workflow parameters
    'integration_service_environment': 'string',
    'managed_identity': 'string',
    'accessible_data': 'objectList',      // Data accessible through connectors
  };

  // Azure Automation Account Properties
  static const azureAutomationAccountProperties = {
    'automation_account_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'location': 'string',
    'runbooks': 'objectList',             // [{name, type, published, description}]
    'modules': 'objectList',              // [{name, version, activity_count}]
    'variables': 'objectList',            // [{name, encrypted, description}]
    'credentials': 'objectList',          // [{name, username, description}]
    'certificates': 'objectList',         // [{name, thumbprint, expiry}]
    'connections': 'objectList',          // [{name, connection_type, description}]
    'schedules': 'objectList',            // [{name, frequency, next_run}]
    'webhooks': 'objectList',             // [{name, enabled, expiry_time}]
    'hybrid_worker_groups': 'stringList',
    'retrieved_credentials': 'objectList', // Automation creds accessed
    'powershell_execution': 'boolean',    // Can execute PowerShell
  };

  // Azure Service Principal Properties
  static const azureServicePrincipalProperties = {
    'application_id': 'string',
    'object_id': 'string',
    'display_name': 'string',
    'tenant_id': 'string',
    'app_roles': 'objectList',            // [{id, display_name, value}]
    'oauth2_permissions': 'objectList',   // [{id, admin_consent_display_name}]
    'key_credentials': 'objectList',      // [{key_id, usage, type, end_date}]
    'password_credentials': 'objectList', // [{key_id, end_date, hint}]
    'required_resource_access': 'objectList', // [{resource_app_id, resource_access}]
    'sign_in_audience': 'string',         // "AzureADMyOrg", "AzureADMultipleOrgs"
    'reply_urls': 'stringList',
    'homepage': 'string',
    'certificates': 'objectList',         // Retrieved certificates
    'secrets': 'objectList',              // Retrieved client secrets
    'assigned_roles': 'objectList',       // [{role_definition, scope}]
  };

  // Azure Managed Identity Properties
  static const azureManagedIdentityProperties = {
    'identity_name': 'string',
    'identity_type': 'string',            // "SystemAssigned", "UserAssigned"
    'resource_group': 'string',
    'subscription_id': 'string',
    'principal_id': 'string',
    'tenant_id': 'string',
    'associated_resources': 'stringList',  // Resources using this identity
    'assigned_roles': 'objectList',       // [{role_definition, scope}]
    'access_token': 'string',             // Retrieved access token
    'access_token_expiry': 'string',
    'accessible_resources': 'objectList', // Resources accessible with this identity
    'privilege_escalation_paths': 'objectList', // Potential privilege escalation
  };
}

// Helper class for creating assets with proper properties
class AssetFactory {
  static final _uuid = const Uuid();

  static Asset createNetworkSegment({
    required String projectId,
    required String subnet,
    String? name,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'subnet': PropertyValue.string(subnet),
      'access_level': PropertyValue.string(AccessLevel.blocked.name),
      'nac_enabled': const PropertyValue.boolean(false),
      'firewall_present': const PropertyValue.boolean(false),
      'live_hosts': const PropertyValue.stringList([]),
      'web_services': const PropertyValue.objectList([]),
      'smb_hosts': const PropertyValue.stringList([]),
      'credentials_available': const PropertyValue.objectList([]),
      'bypass_methods_attempted': const PropertyValue.stringList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.networkSegment,
      projectId: projectId,
      name: name ?? 'Network $subnet',
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['network', 'segment'],
    );
  }

  static Asset createHost({
    required String projectId,
    required String ipAddress,
    String? hostname,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'ip_address': PropertyValue.string(ipAddress),
      if (hostname != null) 'hostname': PropertyValue.string(hostname),
      'open_ports': const PropertyValue.stringList([]),
      'services': const PropertyValue.objectList([]),
      'smb_signing': const PropertyValue.boolean(false),
      'shell_access': const PropertyValue.boolean(false),
      'privilege_level': PropertyValue.string('none'),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.host,
      projectId: projectId,
      name: hostname ?? ipAddress,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['host'],
    );
  }

  static Asset createCredential({
    required String projectId,
    required String username,
    String? password,
    String? hash,
    String? domain,
    required String source,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'username': PropertyValue.string(username),
      if (password != null) 'password': PropertyValue.string(password),
      if (hash != null) 'hash': PropertyValue.string(hash),
      if (domain != null) 'domain': PropertyValue.string(domain),
      'source': PropertyValue.string(source),
      'confirmed_hosts': const PropertyValue.stringList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    final credName = domain != null ? '$domain\\$username' : username;

    return Asset(
      id: _uuid.v4(),
      type: AssetType.credential,
      projectId: projectId,
      name: credName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['credential', source],
    );
  }

  static Asset createActiveDirectoryDomain({
    required String projectId,
    required String domainName,
    String? forestName,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'domain_name': PropertyValue.string(domainName),
      'forest_name': PropertyValue.string(forestName ?? domainName),
      'functional_level': PropertyValue.string('unknown'),
      'domain_controllers': const PropertyValue.stringList([]),
      'trust_relationships': const PropertyValue.objectList([]),
      'password_policy': PropertyValue.map({}),
      'fine_grained_password_policies': const PropertyValue.objectList([]),
      'valid_credentials_available': const PropertyValue.boolean(false),
      'enumeration_completed': const PropertyValue.boolean(false),
      'bloodhound_collected': const PropertyValue.boolean(false),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.activeDirectoryDomain,
      projectId: projectId,
      name: domainName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['ad', 'domain'],
    );
  }

  static Asset createDomainController({
    required String projectId,
    required String hostname,
    required String ipAddress,
    required String domainName,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'hostname': PropertyValue.string(hostname),
      'ip_address': PropertyValue.string(ipAddress),
      'domain_name': PropertyValue.string(domainName),
      'operating_system': PropertyValue.string('unknown'),
      'roles': const PropertyValue.stringList([]),
      'ldap_enabled': const PropertyValue.boolean(true),
      'ldaps_enabled': const PropertyValue.boolean(false),
      'global_catalog': const PropertyValue.boolean(false),
      'smb_signing_required': const PropertyValue.boolean(false),
      'ldap_anonymous_access': const PropertyValue.boolean(false),
      'zerologon_vulnerable': const PropertyValue.boolean(false),
      'printnightmare_vulnerable': const PropertyValue.boolean(false),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.domainController,
      projectId: projectId,
      name: hostname,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['ad', 'dc', 'server'],
    );
  }

  static Asset createAdUser({
    required String projectId,
    required String username,
    required String domainName,
    String? displayName,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'username': PropertyValue.string(username),
      'display_name': PropertyValue.string(displayName ?? username),
      'email': PropertyValue.string(''),
      'enabled': const PropertyValue.boolean(true),
      'password_never_expires': const PropertyValue.boolean(false),
      'password_not_required': const PropertyValue.boolean(false),
      'smart_card_required': const PropertyValue.boolean(false),
      'dont_require_preauth': const PropertyValue.boolean(false),
      'service_principal_names': const PropertyValue.stringList([]),
      'group_memberships': const PropertyValue.stringList([]),
      'last_logon': PropertyValue.string(''),
      'password_last_set': PropertyValue.string(''),
      'account_expires': PropertyValue.string(''),
      'trusted_for_delegation': const PropertyValue.boolean(false),
      'trusted_to_auth_for_delegation': const PropertyValue.boolean(false),
      'unconstrained_delegation': const PropertyValue.boolean(false),
      'constrained_delegation_targets': const PropertyValue.stringList([]),
      'admin_count': const PropertyValue.boolean(false),
      'credentials_obtained': const PropertyValue.objectList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.adUser,
      projectId: projectId,
      name: '$domainName\\$username',
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['ad', 'user'],
    );
  }

  static Asset createAdComputer({
    required String projectId,
    required String hostname,
    required String domainName,
    String? ipAddress,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'hostname': PropertyValue.string(hostname),
      'ip_address': PropertyValue.string(ipAddress ?? ''),
      'operating_system': PropertyValue.string('unknown'),
      'enabled': const PropertyValue.boolean(true),
      'trusted_for_delegation': const PropertyValue.boolean(false),
      'unconstrained_delegation': const PropertyValue.boolean(false),
      'constrained_delegation_targets': const PropertyValue.stringList([]),
      'resource_based_constrained_delegation': const PropertyValue.stringList([]),
      'laps_enabled': const PropertyValue.boolean(false),
      'ms_sql_services': const PropertyValue.objectList([]),
      'last_logon': PropertyValue.string(''),
      'local_admin_access': const PropertyValue.boolean(false),
      'domain_admin_sessions': const PropertyValue.stringList([]),
      'certificate_services': const PropertyValue.boolean(false),
      'sccm_client': const PropertyValue.boolean(false),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.adComputer,
      projectId: projectId,
      name: '$hostname.$domainName',
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['ad', 'computer'],
    );
  }

  static Asset createCertificateAuthority({
    required String projectId,
    required String caName,
    required String caServer,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'ca_name': PropertyValue.string(caName),
      'ca_server': PropertyValue.string(caServer),
      'web_enrollment_enabled': const PropertyValue.boolean(false),
      'template_list': const PropertyValue.stringList([]),
      'vulnerable_templates': const PropertyValue.stringList([]),
      'ca_permissions': const PropertyValue.objectList([]),
      'pki_objects': const PropertyValue.objectList([]),
      'ca_certificate': PropertyValue.string(''),
      'ca_private_key_accessible': const PropertyValue.boolean(false),
      'esc8_vulnerable': const PropertyValue.boolean(false),
      'esc11_vulnerable': const PropertyValue.boolean(false),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.certificateAuthority,
      projectId: projectId,
      name: caName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['ad', 'adcs', 'ca'],
    );
  }

  static Asset createSccmServer({
    required String projectId,
    required String serverHostname,
    required String siteCode,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'server_hostname': PropertyValue.string(serverHostname),
      'management_point': PropertyValue.string(serverHostname),
      'distribution_points': const PropertyValue.stringList([]),
      'site_code': PropertyValue.string(siteCode),
      'site_systems': const PropertyValue.stringList([]),
      'sql_server': PropertyValue.string(''),
      'pxe_enabled': const PropertyValue.boolean(false),
      'client_push_enabled': const PropertyValue.boolean(false),
      'automatic_client_push': const PropertyValue.boolean(false),
      'network_access_account': PropertyValue.string(''),
      'naa_credentials_extracted': const PropertyValue.boolean(false),
      'admin_access': const PropertyValue.boolean(false),
      'device_collection_access': const PropertyValue.boolean(false),
      'vulnerable_to_relay': const PropertyValue.boolean(false),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.sccmServer,
      projectId: projectId,
      name: '$serverHostname ($siteCode)',
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['sccm', 'server', 'management'],
    );
  }

  // Azure Asset Factory Methods

  static Asset createAzureTenant({
    required String projectId,
    required String tenantId,
    required String tenantName,
    List<String>? domainNames,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'tenant_id': PropertyValue.string(tenantId),
      'tenant_name': PropertyValue.string(tenantName),
      'domain_names': PropertyValue.stringList(domainNames ?? []),
      'directory_type': PropertyValue.string('unknown'),
      'mfa_enabled': const PropertyValue.boolean(false),
      'conditional_access_enabled': const PropertyValue.boolean(false),
      'password_protection_enabled': const PropertyValue.boolean(false),
      'security_defaults_enabled': const PropertyValue.boolean(false),
      'users_enumerated': const PropertyValue.boolean(false),
      'groups_enumerated': const PropertyValue.boolean(false),
      'applications_enumerated': const PropertyValue.boolean(false),
      'privileged_users': const PropertyValue.stringList([]),
      'external_users': const PropertyValue.stringList([]),
      'password_spray_attempted': const PropertyValue.boolean(false),
      'phishing_attempted': const PropertyValue.boolean(false),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureTenant,
      projectId: projectId,
      name: tenantName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['azure', 'tenant'],
    );
  }

  static Asset createAzureSubscription({
    required String projectId,
    required String subscriptionId,
    required String subscriptionName,
    required String tenantId,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'subscription_id': PropertyValue.string(subscriptionId),
      'subscription_name': PropertyValue.string(subscriptionName),
      'tenant_id': PropertyValue.string(tenantId),
      'subscription_type': PropertyValue.string('unknown'),
      'state': PropertyValue.string('unknown'),
      'owner_principals': const PropertyValue.stringList([]),
      'contributor_principals': const PropertyValue.stringList([]),
      'resource_groups': const PropertyValue.stringList([]),
      'key_vaults': const PropertyValue.stringList([]),
      'storage_accounts': const PropertyValue.stringList([]),
      'virtual_machines': const PropertyValue.stringList([]),
      'web_apps': const PropertyValue.stringList([]),
      'cost_management_access': const PropertyValue.boolean(false),
      'security_center_enabled': const PropertyValue.boolean(false),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureSubscription,
      projectId: projectId,
      name: subscriptionName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['azure', 'subscription'],
    );
  }

  static Asset createAzureStorageAccount({
    required String projectId,
    required String accountName,
    required String resourceGroup,
    required String subscriptionId,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'account_name': PropertyValue.string(accountName),
      'resource_group': PropertyValue.string(resourceGroup),
      'subscription_id': PropertyValue.string(subscriptionId),
      'location': PropertyValue.string('unknown'),
      'account_type': PropertyValue.string('unknown'),
      'access_tier': PropertyValue.string('unknown'),
      'allow_blob_public_access': const PropertyValue.boolean(false),
      'requires_secure_transfer': const PropertyValue.boolean(true),
      'min_tls_version': PropertyValue.string('TLS1_2'),
      'containers': const PropertyValue.objectList([]),
      'file_shares': const PropertyValue.objectList([]),
      'access_keys': const PropertyValue.stringList([]),
      'connection_strings': const PropertyValue.stringList([]),
      'sensitive_data_found': const PropertyValue.objectList([]),
      'anonymous_access_containers': const PropertyValue.stringList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureStorageAccount,
      projectId: projectId,
      name: accountName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['azure', 'storage'],
    );
  }

  static Asset createAzureVirtualMachine({
    required String projectId,
    required String vmName,
    required String resourceGroup,
    required String subscriptionId,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'vm_name': PropertyValue.string(vmName),
      'resource_group': PropertyValue.string(resourceGroup),
      'subscription_id': PropertyValue.string(subscriptionId),
      'vm_size': PropertyValue.string('unknown'),
      'os_type': PropertyValue.string('unknown'),
      'os_version': PropertyValue.string('unknown'),
      'public_ip': PropertyValue.string(''),
      'private_ip': PropertyValue.string(''),
      'network_security_group': PropertyValue.string(''),
      'open_ports': const PropertyValue.stringList([]),
      'extensions_installed': const PropertyValue.stringList([]),
      'managed_identity': PropertyValue.string(''),
      'boot_diagnostics_enabled': const PropertyValue.boolean(false),
      'antimalware_enabled': const PropertyValue.boolean(false),
      'backup_enabled': const PropertyValue.boolean(false),
      'vm_agent_status': PropertyValue.string('unknown'),
      'admin_credentials': const PropertyValue.objectList([]),
      'lateral_movement_potential': const PropertyValue.boolean(false),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureVirtualMachine,
      projectId: projectId,
      name: vmName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['azure', 'vm', 'compute'],
    );
  }

  static Asset createAzureKeyVault({
    required String projectId,
    required String vaultName,
    required String resourceGroup,
    required String subscriptionId,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'vault_name': PropertyValue.string(vaultName),
      'resource_group': PropertyValue.string(resourceGroup),
      'subscription_id': PropertyValue.string(subscriptionId),
      'vault_uri': PropertyValue.string('https://$vaultName.vault.azure.net/'),
      'location': PropertyValue.string('unknown'),
      'access_policies': const PropertyValue.objectList([]),
      'network_acls': PropertyValue.map({}),
      'rbac_enabled': const PropertyValue.boolean(false),
      'soft_delete_enabled': const PropertyValue.boolean(true),
      'purge_protection_enabled': const PropertyValue.boolean(false),
      'secrets': const PropertyValue.objectList([]),
      'keys': const PropertyValue.objectList([]),
      'certificates': const PropertyValue.objectList([]),
      'accessible_secrets': const PropertyValue.objectList([]),
      'certificate_private_keys': const PropertyValue.objectList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureKeyVault,
      projectId: projectId,
      name: vaultName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['azure', 'keyvault', 'security'],
    );
  }

  static Asset createAzureWebApp({
    required String projectId,
    required String appName,
    required String resourceGroup,
    required String subscriptionId,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'app_name': PropertyValue.string(appName),
      'resource_group': PropertyValue.string(resourceGroup),
      'subscription_id': PropertyValue.string(subscriptionId),
      'app_service_plan': PropertyValue.string(''),
      'site_url': PropertyValue.string('https://$appName.azurewebsites.net'),
      'runtime_stack': PropertyValue.string('unknown'),
      'scm_site_url': PropertyValue.string('https://$appName.scm.azurewebsites.net'),
      'https_only': const PropertyValue.boolean(false),
      'client_affinity_enabled': const PropertyValue.boolean(false),
      'authentication_enabled': const PropertyValue.boolean(false),
      'identity_provider': PropertyValue.string(''),
      'app_settings': PropertyValue.map({}),
      'connection_strings': PropertyValue.map({}),
      'deployment_credentials': const PropertyValue.objectList([]),
      'scm_credentials': const PropertyValue.objectList([]),
      'source_control': PropertyValue.string(''),
      'custom_domains': const PropertyValue.stringList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureWebApp,
      projectId: projectId,
      name: appName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['azure', 'webapp', 'web'],
    );
  }

  static Asset createAzureFunctionApp({
    required String projectId,
    required String functionAppName,
    required String resourceGroup,
    required String subscriptionId,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'function_app_name': PropertyValue.string(functionAppName),
      'resource_group': PropertyValue.string(resourceGroup),
      'subscription_id': PropertyValue.string(subscriptionId),
      'runtime': PropertyValue.string('unknown'),
      'functions': const PropertyValue.objectList([]),
      'consumption_plan': const PropertyValue.boolean(true),
      'storage_account': PropertyValue.string(''),
      'app_insights_enabled': const PropertyValue.boolean(false),
      'identity_enabled': const PropertyValue.boolean(false),
      'cors_settings': PropertyValue.map({}),
      'host_keys': const PropertyValue.objectList([]),
      'function_keys': const PropertyValue.objectList([]),
      'deployment_source': PropertyValue.string(''),
      'environment_variables': PropertyValue.map({}),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureFunctionApp,
      projectId: projectId,
      name: functionAppName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['azure', 'functions', 'serverless'],
    );
  }

  static Asset createAzureServicePrincipal({
    required String projectId,
    required String applicationId,
    required String displayName,
    required String tenantId,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'application_id': PropertyValue.string(applicationId),
      'object_id': PropertyValue.string(''),
      'display_name': PropertyValue.string(displayName),
      'tenant_id': PropertyValue.string(tenantId),
      'app_roles': const PropertyValue.objectList([]),
      'oauth2_permissions': const PropertyValue.objectList([]),
      'key_credentials': const PropertyValue.objectList([]),
      'password_credentials': const PropertyValue.objectList([]),
      'required_resource_access': const PropertyValue.objectList([]),
      'sign_in_audience': PropertyValue.string('AzureADMyOrg'),
      'reply_urls': const PropertyValue.stringList([]),
      'homepage': PropertyValue.string(''),
      'certificates': const PropertyValue.objectList([]),
      'secrets': const PropertyValue.objectList([]),
      'assigned_roles': const PropertyValue.objectList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureServicePrincipal,
      projectId: projectId,
      name: displayName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['azure', 'service-principal', 'identity'],
    );
  }

  static Asset createAzureManagedIdentity({
    required String projectId,
    required String identityName,
    required String identityType,
    required String subscriptionId,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'identity_name': PropertyValue.string(identityName),
      'identity_type': PropertyValue.string(identityType),
      'resource_group': PropertyValue.string(''),
      'subscription_id': PropertyValue.string(subscriptionId),
      'principal_id': PropertyValue.string(''),
      'tenant_id': PropertyValue.string(''),
      'associated_resources': const PropertyValue.stringList([]),
      'assigned_roles': const PropertyValue.objectList([]),
      'access_token': PropertyValue.string(''),
      'access_token_expiry': PropertyValue.string(''),
      'accessible_resources': const PropertyValue.objectList([]),
      'privilege_escalation_paths': const PropertyValue.objectList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureManagedIdentity,
      projectId: projectId,
      name: identityName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['azure', 'managed-identity', 'identity'],
    );
  }

  static Asset createAzureDevOpsOrganization({
    required String projectId,
    required String organizationName,
    required String organizationUrl,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'organization_name': PropertyValue.string(organizationName),
      'organization_url': PropertyValue.string(organizationUrl),
      'projects': const PropertyValue.objectList([]),
      'users': const PropertyValue.objectList([]),
      'service_connections': const PropertyValue.objectList([]),
      'variable_groups': const PropertyValue.objectList([]),
      'build_definitions': const PropertyValue.objectList([]),
      'release_definitions': const PropertyValue.objectList([]),
      'repositories': const PropertyValue.objectList([]),
      'artifacts': const PropertyValue.objectList([]),
      'personal_access_tokens': const PropertyValue.stringList([]),
      'sensitive_variables': const PropertyValue.objectList([]),
      'source_code_access': const PropertyValue.boolean(false),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureDevOpsOrganization,
      projectId: projectId,
      name: organizationName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['azure', 'devops', 'organization'],
    );
  }

  static Asset createAzureSqlDatabase({
    required String projectId,
    required String serverName,
    required String databaseName,
    required String resourceGroup,
    required String subscriptionId,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'server_name': PropertyValue.string(serverName),
      'database_name': PropertyValue.string(databaseName),
      'resource_group': PropertyValue.string(resourceGroup),
      'subscription_id': PropertyValue.string(subscriptionId),
      'server_fqdn': PropertyValue.string('$serverName.database.windows.net'),
      'sql_version': PropertyValue.string('unknown'),
      'pricing_tier': PropertyValue.string('unknown'),
      'firewall_rules': const PropertyValue.objectList([]),
      'azure_services_access': const PropertyValue.boolean(false),
      'aad_authentication': const PropertyValue.boolean(false),
      'aad_admin': PropertyValue.string(''),
      'transparent_data_encryption': const PropertyValue.boolean(false),
      'auditing_enabled': const PropertyValue.boolean(false),
      'threat_detection_enabled': const PropertyValue.boolean(false),
      'database_users': const PropertyValue.stringList([]),
      'accessible_databases': const PropertyValue.stringList([]),
      'sensitive_tables': const PropertyValue.objectList([]),
      'sql_injection_tested': const PropertyValue.boolean(false),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureSqlDatabase,
      projectId: projectId,
      name: '$serverName/$databaseName',
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['azure', 'sql', 'database'],
    );
  }

  static Asset createAzureContainerRegistry({
    required String projectId,
    required String registryName,
    required String resourceGroup,
    required String subscriptionId,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'registry_name': PropertyValue.string(registryName),
      'resource_group': PropertyValue.string(resourceGroup),
      'subscription_id': PropertyValue.string(subscriptionId),
      'login_server': PropertyValue.string('$registryName.azurecr.io'),
      'sku': PropertyValue.string('Basic'),
      'admin_enabled': const PropertyValue.boolean(false),
      'public_network_access': PropertyValue.string('Enabled'),
      'repositories': const PropertyValue.objectList([]),
      'webhooks': const PropertyValue.objectList([]),
      'replications': const PropertyValue.stringList([]),
      'admin_credentials': const PropertyValue.objectList([]),
      'vulnerable_images': const PropertyValue.objectList([]),
      'exposed_secrets': const PropertyValue.objectList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureContainerRegistry,
      projectId: projectId,
      name: registryName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['azure', 'acr', 'containers'],
    );
  }

  static Asset createAzureLogicApp({
    required String projectId,
    required String logicAppName,
    required String resourceGroup,
    required String subscriptionId,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'logic_app_name': PropertyValue.string(logicAppName),
      'resource_group': PropertyValue.string(resourceGroup),
      'subscription_id': PropertyValue.string(subscriptionId),
      'state': PropertyValue.string('Enabled'),
      'location': PropertyValue.string('unknown'),
      'triggers': const PropertyValue.objectList([]),
      'actions': const PropertyValue.objectList([]),
      'connections': const PropertyValue.objectList([]),
      'run_history': const PropertyValue.objectList([]),
      'parameters': PropertyValue.map({}),
      'integration_service_environment': PropertyValue.string(''),
      'managed_identity': PropertyValue.string(''),
      'accessible_data': const PropertyValue.objectList([]),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureLogicApp,
      projectId: projectId,
      name: logicAppName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['azure', 'logic-app', 'workflow'],
    );
  }

  static Asset createAzureAutomationAccount({
    required String projectId,
    required String automationAccountName,
    required String resourceGroup,
    required String subscriptionId,
    Map<String, PropertyValue>? additionalProperties,
  }) {
    final properties = <String, PropertyValue>{
      'automation_account_name': PropertyValue.string(automationAccountName),
      'resource_group': PropertyValue.string(resourceGroup),
      'subscription_id': PropertyValue.string(subscriptionId),
      'location': PropertyValue.string('unknown'),
      'runbooks': const PropertyValue.objectList([]),
      'modules': const PropertyValue.objectList([]),
      'variables': const PropertyValue.objectList([]),
      'credentials': const PropertyValue.objectList([]),
      'certificates': const PropertyValue.objectList([]),
      'connections': const PropertyValue.objectList([]),
      'schedules': const PropertyValue.objectList([]),
      'webhooks': const PropertyValue.objectList([]),
      'hybrid_worker_groups': const PropertyValue.stringList([]),
      'retrieved_credentials': const PropertyValue.objectList([]),
      'powershell_execution': const PropertyValue.boolean(false),
      if (additionalProperties != null) ...additionalProperties,
    };

    return Asset(
      id: _uuid.v4(),
      type: AssetType.azureAutomationAccount,
      projectId: projectId,
      name: automationAccountName,
      properties: properties,
      completedTriggers: [],
      triggerResults: {},
      parentAssetIds: [],
      childAssetIds: [],
      discoveredAt: DateTime.now(),
      tags: ['azure', 'automation', 'runbooks'],
    );
  }
}

// Extension methods for easier property access
extension AssetPropertyExtensions on Asset {
  T? getProperty<T>(String key) {
    final prop = properties[key];
    if (prop == null) return null;

    return prop.when(
      string: (v) => v as T,
      integer: (v) => v as T,
      boolean: (v) => v as T,
      stringList: (v) => v as T,
      map: (v) => v as T,
      objectList: (v) => v as T,
    );
  }

  bool hasProperty(String key) => properties.containsKey(key);

  Asset updateProperty(String key, PropertyValue value) {
    return copyWith(
      properties: {...properties, key: value},
      lastUpdated: DateTime.now(),
    );
  }

  Asset updateProperties(Map<String, PropertyValue> updates) {
    return copyWith(
      properties: {...properties, ...updates},
      lastUpdated: DateTime.now(),
    );
  }

  bool hasTriggerCompleted(String deduplicationKey) {
    return completedTriggers.contains(deduplicationKey);
  }

  Asset markTriggerCompleted(String deduplicationKey, TriggerResult result) {
    return copyWith(
      completedTriggers: [...completedTriggers, deduplicationKey],
      triggerResults: {...triggerResults, deduplicationKey: result},
      lastUpdated: DateTime.now(),
    );
  }
}