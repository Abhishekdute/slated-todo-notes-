import 'package:hive/hive.dart';

part 'note_model.g.dart';

@HiveType(typeId: 2)
class NoteModel extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String content;

  @HiveField(2)
  DateTime createdAt;

  @HiveField(3)
  String? imagePath;

  @HiveField(4)
  String? handwritingPath;

  @HiveField(5)
  int colorValue;

  NoteModel({
    required this.title,
    required this.content,
    required this.createdAt,
    this.imagePath,
    this.handwritingPath,
    this.colorValue = 0xFFFFFFFF,
  });
}
