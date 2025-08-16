import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeProvider = NotifierProvider<HomeNotifier, HomeState>(
  HomeNotifier.new,
);

class HomeNotifier extends Notifier<HomeState> {
  @override
  HomeState build() {
    return const HomeState();
  }

  void toggleExpanded() {
    state = state.copyWith(isCardExpanded: !state.isCardExpanded);
  }

  void toggleNavBarOpen() {
    state = state.copyWith(isNavBarOpen: !state.isNavBarOpen);
  }
}

class HomeState {
  final bool isCardExpanded;
  final bool isNavBarOpen;
  const HomeState({this.isCardExpanded = false, this.isNavBarOpen = false});

  @override
  int get hashCode => Object.hash(isCardExpanded, isNavBarOpen);

  HomeState copyWith({bool? isCardExpanded, bool? isNavBarOpen}) {
    return HomeState(
      isCardExpanded: isCardExpanded ?? this.isCardExpanded,
      isNavBarOpen: isNavBarOpen ?? this.isNavBarOpen,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is HomeState &&
        other.isCardExpanded == isCardExpanded &&
        other.isNavBarOpen == isNavBarOpen;
  }
}
