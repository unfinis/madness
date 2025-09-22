import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/assets.dart';
import '../constants/app_spacing.dart';

/// Dialog for adding/editing applications installed on hosts
class HostApplicationDialog extends StatefulWidget {
  final HostApplication? application;
  final Function(HostApplication) onSave;

  const HostApplicationDialog({
    super.key,
    this.application,
    required this.onSave,
  });

  @override
  State<HostApplicationDialog> createState() => _HostApplicationDialogState();
}

class _HostApplicationDialogState extends State<HostApplicationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _versionController;
  late TextEditingController _vendorController;
  late TextEditingController _installLocationController;
  late TextEditingController _sizeController;
  late TextEditingController _licenseKeyController;

  String _selectedType = 'user';
  String _selectedArchitecture = 'x64';
  String _selectedLicenseType = 'commercial';
  DateTime? _installDate;
  bool _isSystemCritical = false;
  bool _hasUpdateAvailable = false;
  List<String> _configFiles = [];
  List<String> _dataDirectories = [];
  List<String> _registryKeys = [];
  List<String> _networkPorts = [];
  List<String> _vulnerabilities = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (widget.application != null) {
      _loadApplicationData();
    }
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _versionController = TextEditingController();
    _vendorController = TextEditingController();
    _installLocationController = TextEditingController();
    _sizeController = TextEditingController();
    _licenseKeyController = TextEditingController();
  }

  void _loadApplicationData() {
    final app = widget.application!;
    _nameController.text = app.name;
    _selectedType = app.type;
    _versionController.text = app.version ?? '';
    _vendorController.text = app.vendor ?? '';
    _selectedArchitecture = app.architecture ?? 'x64';
    _installLocationController.text = app.installLocation ?? '';
    _installDate = app.installDate;
    _sizeController.text = app.sizeMB?.toString() ?? '';
    _configFiles = List.from(app.configFiles ?? []);
    _dataDirectories = List.from(app.dataDirectories ?? []);
    _registryKeys = List.from(app.registryKeys ?? []);
    _networkPorts = List.from(app.networkPorts ?? []);
    _vulnerabilities = List.from(app.vulnerabilities ?? []);
    _isSystemCritical = app.isSystemCritical ?? false;
    _hasUpdateAvailable = app.hasUpdateAvailable ?? false;
    _selectedLicenseType = app.licenseType ?? 'commercial';
    _licenseKeyController.text = app.licenseKey ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _versionController.dispose();
    _vendorController.dispose();
    _installLocationController.dispose();
    _sizeController.dispose();
    _licenseKeyController.dispose();
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
            title: Text(widget.application == null ? 'Add Application' : 'Edit Application'),
            automaticallyImplyLeading: false,
            actions: [
              TextButton(
                onPressed: _saveApplication,
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
                  _buildInstallationSection(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildConfigurationSection(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildSecuritySection(),
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
              'Application Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Application Name *',
                hintText: 'Microsoft Office, Google Chrome, nginx',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Application name is required';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Application Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'system', child: Text('System')),
                      DropdownMenuItem(value: 'user', child: Text('User Application')),
                      DropdownMenuItem(value: 'service', child: Text('Service/Daemon')),
                      DropdownMenuItem(value: 'driver', child: Text('Driver')),
                      DropdownMenuItem(value: 'runtime', child: Text('Runtime/Framework')),
                    ],
                    onChanged: (value) => setState(() => _selectedType = value!),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _versionController,
                    decoration: const InputDecoration(
                      labelText: 'Version',
                      hintText: '2021, 15.4.1, 1.20.1',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _vendorController,
                    decoration: const InputDecoration(
                      labelText: 'Vendor/Publisher',
                      hintText: 'Microsoft, Google, Apache',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedArchitecture,
                    decoration: const InputDecoration(
                      labelText: 'Architecture',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'x64', child: Text('x64 (64-bit)')),
                      DropdownMenuItem(value: 'x86', child: Text('x86 (32-bit)')),
                      DropdownMenuItem(value: 'arm64', child: Text('ARM64')),
                      DropdownMenuItem(value: 'any', child: Text('Any CPU')),
                    ],
                    onChanged: (value) => setState(() => _selectedArchitecture = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    title: const Text('System Critical'),
                    subtitle: const Text('Essential for system operation'),
                    value: _isSystemCritical,
                    onChanged: (value) => setState(() => _isSystemCritical = value),
                  ),
                ),
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Update Available'),
                    subtitle: const Text('Newer version exists'),
                    value: _hasUpdateAvailable,
                    onChanged: (value) => setState(() => _hasUpdateAvailable = value),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstallationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Installation Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _installLocationController,
              decoration: const InputDecoration(
                labelText: 'Install Location',
                hintText: 'C:\\Program Files\\App, /opt/app, /usr/local/bin',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Install Date'),
                    subtitle: Text(_installDate?.toLocal().toString().split(' ')[0] ?? 'Not set'),
                    trailing: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: _selectInstallDate,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _sizeController,
                    decoration: const InputDecoration(
                      labelText: 'Size (MB)',
                      hintText: '250, 1024',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedLicenseType,
                    decoration: const InputDecoration(
                      labelText: 'License Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'commercial', child: Text('Commercial')),
                      DropdownMenuItem(value: 'open_source', child: Text('Open Source')),
                      DropdownMenuItem(value: 'freeware', child: Text('Freeware')),
                      DropdownMenuItem(value: 'trial', child: Text('Trial')),
                      DropdownMenuItem(value: 'oem', child: Text('OEM')),
                    ],
                    onChanged: (value) => setState(() => _selectedLicenseType = value!),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _licenseKeyController,
                    decoration: const InputDecoration(
                      labelText: 'License Key',
                      hintText: 'Software license key',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigurationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration & Resources',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: _buildListButton(
                    'Configuration Files',
                    _configFiles,
                    'C:\\Program Files\\App\\config.ini',
                    Icons.description,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildListButton(
                    'Data Directories',
                    _dataDirectories,
                    'C:\\ProgramData\\App',
                    Icons.folder,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: _buildListButton(
                    'Registry Keys',
                    _registryKeys,
                    'HKLM\\SOFTWARE\\App',
                    Icons.storage,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildListButton(
                    'Network Ports',
                    _networkPorts,
                    '8080, 443, 22',
                    Icons.network_check,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Security & Vulnerabilities',
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

  Widget _buildListButton(String title, List<String> items, String hintText, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () => _manageList(title, items, hintText),
      icon: Icon(icon, size: 16),
      label: Text('$title (${items.length})'),
      style: ElevatedButton.styleFrom(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  void _manageList(String title, List<String> items, String hintText) {
    showDialog(
      context: context,
      builder: (context) => _buildListManagementDialog(
        title: title,
        items: items,
        hintText: hintText,
        onSave: (newItems) => setState(() {
          items.clear();
          items.addAll(newItems);
        }),
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

  void _selectInstallDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _installDate ?? DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _installDate = date);
    }
  }

  void _saveApplication() {
    if (_formKey.currentState!.validate()) {
      final application = HostApplication(
        id: widget.application?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        type: _selectedType,
        version: _versionController.text.isEmpty ? null : _versionController.text,
        vendor: _vendorController.text.isEmpty ? null : _vendorController.text,
        architecture: _selectedArchitecture,
        installLocation: _installLocationController.text.isEmpty ? null : _installLocationController.text,
        installDate: _installDate,
        sizeMB: _sizeController.text.isEmpty ? null : int.tryParse(_sizeController.text),
        configFiles: _configFiles.isEmpty ? null : _configFiles,
        dataDirectories: _dataDirectories.isEmpty ? null : _dataDirectories,
        registryKeys: _registryKeys.isEmpty ? null : _registryKeys,
        networkPorts: _networkPorts.isEmpty ? null : _networkPorts,
        vulnerabilities: _vulnerabilities.isEmpty ? null : _vulnerabilities,
        isSystemCritical: _isSystemCritical,
        hasUpdateAvailable: _hasUpdateAvailable,
        licenseType: _selectedLicenseType,
        licenseKey: _licenseKeyController.text.isEmpty ? null : _licenseKeyController.text,
      );

      widget.onSave(application);
      Navigator.of(context).pop();
    }
  }
}