import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/home/app_colors.dart';
import 'package:todo/home/home_task_list/edit_task.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/provider/list_provider.dart';

import '../../provider/auth_user_provider.dart';
import '../../provider/theme_provider.dart';

class TaskListItem extends StatefulWidget {
  Task task;

  TaskListItem({super.key, required this.task});

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var listProvider = Provider.of<ListProvider>(context);
    var authProvider = Provider.of<AuthUserProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: .25,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (context) {
                Navigator.pushNamed(context, EditTask.routeName,
                    arguments: widget.task);
              },
              backgroundColor: AppColors.greenColor,
              foregroundColor: AppColors.whiteColor,
              icon: Icons.edit,
              label: 'Edit',
            ),
          ],
        ),
        startActionPane: ActionPane(
          extentRatio: .25,
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(15),
              onPressed: (context) {
                FirebaseUtils.deleteTaskFromFireStore(
                        widget.task.id, authProvider.currentUser!.id!)
                    .then((value) {
                  debugPrint('Task deleted successfully');
                  listProvider
                      .getAllTasksFromFireStore(authProvider.currentUser!.id!);
                }).timeout(const Duration(seconds: 1), onTimeout: () {
                  debugPrint('Task deleted successfully');
                  listProvider
                      .getAllTasksFromFireStore(authProvider.currentUser!.id!);
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: themeProvider.isDarkMode ? Colors.black : Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 4,
                height: height * .09,
                color: widget.task.isDone
                    ? AppColors.greenColor
                    : AppColors.primaryColor,
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.task.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: widget.task.isDone
                                ? AppColors.greenColor
                                : AppColors.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      widget.task.description,
                      style: TextStyle(
                          fontSize: 16,
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  var authProvider =
                      Provider.of<AuthUserProvider>(context, listen: false);
                  FirebaseUtils.editIsDone(
                      widget.task, authProvider.currentUser?.id ?? '');
                  widget.task.isDone = !widget.task.isDone;
                  setState(() {});
                },
                child: widget.task.isDone
                    ? Text(
                        'Done!',
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(color: AppColors.greenColor),
                      )
                    : Container(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}