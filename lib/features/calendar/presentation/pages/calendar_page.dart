import 'package:flutter/material.dart';
import 'package:flutter_application_1/core/constants/app_colors.dart';
import 'package:flutter_application_1/core/constants/app_time.dart';
import 'package:flutter_application_1/features/calendar/presentation/bloc/cubit/calendar_cubit.dart';
import 'package:flutter_application_1/features/calendar/presentation/bloc/cubit/calendar_state.dart';
import 'package:flutter_application_1/features/calendar/presentation/widgets/search_field.dart';
import 'package:flutter_application_1/features/home/presentation/home/widgets/TodayTaskItem.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CalendarCubit(),
      child: Scaffold(
        backgroundColor: AppColors.bgBlack,
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 20.h),
        _buildSearchWithFilters(),
        _buildAddButtonRow(),
        SizedBox(height: 12.h),
        _buildCalendar(),
        SizedBox(
          height: 12.h,
        ),
        _buildSearchableTasks(),
      ],
    );
  }



  Widget _buildSearchableTasks() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          _buildTasksAdd() , 
          SizedBox(height: 15.h),
          TodayTaskItem(title: "Task a", project: "project a")
          
          
          ],
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
    return Container(
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
          SizedBox(width: 8.w),
          _buildFilterButton(),
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
    return SearchField(controller: TextEditingController());
  }

  Widget _buildFilterButton() {
    return Container(
      width: 40.w,
      height: 36.h,
      decoration: BoxDecoration(
        color: AppColors.mainWhite,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: Icon(
          FontAwesomeIcons.sliders,
          color: AppColors.mainYellow,
          size: 22.sp,
        ),
      ),
    );
  }

  BlocBuilder<CalendarCubit, CalendarState> _buildCalendar() {
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
