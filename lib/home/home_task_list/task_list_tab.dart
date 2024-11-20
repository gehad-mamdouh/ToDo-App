import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/home/home_task_list/task_list_item.dart';
import 'package:todo/provider/auth_user_provider.dart';
import 'package:todo/provider/list_provider.dart';

import '../../models/task_model.dart';
import '../../provider/theme_provider.dart';

class TaskListTab extends StatefulWidget {
  const TaskListTab({super.key});

  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  List<Task> tasksList = [];

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthUserProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.isDarkMode;

    if (listProvider.taskList.isEmpty) {
      listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
    }

    return Column(
      children: [
        DefaultTextStyle(
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          child: EasyDateTimeLine(
            locale: 'en',
            initialDate: listProvider.selectDate,
            onDateChange: (selectedDate) {
              listProvider.changeSelectDate(
                  selectedDate, authProvider.currentUser!.id!);
            },
            headerProps: const EasyHeaderProps(
              monthPickerType: MonthPickerType.switcher,
              dateFormatter: DateFormatter.fullDateDMY(),
            ),
            dayProps: EasyDayProps(
              dayStructure: DayStructure.dayStrDayNum,
              activeDayStyle: DayStyle(
                decoration: BoxDecoration(
                  color: themeProvider.isDarkMode ? Colors.black : Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xff0d2983),
                      Colors.white,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return TaskListItem(
                task: listProvider.taskList[index],
              );
            },
            itemCount: listProvider.taskList.length,
          ),
        ),
      ],
    );
  }
}
