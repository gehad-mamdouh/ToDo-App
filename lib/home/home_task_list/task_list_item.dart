import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/home/app_colors.dart';
import 'package:todo/provider/list_provider.dart';
import 'package:todo/task_model.dart';

class TaskListItem extends StatelessWidget {
  Task task;

  TaskListItem({required this.task});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var listProvider = Provider.of<ListProvider>(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Slidable(
        startActionPane: ActionPane(
          extentRatio: .25,
          motion: const DrawerMotion(),
          dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (context) {
                FirebaseUtils.deleteTaskFromFireStore(task)
                    .timeout(Duration(seconds: 1), onTimeout: () {
                  print('Task deleted successfully');
                  listProvider.getAllTasksFromFireStore();
                });
              },
              backgroundColor: AppColors.redColor,
              foregroundColor: AppColors.whiteColor,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 4,
                height: height * .09,
                color: AppColors.primaryColor,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      task.description,
                      style:
                          TextStyle(fontSize: 16, color: AppColors.blackColor),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: height * .01,
                  horizontal: height * .03,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppColors.primaryColor,
                ),
                child: Icon(
                  Icons.check,
                  color: AppColors.whiteColor,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}