import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// class TabIndexCubit extends Cubit<int> {
//   TabIndexCubit() : super(0);
//
//   void changeTab(int index) {
//     emit(index);
//   }
// }

// class TabControllerCubit extends Cubit<TabController> {
//   TabControllerCubit({
//     required TabController tabController,
//   }) : super(tabController) {
//     tabController.addListener(() {
//       emit(tabController);
//     });
//   }
//
//   void changeTab(int index) {
//     state.index = index;
//     emit(state);
//   }
// }

class TabControllerData {
  final TabController tabController;
  final double offset;

  TabControllerData({
    required this.tabController,
    this.offset = 0,
  });
}

class TabControllerCubit extends Cubit<TabControllerData> {
  TabControllerCubit({
    required TabController tabController,
  }) : super(TabControllerData(tabController: tabController)) {
    tabController.addListener(() {
      emit(TabControllerData(
        tabController: tabController,
        offset: tabController.animation!.value,
      ));
    });
  }
}
