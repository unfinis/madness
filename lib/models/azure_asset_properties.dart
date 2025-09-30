/// Azure Resource Property Definitions
///
/// Comprehensive property schemas for Azure cloud resources
/// used in cloud penetration testing and security assessments.

class AzureAssetProperties {

  /// Base Azure Resource properties (inherited by all Azure types)
  static const azureResourceBase = {
    'resource_id': 'string',                // Full Azure Resource ID
    'resource_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'subscription_name': 'string',
    'tenant_id': 'string',
    'location': 'string',                   // Region
    'tags': 'objectList',
    'created_time': 'dateTime',
    'created_by': 'string',
    'modified_time': 'dateTime',
    'modified_by': 'string',
    'managed_by': 'string',
    'sku': 'string',
    'kind': 'string',
    'provisioning_state': 'string',
  };

  /// Azure Virtual Machine properties
  static const azureVMProperties = {
    // Include base properties
    'resource_id': 'string',
    'resource_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'subscription_name': 'string',
    'tenant_id': 'string',
    'location': 'string',
    'tags': 'objectList',
    'created_time': 'dateTime',
    'created_by': 'string',
    'modified_time': 'dateTime',
    'modified_by': 'string',
    'managed_by': 'string',
    'sku': 'string',
    'kind': 'string',
    'provisioning_state': 'string',

    // VM Specific
    'vm_id': 'string',
    'vm_size': 'string',                    // Standard_D2s_v3, etc
    'os_type': 'string',                    // Windows, Linux
    'os_name': 'string',
    'os_version': 'string',
    'computer_name': 'string',
    'admin_username': 'string',
    'domain_joined': 'boolean',
    'domain_name': 'string',

    // Compute
    'power_state': 'string',                // Running, Stopped, Deallocated
    'availability_set': 'string',
    'availability_zone': 'string',
    'proximity_placement_group': 'string',
    'host_id': 'string',
    'host_group': 'string',

    // Networking
    'private_ip_addresses': 'stringList',
    'public_ip_addresses': 'stringList',
    'fqdn': 'string',
    'network_interfaces': 'objectList',
    'nsg_rules': 'objectList',
    'application_security_groups': 'stringList',
    'load_balancer_backends': 'stringList',
    'accelerated_networking': 'boolean',

    // Storage
    'os_disk': 'objectList',
    'data_disks': 'objectList',
    'disk_encryption_enabled': 'boolean',
    'disk_encryption_type': 'string',       // Platform, Customer, Both
    'temp_disk': 'boolean',
    'ultra_ssd_enabled': 'boolean',

    // Security
    'managed_identity_enabled': 'boolean',
    'system_assigned_identity': 'string',   // Object ID
    'user_assigned_identities': 'stringList',
    'boot_diagnostics': 'boolean',
    'guest_configuration': 'objectList',
    'patch_status': 'string',
    'update_management': 'boolean',
    'antimalware_enabled': 'boolean',
    'encryption_at_host': 'boolean',
    'secure_boot': 'boolean',
    'vtpm': 'boolean',

    // Extensions
    'extensions': 'objectList',
    'custom_script_extension': 'boolean',
    'monitoring_agent': 'boolean',
    'backup_enabled': 'boolean',
    'backup_policy': 'string',

    // Access
    'ssh_public_keys': 'stringList',
    'rdp_enabled': 'boolean',
    'ssh_enabled': 'boolean',
    'bastion_connected': 'boolean',
    'just_in_time_enabled': 'boolean',
    'run_command_enabled': 'boolean',
    'serial_console_enabled': 'boolean',

    // Vulnerabilities
    'missing_patches': 'objectList',
    'vulnerability_findings': 'objectList',
    'compliance_issues': 'objectList',
  };

