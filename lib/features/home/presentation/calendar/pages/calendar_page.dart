import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_time.dart';
import 'package:flutter_application_1/features/home/presentation/calendar/bloc/cubit/calendar_cubit.dart';
import 'package:flutter_application_1/features/home/presentation/calendar/bloc/cubit/calendar_state.dart';
import 'package:flutter_application_1/features/home/presentation/calendar/widgets/search_field.dart';
import 'package:flutter_application_1/features/home/presentation/home/widgets/TodayTaskItem.dart';
import 'package:flutter_application_1/features/home/presentation/create_project/presentation/create_project.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks/tasks_bloc.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks/tasks_event.dart';
import 'package:flutter_application_1/features/home/presentation/home/bloc/bloc/tasks/tasks_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    final selectedDay = context.read<CalendarCubit>().state.selectedDay;
    if (mounted) {
      context.read<TasksBloc>().add(GetTasksEvent(date: selectedDay));
    }
    await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgBlack,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, calendarState) {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.mainYellow,
          backgroundColor: AppColors.bgBlack,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                _buildSearchWithFilters(),
                _buildAddButtonRow(),
                SizedBox(height: 12.h),
                _buildCalendar(context),
                SizedBox(height: 12.h),
                _buildSearchableTasks(context),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchableTasks(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: BlocBuilder<TasksBloc, TasksState>(
        builder: (context, state) {
          if (state is LoadingTasks) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(30.h),
                child: CircularProgressIndicator(
                  color: AppColors.mainYellow,
                ),
              ),
            );
          }
          if (state is TasksAndCountsState && state.tasks != null) {
            if (state.tasks!.isEmpty) {
              return Text("No tasks for this day.");
            }
            return Column(
              children: state.tasks!.map((task) {
                return TodayTaskItem(
                  title: task.title,
                  project: "Project ${task.projectId}",
                );
              }).toList(),
            );
          }
          return Text("No tasks loaded.");
        },
      ),
    );
  }

  Widget _buildTasksAdd() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Tasks",
          style: TextStyle(
            color: AppColors.mainYellow,
            fontSize: 17.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildAddButton("Task"),
      ],
    );
  }

  Widget _buildAddButton(String title) {
    return Builder(
      builder: (context) => InkWell(
        onTap: () {
          if (title == "Project") {
            CreateProjectBottomSheetExtension(context)
                .showCreateProjectBottomSheet();
          } else if (title == "Task") {
            Navigator.of(context).pushNamed('/create-task');
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.mainYellow,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                FontAwesomeIcons.plus,
                color: AppColors.mainWhite,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                "Add $title",
                style: TextStyle(
                  color: AppColors.mainWhite,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchWithFilters() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Expanded(
            child: _buildSearchBar(),
          ),
          // SizedBox(width: 8.w),
          // _buildFilterButton(),
        ],
      ),
    );
  }

  Widget _buildAddButtonRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildAddButton("Project"),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return SearchField(controller: _searchController);
  }


  BlocBuilder<CalendarCubit, CalendarState> _buildCalendar(
      BuildContext context) {
    return BlocBuilder<CalendarCubit, CalendarState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 2.h),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.mainBlack,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: TableCalendar(
              firstDay: DateTime(DateTime.now().year, 1, 1),
              lastDay: DateTime(AppTime.currentYear, 12, 31),
              focusedDay: state.focusedDay,
              selectedDayPredicate: (day) => isSameDay(state.selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                context
                    .read<CalendarCubit>()
                    .selectDay(selectedDay, focusedDay);
                context.read<TasksBloc>().add(GetTasksEvent(date: selectedDay));
              },
              onPageChanged: (focusedDay) {
                context.read<CalendarCubit>().changeFocusedDay(focusedDay);
              },
              calendarFormat: CalendarFormat.month,
              startingDayOfWeek: StartingDayOfWeek.monday,
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainWhite,
                ),
                leftChevronIcon: Icon(
                  Icons.chevron_left,
                  color: AppColors.mainYellow,
                ),
                rightChevronIcon: Icon(
                  Icons.chevron_right,
                  color: AppColors.mainYellow,
                ),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                todayDecoration: BoxDecoration(
                  color: AppColors.mainYellow.withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: AppColors.mainYellow,
                  shape: BoxShape.circle,
                ),
                defaultTextStyle: TextStyle(
                  color: AppColors.mainWhite,
                  fontSize: 14.sp,
                ),
                weekendTextStyle: TextStyle(
                  color: AppColors.mainWhite,
                  fontSize: 14.sp,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: AppColors.mainWhite,
                  fontWeight: FontWeight.w600,
                ),
                weekendStyle: TextStyle(
                  color: AppColors.mainWhite,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

extension CreateProjectBottomSheetExtension on BuildContext {
  void showCreateProjectBottomSheet() {
    showModalBottomSheet(
      context: this,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => const CreateProjectBottomSheet(),
    );
  }
}
