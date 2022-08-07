import 'package:object_box/database/objectbox_database.dart';
import 'package:object_box/model.dart';
import 'package:objectbox/objectbox.dart';

class TodoRepository {
  final db = ObjectBoxDatabase();

  Future<Todo> insert(String desc) async {
    Todo todo = Todo(desc: desc, completed: false);
    final box = await getBox();
    box.put(todo);
    return todo;
  }

  Future<Box<Todo>> getBox() async {
    final store = await db.getStore();
    if (Admin.isAvailable()) {
      // Keep a reference until no longer needed or manually closed.
      var admin = Admin(store);
    }
    return store.box<Todo>();
  }

  Future<List<Todo>> getAll() async {
    List<Todo> todos;
    final box = await getBox();
    todos = box.getAll();
    return todos;
  }

  Future<bool> delete(int id) async {
    final box = await getBox();
    return box.remove(id);
  }

  Future<Todo> update(Todo todo) async {
    final box = await getBox();
    box.put(todo);
    return todo;
  }
}