  /// Azure Storage Account properties
  static const azureStorageAccountProperties = {
    // Base properties
    'resource_id': 'string',
    'resource_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'subscription_name': 'string',
    'tenant_id': 'string',
    'location': 'string',
    'tags': 'objectList',
    'created_time': 'dateTime',
    'created_by': 'string',
    'modified_time': 'dateTime',
    'modified_by': 'string',
    'managed_by': 'string',
    'sku': 'string',
    'kind': 'string',
    'provisioning_state': 'string',

    // Storage Account Specific
    'account_kind': 'string',               // StorageV2, BlobStorage, FileStorage
    'account_tier': 'string',               // Standard, Premium
    'replication': 'string',                // LRS, ZRS, GRS, RA-GRS
    'access_tier': 'string',                // Hot, Cool, Archive

    // Endpoints
    'blob_endpoint': 'string',
    'file_endpoint': 'string',
    'table_endpoint': 'string',
    'queue_endpoint': 'string',
    'dfs_endpoint': 'string',               // Data Lake
    'web_endpoint': 'string',               // Static website
    'primary_endpoints': 'objectList',
    'secondary_endpoints': 'objectList',

    // Security - Network
    'public_access_enabled': 'boolean',
    'public_network_access': 'string',      // Enabled, Disabled
    'allowed_ip_ranges': 'stringList',
    'virtual_network_rules': 'objectList',
    'private_endpoints': 'objectList',
    'firewall_bypass': 'stringList',
    'default_action': 'string',             // Allow, Deny

    // Security - Encryption
    'encryption_services': 'objectList',
    'encryption_key_source': 'string',      // Microsoft, Customer
    'customer_managed_key': 'string',
    'infrastructure_encryption': 'boolean',
    'require_encrypted_transfer': 'boolean',
    'tls_version': 'string',

    // Security - Access
    'shared_key_access': 'boolean',
    'sas_policies': 'objectList',
    'stored_access_policies': 'objectList',
    'ad_authentication': 'boolean',
    'rbac_enabled': 'boolean',
    'acl_enabled': 'boolean',
    'anonymous_access_level': 'string',     // Private, Blob, Container

    // Blob Specific
    'blob_soft_delete': 'boolean',
    'blob_retention_days': 'integer',
    'container_soft_delete': 'boolean',
    'versioning_enabled': 'boolean',
    'change_feed_enabled': 'boolean',
    'point_in_time_restore': 'boolean',
    'immutability_policy': 'boolean',
    'legal_hold': 'boolean',

    // Containers/Shares/Tables/Queues
    'containers': 'objectList',
    'file_shares': 'objectList',
    'tables': 'objectList',
    'queues': 'objectList',

    // Data Lake
    'hierarchical_namespace': 'boolean',
    'sftp_enabled': 'boolean',
    'nfs_enabled': 'boolean',

    // Monitoring
    'diagnostic_settings': 'objectList',
    'metrics_enabled': 'boolean',
    'logging_enabled': 'boolean',
    'log_analytics_workspace': 'string',

    // Discovered Issues
    'public_containers': 'objectList',
    'public_blobs': 'objectList',
    'sas_tokens_found': 'objectList',
    'access_keys_exposed': 'boolean',
    'sensitive_data_found': 'objectList',
  };

  /// Azure Key Vault properties
  static const azureKeyVaultProperties = {
    // Base properties
    'resource_id': 'string',
    'resource_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'subscription_name': 'string',
    'tenant_id': 'string',
    'location': 'string',
    'tags': 'objectList',
    'created_time': 'dateTime',
    'created_by': 'string',
    'modified_time': 'dateTime',
    'modified_by': 'string',
    'managed_by': 'string',
    'sku': 'string',
    'kind': 'string',
    'provisioning_state': 'string',

    // Key Vault Specific
    'vault_uri': 'string',
    'sku_family': 'string',
    'sku_name': 'string',                   // Standard, Premium

    // Access Configuration
    'access_policies': 'objectList',
    'rbac_authorization': 'boolean',
    'enable_soft_delete': 'boolean',
    'soft_delete_retention_days': 'integer',
    'enable_purge_protection': 'boolean',

    // Network Security
    'network_acls': 'objectList',
    'public_network_access': 'string',
    'private_endpoints': 'objectList',
    'firewall_rules': 'objectList',
    'virtual_network_rules': 'objectList',
    'bypass': 'string',                     // AzureServices, None

    // HSM
    'hsm_enabled': 'boolean',
    'hsm_type': 'string',

    // Objects
    'keys': 'objectList',
    'secrets': 'objectList',
    'certificates': 'objectList',

    // Key Properties
    'key_types': 'stringList',              // RSA, EC, RSA-HSM, EC-HSM
    'key_sizes': 'stringList',
    'key_operations': 'stringList',
    'exportable_keys': 'boolean',

    // Secret Properties
    'secret_count': 'integer',
    'expired_secrets': 'objectList',
    'no_expiry_secrets': 'objectList',
    'plaintext_secrets_exposed': 'objectList',

    // Certificate Properties
    'certificate_authorities': 'stringList',
    'expired_certificates': 'objectList',
    'self_signed_certificates': 'objectList',

    // Backup
    'backup_enabled': 'boolean',
    'geo_replication': 'boolean',

    // Compliance
    'fips_validated': 'boolean',
    'compliance_certifications': 'stringList',

    // Vulnerabilities
    'weak_access_policies': 'objectList',
    'overly_permissive': 'boolean',
    'missing_network_restrictions': 'boolean',
  };

