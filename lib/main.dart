import 'package:flutter/material.dart';
import 'package:object_box/database/database_manager.dart';
import 'package:object_box/repositories/encrypt_repository.dart';
import 'package:object_box/repositories/todo_resposity.dart';

import 'model/model.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo>? value;

  @override
  void initState() {
    showBox();
    super.initState();
  }

  void showBox() async {
    var data = TodoRepository();
    await data.getAll().then((val) {
      setState(() {
        value = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.key),
          onPressed: () {
            DatabaseManager().init().then((value) {
              TodoRepository().insert("test").then((value) {
                print('berhasil');
                showBox();
              }).catchError((onError) {
                print('dsadas $onError');
              });
            }).catchError((onError){
              print('error $onError');
            });

            // TodoRepository().insert("test").then((value) {
            //   print('berhasil');
            //   showBox();
            // }).catchError((onError) {
            //   print('dsadas $onError');
            // });
          }),
      body: SafeArea(
        child: value?.isEmpty ?? true
            ? const Center(
                child: Text("KOSONG"),
              )
            : ListView.builder(
                itemCount: value?.length, //or 'foods.length'
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text("${value![index].id}"),
                    title: Text("index: $index ${value![index].desc}"),
                    subtitle: Text("${value![index].completed}"),
                  );
                },
              ),
      ),
    );
  }
}
