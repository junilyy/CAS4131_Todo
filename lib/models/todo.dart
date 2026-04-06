class Todo {
  const Todo({required this.id, required this.title, this.isDone = false});

  final String id;
  final String title;
  final bool isDone;
}
