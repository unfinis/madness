import 'package:flutter/material.dart';
import '../models/assets.dart';

class AssetTypeSelectorDialog extends StatefulWidget {
  const AssetTypeSelectorDialog({super.key});

  @override
  State<AssetTypeSelectorDialog> createState() => _AssetTypeSelectorDialogState();
}

class _AssetTypeSelectorDialogState extends State<AssetTypeSelectorDialog> {
  AssetType? _selectedType;

  // Organized asset types by category for better UX
  final Map<String, List<AssetTypeInfo>> _assetCategories = {
    'Infrastructure': [
      AssetTypeInfo(
        type: AssetType.environment,
        title: 'Environment',
        description: 'Top-level environment container (e.g., Corporate Network)',
        icon: Icons.business,
        examples: ['Corporate Environment', 'DMZ Environment', 'Cloud Environment'],
      ),
      AssetTypeInfo(
        type: AssetType.physicalSite,
        title: 'Physical Site',
        description: 'Physical location or facility',
        icon: Icons.location_city,
        examples: ['Headquarters', 'Branch Office', 'Data Center'],
      ),
      AssetTypeInfo(
        type: AssetType.networkSegment,
        title: 'Network Segment',
        description: 'Network subnet or VLAN',
        icon: Icons.network_check,
        examples: ['192.168.1.0/24', 'DMZ VLAN 100', 'Guest Network'],
      ),
      AssetTypeInfo(
        type: AssetType.host,
        title: 'Host/Computer',
        description: 'Server, workstation, or device',
        icon: Icons.computer,
        examples: ['Domain Controller', 'Web Server', 'Workstation'],
      ),
      AssetTypeInfo(
        type: AssetType.service,
        title: 'Service',
        description: 'Network service or application',
        icon: Icons.apps,
        examples: ['HTTP (80)', 'SSH (22)', 'LDAP (389)'],
      ),
    ],
    'Identity & Access': [
      AssetTypeInfo(
        type: AssetType.credential,
        title: 'Credential',
        description: 'Username/password or authentication token',
        icon: Icons.key,
        examples: ['admin@domain.com', 'Local Administrator', 'Service Account'],
      ),
      AssetTypeInfo(
        type: AssetType.identity,
        title: 'Identity',
        description: 'User or service identity',
        icon: Icons.person,
        examples: ['Domain User', 'Service Principal', 'Local Account'],
      ),
      AssetTypeInfo(
        type: AssetType.authenticationSystem,
        title: 'Authentication System',
        description: 'Identity provider or authentication service',
        icon: Icons.security,
        examples: ['Active Directory', 'LDAP Server', 'OAuth Provider'],
      ),
      AssetTypeInfo(
        type: AssetType.person,
        title: 'Person',
        description: 'Individual person (for social engineering contexts)',
        icon: Icons.person_outline,
        examples: ['John Smith (IT Admin)', 'CEO', 'Receptionist'],
      ),
    ],
    'Cloud & Azure': [
      AssetTypeInfo(
        type: AssetType.cloudTenant,
        title: 'Cloud Tenant',
        description: 'Cloud subscription or tenant',
        icon: Icons.cloud,
        examples: ['Azure Tenant', 'AWS Account', 'Office 365 Tenant'],
      ),
      AssetTypeInfo(
        type: AssetType.cloudResource,
        title: 'Cloud Resource',
        description: 'Cloud service or resource',
        icon: Icons.cloud_queue,
        examples: ['Azure VM', 'S3 Bucket', 'Azure Storage Account'],
      ),
      AssetTypeInfo(
        type: AssetType.cloudIdentity,
        title: 'Cloud Identity',
        description: 'Cloud-based identity or principal',
        icon: Icons.cloud_circle,
        examples: ['Azure AD User', 'Service Principal', 'IAM Role'],
      ),
    ],
    'Wireless & Network': [
      AssetTypeInfo(
        type: AssetType.wirelessNetwork,
        title: 'Wireless Network',
        description: 'WiFi network or access point',
        icon: Icons.wifi,
        examples: ['Corporate-WiFi', 'Guest Network', 'IoT SSID'],
      ),
      AssetTypeInfo(
        type: AssetType.wirelessClient,
        title: 'Wireless Client',
        description: 'Device connected to wireless network',
        icon: Icons.devices,
        examples: ['Mobile Phone', 'Laptop', 'IoT Device'],
      ),
      AssetTypeInfo(
        type: AssetType.networkDevice,
        title: 'Network Device',
        description: 'Router, switch, or network appliance',
        icon: Icons.router,
        examples: ['Core Router', 'Access Switch', 'Firewall'],
      ),
    ],
    'Data & Files': [
      AssetTypeInfo(
        type: AssetType.file,
        title: 'File',
        description: 'Document, script, or data file',
        icon: Icons.description,
        examples: ['Config File', 'Database Backup', 'Script'],
      ),
      AssetTypeInfo(
        type: AssetType.database,
        title: 'Database',
        description: 'Database server or instance',
        icon: Icons.storage,
        examples: ['SQL Server', 'MySQL Database', 'Oracle DB'],
      ),
      AssetTypeInfo(
        type: AssetType.software,
        title: 'Software',
        description: 'Installed application or tool',
        icon: Icons.extension,
        examples: ['Antivirus Software', 'Backup Tool', 'Custom App'],
      ),
      AssetTypeInfo(
        type: AssetType.certificate,
        title: 'Certificate',
        description: 'Digital certificate or key',
        icon: Icons.verified_user,
        examples: ['SSL Certificate', 'Code Signing Cert', 'CA Certificate'],
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.add_circle_outline, color: Colors.blue),
          SizedBox(width: 8),
          Text('Create New Asset'),
        ],
      ),
      content: SizedBox(
        width: 700,
        height: 600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose the type of asset you want to create:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: DefaultTabController(
                length: _assetCategories.length,
                child: Column(
                  children: [
                    TabBar(
                      isScrollable: true,
                      tabs: _assetCategories.keys.map((category) => Tab(text: category)).toList(),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: TabBarView(
                        children: _assetCategories.entries.map((entry) {
                          return _buildCategoryGrid(entry.key, entry.value);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _selectedType != null
              ? () => Navigator.of(context).pop(_selectedType)
              : null,
          child: const Text('Create Asset'),
        ),
      ],
    );
  }

  Widget _buildCategoryGrid(String category, List<AssetTypeInfo> assetTypes) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: assetTypes.length,
      itemBuilder: (context, index) {
        final assetType = assetTypes[index];
        final isSelected = _selectedType == assetType.type;

        return Card(
          elevation: isSelected ? 4 : 1,
          color: isSelected ? Colors.blue.shade50 : null,
          child: InkWell(
            onTap: () => setState(() => _selectedType = assetType.type),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        assetType.icon,
                        color: isSelected ? Colors.blue : Colors.grey.shade600,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          assetType.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.blue : null,
                          ),
                        ),
                      ),
                      if (isSelected) const Icon(Icons.check_circle, color: Colors.blue),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    assetType.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  if (assetType.examples.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Examples: ${assetType.examples.take(2).join(', ')}${assetType.examples.length > 2 ? '...' : ''}',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class AssetTypeInfo {
  final AssetType type;
  final String title;
  final String description;
  final IconData icon;
  final List<String> examples;

  AssetTypeInfo({
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.examples,
  });
}