  /// Azure SQL Database properties
  static const azureSQLDatabaseProperties = {
    // Base properties
    'resource_id': 'string',
    'resource_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'subscription_name': 'string',
    'tenant_id': 'string',
    'location': 'string',
    'tags': 'objectList',
    'created_time': 'dateTime',
    'created_by': 'string',
    'modified_time': 'dateTime',
    'modified_by': 'string',
    'managed_by': 'string',
    'sku': 'string',
    'kind': 'string',
    'provisioning_state': 'string',

    // Database Specific
    'server_name': 'string',
    'database_name': 'string',
    'edition': 'string',                    // Basic, Standard, Premium
    'service_objective': 'string',
    'elastic_pool': 'string',
    'collation': 'string',
    'max_size_gb': 'double',
    'current_size_gb': 'double',

    // Connection
    'connection_string': 'string',
    'fqdn': 'string',
    'port': 'integer',
    'min_tls_version': 'string',

    // Authentication
    'authentication_type': 'string',        // SQL, AAD, Both
    'aad_admin': 'string',
    'sql_admin': 'string',
    'contained_database_auth': 'boolean',

    // Security
    'transparent_data_encryption': 'boolean',
    'encryption_protector': 'string',
    'always_encrypted': 'boolean',
    'row_level_security': 'boolean',
    'dynamic_data_masking': 'boolean',
    'data_discovery_classification': 'boolean',

    // Network Security
    'public_network_access': 'boolean',
    'firewall_rules': 'objectList',
    'virtual_network_rules': 'objectList',
    'private_endpoints': 'objectList',
    'connection_policy': 'string',          // Default, Proxy, Redirect

    // Auditing
    'auditing_enabled': 'boolean',
    'audit_destination': 'string',
    'threat_detection_enabled': 'boolean',
    'vulnerability_assessment': 'boolean',
    'security_alert_policies': 'objectList',

    // Backup
    'backup_retention_days': 'integer',
    'point_in_time_restore': 'boolean',
    'long_term_backup': 'boolean',
    'geo_replication': 'boolean',
    'failover_group': 'string',

    // Performance
    'compute_tier': 'string',               // Provisioned, Serverless
    'auto_pause_delay': 'integer',
    'zone_redundant': 'boolean',

    // Discovered Issues
    'sql_injection_points': 'objectList',
    'weak_passwords': 'objectList',
    'missing_patches': 'objectList',
    'excessive_permissions': 'objectList',
    'sensitive_data_exposed': 'objectList',
  };

  /// Azure Function App properties
  static const azureFunctionProperties = {
    // Base properties
    'resource_id': 'string',
    'resource_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'subscription_name': 'string',
    'tenant_id': 'string',
    'location': 'string',
    'tags': 'objectList',
    'created_time': 'dateTime',
    'created_by': 'string',
    'modified_time': 'dateTime',
    'modified_by': 'string',
    'managed_by': 'string',
    'sku': 'string',
    'kind': 'string',
    'provisioning_state': 'string',

    // Function App Specific
    'function_app_name': 'string',
    'default_hostname': 'string',
    'runtime': 'string',                    // dotnet, node, python, java
    'runtime_version': 'string',
    'os_type': 'string',                    // Windows, Linux
    'app_service_plan': 'string',
    'consumption_plan': 'boolean',

    // Functions
    'functions': 'objectList',
    'function_count': 'integer',
    'triggers': 'stringList',               // HTTP, Timer, Blob, Queue
    'bindings': 'objectList',

    // Authentication
    'auth_enabled': 'boolean',
    'auth_providers': 'stringList',
    'auth_settings': 'objectList',
    'client_certificates': 'boolean',
    'api_keys': 'objectList',
    'master_key_exposed': 'boolean',

    // Networking
    'inbound_ip_restrictions': 'objectList',
    'scm_ip_restrictions': 'objectList',
    'vnet_integration': 'boolean',
    'hybrid_connections': 'objectList',
    'private_endpoints': 'objectList',
    'cors_settings': 'objectList',

    // Configuration
    'app_settings': 'objectList',
    'connection_strings': 'objectList',
    'managed_identity': 'boolean',
    'key_vault_references': 'objectList',
    'environment_variables': 'objectList',

    // Storage
    'storage_account': 'string',
    'storage_encrypted': 'boolean',
    'files_accessible': 'boolean',

    // Security Issues
    'secrets_in_code': 'objectList',
    'insecure_bindings': 'objectList',
    'command_injection': 'objectList',
    'path_traversal': 'objectList',
    'verbose_errors': 'boolean',
  };

