import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/scope.dart';
import '../providers/scope_provider.dart';
import '../widgets/scope_filters_widget.dart';
import '../widgets/scope_segment_card_widget.dart';
import '../widgets/common_layout_widgets.dart';
import '../widgets/common_state_widgets.dart';
import '../widgets/standard_stats_bar.dart';
import '../dialogs/add_scope_segment_dialog.dart';

class ScopeScreen extends ConsumerStatefulWidget {
  const ScopeScreen({super.key});

  @override
  ConsumerState<ScopeScreen> createState() => _ScopeScreenState();
}

class _ScopeScreenState extends ConsumerState<ScopeScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredSegments = ref.watch(filteredScopeSegmentsProvider);
    
    return ScreenWrapper(
      children: [
        _buildScopeStatsBar(context),
        const SizedBox(height: CommonLayoutWidgets.sectionSpacing),
        
        ResponsiveCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: CommonLayoutWidgets.sectionSpacing),
              
              ScopeFiltersWidget(searchController: _searchController),
              const SizedBox(height: CommonLayoutWidgets.sectionSpacing),
              
              if (filteredSegments.isEmpty)
                CommonStateWidgets.noData(
                  itemName: 'testing segments',
                  icon: Icons.schema_outlined,
                  onCreate: () => _showAddSegmentDialog(context),
                  createButtonText: 'Add First Segment',
                )
              else
                _buildSegmentsList(filteredSegments),
            ],
          ),
        ),
      ],
    );
  }



  Widget _buildSegmentsList(List<ScopeSegment> segments) {
    return Column(
      children: segments.asMap().entries.map((entry) {
        final index = entry.key;
        final segment = entry.value;
        return Padding(
          padding: EdgeInsets.only(bottom: index < segments.length - 1 ? CommonLayoutWidgets.itemSpacing : 0),
          child: ScopeSegmentCardWidget(segment: segment),
        );
      }).toList(),
    );
  }

  void _showAddSegmentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const AddScopeSegmentDialog(),
    );
  }


  Widget _buildScopeStatsBar(BuildContext context) {
    final segments = ref.watch(filteredScopeSegmentsProvider);
    final stats = _calculateScopeStats(segments);

    final statsData = [
      StatData(
        label: 'Total',
        count: stats.total,
        icon: Icons.track_changes,
        color: Theme.of(context).colorScheme.primary,
      ),
      StatData(
        label: 'External',
        count: stats.external,
        icon: Icons.public,
        color: Colors.teal,
      ),
      StatData(
        label: 'Internal',
        count: stats.internal,
        icon: Icons.business,
        color: Colors.blue,
      ),
      StatData(
        label: 'Web App',
        count: stats.webapp,
        icon: Icons.web,
        color: Colors.green,
      ),
      StatData(
        label: 'Mobile',
        count: stats.mobile,
        icon: Icons.phone_android,
        color: Colors.orange,
      ),
      StatData(
        label: 'API',
        count: stats.api,
        icon: Icons.api,
        color: Colors.red,
      ),
      StatData(
        label: 'Wireless',
        count: stats.wireless,
        icon: Icons.wifi,
        color: Colors.purple,
      ),
    ];

    return StandardStatsBar(chips: StatsHelper.buildChips(statsData));
  }


  ScopeStats _calculateScopeStats(List<ScopeSegment> segments) {
    final external = segments.where((s) => s.type == ScopeSegmentType.external).length;
    final internal = segments.where((s) => s.type == ScopeSegmentType.internal).length;
    final webapp = segments.where((s) => s.type == ScopeSegmentType.webapp).length;
    final mobile = segments.where((s) => s.type == ScopeSegmentType.mobile).length;
    final api = segments.where((s) => s.type == ScopeSegmentType.api).length;
    final wireless = segments.where((s) => s.type == ScopeSegmentType.wireless).length;

    return ScopeStats(
      total: segments.length,
      external: external,
      internal: internal,
      webapp: webapp,
      mobile: mobile,
      api: api,
      wireless: wireless,
    );
  }
}

class ScopeStats {
  final int total;
  final int external;
  final int internal;
  final int webapp;
  final int mobile;
  final int api;
  final int wireless;

  ScopeStats({
    required this.total,
    required this.external,
    required this.internal,
    required this.webapp,
    required this.mobile,
    required this.api,
    required this.wireless,
  });
}