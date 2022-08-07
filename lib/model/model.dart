
import 'package:objectbox/objectbox.dart';

@Entity()
class Todo {
  int id;
  String desc;
  bool completed;
  Todo({
    this.id = 0,
    this.desc = '',
    this.completed = false,
  });

  Todo copyWith({
    int? id,
    String? desc,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      desc: desc ?? this.desc,
      completed: completed ?? this.completed,
    );
  }
}