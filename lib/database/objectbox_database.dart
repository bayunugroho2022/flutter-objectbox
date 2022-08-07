
import 'package:object_box/objectbox.g.dart';

class ObjectBoxDatabase {
  static final ObjectBoxDatabase _singleton = ObjectBoxDatabase._internal();
  Store? _store;

  factory ObjectBoxDatabase() {
    return _singleton;
  }

  Future<Store> getStore() async {
    return _store ??= await openStore();
  }

  ObjectBoxDatabase._internal();
}