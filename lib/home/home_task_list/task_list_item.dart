import 'package:flutter/material.dart';
import 'package:todo/home/app_colors.dart';

class TaskListItem extends StatelessWidget {
  const TaskListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: AppColors.whiteColor, borderRadius: BorderRadius.circular(22)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: EdgeInsets.all(12),
            width: 4,
            height: MediaQuery.of(context).size.height * .09,
            color: AppColors.primaryColor,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Title',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primaryColor, fontWeight: FontWeight.w500),
              ),
              Text(
                'desc',
                style: TextStyle(fontSize: 16, color: AppColors.blackColor),
              )
            ],
          )),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: MediaQuery.of(context).size.height * .01,
                horizontal: MediaQuery.of(context).size.height * .03),
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
    );
  }
}
