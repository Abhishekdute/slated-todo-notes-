import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import '../../../utils/colors.dart';

class DrawingPad extends StatefulWidget {
  const DrawingPad({super.key});

  @override
  State<DrawingPad> createState() => _DrawingPadState();
}

class _DrawingPadState extends State<DrawingPad> {
  late SignatureController _controller;
  Color _selectedColor = AppColors.primary;
  double _strokeWidth = 3.0;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _controller = SignatureController(
      penStrokeWidth: _strokeWidth,
      penColor: _selectedColor,
      exportBackgroundColor: Colors.white,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _saveDrawing() async {
    if (_controller.isEmpty) {
      Navigator.pop(context);
      return;
    }

    final Uint8List? data = await _controller.toPngBytes();
    if (data != null) {
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/drawing_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(path);
      await file.writeAsBytes(data);
      Navigator.pop(context, path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Handwriting / Drawing"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveDrawing,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[200],
              child: Signature(
                controller: _controller,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          _buildToolBar(),
        ],
      ),
    );
  }

  Widget _buildToolBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.circle, color: _selectedColor),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Pick a color'),
                  content: SingleChildScrollView(
                    child: BlockPicker(
                      pickerColor: _selectedColor,
                      onColorChanged: (color) {
                        setState(() {
                          _selectedColor = color;
                          // In some versions we have to recreate or use points
                          // For simplicity in this version, let's see if we can just update
                          // If setters are missing, we might need a different approach
                          // but usually points keep their own color.
                          // Recreating controller loses points.
                          // Let's assume the user wants to change color for NEXT strokes.
                          _controller = SignatureController(
                            penStrokeWidth: _strokeWidth,
                            penColor: _selectedColor,
                            exportBackgroundColor: Colors.white,
                            points: _controller.points,
                          );
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.cleaning_services),
            onPressed: () => _controller.clear(),
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: () => _controller.undo(),
          ),
          Expanded(
            child: Slider(
              value: _strokeWidth,
              min: 1.0,
              max: 10.0,
              onChanged: (val) {
                setState(() {
                  _strokeWidth = val;
                  _controller = SignatureController(
                    penStrokeWidth: _strokeWidth,
                    penColor: _selectedColor,
                    exportBackgroundColor: Colors.white,
                    points: _controller.points,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
