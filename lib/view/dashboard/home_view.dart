import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../../core/user/user_manager.dart';
import '../../main.dart';
import '../../utils/colors.dart';
import '../tasks/todo_edit_view.dart';
import '../widgets/app_logo.dart';
import 'widgets/app_drawer.dart';
import 'widgets/todo_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final GlobalKey<SliderDrawerState> _sliderKey = GlobalKey<SliderDrawerState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserManager>(context);
    final dataService = BaseWidget.of(context).dataService;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SliderDrawer(
        key: _sliderKey,
        animationDuration: 500,
        // Library ke default AppBar ko puri tarah khatam karne ke liye
        appBar: const SizedBox(), 
        slider: const AppDrawer(),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              // --- PREMIUM CUSTOM APP BAR ---
              Container(
                padding: EdgeInsets.only(top: topPadding + 10, left: 10, right: 20, bottom: 10),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Row(
                  children: [
                    // Styled Menu Icon
                    IconButton(
                      onPressed: () => _sliderKey.currentState?.toggle(),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.notes_rounded, size: 28, color: AppColors.primary),
                      ),
                    ),
                    
                    // App Logo & Title
                    Expanded(
                      child: FadeInDown(
                        child: const SlatedLogo(size: 32, showText: true),
                      ),
                    ),
                    
                    // BIG PREMIUM PROFILE PICTURE
                    ZoomIn(
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary.withOpacity(0.15), width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 30, // Kafi bada size (60px total)
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: user.profilePic == null 
                              ? const Icon(Icons.person, size: 30, color: AppColors.primary) 
                              : ClipOval(
                                  child: Image.file(
                                    File(user.profilePic!), 
                                    width: 60, 
                                    height: 60, 
                                    fit: BoxFit.cover
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // --- MAIN CONTENT ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInLeft(child: _buildHeader(user.name)),
                    Expanded(
                      child: ValueListenableBuilder(
                        valueListenable: dataService.listenToTasks(),
                        builder: (context, box, _) {
                          final tasks = box.values.toList();
                          if (tasks.isEmpty) return _buildEmptyState();
                          
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            physics: const BouncingScrollPhysics(),
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              return FadeInUp(
                                delay: Duration(milliseconds: index * 50),
                                child: TodoItemCard(task: tasks[index]),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FadeInRight(
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: AppColors.premiumGradient),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: FloatingActionButton.extended(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TodoEditView())),
            backgroundColor: Colors.transparent,
            elevation: 0,
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
            label: const Text("Create Task", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String name) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 5, 24, 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text("Hey $name", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
              const SizedBox(width: 8),
              const Text("👋", style: TextStyle(fontSize: 24)),
            ],
          ),
          Text(
            "You have things to do today!", 
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w500)
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/lottie/1.json',
            width: 250,
            repeat: true,
          ),
          const SizedBox(height: 20),
          FadeIn(
            delay: const Duration(seconds: 1),
            child: Column(
              children: [
                const Text(
                  "No tasks found!", 
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 8),
                Text(
                  "Tap the button below to add one", 
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 14)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
