import 'package:flutter/material.dart';
import 'package:todo_app/repository.dart';

class StreamPage extends StatefulWidget {
  const StreamPage({super.key});

  @override
  State<StreamPage> createState() => _StreamPageState();
}

class _StreamPageState extends State<StreamPage> {
  late Repository repository;
  TextEditingController? title;
  TextEditingController? desc;
  TextEditingController? id;

  @override
  void initState() {
    title = TextEditingController();
    desc = TextEditingController();
    id = TextEditingController();
    repository = Repository();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<ToDoModel>>(
        stream: repository.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: Text("No Todo "),
            );
          } else {
            final todos = snapshot.data!;
            return ListView.separated(
                itemBuilder: (_, index) => ListTile(
                  selectedColor: Colors.yellow,
                      title: Text(todos[index].title),
                      subtitle: Text(todos[index].desc),
                    ),
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemCount: todos.length);
          }
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () async {
              showDialog(
                  barrierDismissible: false,
                  context: context, builder: (BuildContext context){
                return AlertDialog(
                  title: const Text("Adding stream"),
                  content: SizedBox(
                    height: 150,
                    child: Column(
                      children: [
                        TextField(
                          controller: title,
                          decoration: const InputDecoration(
                            hintText: 'Title'
                          ),
                        ),
                        TextField(
                          controller: desc,
                          decoration: const InputDecoration(
                              hintText: 'Description'
                          ),
                        ),
                        const SizedBox(height: 6),
                        IconButton(
                            color: Colors.blue,
                            onPressed: () async {
                              if (title!.text.isEmpty || desc!.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Title and description must not be empty'),
                                  ),
                                );
                              } else {
                                await repository.createToDo(
                                  title!.text,
                                  desc!.text,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Successfully created'),
                                  ),
                                );
                                title!.clear();
                                desc!.clear();
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(Icons.add))
                      ],
                    ),
                  ),
                );
              });
          
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
              onPressed: () async {
                showDialog(context: context, 
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Enter id to remove!"),
                        content: SizedBox(height: 99,
                        child: Column(
                          children: [
                            TextField(
                              controller: id,
                              decoration: const InputDecoration(
                                  hintText: 'id'
                              ),
                            ),
                            Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                    color: Colors.redAccent,
                                    onPressed: () async {
                                      int? todoId = int.tryParse(id!.text);
                                      if (todoId != null) {
                                        bool removed = await repository.removeToDo(todoId);
                                        if (removed) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Successfully removed'),
                                            ),
                                          );
                                          id!.clear();
                                          Navigator.pop(context);
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('ID not found'),
                                            ),
                                          );
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Invalid ID'),
                                          ),
                                        );
                                      }
                                    },

                                    icon: const Icon(Icons.delete_forever)),
                                const SizedBox(width: 10,),
                                IconButton(onPressed: (){
                                  Navigator.pop(context);
                                }, icon: const Icon(Icons.exit_to_app))
                              ],
                            )
                          ],
                        ),
                        ),
                      );
                    }
                );
              },
            child: const Icon(Icons.delete_forever),
              
          )
        ],
      ),
    );
  }
    @override
  void dispose() {
    title?.dispose();
    desc?.dispose();
    id?.dispose();
    super.dispose();
  }
}
