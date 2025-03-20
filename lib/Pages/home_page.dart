import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/Services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Firestore service
  final FirestoreService firestoreService = FirestoreService();
  // Text Controller
  final TextEditingController textController = TextEditingController();

  // Open dialog to add a note
  void openNoteBox() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Note"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Enter your note"),
        ),
        actions: [
          // Button to save note
          ElevatedButton(
            onPressed: () async {
              if (textController.text.trim().isNotEmpty) {
                await firestoreService.addNote(textController.text);
                textController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notes")),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No notes available"));
          }

          var notesList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notesList.length,
            itemBuilder: (context, index) {
              var note = notesList[index];
              String noteId = note.id;
              String noteText = note['note'];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(noteText),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Edit Button
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => openEditBox(noteId, noteText),
                      ),
                      // Delete Button
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => firestoreService.deleteNote(noteId),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Open dialog to edit a note
  void openEditBox(String noteId, String currentText) {
    textController.text = currentText;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Note"),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(hintText: "Edit your note"),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (textController.text.trim().isNotEmpty) {
                await firestoreService.updateNote(noteId, textController.text);
                textController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}
