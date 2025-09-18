import 'package:flutter_riverpod/flutter_riverpod.dart';

enum NavigationSection {
  home,
  dashboard,
  tasks,
  comms,
  checklist,
  expenses,
  contacts,
  scope,
  documents,
  travel,
  methodology,
  assets,
  credentials,
  history,
  findings,
  attackChains,
  screenshots,
  reports,
  agents,
  plugins,
  ingestors,
  settings,
}

class NavigationState {
  final NavigationSection currentSection;

  NavigationState({required this.currentSection});
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(NavigationState(currentSection: NavigationSection.home));

  void navigateTo(NavigationSection section) {
    state = NavigationState(currentSection: section);
  }
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>((ref) {
  return NavigationNotifier();
});