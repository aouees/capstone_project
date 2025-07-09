class Task {
  String title;
  String description;
  bool done;

  Task(this.title, this.description, this.done);

  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String,
        description = json['description'] as String? ?? '',
        done = json['done'] as bool? ?? false;

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'done': done,
      };
}