  /// Azure App Service properties
  static const azureAppServiceProperties = {
    // Base properties
    'resource_id': 'string',
    'resource_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'subscription_name': 'string',
    'tenant_id': 'string',
    'location': 'string',
    'tags': 'objectList',
    'created_time': 'dateTime',
    'created_by': 'string',
    'modified_time': 'dateTime',
    'modified_by': 'string',
    'managed_by': 'string',
    'sku': 'string',
    'kind': 'string',
    'provisioning_state': 'string',

    // App Service Specific
    'site_name': 'string',
    'default_hostname': 'string',
    'custom_domains': 'stringList',
    'app_service_plan': 'string',
    'operating_system': 'string',

    // Runtime
    'runtime_stack': 'string',
    'runtime_version': 'string',
    'php_version': 'string',
    'python_version': 'string',
    'node_version': 'string',
    'java_version': 'string',
    'dotnet_version': 'string',

    // Configuration
    'always_on': 'boolean',
    'http20_enabled': 'boolean',
    'min_tls_version': 'string',
    'ftps_state': 'string',
    'remote_debugging': 'boolean',
    'web_sockets': 'boolean',

    // Authentication
    'auth_enabled': 'boolean',
    'auth_providers': 'stringList',
    'client_cert_enabled': 'boolean',
    'client_cert_mode': 'string',

    // Deployment
    'deployment_slots': 'objectList',
    'deployment_sources': 'objectList',
    'scm_site': 'string',
    'ftp_access': 'boolean',
    'git_enabled': 'boolean',
    'local_git_url': 'string',

    // Security Issues
    'directory_browsing': 'boolean',
    'detailed_errors': 'boolean',
    'failed_request_tracing': 'boolean',
    'request_tracing': 'boolean',
    'application_logs': 'boolean',
    'exposed_files': 'objectList',
    'backup_files': 'objectList',
    'source_code_exposed': 'boolean',
  };

  /// Azure AKS (Kubernetes) properties
  static const azureAKSProperties = {
    // Base properties
    'resource_id': 'string',
    'resource_name': 'string',
    'resource_group': 'string',
    'subscription_id': 'string',
    'subscription_name': 'string',
    'tenant_id': 'string',
    'location': 'string',
    'tags': 'objectList',
    'created_time': 'dateTime',
    'created_by': 'string',
    'modified_time': 'dateTime',
    'modified_by': 'string',
    'managed_by': 'string',
    'sku': 'string',
    'kind': 'string',
    'provisioning_state': 'string',

    // AKS Specific
    'cluster_name': 'string',
    'kubernetes_version': 'string',
    'dns_prefix': 'string',
    'fqdn': 'string',
    'node_resource_group': 'string',

    // Node Pools
    'node_pools': 'objectList',
    'node_count': 'integer',
    'vm_sizes': 'stringList',
    'os_types': 'stringList',
    'auto_scaling': 'boolean',
    'availability_zones': 'stringList',

    // Networking
    'network_plugin': 'string',             // kubenet, azure
    'network_policy': 'string',             // calico, azure
    'service_cidr': 'string',
    'dns_service_ip': 'string',
    'pod_cidr': 'string',
    'load_balancer_sku': 'string',
    'outbound_type': 'string',

    // Security
    'rbac_enabled': 'boolean',
    'aad_enabled': 'boolean',
    'azure_rbac': 'boolean',
    'admin_groups': 'stringList',
    'managed_identity': 'boolean',
    'disk_encryption': 'boolean',
    'network_policy_enabled': 'boolean',
    'pod_security_policy': 'boolean',
    'private_cluster': 'boolean',

    // Addons
    'monitoring_enabled': 'boolean',
    'azure_policy_enabled': 'boolean',
    'ingress_controller': 'string',
    'service_mesh': 'string',               // Istio, Linkerd

    // Access
    'api_server_access': 'stringList',
    'authorized_ip_ranges': 'stringList',
    'ssh_public_key': 'string',
    'windows_profile': 'objectList',

    // Vulnerabilities
    'exposed_dashboard': 'boolean',
    'public_api_server': 'boolean',
    'insecure_kubelet': 'boolean',
    'privileged_containers': 'objectList',
    'host_network_pods': 'objectList',
    'default_service_accounts': 'objectList',
  };
}
