import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/assets.dart';
import '../constants/app_spacing.dart';

/// Dialog for adding/editing network interfaces on hosts
class NetworkInterfaceDialog extends StatefulWidget {
  final NetworkInterface? interface;
  final Function(NetworkInterface) onSave;

  const NetworkInterfaceDialog({
    super.key,
    this.interface,
    required this.onSave,
  });

  @override
  State<NetworkInterfaceDialog> createState() => _NetworkInterfaceDialogState();
}

class _NetworkInterfaceDialogState extends State<NetworkInterfaceDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _macController;
  late TextEditingController _descriptionController;
  late TextEditingController _vendorController;
  late TextEditingController _driverController;
  late TextEditingController _speedController;
  late TextEditingController _switchPortController;
  late TextEditingController _vlanController;

  String _selectedType = 'ethernet';
  bool _isEnabled = true;
  bool _isConnected = false;
  List<NetworkAddress> _addresses = [];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    if (widget.interface != null) {
      _loadInterfaceData();
    }
  }

  void _initializeControllers() {
    _nameController = TextEditingController();
    _macController = TextEditingController();
    _descriptionController = TextEditingController();
    _vendorController = TextEditingController();
    _driverController = TextEditingController();
    _speedController = TextEditingController();
    _switchPortController = TextEditingController();
    _vlanController = TextEditingController();
  }

  void _loadInterfaceData() {
    final interface = widget.interface!;
    _nameController.text = interface.name;
    _macController.text = interface.macAddress;
    _selectedType = interface.type;
    _isEnabled = interface.isEnabled;
    _descriptionController.text = interface.description ?? '';
    _vendorController.text = interface.vendor ?? '';
    _driverController.text = interface.driver ?? '';
    _speedController.text = interface.speedMbps?.toString() ?? '';
    _isConnected = interface.isConnected ?? false;
    _switchPortController.text = interface.connectedSwitchPort ?? '';
    _vlanController.text = interface.vlanId ?? '';
    _addresses = List.from(interface.addresses);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _macController.dispose();
    _descriptionController.dispose();
    _vendorController.dispose();
    _driverController.dispose();
    _speedController.dispose();
    _switchPortController.dispose();
    _vlanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 600,
        height: 700,
        child: Scaffold(
          appBar: AppBar(
            title: Text(widget.interface == null ? 'Add Network Interface' : 'Edit Network Interface'),
            automaticallyImplyLeading: false,
            actions: [
              TextButton(
                onPressed: _saveInterface,
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
                  _buildNetworkConfigSection(),
                  const SizedBox(height: AppSpacing.lg),
                  _buildAddressesSection(),
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
              'Basic Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Interface Name *',
                      hintText: 'eth0, Wi-Fi, Ethernet',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Interface name is required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Interface Type',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'ethernet', child: Text('Ethernet')),
                      DropdownMenuItem(value: 'wireless', child: Text('Wireless')),
                      DropdownMenuItem(value: 'loopback', child: Text('Loopback')),
                      DropdownMenuItem(value: 'virtual', child: Text('Virtual')),
                      DropdownMenuItem(value: 'tunnel', child: Text('Tunnel')),
                    ],
                    onChanged: (value) => setState(() => _selectedType = value!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _macController,
              decoration: const InputDecoration(
                labelText: 'MAC Address *',
                hintText: '00:11:22:33:44:55',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F:]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'MAC address is required';
                }
                if (!RegExp(r'^([0-9a-fA-F]{2}[:-]){5}([0-9a-fA-F]{2})$').hasMatch(value)) {
                  return 'Invalid MAC address format';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Optional description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Interface Enabled'),
                    value: _isEnabled,
                    onChanged: (value) => setState(() => _isEnabled = value),
                  ),
                ),
                Expanded(
                  child: SwitchListTile(
                    title: const Text('Currently Connected'),
                    value: _isConnected,
                    onChanged: (value) => setState(() => _isConnected = value),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkConfigSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Network Configuration',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _vendorController,
                    decoration: const InputDecoration(
                      labelText: 'Vendor',
                      hintText: 'Intel, Realtek, Broadcom',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _driverController,
                    decoration: const InputDecoration(
                      labelText: 'Driver',
                      hintText: 'Driver name/version',
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
                    controller: _speedController,
                    decoration: const InputDecoration(
                      labelText: 'Speed (Mbps)',
                      hintText: '1000, 100, 10',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _vlanController,
                    decoration: const InputDecoration(
                      labelText: 'VLAN ID',
                      hintText: '100, 200',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            TextFormField(
              controller: _switchPortController,
              decoration: const InputDecoration(
                labelText: 'Connected Switch Port',
                hintText: 'Gi0/1, FastEthernet0/24',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressesSection() {
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
                  'IP Addresses',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _addAddress,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Address'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            if (_addresses.isEmpty)
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.network_check, color: Colors.grey.shade600, size: 32),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'No IP addresses configured',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _addresses.length,
                itemBuilder: (context, index) => _buildAddressCard(index),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(int index) {
    final address = _addresses[index];
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        leading: Icon(
          address.isStatic == true ? Icons.lock : Icons.sync,
          color: address.isStatic == true ? Colors.blue : Colors.orange,
        ),
        title: Text(address.ip),
        subtitle: Text(
          'Subnet: ${address.subnet ?? 'N/A'} • '
          'Gateway: ${address.gateway ?? 'N/A'} • '
          '${address.isStatic == true ? 'Static' : 'Dynamic'}',
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeAddress(index),
        ),
        onTap: () => _editAddress(index),
      ),
    );
  }

  void _addAddress() {
    showDialog(
      context: context,
      builder: (context) => NetworkAddressDialog(
        onSave: (address) {
          setState(() => _addresses.add(address));
        },
      ),
    );
  }

  void _editAddress(int index) {
    showDialog(
      context: context,
      builder: (context) => NetworkAddressDialog(
        address: _addresses[index],
        onSave: (address) {
          setState(() => _addresses[index] = address);
        },
      ),
    );
  }

  void _removeAddress(int index) {
    setState(() => _addresses.removeAt(index));
  }

  void _saveInterface() {
    if (_formKey.currentState!.validate()) {
      final interface = NetworkInterface(
        id: widget.interface?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        type: _selectedType,
        macAddress: _macController.text,
        isEnabled: _isEnabled,
        addresses: _addresses,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        vendor: _vendorController.text.isEmpty ? null : _vendorController.text,
        driver: _driverController.text.isEmpty ? null : _driverController.text,
        speedMbps: _speedController.text.isEmpty ? null : int.tryParse(_speedController.text),
        isConnected: _isConnected,
        connectedSwitchPort: _switchPortController.text.isEmpty ? null : _switchPortController.text,
        vlanId: _vlanController.text.isEmpty ? null : _vlanController.text,
        lastSeen: DateTime.now(),
      );

      widget.onSave(interface);
      Navigator.of(context).pop();
    }
  }
}

/// Dialog for adding/editing network addresses
class NetworkAddressDialog extends StatefulWidget {
  final NetworkAddress? address;
  final Function(NetworkAddress) onSave;

  const NetworkAddressDialog({
    super.key,
    this.address,
    required this.onSave,
  });

  @override
  State<NetworkAddressDialog> createState() => _NetworkAddressDialogState();
}

class _NetworkAddressDialogState extends State<NetworkAddressDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _ipController;
  late TextEditingController _subnetController;
  late TextEditingController _gatewayController;
  late TextEditingController _dnsController;
  late TextEditingController _macController;

  bool _isStatic = true;

  @override
  void initState() {
    super.initState();
    _ipController = TextEditingController();
    _subnetController = TextEditingController();
    _gatewayController = TextEditingController();
    _dnsController = TextEditingController();
    _macController = TextEditingController();

    if (widget.address != null) {
      _loadAddressData();
    }
  }

  void _loadAddressData() {
    final address = widget.address!;
    _ipController.text = address.ip;
    _subnetController.text = address.subnet ?? '';
    _gatewayController.text = address.gateway ?? '';
    _dnsController.text = address.dnsServers?.join(', ') ?? '';
    _macController.text = address.macAddress ?? '';
    _isStatic = address.isStatic ?? true;
  }

  @override
  void dispose() {
    _ipController.dispose();
    _subnetController.dispose();
    _gatewayController.dispose();
    _dnsController.dispose();
    _macController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.address == null ? 'Add IP Address' : 'Edit IP Address'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _ipController,
                decoration: const InputDecoration(
                  labelText: 'IP Address *',
                  hintText: '192.168.1.100',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'IP address is required';
                  }
                  if (!RegExp(r'^((25[0-5]|(2[0-4]|1\d|[1-9]|)\d)\.?\b){4}$').hasMatch(value)) {
                    return 'Invalid IP address format';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _subnetController,
                decoration: const InputDecoration(
                  labelText: 'Subnet Mask',
                  hintText: '255.255.255.0 or /24',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _gatewayController,
                decoration: const InputDecoration(
                  labelText: 'Gateway',
                  hintText: '192.168.1.1',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              TextFormField(
                controller: _dnsController,
                decoration: const InputDecoration(
                  labelText: 'DNS Servers',
                  hintText: '8.8.8.8, 8.8.4.4',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.md),

              SwitchListTile(
                title: const Text('Static IP'),
                subtitle: const Text('Uncheck for DHCP'),
                value: _isStatic,
                onChanged: (value) => setState(() => _isStatic = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveAddress,
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final dnsServers = _dnsController.text.isEmpty
          ? null
          : _dnsController.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

      final address = NetworkAddress(
        ip: _ipController.text,
        subnet: _subnetController.text.isEmpty ? null : _subnetController.text,
        gateway: _gatewayController.text.isEmpty ? null : _gatewayController.text,
        dnsServers: dnsServers,
        macAddress: _macController.text.isEmpty ? null : _macController.text,
        isStatic: _isStatic,
      );

      widget.onSave(address);
      Navigator.of(context).pop();
    }
  }
}