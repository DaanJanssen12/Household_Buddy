enum TaskType { daily, weekly, incidental }
enum TaskDifficulty { easy, medium, hard }

class Task
{
  final String name;
  final TaskType type;
  final TaskDifficulty difficulty;
  late bool isCompleted;
  late String? id;

  Task({required this.name, required this.type, required this.difficulty, required this.isCompleted, this.id});

  static Task fromMap(String id, Map<String, dynamic> map){
    print(map['dateCompleted']);
    String? dateCompletedStr = map['dateCompleted'];
    DateTime? dateCompleted = null;
    if(dateCompletedStr != null){
      dateCompleted = DateTime.parse(dateCompletedStr);
    }
    bool isCompleted = false;
    TaskType type = stringToTaskType(map['type']);
    if(dateCompleted == null){
      isCompleted = false;
    }
    else{
      switch(type){
        case TaskType.daily:
          isCompleted = isToday(dateCompleted);
          break;
        case TaskType.weekly:
          isCompleted = isThisWeek(dateCompleted);
          break;
        case TaskType.incidental:
          isCompleted = true;
          break;
      }
    }
    return Task(
      id: id,
      name: map['name'], 
      type: type, 
      difficulty: stringToDifficulty(map['difficulty']), 
      isCompleted: isCompleted);
  }

  void setId(String _id){
    id = _id;
  }
  void complete(){
    isCompleted = true;
  }

  int getValue(){

    double difficultyModifier = 1.0;
    switch(difficulty){
      case TaskDifficulty.easy:
      difficultyModifier = 1;
      break;
      case TaskDifficulty.medium:
      difficultyModifier = 1.5;
      break;
      case TaskDifficulty.hard:
      difficultyModifier = 2;
      break;
    }

    int baseVal = 5;
    switch(type){
      case TaskType.daily:
        baseVal = 5;
        break;
        case TaskType.weekly:
        baseVal = 10;
        break;
        case TaskType.incidental:
        baseVal = 20;
        break;
    }

    return (baseVal * difficultyModifier).round();
  }
}

bool isToday(DateTime date) {
  DateTime today = DateTime.now();
  return date.year == today.year && date.month == today.month && date.day == today.day;
}

bool isThisWeek(DateTime date) {
  DateTime today = DateTime.now();
  int dayOfWeek = today.weekday; // 1=Monday, 7=Sunday
  DateTime startOfWeek = today.subtract(Duration(days: dayOfWeek - 1)); // Get the start of the week (Monday)
  DateTime endOfWeek = startOfWeek.add(Duration(days: 6)); // Get the end of the week (Sunday)

  return date.isAfter(startOfWeek) && date.isBefore(endOfWeek.add(Duration(days: 1)));
}

String taskTypeToString(TaskType type) {
  return type.toString().split('.').last;
}

TaskType stringToTaskType(String type) {
  return TaskType.values.firstWhere((e) => e.toString().split('.').last == type);
}

String difficultyToString(TaskDifficulty type) {
  return type.toString().split('.').last;
}

TaskDifficulty stringToDifficulty(String type) {
  return TaskDifficulty.values.firstWhere((e) => e.toString().split('.').last == type);
}