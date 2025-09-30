/// Critical Asset Property Definitions
///
/// This file defines comprehensive property schemas for critical asset types
/// used in penetration testing and security assessments.

class CriticalAssetProperties {

  /// WebApplication properties - comprehensive for modern web apps
  static const webApplicationProperties = {
    // Basic Information
    'base_url': 'string',
    'domain': 'string',
    'ip_addresses': 'stringList',
    'ports': 'stringList',
    'protocol': 'string',                    // http, https

    // Technology Stack
    'web_server': 'string',                  // Apache, Nginx, IIS
    'application_server': 'string',          // Tomcat, Node.js, etc
    'framework': 'string',                   // Laravel, Django, React, Angular
    'framework_version': 'string',
    'programming_language': 'string',
    'language_version': 'string',
    'database_backend': 'string',
    'cms': 'string',                        // WordPress, Drupal, Joomla
    'cms_version': 'string',
    'technology_stack': 'stringList',

    // Authentication & Authorization
    'authentication_type': 'stringList',     // Forms, OAuth, SAML, MFA, None
    'oauth_provider': 'string',
    'saml_provider': 'string',
    'session_management': 'string',          // Cookie, JWT, Server-side
    'session_cookie_name': 'string',
    'mfa_enabled': 'boolean',
    'sso_enabled': 'boolean',
    'password_policy': 'objectList',

    // Security Features
    'waf_present': 'boolean',
    'waf_vendor': 'string',                  // Cloudflare, Akamai, AWS WAF
    'waf_bypassed': 'boolean',
    'cors_policy': 'string',
    'csp_header': 'string',
    'security_headers': 'objectList',
    'https_enforced': 'boolean',
    'hsts_enabled': 'boolean',
    'certificate_info': 'string',            // Reference to certificate asset

    // Application Structure
    'api_endpoints': 'objectList',           // References to API assets
    'admin_panels': 'objectList',
    'upload_points': 'objectList',
    'forms': 'objectList',
    'parameters': 'objectList',
    'cookies': 'objectList',
    'local_storage_keys': 'stringList',
    'subdomains': 'stringList',
    'directories': 'objectList',
    'files': 'objectList',
    'backup_files': 'stringList',

    // CMS Specific
    'plugins': 'objectList',                 // {name, version, vulnerable}
    'themes': 'objectList',
    'users': 'objectList',
    'admin_users': 'stringList',

    // Vulnerabilities
    'vulnerabilities': 'objectList',
    'cve_list': 'stringList',
    'owasp_top_10': 'objectList',
    'vulnerability_score': 'double',

    // Testing Status
    'last_tested': 'dateTime',
    'test_coverage': 'string',               // Full, Partial, None
    'authenticated_testing': 'boolean',
    'test_accounts': 'objectList',
  };

  /// API Endpoint properties - detailed for REST/GraphQL/SOAP
  static const apiEndpointProperties = {
    // Basic Information
    'endpoint_url': 'string',
    'base_path': 'string',
    'full_path': 'string',
    'methods': 'stringList',                 // GET, POST, PUT, DELETE, PATCH
    'api_type': 'string',                    // REST, GraphQL, SOAP, gRPC, WebSocket
    'api_version': 'string',
    'deprecated': 'boolean',

    // Authentication
    'authentication_required': 'boolean',
    'authentication_type': 'stringList',     // Bearer, API Key, OAuth, Basic, Certificate
    'api_key_location': 'string',           // Header, Query, Cookie
    'api_key_name': 'string',
    'oauth_scopes': 'stringList',
    'requires_mfa': 'boolean',

    // Rate Limiting & Throttling
    'rate_limited': 'boolean',
    'rate_limit': 'integer',
    'rate_limit_window': 'integer',         // Seconds
    'throttling_enabled': 'boolean',
    'bypass_possible': 'boolean',

    // Request/Response
    'content_types': 'stringList',          // application/json, text/xml
    'accepts': 'stringList',
    'parameters': 'objectList',             // {name, type, required, location}
    'headers': 'objectList',
    'request_schema': 'string',             // JSON Schema
    'response_schema': 'string',
    'example_request': 'string',
    'example_response': 'string',

    // Documentation
    'documented': 'boolean',
    'documentation_url': 'string',
    'swagger_url': 'string',
    'postman_collection': 'string',

    // Security
    'input_validation': 'boolean',
    'output_encoding': 'boolean',
    'sql_injection_tested': 'boolean',
    'xxe_tested': 'boolean',
    'idor_tested': 'boolean',
    'vulnerabilities': 'objectList',

    // Permissions
    'required_role': 'string',
    'required_permissions': 'stringList',
    'publicly_accessible': 'boolean',

    // GraphQL Specific
    'graphql_introspection': 'boolean',
    'graphql_queries': 'objectList',
    'graphql_mutations': 'objectList',
    'graphql_subscriptions': 'objectList',

    // SOAP Specific
    'wsdl_url': 'string',
    'soap_actions': 'stringList',
  };

