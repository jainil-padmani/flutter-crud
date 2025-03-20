import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // Get collection reference
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  // CREATE: Add a new note
  Future<void> addNote(String note) async {
    try {
      await notes.add({
        'note': note,
        'timestamp': Timestamp.now(),
      });
      print("Note added successfully!");
    } catch (e) {
      print("Error adding note: $e");
    }
  }

  // READ: Get notes as a Stream
  Stream<QuerySnapshot> getNotes() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  // UPDATE: Edit a note given its document ID
  Future<void> updateNote(String noteId, String updatedNote) async {
    try {
      await notes.doc(noteId).update({'note': updatedNote});
      print("Note updated successfully!");
    } catch (e) {
      print("Error updating note: $e");
    }
  }

  // DELETE: Remove a note given its document ID
  Future<void> deleteNote(String noteId) async {
    try {
      await notes.doc(noteId).delete();
      print("Note deleted successfully!");
    } catch (e) {
      print("Error deleting note: $e");
    }
  }
}
