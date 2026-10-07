import 'package:todo/database/database.dart';
import 'package:todo/database/todo.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'manage_tasks_screen.dart';

class HomeScreen extends StatefulWidget {
  final String name;

  const HomeScreen({super.key, required this.name});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userName;
  List<Todo>? tasks;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('name') ?? '';
      tasks = HiveService().getTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    //if (tasks == null) tasks =[];
    tasks ??=[];
      int tasksIsFalse =tasks!.where((task) => task.isComplete == false).length;
      int tasksIsTrue =tasks!.length - tasksIsFalse;
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
            Container(
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xff354B6C),
              ),
              child: Column(
                children: [
                  Text(
                    'Welcome $userName',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20,color: Color(0xFFF0F4F8)),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.greenAccent[100],
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.task_rounded),
                              Text(
                                '$tasksIsTrue',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                'Done',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.redAccent[100],
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.incomplete_circle),
                              Text(
                                '$tasksIsFalse',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                'To-Done',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            printTasks(context),
          ],
        ),
      ),
      floatingActionButton: InkWell(
        onTap: () async {
          //Navigator.pushNamed(context, '/add_task');
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ManageTask(
                    title: 'Add Task',
                    titleButton: "Save",
                    hintText: "What needs to be done?",
                    iconData: Icons.note_add_outlined,
                  ),
            ),
          );
          if (result == true) {
            loadUserData();
          }
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
          child: Icon(Icons.add_task_sharp, size: 40, color: Colors.white),
        ),
      ),
    );
  }

  Widget printTasks(BuildContext context) {
    bool isTasksEmpty = tasks?.isEmpty ?? true;
    return isTasksEmpty
        ? Container(
      width: double.infinity,
      padding: EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.blueAccent[100],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'No tasks for today!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            'No tasks for today!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    )
        : Expanded(
      child: ListView.builder(
        itemCount: tasks!.length,
        itemBuilder: (context, index) {
          final task = tasks![index];
          return InkWell(
            onTap: (){
              showDetailsDialog(
                context,
                task.title,
                task.details,
                task.isComplete ? "Done" : "ToDo",
              );
            },
            child: Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.only(bottom: 10.0),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (task.isComplete) InkWell(
                          onTap: () async{
                            setState(() {
                              task.isComplete=false;
                            });
                            await HiveService().updateTask(index, task);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent[100],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'Done',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ) else InkWell(
                          onTap: () async{
                            setState(() {
                              task.isComplete=true;
                            });
                            await HiveService().updateTask(index, task);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 6.0,
                              horizontal: 8.0,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.redAccent[100],
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              'ToDo',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                        Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          onPressed: () async {
                            await HiveService().deleteTask(index);
                            setState(() {
                              tasks?.remove(task);
                            });
                          },
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                        ),
                        IconButton(
                          onPressed: () async{
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageTask(
                                  title: 'Edit Task',
                                  titleButton: 'Update',
                                  hintText: 'Update your task details',
                                  iconData: Icons.note_alt_outlined,
                                  taskText: task.title,
                                  taskDetails: task.details,
                                  index: index,
                                  isDone: task.isComplete,
                                ),
                              ),
                            );
                            if (result == true) {
                              loadUserData();
                            }

                          },
                          icon: Icon(Icons.edit),
                          color: Colors.blueGrey,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void showDetailsDialog(BuildContext context, String title, String details, String isComplete) {
    showDialog(
      context: context,
      barrierDismissible: true, // تتيح إغلاق النافذة عند الضغط خارجها
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                isComplete,
                style: TextStyle(
                  color: (isComplete=="Done" ? Colors.green : Colors.red),
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          // 2. التفاصيل (تأتي أسفل العنوان تلقائياً)
          content: Text(
            details,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          // أزرار التحكم بأسفل النافذة
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق النافذة
              },
              child: Center(
                child: const Text(
                  'إغلاق',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}
