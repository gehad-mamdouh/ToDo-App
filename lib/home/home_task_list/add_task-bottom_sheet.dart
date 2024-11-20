import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/firebase_utils.dart';
import 'package:todo/models/task_model.dart';
import 'package:todo/provider/auth_user_provider.dart';
import 'package:todo/provider/list_provider.dart';

import '../../provider/theme_provider.dart';

class AddTaskBottomSheet extends StatefulWidget {
  const AddTaskBottomSheet({super.key});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String title = '';
  String description = '';
  late ListProvider listProvider;

  @override
  Widget build(BuildContext context) {
    listProvider = Provider.of<ListProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add New Task',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: themeProvider.isDarkMode ? Colors.white : Colors.black),
          ),
          Form(
            key: formKey,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please enter task title';
                      }
                      return null;
                    },
                    onChanged: (text) {
                      title = text;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter task title',
                      hintStyle: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Enter task description',
                      hintStyle: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onChanged: (text) {
                      description = text;
                    },
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Please enter task description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10.0),
                  InkWell(
                    onTap: showCalendar,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Select date',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.blue,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: showCalendar,
                      child: Text(
                        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    onPressed: addTask,
                    child: Text('Add',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: themeProvider.isDarkMode
                                ? Colors.black
                                : Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addTask() {
    if (formKey.currentState?.validate() == true) {
      Task task = Task(
        title: title,
        dateTime: selectedDate,
        description: description,
      );
      var authProvider = Provider.of<AuthUserProvider>(context, listen: false);
      FirebaseUtils.addTaskToFireStore(task, authProvider.currentUser!.id!)
          .then((value) {
        print('Task added successfully');
        listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
        Navigator.pop(context);
      });
      print('Task added successfully');
      listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
      Navigator.pop(context);
    }
  }

  void showCalendar() async {
    var chosenDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (chosenDate != null) {
      setState(() {
        selectedDate = chosenDate;
      });
    }
  }
}
