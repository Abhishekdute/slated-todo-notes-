import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_manager.dart';
import '../../../core/user/user_manager.dart';
import '../../../utils/colors.dart';
import '../../profile/profile_edit_view.dart';
import '../../notes/notes_view.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);
    final userManager = Provider.of<UserManager>(context);
    final isDark = themeManager.isDarkMode;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.1))),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Profile Section
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileEditView()),
                  );
                },
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: AppColors.primary.withOpacity(0.1),
                            backgroundImage: userManager.profilePic != null
                                ? FileImage(File(userManager.profilePic!))
                                : null,
                            child: userManager.profilePic == null
                                ? const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: AppColors.primary,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userManager.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      userManager.email,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              const Divider(indent: 20, endIndent: 20),
              const SizedBox(height: 10),

              _buildDrawerItem(
                icon: Icons.task_alt_rounded,
                title: "Tasks",
                onTap: () => Navigator.pop(context),
              ),

              _buildDrawerItem(
                icon: Icons.note_alt_outlined,
                title: "Notes",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NotesView()),
                  );
                },
              ),

              const SizedBox(height: 10),
              const Divider(indent: 20, endIndent: 20),

              _buildDrawerItem(
                icon: isDark ? Icons.dark_mode : Icons.light_mode,
                title: "Dark Mode",
                trailing: Switch(
                  value: isDark,
                  onChanged: (val) => themeManager.toggleTheme(),
                  activeThumbColor: AppColors.primary,
                ),
                onTap: () => themeManager.toggleTheme(),
              ),

              _buildDrawerItem(
                icon: Icons.logout_rounded,
                title: "Exit App",
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Exit"),
                      content: const Text(
                        "Are you sure you want to close the app?",
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () => SystemNavigator.pop(),
                          child: const Text(
                            "Exit",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const Text(
                      "Slated",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      "v2.1.0",
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary.withOpacity(0.8)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
    );
  }
}
