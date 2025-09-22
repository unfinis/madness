import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/assets.dart';
import '../constants/app_spacing.dart';

/// Dialog for adding/editing services running on hosts
class HostServiceDialog extends StatefulWidget {
  final HostService? service;
  final Function(HostService) onSave;

  const HostServiceDialog({
    super.key,
    this.service,
    required this.onSave,
  });

  @override
  State<HostServiceDialog> createState() => _HostServiceDialogState();
}

class _HostServiceDialogState extends State<HostServiceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _portController;
  late TextEditingController _versionController;
  late TextEditingController _bannerController;
  late TextEditingController _productNameController;
  late TextEditingController _productVersionController;
  late TextEditingController _sslVersionController;

  String _selectedProtocol = 'tcp';
  String _selectedState = 'open';
  String _selectedConfidence = 'high';
  bool _requiresAuth = false;
  List<String> _authMethods = [];
  List<String> _sslCiphers = [];
  List<String> _vulnerabilities = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (widget.service != null) {
      _loadServiceData();
    }
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _portController = TextEditingController();
    _versionController = TextEditingController();
    _bannerController = TextEditingController();
    _productNameController = TextEditingController();
    _productVersionController = TextEditingController();
    _sslVersionController = TextEditingController();
  }

  void _loadServiceData() {
    final service = widget.service!;
    _nameController.text = service.name;
    _portController.text = service.port.toString();
    _selectedProtocol = service.protocol;
    _selectedState = service.state;
    _versionController.text = service.version ?? '';
    _bannerController.text = service.banner ?? '';
    _productNameController.text = service.productName ?? '';
    _productVersionController.text = service.productVersion ?? '';
    _requiresAuth = service.requiresAuthentication ?? false;
    _authMethods = List.from(service.authenticationMethods ?? []);
    _sslVersionController.text = service.sslVersion ?? '';
    _sslCiphers = List.from(service.sslCiphers ?? []);
    _vulnerabilities = List.from(service.vulnerabilities ?? []);
    _selectedConfidence = service.confidence ?? 'high';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _portController.dispose();
    _versionController.dispose();
    _bannerController.dispose();
    _productNameController.dispose();
    _productVersionController.dispose();
    _sslVersionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 700,
        height: 800,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.service == null ? 'Add Service' : 'Edit Service'),
            automaticallyImplyLeading: false,
            actions: [
              TextButton(
                onPressed: _saveService,
                child: const Text('Save'),
              ),
              const SizedBox(width: AppSpacing.sm),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
            ],
          ),
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBasicInfoSection(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildProductInfoSection(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSecuritySection(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildVulnerabilitiesSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Service Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Service Name *',
                      hintText: 'http, ssh, ftp, smb',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Service name is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _portController,
                    decoration: const InputDecoration(
                      labelText: 'Port *',
                      hintText: '80, 443, 22',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Port is required';
                      }
                      final port = int.tryParse(value);
                      if (port == null || port < 1 || port > 65535) {
                        return 'Invalid port number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedProtocol,
                    decoration: const InputDecoration(
                      labelText: 'Protocol',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'tcp', child: Text('TCP')),
                      DropdownMenuItem(value: 'udp', child: Text('UDP')),
                    ],
                    onChanged: (value) => setState(() => _selectedProtocol = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedState,
                    decoration: const InputDecoration(
                      labelText: 'State',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'open', child: Text('Open')),
                      DropdownMenuItem(value: 'filtered', child: Text('Filtered')),
                      DropdownMenuItem(value: 'closed', child: Text('Closed')),
                    ],
                    onChanged: (value) => setState(() => _selectedState = value!),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedConfidence,
                    decoration: const InputDecoration(
                      labelText: 'Confidence',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'low', child: Text('Low')),
                      DropdownMenuItem(value: 'medium', child: Text('Medium')),
                      DropdownMenuItem(value: 'high', child: Text('High')),
                    ],
                    onChanged: (value) => setState(() => _selectedConfidence = value!),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _versionController,
                    decoration: const InputDecoration(
                      labelText: 'Version',
                      hintText: '2.4.41, 8.0.1',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _bannerController,
              decoration: const InputDecoration(
                labelText: 'Service Banner',
                hintText: 'Server response banner',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _productNameController,
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                      hintText: 'Apache httpd, OpenSSH',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _productVersionController,
                    decoration: const InputDecoration(
                      labelText: 'Product Version',
                      hintText: '2.4.41, 8.0p1',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Security & Authentication',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            SwitchListTile(
              title: const Text('Requires Authentication'),
              subtitle: const Text('Service requires login/credentials'),
              value: _requiresAuth,
              onChanged: (value) => setState(() => _requiresAuth = value),
            ),

            if (_requiresAuth) ...[
              const SizedBox(height: AppSpacing.md),
              _buildAuthMethodsChips(),
            ],

            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _sslVersionController,
                    decoration: const InputDecoration(
                      labelText: 'SSL/TLS Version',
                      hintText: 'TLS 1.2, SSL 3.0',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _manageSslCiphers,
                    icon: const Icon(Icons.security, size: 16),
                    label: Text('SSL Ciphers (${_sslCiphers.length})'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAuthMethodsChips() {
    const availableMethods = [
      'basic', 'digest', 'ntlm', 'kerberos', 'oauth', 'certificate', 'key'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Authentication Methods:'),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: 8,
          children: availableMethods.map((method) {
            final isSelected = _authMethods.contains(method);
            return FilterChip(
              label: Text(method),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _authMethods.add(method);
                  } else {
                    _authMethods.remove(method);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVulnerabilitiesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Vulnerabilities',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addVulnerability,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add CVE'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade100,
                    foregroundColor: Colors.red.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            if (_vulnerabilities.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      'No known vulnerabilities',
                      style: TextStyle(color: Colors.green.shade700),
                    ),
                  ],
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _vulnerabilities.length,
                itemBuilder: (context, index) => Card(
                  color: Colors.red.shade50,
                  child: ListTile(
                    leading: Icon(Icons.warning, color: Colors.red.shade600),
                    title: Text(_vulnerabilities[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => setState(() => _vulnerabilities.removeAt(index)),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _manageSslCiphers() {
    showDialog(
      context: context,
      builder: (context) => _buildListManagementDialog(
        title: 'SSL/TLS Ciphers',
        items: _sslCiphers,
        hintText: 'TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384',
        onSave: (items) => setState(() => _sslCiphers = items),
      ),
    );
  }

  void _addVulnerability() {
    showDialog(
      context: context,
      builder: (context) => _buildAddItemDialog(
        title: 'Add Vulnerability',
        hintText: 'CVE-2021-44228, CVE-2020-1472',
        onAdd: (item) => setState(() => _vulnerabilities.add(item)),
      ),
    );
  }

  Widget _buildListManagementDialog({
    required String title,
    required List<String> items,
    required String hintText,
    required Function(List<String>) onSave,
  }) {
    final controller = TextEditingController();
    final tempItems = List<String>.from(items);

    return StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 400,
          height: 300,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: hintText,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        setDialogState(() => tempItems.add(controller.text));
                        controller.clear();
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListView.builder(
                  itemCount: tempItems.length,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(tempItems[index]),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => setDialogState(() => tempItems.removeAt(index)),
                    ),
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
            onPressed: () {
              onSave(tempItems);
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddItemDialog({
    required String title,
    required String hintText,
    required Function(String) onAdd,
  }) {
    final controller = TextEditingController();

    return AlertDialog(
      title: Text(title),
      content: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.isNotEmpty) {
              onAdd(controller.text);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  void _saveService() {
    if (_formKey.currentState!.validate()) {
      final service = HostService(
        id: widget.service?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        port: int.parse(_portController.text),
        protocol: _selectedProtocol,
        state: _selectedState,
        version: _versionController.text.isEmpty ? null : _versionController.text,
        banner: _bannerController.text.isEmpty ? null : _bannerController.text,
        productName: _productNameController.text.isEmpty ? null : _productNameController.text,
        productVersion: _productVersionController.text.isEmpty ? null : _productVersionController.text,
        vulnerabilities: _vulnerabilities.isEmpty ? null : _vulnerabilities,
        requiresAuthentication: _requiresAuth,
        authenticationMethods: _authMethods.isEmpty ? null : _authMethods,
        sslVersion: _sslVersionController.text.isEmpty ? null : _sslVersionController.text,
        sslCiphers: _sslCiphers.isEmpty ? null : _sslCiphers,
        lastChecked: DateTime.now(),
        confidence: _selectedConfidence,
      );

      widget.onSave(service);
      Navigator.of(context).pop();
    }
  }
}