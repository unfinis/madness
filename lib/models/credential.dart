enum CredentialType {
  user,
  admin,
  service,
  hash,
}

enum CredentialStatus {
  valid,
  invalid,
  untested,
}

enum CredentialPrivilege {
  user,
  localAdmin,
  domainAdmin,
  serviceAccount,
  system,
}

enum CredentialSource {
  clientProvided,
  defaultCredentials,
  passwordSpray,
  kerberoasting,
  asreproasting,
  smbShare,
  ftpShare,
  coerced,
  domainDump,
  credentialDump,
  hashDump,
  configFile,
}

class Credential {
  final String id;
  final String username;
  final String? password;
  final String? hash;
  final CredentialType type;
  final CredentialStatus status;
  final CredentialPrivilege privilege;
  final CredentialSource source;
  final String target;
  final DateTime dateAdded;
  final DateTime? lastTested;
  final String? notes;
  final String? domain;

  Credential({
    required this.id,
    required this.username,
    this.password,
    this.hash,
    required this.type,
    required this.status,
    required this.privilege,
    required this.source,
    required this.target,
    required this.dateAdded,
    this.lastTested,
    this.notes,
    this.domain,
  });

  Credential copyWith({
    String? id,
    String? username,
    String? password,
    String? hash,
    CredentialType? type,
    CredentialStatus? status,
    CredentialPrivilege? privilege,
    CredentialSource? source,
    String? target,
    DateTime? dateAdded,
    DateTime? lastTested,
    String? notes,
    String? domain,
  }) {
    return Credential(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      hash: hash ?? this.hash,
      type: type ?? this.type,
      status: status ?? this.status,
      privilege: privilege ?? this.privilege,
      source: source ?? this.source,
      target: target ?? this.target,
      dateAdded: dateAdded ?? this.dateAdded,
      lastTested: lastTested ?? this.lastTested,
      notes: notes ?? this.notes,
      domain: domain ?? this.domain,
    );
  }
}

extension CredentialTypeExtension on CredentialType {
  String get displayName {
    switch (this) {
      case CredentialType.user:
        return 'User Account';
      case CredentialType.admin:
        return 'Admin Account';
      case CredentialType.service:
        return 'Service Account';
      case CredentialType.hash:
        return 'Hash';
    }
  }

  String get icon {
    switch (this) {
      case CredentialType.user:
        return '👤';
      case CredentialType.admin:
        return '👑';
      case CredentialType.service:
        return '⚙️';
      case CredentialType.hash:
        return '🔐';
    }
  }
}

extension CredentialStatusExtension on CredentialStatus {
  String get displayName {
    switch (this) {
      case CredentialStatus.valid:
        return 'Valid';
      case CredentialStatus.invalid:
        return 'Invalid';
      case CredentialStatus.untested:
        return 'Untested';
    }
  }

  String get icon {
    switch (this) {
      case CredentialStatus.valid:
        return '✅';
      case CredentialStatus.invalid:
        return '❌';
      case CredentialStatus.untested:
        return '❓';
    }
  }
}

extension CredentialPrivilegeExtension on CredentialPrivilege {
  String get displayName {
    switch (this) {
      case CredentialPrivilege.user:
        return 'User';
      case CredentialPrivilege.localAdmin:
        return 'Local Admin';
      case CredentialPrivilege.domainAdmin:
        return 'Domain Admin';
      case CredentialPrivilege.serviceAccount:
        return 'Service Account';
      case CredentialPrivilege.system:
        return 'System';
    }
  }

  bool get isCritical {
    return this == CredentialPrivilege.domainAdmin || this == CredentialPrivilege.system;
  }
}

extension CredentialSourceExtension on CredentialSource {
  String get displayName {
    switch (this) {
      case CredentialSource.clientProvided:
        return 'Client Provided';
      case CredentialSource.defaultCredentials:
        return 'Default Credentials';
      case CredentialSource.passwordSpray:
        return 'Password Spray';
      case CredentialSource.kerberoasting:
        return 'Kerberoasting';
      case CredentialSource.asreproasting:
        return 'ASREPRoasting';
      case CredentialSource.smbShare:
        return 'SMB Share';
      case CredentialSource.ftpShare:
        return 'FTP Share';
      case CredentialSource.coerced:
        return 'NTLM Coercion';
      case CredentialSource.domainDump:
        return 'Domain Dump';
      case CredentialSource.credentialDump:
        return 'Credential Dump';
      case CredentialSource.hashDump:
        return 'Hash Dump';
      case CredentialSource.configFile:
        return 'Configuration File';
    }
  }
}