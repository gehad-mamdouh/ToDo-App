import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:todo/home/app_colors.dart';
import '../../firebase_utils.dart';
import '../../models/task_model.dart';
import '../../provider/auth_user_provider.dart';
import '../../provider/list_provider.dart';
import '../../provider/theme_provider.dart';

class EditTask extends StatefulWidget {
  static const String routeName = 'EditTaskScreen';

  const EditTask({super.key});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  late ListProvider listProvider;
  Task? task;

  @override
  void initState() {
    super.initState();
    listProvider = Provider.of<ListProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    if (task == null) {
      task = ModalRoute.of(context)!.settings.arguments as Task;
      titleController.text = task!.title ?? "";
      descriptionController.text = task!.description ?? "";
      selectedDate = task!.dateTime ?? DateTime.now();
    }

    var screenSize = MediaQuery.of(context).size;
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'ToDo List',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: themeProvider.isDarkMode ? Colors.black : Colors.white,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Container(
                    height: screenSize.height * 0.1,
                    decoration: BoxDecoration(color: AppColors.primaryColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(top: screenSize.height * .03),
                        padding: EdgeInsets.symmetric(
                          vertical: screenSize.height * .04,
                          horizontal: screenSize.height * .03,
                        ),
                        width: screenSize.width * .85,
                        height: screenSize.height * .7,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: themeProvider.isDarkMode
                              ? Colors.black
                              : Colors.white,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: titleController,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Please enter task title';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Edit task title',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
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
                              ),
                            ),
                            const SizedBox(height: 25.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextFormField(
                                controller: descriptionController,
                                validator: (text) {
                                  if (text == null || text.isEmpty) {
                                    return 'Please enter task description';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Edit task description',
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
                              ),
                            ),
                            const SizedBox(height: 10.0),
                            InkWell(
                              onTap: showCalendar,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Center(
                                  child: Text(
                                    'Select date',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Colors.blue,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                        ),
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
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                          color: themeProvider.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                          fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  editTask();
                                },
                                child: Text('Save Changes',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                            color: themeProvider.isDarkMode
                                                ? Colors.black
                                                : Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void editTask() {
    if (formKey.currentState?.validate() == true) {
      task!.title = titleController.text;
      task!.description = descriptionController.text;
      task!.dateTime = selectedDate;

      var authProvider = Provider.of<AuthUserProvider>(context, listen: false);
      FirebaseUtils.editTask(task!, authProvider.currentUser?.id ?? "")
          .then((value) {
        print('Task edited successfully');
        listProvider.getAllTasksFromFireStore(authProvider.currentUser!.id!);
        Navigator.pop(context);
      }).catchError((error) {
        print('Error editing task: $error');
      });
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
