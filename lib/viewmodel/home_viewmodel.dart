import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    return const HomeState();
  }

  void toggleExpanded(int? sectionIndex) {
    // if (state.isCardExpanded && state.expandedSectionIndex == sectionIndex) {
    //   // Collapse same card
    //   state = state.copyWith(isCardExpanded: false, expandedSectionIndex: null);
    // } else {
    //   // Expand new card

    // }
    state = state.copyWith(
      isCardExpanded: !state.isCardExpanded,
      expandedSectionIndex: sectionIndex,
    );
  }

  void toggleNavBarOpen() {
    state = state.copyWith(isNavBarOpen: !state.isNavBarOpen);
  }
}

class HomeState {
  final bool isCardExpanded;
  final bool isNavBarOpen;
  final int? expandedSectionIndex;

  const HomeState({
    this.isCardExpanded = false,
    this.isNavBarOpen = false,
    this.expandedSectionIndex,
  });

  @override
  int get hashCode =>
      Object.hash(isCardExpanded, isNavBarOpen, expandedSectionIndex);

  HomeState copyWith({
    bool? isCardExpanded,
    bool? isNavBarOpen,
    int? expandedSectionIndex,
  }) {
    return HomeState(
      isCardExpanded: isCardExpanded ?? this.isCardExpanded,
      isNavBarOpen: isNavBarOpen ?? this.isNavBarOpen,
      expandedSectionIndex: expandedSectionIndex,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HomeState &&
        other.isCardExpanded == isCardExpanded &&
        other.isNavBarOpen == isNavBarOpen &&
        other.expandedSectionIndex == expandedSectionIndex;
  }
}
