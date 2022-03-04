import 'package:flutter/material.dart';
import 'package:my_dict/screens/new_word.dart';
import 'package:my_dict/screens/words_list_view.dart';
import 'dart:async';
import './models/word.model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import './models/db.dart';

late DBConnect _dbConnect;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = openDatabase(
    join(await getDatabasesPath(), 'word_database.db'),
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE words(id INTEGER PRIMARY KEY AUTOINCREMENT, word TEXT, meaning TEXT)',
      );
    },
    version: 1,
  );
  _dbConnect = DBConnect(database);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Dict',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'My Dictionary'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Word>> wordsListFromDB;

  getDataFromDB() {
    Future<List<Word>> list = _dbConnect.words();
    setState(() {
      wordsListFromDB = list;
    });
  }

  @override
  void initState() {
    super.initState();
    getDataFromDB();
  }

  @override
  Widget build(BuildContext context) {
    //Future<List<Word>> wordsList;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
          future: wordsListFromDB,
          builder: (context, AsyncSnapshot<List<Word>> snapshot) {
            if (snapshot.hasData) {
              return WordsListView(snapshot.data, getDataFromDB);
            } else {
              return Text('No Data Found');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _navigateToAddWordForm(context);
          // Future<List<Word>> words = _dbConnect.words();
          // words.then((value) => {print(value)});
          // print(_dbConnect.words().then((value) => value));
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _navigateToAddWordForm(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NewWordScreen(_dbConnect)));
    getDataFromDB();
    setState(() {});
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text('New Word added $result')));
  }
}
