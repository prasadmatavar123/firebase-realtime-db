class TodoModel {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
  });

  // Convert Firebase data → TodoModel
  factory TodoModel.fromMap(String id, Map<dynamic, dynamic> map) {
    return TodoModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  // Convert TodoModel → Firebase data
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
    };
  }

  // Create updated Todo
  TodoModel copyWith({
    String? title,
    String? description,
    bool? isCompleted,
  }) {
    return TodoModel(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}