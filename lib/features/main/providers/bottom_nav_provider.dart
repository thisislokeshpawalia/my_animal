import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void changeTab(int index) {
    state = index;
  }
}

final bottomNavProvider =
NotifierProvider<BottomNavNotifier, int>(
  BottomNavNotifier.new,
);