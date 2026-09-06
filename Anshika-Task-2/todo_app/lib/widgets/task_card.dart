import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskCard extends StatelessWidget {
final Task task;
final VoidCallback onDelete;
final VoidCallback onToggle;
final VoidCallback onEdit;

const TaskCard({
super.key,
required this.task,
required this.onDelete,
required this.onToggle,
required this.onEdit,
});

@override
Widget build(BuildContext context) {
return Card(
margin: const EdgeInsets.only(bottom: 12),
child: ListTile(
contentPadding: const EdgeInsets.all(12),


  
    leading: Checkbox(
      value: task.isCompleted,
      onChanged: (_) => onToggle(),
    ),

  //title
    title: Text(
      task.title,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        decoration:
            task.isCompleted ? TextDecoration.lineThrough : null,
      ),
    ),
    // description
    subtitle: task.description.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              task.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        : null,

    // Edit and Delete
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: onEdit,
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ],
    ),
  ),
);


}
}
