import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/auth/Login/login_screen.dart';
import 'package:todo/home/app_colors.dart';
import 'package:todo/home/home_task_list/add_task-bottom_sheet.dart';
import 'package:todo/home/home_task_list/task_list_tab.dart';
import 'package:todo/home/settings/settings_tab.dart';
import 'package:todo/provider/auth_user_provider.dart';
import 'package:todo/provider/list_provider.dart';
import 'package:todo/provider/theme_provider.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home_screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthUserProvider>(context);
    var listProvider = Provider.of<ListProvider>(context);
    var themeProvider = Provider.of<ThemeProvider>(context);

    Color appBarTextColor =
        themeProvider.isDarkMode ? Colors.black : Colors.white;

    Color logoutIconColor =
        themeProvider.isDarkMode ? Colors.black : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To Do List',
          style: TextStyle(
            color: appBarTextColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              listProvider.taskList = [];
              authProvider.currentUser = null;
              Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
            },
            icon: Icon(
              Icons.logout,
              color: logoutIconColor,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        shape: const CircularNotchedRectangle(),
        notchMargin: 15,
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: ''),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined), label: ''),
          ],
          backgroundColor:
              themeProvider.isDarkMode ? const Color(0xff141922) : Colors.white,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addTaskBottomSheet(themeProvider);
        },
        child: Icon(
          Icons.add,
          color: AppColors.whiteColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Column(
        children: [
          Container(
            color: AppColors.primaryColor,
            width: double.infinity,
            height: 80,
          ),
          Expanded(child: tabs[selectedIndex]),
        ],
      ),
    );
  }

  List<Widget> tabs = [const TaskListTab(), SettingsTab()];

  void addTaskBottomSheet(ThemeProvider themeProvider) {
    showModalBottomSheet(
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
      context: context,
      builder: (context) => AddTaskBottomSheet(),
    );
  }
}
