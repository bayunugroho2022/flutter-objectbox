import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:object_box/repositories/encrypt_repository.dart';
import 'package:path_provider/path_provider.dart';

import '../objectbox.g.dart';

class DatabaseManager {
  static DatabaseManager? _instance;

  DatabaseManager._internal();

  /// Singleton Factory constructor
  factory DatabaseManager() {
    _instance ??= DatabaseManager._internal();
    return _instance!;
  }

  /// Initialize configuration of database:
  ///  - Init database file by copying.
  ///  - Open instance of database and close it.
  Future<void> init() async {
    await copyDatabaseFileFromAssets();
    // await testInstanceAndCloseIt();
  }

  /// Copy packaged database from assets folder to the app directory.
  Future<void> copyDatabaseFileFromAssets() async {
    // Search and create db file destination folder if not exist
    print('Search and create db file destination folder if not exist');
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final objectBoxDirectory = Directory(documentsDirectory.path + '/objectbox/');

    if (!objectBoxDirectory.existsSync()) {
      await objectBoxDirectory.create(recursive: false);
    }

    final dbFile = File(objectBoxDirectory.path + 'data.mdb');
    print(dbFile);
    if (!dbFile.existsSync()) {

      // Get pre-populated db file.
      ByteData data = await rootBundle.load("assets/data2.mdb");
      encryptFile(data.buffer.asUint8List(), dbFile);
      // Copying source data into destination file.
      // await dbFile.writeAsBytes(data.buffer.asUint8List());
    }

    if(dbFile.existsSync()) {
      try {
        encryptFileFromPath(dbFile.path);
      } catch(e) {
        print(e);
      }
    }

  }

  encryptFileFromPath(String path) async {
    final dbFile = File(path);
    if(dbFile.existsSync()) {
      try {
        List<int> bytes = await dbFile.readAsBytes();
        EncryptRepository.encryptFile(bytes);
        changeFileNameOnly(dbFile, '${getRandomString(15)}.mdb');
      } catch(e) {
        print(e);
      }
    }
  }

  Future<File> changeFileNameOnly(File file, String newFileName) {
    var path = file.path;
    var lastSeparator = path.lastIndexOf(Platform.pathSeparator);
    var newPath = path.substring(0, lastSeparator + 1) + newFileName;
    return file.rename(newPath);
  }

  encryptFile(List<int> bytes, File dbFile) async{
    // Get pre-populated db file.
    ByteData data = await rootBundle.load("assets/data2.mdb");
    // Copying source data into destination file.
    Uint8List? bytes = await EncryptRepository.encryptFile(data.buffer.asUint8List());
    await dbFile.writeAsBytes(uint8ListToListInt(bytes!));
  }

  uint8ListToListInt(Uint8List bytes) {
    List<int> list = [];
    for(int i = 0; i < bytes.length; i++) {
      list.add(bytes[i]);
    }
    return list;
  }

  Future<void> testInstanceAndCloseIt() async {
    await openStore().then((Store store) {
      store.close();
    });
  }

  getRandomString(int i) {
    var random = Random();
    var codeUnits = List.generate(i, (index) {
      return random.nextInt(33) + 89;
    });
    return String.fromCharCodes(codeUnits);
  }
}