
class CalendarState {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final List<String> tasksForSelectedDay;

  CalendarState({
    required this.focusedDay,
    this.selectedDay,
    this.tasksForSelectedDay = const [],
  });

  CalendarState copyWith({
    DateTime? focusedDay,
    DateTime? selectedDay,
    List<String>? tasksForSelectedDay,
  }) {
    return CalendarState(
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      tasksForSelectedDay: tasksForSelectedDay ?? this.tasksForSelectedDay,
    );
  }
}