import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/todo_model.dart';
import '../../../utils/colors.dart';
import '../../tasks/todo_edit_view.dart';
import '../../../main.dart';

class TodoItemCard extends StatelessWidget {
  final TodoModel task;
  const TodoItemCard({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final dataService = BaseWidget.of(context).dataService;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Dismissible(
        key: Key(task.id),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => dataService.deleteTask(task),
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.red.shade400,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 28),
        ),
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => TodoEditView(task: task)),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withOpacity(0.05)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        task.isCompleted = !task.isCompleted;
                        dataService.updateTask(task);
                      },
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: task.isCompleted ? AppColors.primary : Colors.transparent,
                          border: Border.all(
                            color: task.isCompleted ? AppColors.primary : AppColors.textSecondary.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: task.isCompleted 
                            ? const Icon(Icons.check, size: 16, color: Colors.white) 
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted ? AppColors.textSecondary : null,
                        ),
                      ),
                    ),
                  ],
                ),
                if (task.description.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 38, top: 4, bottom: 8),
                    child: Text(
                      task.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.4),
                    ),
                  ),
                
                Padding(
                  padding: const EdgeInsets.only(left: 38, top: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 12, color: AppColors.primary),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMM d').format(task.createdAtDate),
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('h:mm a').format(task.createdAtTime),
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary.withOpacity(0.7)),
                      ),
                      const Spacer(),
                      if (task.imagePath != null) 
                        Icon(Icons.image_outlined, size: 16, color: AppColors.textSecondary.withOpacity(0.5)),
                      if (task.handwritingPath != null) ...[
                        const SizedBox(width: 6),
                        Icon(Icons.gesture_rounded, size: 16, color: AppColors.textSecondary.withOpacity(0.5)),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
