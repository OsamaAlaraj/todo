import 'package:todo/database/database.dart';
import 'package:todo/database/todo.dart';
import 'package:flutter/material.dart';

class ManageTask extends StatefulWidget {
  final String title;
  final String titleButton;
  final String hintText;
  final IconData? iconData;
  final String? taskText;
  final String? taskDetails;
  final int? index;
  final bool isDone;

  const ManageTask({
    super.key,
    required this.title,
    required this.titleButton,
    required this.hintText,
    this.iconData,
    this.taskText,
    this.taskDetails,
    this.index,
    this.isDone = false,
  });

  @override
  State<ManageTask> createState() => _ManageTaskState();
}

class _ManageTaskState extends State<ManageTask> {
  List<String> tasks = [];
  TextEditingController taskController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  @override
  void dispose() {
    taskController.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.title == "Edit Task" && widget.taskText != null) {
      taskController.text = widget.taskText!;
      detailsController.text = widget.taskDetails!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tudee',
          style: TextStyle(
            fontFamily: 'CherryBomb',
            fontWeight: FontWeight.w400,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFF08083B),
      ),
      body: Container(
        padding: EdgeInsets.all(24),
        color: Color(0xFFF0F4F8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold,color: Color(0xFF08083B)),
                ),
                Icon(widget.iconData, fontWeight: FontWeight.bold,color: Color(0xFF08083B)),
              ],
            ),

            SizedBox(height: 20),
            TextField(
              controller: taskController,
              decoration: InputDecoration(
                labelText: 'Task Name',
                hintText: widget.hintText,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              controller: detailsController,
              minLines: 5,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: widget.hintText,
                labelText: 'Task Details',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () async {
                String taskName = taskController.text.trim();
                String taskDetails = detailsController.text.trim();
                if (taskName.isEmpty && taskDetails.isEmpty) return;
                if (widget.index != null) {
                  Todo data = Todo(
                    title: taskName,
                    details: taskDetails,
                    isComplete: widget.isDone,
                  );
                  await HiveService().updateTask(widget.index!, data);
                } else {
                  Todo data = Todo(
                    title: taskName,
                    details: taskDetails,
                    isComplete: false,
                  );
                  await HiveService().addTask(data);
                }
                taskController.clear();
                // التحقق من أن الشاشة لا تزال موجودة
                if (!context.mounted) return;
                Navigator.pop(context, true);
              },
              child: Container(
                padding: EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFF08083B),
                ),
                child: Center(
                  child: Text(
                    widget.titleButton,
                    style: TextStyle(color: Color(0xFFF0F4F8)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
