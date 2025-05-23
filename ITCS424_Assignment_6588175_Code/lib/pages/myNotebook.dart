import 'package:flutter/material.dart';
import 'package:sdg_app/models/note_model.dart';
import 'notebookNote.dart';
import 'home.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class MynotebookPage extends StatefulWidget {
  const MynotebookPage({super.key});

  @override
  State<MynotebookPage> createState() => _MynotebookPageState();
}

class _MynotebookPageState extends State<MynotebookPage> {
  List<NoteModel> notebooks = [];

  @override
  void initState() {
    super.initState();
    loadNotebooks();

  }

  Future<void> loadNotebooks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? notebookData = prefs.getString('notebooks');

    if (notebookData != null) {
      final List decoded = json.decode(notebookData);
      setState(() {
        notebooks = decoded.map((e) => NoteModel.fromJson(e)).toList();
      });
    } 
  }

  Future<void> saveNotebooks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(notebooks.map((e) => e.toJson()).toList());
    await prefs.setString('notebooks', encoded);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notebook',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Colors.orange,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
          IconButton(onPressed: () {}, icon: Icon(Icons.person)),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        width: 250,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.orangeAccent),
              child: Text(
                'GetYoung?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage()
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('My Notebooks'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Community'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          _searchBox(),
          SizedBox(height: 15),
          _notebookSection(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
      backgroundColor: Colors.orange,
      onPressed: () {
        _showCreateNotebookDialog();
      },
      child: Icon(Icons.add, color: Colors.white),
    ),
    );
  }

  void _showCreateNotebookDialog() {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Notebook'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Notebook name"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent),
              onPressed: () {
                final name = _controller.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    notebooks.add(NoteModel(
                      name: name,
                      content: 'Create new note',
                      isFavorited: false,
                    ));
                  });
                  saveNotebooks();
                  Navigator.of(context).pop(); // Close dialog
                }
              },
              child: Text('Create'),
            ),
          ],
        );
      },
    );
  }


  Column _notebookSection() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, bottom: 15),
              child: Text(
                'My Notebooks',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 150, // Set fixed height for each item
                ),
                padding: EdgeInsets.only(left: 20, right: 20),
                itemCount: notebooks.length,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NotebookDetailPage(
                            notebook: notebooks[index],
                            onUpdate: (updatedNotebook) {
                              setState(() {
                                notebooks[index] = updatedNotebook;
                              });
                              saveNotebooks(); // Save updates
                            },
                            onDelete: (notebookToDelete) {
                              setState(() {
                                notebooks.removeAt(index);
                              });
                              saveNotebooks(); // Save deletions
                            },
                          ),

                        ),
                      );
                    },
                    child: Container(
                      width: 140,
                      child: Column(
                        children: [
                          const Image(
                            image: AssetImage('assets/images/note.png'), 
                            height: 100,
                          ),
                          // Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    notebooks[index].isFavorited = !notebooks[index].isFavorited;
                                  });
                                },
                                icon: Icon(
                                  notebooks[index].isFavorited ? Icons.star : Icons.star_border,
                                  color: notebooks[index].isFavorited ? Colors.amberAccent : null,
                                ),
                              ),
                              Flexible(
                                child: Text(
                                  notebooks[index].name,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                  maxLines: 2, // Or more if needed
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
  }

  Container _searchBox() {
    return Container(
          margin: EdgeInsets.only(top: 40, left: 20, right: 20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0xff1D1617).withOpacity(0.11),
                blurRadius: 40,
                spreadRadius: 0.0,
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(15),
              hintText: 'Search Notebook',
              hintStyle: const TextStyle(color: Color(0xffDDDADA), fontSize: 14),
              prefixIcon: IconButton(
                onPressed: () {}, 
                icon: Icon(Icons.search)
              ),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.filter_list),
              ),
            ),
          ),
        );
  }
}