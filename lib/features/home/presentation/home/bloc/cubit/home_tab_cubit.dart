import 'package:flutter_bloc/flutter_bloc.dart';

enum HomeTab { myTasks, myProjects }

class HomeTabCubit extends Cubit<HomeTab> {
  HomeTabCubit() : super(HomeTab.myTasks);

  void selectTab(HomeTab tab) {
    emit(tab);
  }
}