import 'package:flutter/material.dart';
import 'package:object_box/repositories/encrypt_repository.dart';
import 'package:object_box/repositories/todo_resposity.dart';

import 'model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
    // TODO: implement initState
    super.initState();
  }

  Future showBox() async {
    var data = TodoRepository();
    var allData = await data.getAll();
    setState(() {
      value = allData
          .map<Todo>(
            (e) => Todo(
              desc: "${EncryptRepository.decryptAES(e.desc)}",
              completed: e.completed,
              id: e.id,
            ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.key),
          onPressed: () {
            TodoRepository().insert("test").then((value) {
              print('berhasil');
              showBox();
            }).catchError((onError) {
              print('dsadas $onError');
            });
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
