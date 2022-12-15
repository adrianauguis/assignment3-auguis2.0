import 'package:assignment_auguis/provider/db_provider.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'provider/todo_api_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  loadFromApi() async {
    var apiProvider = TodoApiProvider();
    await apiProvider.getAllTodos();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: DBProvider.db.getAllTodos(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.black12,
                ),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: Text(
                      "${index + 1}",
                      style: const TextStyle(fontSize: 20.0),
                    ),
                    title: Text(
                        "Title: ${snapshot.data[index].title} ${snapshot.data[index].id} "),
                    subtitle: Text('Status: ${snapshot.data[index].completed}'),
                  );
                },
              );
            }
          },
      ),
    );
  }
}
