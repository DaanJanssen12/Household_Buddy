import 'package:flutter/material.dart';
import 'package:household_buddy/models/task.dart';
import 'package:household_buddy/providers/gold_provider.dart';
import 'package:household_buddy/services/auth_service.dart';
import 'package:household_buddy/services/task_service.dart';
import 'package:provider/provider.dart';

class HouseholdTasksPage extends StatefulWidget {
  final AuthService authService;
  final TaskService taskService;
  final String householdId;

  HouseholdTasksPage(
      {required this.authService,
      required this.taskService,
      required this.householdId});

  @override
  _HouseholdTasksPageState createState() => _HouseholdTasksPageState();
}

class _HouseholdTasksPageState extends State<HouseholdTasksPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Task> tasks = [];
  TaskType selectedType = TaskType.daily;
  TaskDifficulty selectedDifficulty = TaskDifficulty.easy;
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedType = TaskType.values[_tabController.index];
      });
    });
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    var _tasks = await widget.taskService.getTasks(widget.householdId);
    setState(() {
      tasks = _tasks;
    });
  }

  void _addTask() async {
    if (taskController.text.isNotEmpty) {
      var task = Task(
          name: taskController.text,
          type: selectedType,
          difficulty: selectedDifficulty,
          isCompleted: false);
      var userId = (await widget.authService.getUser()).$id;
      var taskId =
          await widget.taskService.createTask(userId, widget.householdId, task);
      if (taskId != null) {
        task.setId(taskId);
        setState(() {
          tasks.add(task);
          taskController.clear();
        });
        Navigator.of(context).pop();
      }
    }
  }

  void _completeTask(int index) async {
    if (tasks[index].id != null) {
      await widget.taskService.completeTask(tasks[index].id.toString());
    }
    setState(() {
      tasks[index].complete();
    });
    Provider.of<GoldProvider>(context, listen: false)
        .addGold(widget.householdId, tasks[index].getValue());
  }

  void _removeTask(int index) async {
    if (tasks[index].id != null) {
      await widget.taskService.deleteTask(tasks[index].id.toString());
    }
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _showAddTaskPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add New Task",
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  )), // Uses headlineLarge text style from the theme
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: taskController,
                decoration: InputDecoration(hintText: "Task name"),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<TaskType>(
                value: selectedType,
                decoration: InputDecoration(labelText: "Task Type"),
                items: TaskType.values.map((TaskType type) {
                  return DropdownMenuItem<TaskType>(
                    value: type,
                    child: Text(type.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedType = value!;
                  });
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<TaskDifficulty>(
                value: selectedDifficulty,
                decoration: InputDecoration(labelText: "Difficulty"),
                items: TaskDifficulty.values.map((TaskDifficulty difficulty) {
                  return DropdownMenuItem<TaskDifficulty>(
                    value: difficulty,
                    child: Text(difficulty.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDifficulty = value!;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: _addTask,
              child: Text("Add Task"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Household Tasks",
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                )), // Uses headlineLarge text style from the theme
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset("assets/Images/buddy1.png", height: 100),
                SizedBox(height: 10),
                Text("You're doing great! Keep it up!",
                    style:
                        Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            )),
              ],
            ),
          ),
          TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Daily"),
              Tab(text: "Weekly"),
              Tab(text: "Incidental"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: TaskType.values.map((type) {
                return ListView.builder(
                  itemCount: tasks.where((t) => t.type == type).length,
                  itemBuilder: (context, index) {
                    var filteredTasks =
                        tasks.where((t) => t.type == type).toList();
                    var task = filteredTasks[index];
                    return Card(
                      color: task.isCompleted ? Colors.grey[300] : null,
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                      child: ListTile(
                        title: Text(task.name),
                        subtitle: Row(
                          children: [
                            Icon(Icons.monetization_on),
                            Text(task.getValue().toString()),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!task.isCompleted)
                              IconButton(
                                icon: Icon(Icons.check_circle,
                                    color: Colors.green),
                                onPressed: () =>
                                    _completeTask(tasks.indexOf(task)),
                              ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeTask(tasks.indexOf(task)),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddTaskPopup,
        child: Icon(Icons.add),
      ),
    );
  }
}
