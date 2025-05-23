import 'package:flutter/material.dart';
import 'package:sdg_app/models/note_model.dart';
import 'home.dart';
import 'myNotebook.dart';

class NotebookDetailPage extends StatefulWidget {
  final NoteModel notebook;
  final Function(NoteModel) onUpdate;
  final Function(NoteModel) onDelete;

  const NotebookDetailPage({super.key, required this.notebook, required this.onUpdate, required this.onDelete,});

  @override
  State<NotebookDetailPage> createState() => _NotebookDetailPageState();
}

class _NotebookDetailPageState extends State<NotebookDetailPage> {
  late TextEditingController nameController;
  late TextEditingController contentController;
  bool isEditing = false;


  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.notebook.name);
    contentController = TextEditingController(text: widget.notebook.content);
  }

  void _saveEdits() {
    setState(() {
      widget.notebook.name = nameController.text;
      widget.notebook.content = contentController.text;
      isEditing = false;
    });
    widget.onUpdate(widget.notebook);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Notebook updated successfully')),
    );
  }

  void _deleteNotebook() {
    widget.onDelete(widget.notebook);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.notebook.name,
          style: TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.orange,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
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
                    fontWeight: FontWeight.bold),
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MynotebookPage()
                  ),
                );
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
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  isEditing
                      ? Expanded(
                          child: TextField(
                            controller: nameController,
                            decoration: InputDecoration(border: InputBorder.none),
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        )
                      : Expanded(
                          child: Text(
                            widget.notebook.name,
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                  IconButton(
                    icon: Icon(isEditing ? Icons.save : Icons.edit),
                    onPressed: () {
                      if (isEditing) {
                        _saveEdits();
                      } else {
                        setState(() => isEditing = true);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: _deleteNotebook,
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Wrap TextField in a Container with fixed height and allow scrolling
              isEditing
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.8, // Or any height you want for editing area
                      child: TextField(
                        controller: contentController,
                        maxLines: null,
                        expands: true, // Makes TextField fill the container vertically
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    )
                  : Text(
                      widget.notebook.content,
                      style: TextStyle(fontSize: 14),
                    ),
            ],
          ),
        ),
      ),
    );
  }

}
