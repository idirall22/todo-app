import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './task.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo app',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: MyHomePage(title: 'Todo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final controller = TextEditingController();
  // platform used to call native methods
  final platform = const MethodChannel("todo");

  List<Map<dynamic, dynamic>> tasks = new List<Map<dynamic, dynamic>>();

  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (_, int index) => ListTodo(
                this.tasks[index]["id"],
                this.tasks[index]["content"],
                this.tasks[index]["done"],
                this.setTaskStatus,
                this.updateTask,
                this.deleteTask,
              ),
          itemCount: this.tasks.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Add a task"),
                  content: Container(
                    height: 100,
                    child: Column(
                      children: <Widget>[
                        TextField(
                          autofocus: true,
                          controller: controller,
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    FlatButton(
                        onPressed: () {
                          this.addTask(controller.text);
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          "Add",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, color: Colors.black),
                        ))
                  ],
                );
              });
        },
        tooltip: 'Add task',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  updateTasksList() {
    setState(() {
      this.getTasks().then((tasks) {
        print(tasks);
        setState(() {
          this.tasks = tasks;
        });
      });
    });
  }

  addTask(String content) async {
    try {
      await platform.invokeMethod("addTask", content);
      print("Add task");
    } catch (e) {
      print("Error add task");
      print(e);
    }
    this.updateTasksList();
    this.controller.clear();
  }

  Future<List<Map<dynamic, dynamic>>> getTasks() async {
    List<dynamic> tasks = new List<dynamic>();
    try {
      tasks = await platform.invokeMethod("getTasks");
    } catch (e) {
      print("Error get tasks");
      print(e);
    }
    print(tasks);

    final out = tasks.cast<Map<dynamic, dynamic>>();
    return out;
  }

  deleteTask(int id) async {
    try {
      await platform.invokeMethod("deleteTask", id);
      this.updateTasksList();
      print("deleted");
    } catch (e) {
      print("Error delete");
      print(e);
    }
  }

  updateTask(int id, String content) async {
    try {
      await platform.invokeMethod("updateTask", [id, content]);
      print("update");
    } catch (e) {
      print("Error update");
      print(e);
    }
    this.updateTasksList();
  }

  setTaskStatus(int id) async {
    try {
      await platform.invokeMethod("setStatus", id);
      print("set status");
    } catch (e) {
      print("Error set status");
      print(e);
    }
    this.updateTasksList();
  }
}
