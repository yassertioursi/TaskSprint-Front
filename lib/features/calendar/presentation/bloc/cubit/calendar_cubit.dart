import 'package:flutter_application_1/features/calendar/presentation/bloc/cubit/calendar_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CalendarCubit extends Cubit<CalendarState> {
  CalendarCubit() : super(CalendarState(
    focusedDay: DateTime.now(),
    selectedDay: DateTime.now(),
  ));

  void selectDay(DateTime selectedDay, DateTime focusedDay) {
    // Simulate fetching tasks for the selected day
    final tasks = _getTasksForDay(selectedDay);
    
    emit(state.copyWith(
      selectedDay: selectedDay,
      focusedDay: focusedDay,
      tasksForSelectedDay: tasks,
    ));
  }

  void changeFocusedDay(DateTime focusedDay) {
    emit(state.copyWith(focusedDay: focusedDay));
  }

  List<String> _getTasksForDay(DateTime day) {
    // Mock data - replace with actual API call
    if (day.day % 2 == 0) {
      return ['Task 1 for ${day.day}/${day.month}', 'Task 2 for ${day.day}/${day.month}'];
    } else if (day.day % 3 == 0) {
      return ['Important task for ${day.day}/${day.month}'];
    }
    return [];
  }
}