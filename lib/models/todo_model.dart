import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';

part 'todo_model.g.dart';

@HiveType(typeId: 0)
class TodoModel extends HiveObject {
  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAtTime,
    required this.createdAtDate,
    required this.isCompleted,
    this.imagePath,
    this.handwritingPath,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime createdAtTime;

  @HiveField(4)
  DateTime createdAtDate;

  @HiveField(5)
  bool isCompleted;

  @HiveField(6)
  String? imagePath;

  @HiveField(7)
  String? handwritingPath;

  factory TodoModel.create({
    required String? title,
    required String? description,
    DateTime? createdAtTime,
    DateTime? createdAtDate,
    String? imagePath,
    String? handwritingPath,
  }) =>
      TodoModel(
        id: const Uuid().v1(),
        title: title ?? "",
        description: description ?? "",
        createdAtTime: createdAtTime ?? DateTime.now(),
        isCompleted: false,
        createdAtDate: createdAtDate ?? DateTime.now(),
        imagePath: imagePath,
        handwritingPath: handwritingPath,
      );
}
