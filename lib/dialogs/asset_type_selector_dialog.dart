import 'package:flutter/material.dart';
import '../models/asset.dart';

class AssetTypeSelectorDialog extends StatefulWidget {
  final Function(AssetType) onAssetTypeSelected;

  const AssetTypeSelectorDialog({
    super.key,
    required this.onAssetTypeSelected,
  });

  @override
  State<AssetTypeSelectorDialog> createState() => _AssetTypeSelectorDialogState();
}

class _AssetTypeSelectorDialogState extends State<AssetTypeSelectorDialog> {
  AssetType? _selectedType;

  // Simplified asset types for the comprehensive system
  final List<AssetTypeInfo> _assetTypes = [
    AssetTypeInfo(
      type: AssetType.networkSegment,
      title: 'Network Segment',
      description: 'Network subnets, VLANs, and IP ranges',
      icon: Icons.router,
      examples: ['192.168.1.0/24', 'DMZ VLAN 100', 'Guest Network'],
    ),
    AssetTypeInfo(
      type: AssetType.host,
      title: 'Host/Computer',
      description: 'Servers, workstations, and devices',
      icon: Icons.computer,
      examples: ['Domain Controller', 'Web Server', 'Workstation'],
    ),
    AssetTypeInfo(
      type: AssetType.service,
      title: 'Service',
      description: 'Network services and applications',
      icon: Icons.web,
      examples: ['HTTP (80)', 'SSH (22)', 'LDAP (389)'],
    ),
    AssetTypeInfo(
      type: AssetType.credential,
      title: 'Credential',
      description: 'Authentication credentials and tokens',
      icon: Icons.key,
      examples: ['admin@domain.com', 'Local Administrator', 'Service Account'],
    ),
    AssetTypeInfo(
      type: AssetType.vulnerability,
      title: 'Vulnerability',
      description: 'Security vulnerabilities and weaknesses',
      icon: Icons.security,
      examples: ['CVE-2023-1234', 'Weak Password Policy', 'Missing Patch'],
    ),
    AssetTypeInfo(
      type: AssetType.domain,
      title: 'Domain',
      description: 'Active Directory domains and realms',
      icon: Icons.domain,
      examples: ['corp.local', 'WORKGROUP', 'Azure AD Tenant'],
    ),
    AssetTypeInfo(
      type: AssetType.wireless_network,
      title: 'Wireless Network',
      description: 'WiFi networks and access points',
      icon: Icons.wifi,
      examples: ['Corporate-WiFi', 'Guest Network', 'IoT SSID'],
    ),
    AssetTypeInfo(
      type: AssetType.restrictedEnvironment,
      title: 'Restricted Environment',
      description: 'Kiosks, containers, sandboxes, and restricted shells',
      icon: Icons.shield,
      examples: ['Citrix VDI', 'Kiosk Mode', 'Docker Container'],
    ),
    AssetTypeInfo(
      type: AssetType.securityControl,
      title: 'Security Control',
      description: 'Security products and defensive mechanisms',
      icon: Icons.security,
      examples: ['Windows Defender', 'AMSI', 'Application Whitelisting'],
    ),
  ];

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
        width: 500,
        height: 400,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose the type of asset you want to create:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: _assetTypes.length,
                itemBuilder: (context, index) {
                  final assetType = _assetTypes[index];
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
                          ],
                        ),
                      ),
                    ),
                  );
                },
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
              ? () => widget.onAssetTypeSelected(_selectedType!)
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