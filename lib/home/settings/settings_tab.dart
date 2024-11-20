import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/home/app_colors.dart';

import '../../provider/theme_provider.dart';

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: themeProvider.isDarkMode
                ? Color(0xff1A1A1A) // لون الخلفية في وضع الدارك
                : Colors.white, // لون الخلفية في وضع الفاتح
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            themeProvider.isDarkMode
                                ? Icons.dark_mode
                                : Icons.light_mode,
                            color: themeProvider.isDarkMode
                                ? Colors.amber
                                : Colors.blueAccent,
                          ),
                          SizedBox(width: 8),
                          Text(
                            themeProvider.isDarkMode
                                ? 'Dark Mode'
                                : 'Light Mode',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontSize: 18,
                                  color: themeProvider.isDarkMode
                                      ? Colors.white
                                      : AppColors.blackColor,
                                ),
                          ),
                        ],
                      ),
                      Transform.scale(
                        scale: 1.2,
                        child: Switch(
                          value: themeProvider.isDarkMode,
                          activeColor: Colors.amber,
                          inactiveThumbColor: Colors.blueAccent,
                          onChanged: (value) {
                            themeProvider.toggleTheme(value);
                          },
                        ),
                      ),
                    ],
                  ),
                  Divider(thickness: 1, height: 30),
                  ElevatedButton.icon(
                    onPressed: () {
                      themeProvider.toggleTheme(!themeProvider.isDarkMode);
                    },
                    icon: Icon(
                      themeProvider.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: Colors.white,
                    ),
                    label: Text(
                      themeProvider.isDarkMode
                          ? 'Switch to Light Mode'
                          : 'Switch to Dark Mode',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeProvider.isDarkMode
                          ? Colors.black54
                          : Colors.blueAccent,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
