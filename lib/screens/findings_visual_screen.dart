import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/projects_provider.dart';
import '../providers/comprehensive_asset_provider.dart';
import '../widgets/common_state_widgets.dart';
import '../constants/app_spacing.dart';
import '../models/asset.dart';
import 'dart:math' as math;

class FindingsVisualScreen extends ConsumerStatefulWidget {
  const FindingsVisualScreen({super.key});

  @override
  ConsumerState<FindingsVisualScreen> createState() => _FindingsVisualScreenState();
}

class _FindingsVisualScreenState extends ConsumerState<FindingsVisualScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedSeverity = 'all';
  String _selectedCategory = 'all';
  ViewMode _viewMode = ViewMode.grid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProject = ref.watch(currentProjectProvider);

    if (currentProject == null) {
      return Scaffold(
        body: CommonStateWidgets.noProjectSelected(),
      );
    }

    // Mock findings data - would come from actual findings provider
    final findings = _generateMockFindings();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Findings & Results'),
        actions: [
          IconButton(
            icon: Icon(_viewMode == ViewMode.grid ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == ViewMode.grid ? ViewMode.list : ViewMode.grid;
              });
            },
            tooltip: _viewMode == ViewMode.grid ? 'List View' : 'Grid View',
          ),
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export_report',
                child: ListTile(
                  leading: Icon(Icons.file_download),
                  title: Text('Export Report'),
                ),
              ),
              const PopupMenuItem(
                value: 'generate_chart',
                child: ListTile(
                  leading: Icon(Icons.pie_chart),
                  title: Text('Generate Charts'),
                ),
              ),
              const PopupMenuItem(
                value: 'share_findings',
                child: ListTile(
                  leading: Icon(Icons.share),
                  title: Text('Share Findings'),
                ),
              ),
            ],
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Overview'),
            Tab(icon: Icon(Icons.bug_report), text: 'Vulnerabilities'),
            Tab(icon: Icon(Icons.timeline), text: 'Timeline'),
            Tab(icon: Icon(Icons.bubble_chart), text: 'Relationships'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(findings),
          _buildVulnerabilitiesTab(findings),
          _buildTimelineTab(findings),
          _buildRelationshipsTab(findings),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(List<Finding> findings) {
    final stats = _calculateStats(findings);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Executive Summary Card
          _buildExecutiveSummaryCard(stats),
          const SizedBox(height: AppSpacing.xl),

          // Severity Distribution
          _buildSeverityDistribution(stats),
          const SizedBox(height: AppSpacing.xl),

          // Category Breakdown
          _buildCategoryBreakdown(findings),
          const SizedBox(height: AppSpacing.xl),

          // Risk Matrix
          _buildRiskMatrix(findings),
          const SizedBox(height: AppSpacing.xl),

          // Top Findings
          _buildTopFindings(findings),
        ],
      ),
    );
  }

  Widget _buildExecutiveSummaryCard(FindingsStats stats) {
    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withValues(alpha: 0.1),
              Theme.of(context).primaryColor.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.assessment,
                    size: 32,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Text(
                    'Executive Summary',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryMetric(
                      'Total Findings',
                      stats.total.toString(),
                      Icons.bug_report,
                      Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: _buildSummaryMetric(
                      'Critical',
                      stats.critical.toString(),
                      Icons.error,
                      Colors.red,
                    ),
                  ),
                  Expanded(
                    child: _buildSummaryMetric(
                      'High',
                      stats.high.toString(),
                      Icons.warning,
                      Colors.orange,
                    ),
                  ),
                  Expanded(
                    child: _buildSummaryMetric(
                      'Risk Score',
                      stats.riskScore.toStringAsFixed(1),
                      Icons.speed,
                      Colors.purple,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryMetric(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSeverityDistribution(FindingsStats stats) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Severity Distribution',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _buildSeverityBar('Critical', stats.critical, stats.total, Colors.red),
            const SizedBox(height: AppSpacing.md),
            _buildSeverityBar('High', stats.high, stats.total, Colors.orange),
            const SizedBox(height: AppSpacing.md),
            _buildSeverityBar('Medium', stats.medium, stats.total, Colors.yellow[700]!),
            const SizedBox(height: AppSpacing.md),
            _buildSeverityBar('Low', stats.low, stats.total, Colors.green),
            const SizedBox(height: AppSpacing.md),
            _buildSeverityBar('Info', stats.info, stats.total, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildSeverityBar(String label, int count, int total, Color color) {
    final percentage = total > 0 ? (count / total) : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              '$count (${(percentage * 100).toStringAsFixed(1)}%)',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryBreakdown(List<Finding> findings) {
    final categories = _getCategoryBreakdown(findings);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category Breakdown',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              height: 200,
              child: Center(
                child: _buildPieChart(categories),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              children: categories.entries.map((entry) {
                final color = _getCategoryColor(entry.key);
                return Chip(
                  label: Text(
                    '${entry.key}: ${entry.value}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: color.withValues(alpha: 0.2),
                  side: BorderSide(color: color),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart(Map<String, int> data) {
    return CustomPaint(
      size: const Size(200, 200),
      painter: PieChartPainter(data, _getCategoryColor),
    );
  }

  Widget _buildRiskMatrix(List<Finding> findings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Risk Matrix',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              height: 300,
              child: _buildRiskMatrixGrid(findings),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskMatrixGrid(List<Finding> findings) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        final row = index ~/ 3;
        final col = index % 3;
        final severity = ['Low', 'Medium', 'High'][2 - row];
        final likelihood = ['Low', 'Medium', 'High'][col];
        final riskLevel = _calculateRiskLevel(severity, likelihood);
        final count = _countFindingsInCell(findings, severity, likelihood);

        return Container(
          decoration: BoxDecoration(
            color: _getRiskColor(riskLevel).withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _getRiskColor(riskLevel)),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _getRiskColor(riskLevel),
                  ),
                ),
                Text(
                  riskLevel,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopFindings(List<Finding> findings) {
    final topFindings = findings.take(5).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Findings',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () => _tabController.animateTo(1),
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            ...topFindings.map((finding) => _buildFindingCard(finding)),
          ],
        ),
      ),
    );
  }

  Widget _buildVulnerabilitiesTab(List<Finding> findings) {
    final filteredFindings = _applyFilters(findings);

    return Column(
      children: [
        _buildFilterBar(),
        const Divider(height: 1),
        Expanded(
          child: _viewMode == ViewMode.grid
              ? _buildFindingsGrid(filteredFindings)
              : _buildFindingsList(filteredFindings),
        ),
      ],
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedSeverity,
              decoration: const InputDecoration(
                labelText: 'Severity',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Severities')),
                DropdownMenuItem(value: 'critical', child: Text('Critical')),
                DropdownMenuItem(value: 'high', child: Text('High')),
                DropdownMenuItem(value: 'medium', child: Text('Medium')),
                DropdownMenuItem(value: 'low', child: Text('Low')),
                DropdownMenuItem(value: 'info', child: Text('Info')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSeverity = value ?? 'all';
                });
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              items: const [
                DropdownMenuItem(value: 'all', child: Text('All Categories')),
                DropdownMenuItem(value: 'authentication', child: Text('Authentication')),
                DropdownMenuItem(value: 'authorization', child: Text('Authorization')),
                DropdownMenuItem(value: 'injection', child: Text('Injection')),
                DropdownMenuItem(value: 'cryptography', child: Text('Cryptography')),
                DropdownMenuItem(value: 'configuration', child: Text('Configuration')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value ?? 'all';
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFindingsGrid(List<Finding> findings) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        childAspectRatio: 1.2,
      ),
      itemCount: findings.length,
      itemBuilder: (context, index) => _buildFindingGridCard(findings[index]),
    );
  }

  Widget _buildFindingsList(List<Finding> findings) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: findings.length,
      itemBuilder: (context, index) => _buildFindingCard(findings[index]),
    );
  }

  Widget _buildFindingGridCard(Finding finding) {
    final severityColor = _getSeverityColor(finding.severity);

    return Card(
      elevation: 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border(
            top: BorderSide(color: severityColor, width: 4),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getSeverityIcon(finding.severity),
                    color: severityColor,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      finding.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: Text(
                  finding.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Chip(
                    label: Text(
                      finding.category,
                      style: const TextStyle(fontSize: 10),
                    ),
                    backgroundColor: _getCategoryColor(finding.category).withValues(alpha: 0.2),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  ),
                  Text(
                    'CVSS: ${finding.cvssScore.toStringAsFixed(1)}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: severityColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFindingCard(Finding finding) {
    final severityColor = _getSeverityColor(finding.severity);

    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: severityColor.withValues(alpha: 0.1),
          child: Icon(
            _getSeverityIcon(finding.severity),
            color: severityColor,
            size: 20,
          ),
        ),
        title: Text(
          finding.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              finding.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                Chip(
                  label: Text(
                    finding.severity.toUpperCase(),
                    style: const TextStyle(fontSize: 9),
                  ),
                  backgroundColor: severityColor.withValues(alpha: 0.2),
                  side: BorderSide(color: severityColor),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  finding.category,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'CVSS',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
              ),
            ),
            Text(
              finding.cvssScore.toStringAsFixed(1),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: severityColor,
              ),
            ),
          ],
        ),
        onTap: () => _showFindingDetails(finding),
      ),
    );
  }

  Widget _buildTimelineTab(List<Finding> findings) {
    final sortedFindings = List<Finding>.from(findings)
      ..sort((a, b) => b.discoveredAt.compareTo(a.discoveredAt));

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: sortedFindings.length,
      itemBuilder: (context, index) {
        final finding = sortedFindings[index];
        final isFirst = index == 0;
        final isLast = index == sortedFindings.length - 1;

        return _buildTimelineItem(finding, isFirst, isLast);
      },
    );
  }

  Widget _buildTimelineItem(Finding finding, bool isFirst, bool isLast) {
    final severityColor = _getSeverityColor(finding.severity);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline line and dot
        Container(
          width: 60,
          child: Column(
            children: [
              if (!isFirst)
                Container(
                  width: 2,
                  height: 30,
                  color: Colors.grey[300],
                ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: severityColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: severityColor.withValues(alpha: 0.3),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 100,
                  color: Colors.grey[300],
                ),
            ],
          ),
        ),
        // Timeline content
        Expanded(
          child: Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _getSeverityIcon(finding.severity),
                        color: severityColor,
                        size: 16,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          finding.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        _formatDateTime(finding.discoveredAt),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    finding.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRelationshipsTab(List<Finding> findings) {
    return Center(
      child: CustomPaint(
        size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height - 200),
        painter: RelationshipGraphPainter(findings),
      ),
    );
  }

  // Helper methods
  List<Finding> _generateMockFindings() {
    return [
      Finding(
        id: '1',
        title: 'SQL Injection in Login Form',
        description: 'The login form is vulnerable to SQL injection attacks through the username field',
        severity: 'critical',
        category: 'injection',
        cvssScore: 9.8,
        discoveredAt: DateTime.now().subtract(const Duration(hours: 2)),
        affectedAssets: ['web-server-01', 'database-01'],
      ),
      Finding(
        id: '2',
        title: 'Weak Password Policy',
        description: 'System allows passwords with less than 8 characters and no complexity requirements',
        severity: 'high',
        category: 'authentication',
        cvssScore: 7.5,
        discoveredAt: DateTime.now().subtract(const Duration(hours: 5)),
        affectedAssets: ['auth-server-01'],
      ),
      Finding(
        id: '3',
        title: 'Unencrypted Data Transmission',
        description: 'Sensitive data is transmitted over HTTP without encryption',
        severity: 'high',
        category: 'cryptography',
        cvssScore: 8.2,
        discoveredAt: DateTime.now().subtract(const Duration(hours: 8)),
        affectedAssets: ['api-gateway-01'],
      ),
      Finding(
        id: '4',
        title: 'Default Admin Credentials',
        description: 'Admin console uses default credentials (admin/admin)',
        severity: 'critical',
        category: 'authentication',
        cvssScore: 9.1,
        discoveredAt: DateTime.now().subtract(const Duration(hours: 12)),
        affectedAssets: ['admin-console-01'],
      ),
      Finding(
        id: '5',
        title: 'Directory Listing Enabled',
        description: 'Web server has directory listing enabled, exposing file structure',
        severity: 'medium',
        category: 'configuration',
        cvssScore: 5.3,
        discoveredAt: DateTime.now().subtract(const Duration(hours: 24)),
        affectedAssets: ['web-server-01'],
      ),
      Finding(
        id: '6',
        title: 'Outdated SSL Certificate',
        description: 'SSL certificate is using deprecated TLS 1.0 protocol',
        severity: 'medium',
        category: 'cryptography',
        cvssScore: 4.8,
        discoveredAt: DateTime.now().subtract(const Duration(hours: 36)),
        affectedAssets: ['web-server-01', 'api-gateway-01'],
      ),
      Finding(
        id: '7',
        title: 'Cross-Site Scripting (XSS)',
        description: 'Reflected XSS vulnerability in search functionality',
        severity: 'high',
        category: 'injection',
        cvssScore: 7.1,
        discoveredAt: DateTime.now().subtract(const Duration(hours: 48)),
        affectedAssets: ['web-server-01'],
      ),
      Finding(
        id: '8',
        title: 'Information Disclosure',
        description: 'Server headers expose version information',
        severity: 'low',
        category: 'configuration',
        cvssScore: 3.7,
        discoveredAt: DateTime.now().subtract(const Duration(hours: 72)),
        affectedAssets: ['web-server-01', 'api-gateway-01', 'admin-console-01'],
      ),
    ];
  }

  List<Finding> _applyFilters(List<Finding> findings) {
    return findings.where((finding) {
      if (_selectedSeverity != 'all' && finding.severity != _selectedSeverity) {
        return false;
      }
      if (_selectedCategory != 'all' && finding.category != _selectedCategory) {
        return false;
      }
      return true;
    }).toList();
  }

  FindingsStats _calculateStats(List<Finding> findings) {
    final critical = findings.where((f) => f.severity == 'critical').length;
    final high = findings.where((f) => f.severity == 'high').length;
    final medium = findings.where((f) => f.severity == 'medium').length;
    final low = findings.where((f) => f.severity == 'low').length;
    final info = findings.where((f) => f.severity == 'info').length;

    final riskScore = (critical * 10.0 + high * 7.5 + medium * 5.0 + low * 2.5 + info * 1.0) /
                      (findings.isEmpty ? 1 : findings.length);

    return FindingsStats(
      total: findings.length,
      critical: critical,
      high: high,
      medium: medium,
      low: low,
      info: info,
      riskScore: riskScore,
    );
  }

  Map<String, int> _getCategoryBreakdown(List<Finding> findings) {
    final breakdown = <String, int>{};
    for (final finding in findings) {
      breakdown[finding.category] = (breakdown[finding.category] ?? 0) + 1;
    }
    return breakdown;
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'critical':
        return Colors.red[900]!;
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.yellow[700]!;
      case 'info':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity) {
      case 'critical':
        return Icons.error;
      case 'high':
        return Icons.warning;
      case 'medium':
        return Icons.priority_high;
      case 'low':
        return Icons.info;
      case 'info':
        return Icons.info_outline;
      default:
        return Icons.help_outline;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'injection':
        return Colors.purple;
      case 'authentication':
        return Colors.blue;
      case 'authorization':
        return Colors.indigo;
      case 'cryptography':
        return Colors.teal;
      case 'configuration':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _calculateRiskLevel(String severity, String likelihood) {
    if ((severity == 'High' && likelihood == 'High') ||
        (severity == 'High' && likelihood == 'Medium') ||
        (severity == 'Medium' && likelihood == 'High')) {
      return 'High';
    } else if ((severity == 'Medium' && likelihood == 'Medium') ||
               (severity == 'Low' && likelihood == 'High') ||
               (severity == 'High' && likelihood == 'Low')) {
      return 'Medium';
    } else {
      return 'Low';
    }
  }

  Color _getRiskColor(String riskLevel) {
    switch (riskLevel) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  int _countFindingsInCell(List<Finding> findings, String severity, String likelihood) {
    // This is a simplified count - in real implementation would use actual likelihood data
    return findings.where((f) =>
      f.severity.toLowerCase() == severity.toLowerCase()
    ).length ~/ 3; // Divide by 3 to distribute across likelihood levels
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')} '
           '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void _showFindingDetails(Finding finding) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _getSeverityIcon(finding.severity),
              color: _getSeverityColor(finding.severity),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(child: Text(finding.title)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(finding.description),
              const SizedBox(height: AppSpacing.lg),
              _buildDetailRow('Severity', finding.severity.toUpperCase()),
              _buildDetailRow('Category', finding.category),
              _buildDetailRow('CVSS Score', finding.cvssScore.toString()),
              _buildDetailRow('Discovered', _formatDateTime(finding.discoveredAt)),
              const SizedBox(height: AppSpacing.lg),
              const Text('Affected Assets:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...finding.affectedAssets.map((asset) => Padding(
                padding: const EdgeInsets.only(left: AppSpacing.md, top: AppSpacing.xs),
                child: Text('• $asset'),
              )),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Generating detailed report...')),
              );
            },
            child: const Text('Generate Report'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'export_report':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Exporting findings report...')),
        );
        break;
      case 'generate_chart':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Generating charts...')),
        );
        break;
      case 'share_findings':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sharing findings...')),
        );
        break;
    }
  }
}

// Data models
class Finding {
  final String id;
  final String title;
  final String description;
  final String severity;
  final String category;
  final double cvssScore;
  final DateTime discoveredAt;
  final List<String> affectedAssets;

  const Finding({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.category,
    required this.cvssScore,
    required this.discoveredAt,
    required this.affectedAssets,
  });
}

class FindingsStats {
  final int total;
  final int critical;
  final int high;
  final int medium;
  final int low;
  final int info;
  final double riskScore;

  const FindingsStats({
    required this.total,
    required this.critical,
    required this.high,
    required this.medium,
    required this.low,
    required this.info,
    required this.riskScore,
  });
}

enum ViewMode { grid, list }

// Custom painters
class PieChartPainter extends CustomPainter {
  final Map<String, int> data;
  final Color Function(String) getColor;

  PieChartPainter(this.data, this.getColor);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2;
    var startAngle = -math.pi / 2;
    final total = data.values.fold(0, (a, b) => a + b);

    data.forEach((category, value) {
      final sweepAngle = 2 * math.pi * (value / total);
      final paint = Paint()
        ..color = getColor(category)
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class RelationshipGraphPainter extends CustomPainter {
  final List<Finding> findings;

  RelationshipGraphPainter(this.findings);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.withValues(alpha: 0.3)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final nodePaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Draw a simple network graph representation
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 3;

    // Draw findings as nodes in a circle
    for (int i = 0; i < findings.length && i < 8; i++) {
      final angle = 2 * math.pi * i / math.min(findings.length, 8);
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      final nodeCenter = Offset(x, y);

      // Draw connections to center
      canvas.drawLine(center, nodeCenter, paint);

      // Draw node
      canvas.drawCircle(nodeCenter, 20, nodePaint);
    }

    // Draw center node
    canvas.drawCircle(center, 30, nodePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}