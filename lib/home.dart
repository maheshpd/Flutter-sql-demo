import 'package:flutter/material.dart';
import 'package:untitled/db_handler.dart';
import 'package:untitled/notesModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DBHelper? dbHelper;
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes SQL'),
        centerTitle: true,
      ),
      body: Column(
        children: [
            Expanded(
              child: FutureBuilder(
              future: notesList,
          builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {

                if(snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data?.length,
                      reverse: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: (){
                            dbHelper!.update(
                              NotesModel(
                                  id: snapshot.data![index].id!,
                                  title: 'First flutter note',
                                  age: 11,
                                  description: 'let me talk to you tommorow',
                                  email: 'mp@gmail.com')
                            );
                            setState(() {
                              notesList = dbHelper!.getNotesList();
                            });
                          },
                          child: Dismissible(
                            direction: DismissDirection.endToStart,
                            background: Container(
                              color: Colors.red,
                              child: const Icon(Icons.delete_forever),
                            ),
                            onDismissed: (DismissDirection direction){
                              setState(() {
                              dbHelper!.delete(snapshot.data![index].id!);
                              notesList = dbHelper!.getNotesList();
                              snapshot.data!.remove(snapshot.data![index]);
                              });
                            },
                            key: ValueKey<int>(snapshot.data![index].id!),
                            child: Card(
                              child: ListTile(
                                title: Text(snapshot.data![index].title.toString()),
                                subtitle: Text(snapshot.data![index].title.toString()),
                                trailing: Text(snapshot.data![index].age.toString()),
                              ),
                            ),
                          ),
                        );
                      }
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              }),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          dbHelper!.insert(
            NotesModel(
                title: 'Second Note',
                age: 22,
                description: 'This is my first sql app',
                email: 'mahesh@gmail.com')
          ).then((value){
            print('data added');
            setState(() {
              notesList = dbHelper!.getNotesList();
            });
          }).onError((error, stackTrace){
            print(error.toString());
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
