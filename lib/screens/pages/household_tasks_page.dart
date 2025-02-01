import 'package:flutter/material.dart';
import 'package:household_buddy/providers/gold_provider.dart';
import 'package:provider/provider.dart';

class HouseholdTasksPage extends StatefulWidget {
  @override
  _HouseholdTasksPageState createState() => _HouseholdTasksPageState();
}

class _HouseholdTasksPageState extends State<HouseholdTasksPage> {
  List<String> tasks = ["Dishes", "Vacuuming", "Take out the trash"];
  TextEditingController taskController = TextEditingController();

  void _addTask() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        tasks.add(taskController.text);
        taskController.clear();
      });
    }
  }

  void _removeTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });

    Provider.of<GoldProvider>(context, listen: false).addGold(10);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Household Tasks"),
      ),
      body: Column(
        children: [
          // Buddy cheering at the top
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset("assets/Images/buddy1.png", height: 100),
                SizedBox(height: 10),
                Text("You're doing great! Keep it up!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          
          // Task Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: InputDecoration(hintText: "Add a new task"),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.blue),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          
          // Task List
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 16),
                  child: ListTile(
                    title: Text(tasks[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => _removeTask(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