  /// Container properties - comprehensive for Docker/K8s
  static const containerProperties = {
    // Basic Information
    'container_id': 'string',
    'container_name': 'string',
    'image': 'string',
    'image_tag': 'string',
    'image_digest': 'string',
    'registry': 'string',
    'registry_credentials': 'boolean',

    // Orchestration
    'orchestrator': 'string',               // Docker, Kubernetes, ECS, AKS
    'cluster_name': 'string',
    'namespace': 'string',
    'pod_name': 'string',
    'deployment_name': 'string',
    'replica_count': 'integer',

    // Configuration
    'privileged': 'boolean',
    'run_as_root': 'boolean',
    'user': 'string',
    'capabilities_added': 'stringList',
    'capabilities_dropped': 'stringList',
    'security_context': 'objectList',
    'app_armor': 'string',
    'se_linux': 'string',
    'read_only_root': 'boolean',

    // Networking
    'network_mode': 'string',               // bridge, host, none
    'exposed_ports': 'objectList',
    'published_ports': 'objectList',
    'network_policies': 'objectList',
    'service_mesh': 'string',               // Istio, Linkerd

    // Storage
    'volumes': 'objectList',
    'volume_mounts': 'objectList',
    'persistent_volumes': 'objectList',
    'host_path_volumes': 'stringList',
    'config_maps': 'stringList',
    'secrets_mounted': 'stringList',

    // Environment
    'environment_variables': 'objectList',
    'sensitive_env_vars': 'stringList',     // Passwords, API keys in env

    // Kubernetes Specific
    'service_account': 'string',
    'automount_service_token': 'boolean',
    'rbac_permissions': 'objectList',
    'network_policies_applied': 'stringList',
    'pod_security_policy': 'string',

    // Security Issues
    'escape_possible': 'boolean',
    'escape_method': 'string',
    'vulnerable_packages': 'objectList',
    'cve_list': 'stringList',
    'trivy_scan_results': 'objectList',
    'dockerfile_issues': 'objectList',
  };

  /// Certificate properties - comprehensive SSL/TLS analysis
  static const certificateProperties = {
    // Basic Information
    'cert_type': 'string',                  // SSL, Code Signing, Client, CA
    'fingerprint_sha256': 'string',
    'fingerprint_sha1': 'string',
    'serial_number': 'string',

    // Subject Information
    'subject_cn': 'string',
    'subject_o': 'string',                  // Organization
    'subject_ou': 'string',                 // Organizational Unit
    'subject_c': 'string',                  // Country
    'subject_st': 'string',                 // State
    'subject_l': 'string',                  // Locality
    'subject_email': 'string',
    'san_names': 'stringList',              // Subject Alternative Names

    // Issuer Information
    'issuer_cn': 'string',
    'issuer_o': 'string',
    'issuer_ca': 'boolean',
    'self_signed': 'boolean',
    'ca_certificate': 'boolean',

    // Validity
    'valid_from': 'dateTime',
    'valid_to': 'dateTime',
    'days_remaining': 'integer',
    'expired': 'boolean',
    'not_yet_valid': 'boolean',

    // Technical Details
    'version': 'integer',
    'signature_algorithm': 'string',
    'weak_signature': 'boolean',
    'public_key_algorithm': 'string',
    'key_size': 'integer',
    'weak_key': 'boolean',                  // < 2048 RSA or < 256 ECC
    'debian_weak_key': 'boolean',

    // Chain Information
    'chain_complete': 'boolean',
    'chain_valid': 'boolean',
    'chain_certificates': 'stringList',     // Asset IDs of chain certs
    'root_ca': 'string',
    'intermediate_cas': 'stringList',

    // Features
    'wildcard': 'boolean',
    'ev_certificate': 'boolean',            // Extended Validation
    'ct_logged': 'boolean',                 // Certificate Transparency
    'must_staple': 'boolean',               // OCSP Must-Staple
    'key_usage': 'stringList',
    'extended_key_usage': 'stringList',

    // Validation Status
    'revoked': 'boolean',
    'revocation_date': 'dateTime',
    'revocation_reason': 'string',
    'ocsp_response': 'string',
    'crl_checked': 'boolean',

    // Security Issues
    'vulnerabilities': 'objectList',
    'heartbleed_vulnerable': 'boolean',
    'private_key_compromised': 'boolean',
    'known_weak': 'boolean',
    'compliance_issues': 'stringList',
  };

  /// DNS Record properties
  static const dnsRecordProperties = {
    'record_name': 'string',
    'record_type': 'string',               // A, AAAA, CNAME, MX, TXT, etc.
    'record_value': 'string',
    'ttl': 'integer',
    'nameserver': 'string',
    'dnssec_enabled': 'boolean',
    'wildcard': 'boolean',
    'subdomain_takeover_risk': 'boolean',
  };

  /// Email properties
  static const emailProperties = {
    'email_address': 'string',
    'domain': 'string',
    'validated': 'boolean',
    'deliverable': 'boolean',
    'role_account': 'boolean',             // admin@, info@, etc.
    'mx_records': 'stringList',
    'spf_record': 'string',
    'dmarc_record': 'string',
    'dkim_configured': 'boolean',
    'breached': 'boolean',
    'breach_sources': 'stringList',
  };
}
