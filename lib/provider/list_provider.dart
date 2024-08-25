import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todo/task_model.dart';

import '../firebase_utils.dart';

class ListProvider extends ChangeNotifier {
  List<Task> taskList = [];
  DateTime selectDate = DateTime.now();

  void getAllTasksFromFireStore() async {
    QuerySnapshot<Task> querySnapshot =
        await FirebaseUtils.getTasksCollection().get();

    taskList = querySnapshot.docs.map((doc) => doc.data()).toList();

    taskList = taskList.where((task) {
      return selectDate.day == task.dateTime.day &&
          selectDate.month == task.dateTime.month &&
          selectDate.year == task.dateTime.year;
    }).toList();
    taskList.sort((Task task1, Task task2) {
      return task1.dateTime.compareTo(task2.dateTime);
    });

    notifyListeners();
  }

  void changeSelectDate(DateTime newSelectDate) {
    selectDate = newSelectDate;
    getAllTasksFromFireStore();
  }
}
