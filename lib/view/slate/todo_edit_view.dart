import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../core/user/user_manager.dart';
import '../../main.dart';
import '../../models/todo_model.dart';
import '../../utils/colors.dart';
import 'widgets/drawing_pad.dart';

class TodoEditView extends StatefulWidget {
  final TodoModel? task;
  const TodoEditView({super.key, this.task});

  @override
  State<TodoEditView> createState() => _TodoEditViewState();
}

class _TodoEditViewState extends State<TodoEditView> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  DateTime? _selectedTime;
  String? _imagePath;
  String? _handwritingPath;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? "");
    _descController = TextEditingController(text: widget.task?.description ?? "");
    _selectedTime = widget.task?.createdAtTime;
    _imagePath = widget.task?.imagePath;
    _handwritingPath = widget.task?.handwritingPath;
  }

  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _imagePath = image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserManager>(context);
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        title: Text(
          widget.task == null ? "Create New Task" : "Edit Task", 
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20)
        ),
        actions: [
          _buildUserProfileHeader(user),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title Input
                FadeInDown(
                  duration: const Duration(milliseconds: 400),
                  child: TextField(
                    controller: _titleController,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5),
                    decoration: InputDecoration(
                      hintText: "What needs to be done?",
                      hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.4)),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                
                const SizedBox(height: 10),
                
                // Description Input
                FadeInDown(
                  delay: const Duration(milliseconds: 100),
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 120),
                    child: TextField(
                      controller: _descController,
                      maxLines: null,
                      style: const TextStyle(fontSize: 16, height: 1.5),
                      decoration: InputDecoration(
                        hintText: "Add some details or notes...",
                        hintStyle: TextStyle(color: AppColors.textSecondary.withOpacity(0.5), fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                
                // Premium Quick Actions (Floating bar style)
                FadeInUp(
                  delay: const Duration(milliseconds: 200),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildPremiumAction(
                          icon: Icons.image_rounded,
                          label: "Image",
                          color: Colors.blue,
                          onTap: _pickImage,
                          isActive: _imagePath != null,
                          index: 0,
                        ),
                        _buildPremiumAction(
                          icon: Icons.gesture_rounded,
                          label: "Write",
                          color: Colors.orange,
                          onTap: () async {
                            final path = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const DrawingPad()),
                            );
                            if (path != null) setState(() => _handwritingPath = path);
                          },
                          isActive: _handwritingPath != null,
                          index: 1,
                        ),
                        _buildPremiumAction(
                          icon: Icons.alarm_rounded,
                          label: _selectedTime == null ? "Alarm" : DateFormat('jm').format(_selectedTime!),
                          color: Colors.purple,
                          onTap: () {
                            DatePicker.showTimePicker(
                              context,
                              showTitleActions: true,
                              onConfirm: (date) => setState(() => _selectedTime = date),
                              currentTime: DateTime.now(),
                            );
                          },
                          isActive: _selectedTime != null,
                          index: 2,
                        ),
                      ],
                    ),
                  ),
                ),

                if (_imagePath != null || _handwritingPath != null) ...[
                  const SizedBox(height: 30),
                  const Text(
                    "ATTACHMENTS", 
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.textSecondary, letterSpacing: 1.2)
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      if (_imagePath != null) _buildAttachmentPreview(_imagePath!, isImage: true),
                      if (_handwritingPath != null) _buildAttachmentPreview(_handwritingPath!, isImage: false),
                    ],
                  ),
                ],

                const SizedBox(height: 120), // Space for save button
              ],
            ),
          ),
          
          // Bottom Save Button
          Align(
            alignment: Alignment.bottomCenter,
            child: FadeInUp(
              delay: const Duration(milliseconds: 300),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).scaffoldBackgroundColor.withOpacity(0),
                      Theme.of(context).scaffoldBackgroundColor,
                    ],
                  ),
                ),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: AppColors.premiumGradient),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _saveTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Text(
                      "SAVE TASK",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 1.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileHeader(UserManager user) {
    return ZoomIn(
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 2),
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundColor: AppColors.primary.withOpacity(0.1),
          child: user.profilePic == null 
              ? const Icon(Icons.person, size: 20, color: AppColors.primary) 
              : ClipOval(child: Image.file(File(user.profilePic!), width: 40, height: 40, fit: BoxFit.cover)),
        ),
      ),
    );
  }

  Widget _buildPremiumAction({
    required IconData icon, 
    required String label, 
    required Color color,
    required VoidCallback onTap, 
    required bool isActive,
    required int index,
  }) {
    return ElasticIn(
      delay: Duration(milliseconds: 400 + (index * 100)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isActive ? color : color.withOpacity(0.1),
                shape: BoxShape.circle,
                boxShadow: isActive ? [
                  BoxShadow(color: color.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 8))
                ] : [],
              ),
              child: Icon(
                icon, 
                size: 28, 
                color: isActive ? Colors.white : color
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label, 
            style: TextStyle(
              fontSize: 12, 
              fontWeight: FontWeight.w800, 
              color: isActive ? color : AppColors.textSecondary,
              letterSpacing: 0.5,
            )
          ),
        ],
      ),
    );
  }

  Widget _buildAttachmentPreview(String path, {required bool isImage}) {
    return ZoomIn(
      child: Stack(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
              ],
              image: DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover),
              border: Border.all(color: Colors.white, width: 3),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: () => setState(() {
                if (isImage) {
                  _imagePath = null;
                } else {
                  _handwritingPath = null;
                }
              }),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                child: const Icon(Icons.close_rounded, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveTask() {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Title is required!"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
      );
      return;
    }

    final dataService = BaseWidget.of(context).dataService;
    
    if (widget.task == null) {
      final task = TodoModel.create(
        title: _titleController.text,
        description: _descController.text,
        createdAtTime: _selectedTime ?? DateTime.now(),
        createdAtDate: _selectedTime ?? DateTime.now(),
        imagePath: _imagePath,
        handwritingPath: _handwritingPath,
      );
      dataService.addTask(task);
    } else {
      widget.task!.title = _titleController.text;
      widget.task!.description = _descController.text;
      widget.task!.createdAtTime = _selectedTime ?? widget.task!.createdAtTime;
      widget.task!.imagePath = _imagePath;
      widget.task!.handwritingPath = _handwritingPath;
      dataService.updateTask(widget.task!);
    }
    Navigator.pop(context);
  }
}
