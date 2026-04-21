import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart';

import '../../core/user/user_manager.dart';
import '../../main.dart';
import '../../models/note_model.dart';
import '../../utils/colors.dart';
import '../tasks/widgets/drawing_pad.dart';

class NoteEditView extends StatefulWidget {
  final NoteModel? note;
  const NoteEditView({super.key, this.note});

  @override
  State<NoteEditView> createState() => _NoteEditViewState();
}

class _NoteEditViewState extends State<NoteEditView> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  String? _imagePath;
  String? _handwritingPath;
  int _selectedColor = 0xFFFFFFFF;

  final List<int> _colors = [
    0xFFFFFFFF, // White
    0xFFF28B82, // Red
    0xFFFBBC04, // Orange
    0xFFFFF475, // Yellow
    0xFFCCFF90, // Green
    0xFFA7FFEB, // Teal
    0xFFCBF0F8, // Blue
    0xFFAFCBEE, // Dark Blue
    0xFFD7AEFB, // Purple
    0xFFFDCFE8, // Pink
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? "");
    _contentController = TextEditingController(
      text: widget.note?.content ?? "",
    );
    _imagePath = widget.note?.imagePath;
    _handwritingPath = widget.note?.handwritingPath;
    _selectedColor = widget.note?.colorValue ?? 0xFFFFFFFF;
  }

  Future<void> _pickImage() async {
    final XFile? image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image != null) {
      setState(() => _imagePath = image.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? Color(_selectedColor).withOpacity(0.1)
        : Color(_selectedColor);

    return Scaffold(
      backgroundColor: isDark
          ? Theme.of(context).scaffoldBackgroundColor
          : backgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            onPressed: _showColorPicker,
          ),
          IconButton(
            icon: const Icon(Icons.image_outlined),
            onPressed: _pickImage,
          ),
          IconButton(
            icon: const Icon(Icons.gesture_rounded),
            onPressed: () async {
              final path = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DrawingPad()),
              );
              if (path != null) setState(() => _handwritingPath = path);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${DateTime.now().day} ${_getMonth(DateTime.now().month)} | ${TimeOfDay.now().format(context)}",
              style: TextStyle(
                color: AppColors.textSecondary.withOpacity(0.6),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
            if (_imagePath != null || _handwritingPath != null) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    if (_imagePath != null)
                      _buildAttachmentPreview(_imagePath!, true),
                    if (_handwritingPath != null)
                      _buildAttachmentPreview(_handwritingPath!, false),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            TextField(
              controller: _contentController,
              maxLines: null,
              style: const TextStyle(fontSize: 18, height: 1.6),
              decoration: const InputDecoration(
                hintText: "Start typing...",
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveNote,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.check_rounded, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildAttachmentPreview(String path, bool isImage) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: FileImage(File(path)), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
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
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 16, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Background Color",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _colors.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedColor = _colors[index]);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Color(_colors[index]),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.3),
                          ),
                        ),
                        child: _selectedColor == _colors[index]
                            ? const Icon(Icons.check, size: 20)
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }

  void _saveNote() {
    if (_titleController.text.isEmpty && _contentController.text.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final dataService = BaseWidget.of(context).dataService;
    if (widget.note == null) {
      final note = NoteModel(
        title: _titleController.text,
        content: _contentController.text,
        createdAt: DateTime.now(),
        imagePath: _imagePath,
        handwritingPath: _handwritingPath,
        colorValue: _selectedColor,
      );
      dataService.addNote(note);
    } else {
      widget.note!.title = _titleController.text;
      widget.note!.content = _contentController.text;
      widget.note!.imagePath = _imagePath;
      widget.note!.handwritingPath = _handwritingPath;
      widget.note!.colorValue = _selectedColor;
      dataService.updateNote(widget.note!);
    }
    Navigator.pop(context);
  }
}
