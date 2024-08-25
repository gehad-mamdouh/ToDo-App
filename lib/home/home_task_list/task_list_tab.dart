import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/home/home_task_list/task_list_item.dart';
import 'package:todo/provider/list_provider.dart';

import '../../task_model.dart';

class TaskListTab extends StatefulWidget {
  TaskListTab({super.key});

  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  List<Task> tasksList = [];

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);
    if (listProvider.taskList.isEmpty) {
      listProvider.getAllTasksFromFireStore();
    }
    return Column(
      children: [
        EasyDateTimeLine(
          locale: 'en',
          initialDate: listProvider.selectDate,
          onDateChange: (selectedDate) {
            listProvider.changeSelectDate(selectedDate);
            //`selectedDate` the new date selected.
          },
          headerProps: const EasyHeaderProps(
            monthPickerType: MonthPickerType.switcher,
            dateFormatter: DateFormatter.fullDateDMY(),
          ),
          dayProps: const EasyDayProps(
            dayStructure: DayStructure.dayStrDayNum,
            activeDayStyle: DayStyle(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xff3371FF),
                    Color(0xff8426D6),
                  ],
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
        )
      ],
    );
  }
}
