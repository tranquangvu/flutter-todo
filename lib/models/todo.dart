class Todo {
  final int id;
  final String title;
  final bool isDone;
  final int taskId;

  Todo({
    required this.id,
    required this.title,
    required this.isDone,
    required this.taskId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      'taskId': taskId,
    };
  }

  @override
  String toString() {
    return 'Dog{id: $id, title: $title, isDone: $isDone, taskId: $taskId}';
  }
}
