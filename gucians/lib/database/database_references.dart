import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseReferences {
  static FirebaseFirestore database = FirebaseFirestore.instance;
  static CollectionReference<Map<String, dynamic>> users =
      database.collection('users');
  static CollectionReference<Map<String, dynamic>> posts =
      database.collection('posts');
  static CollectionReference<Map<String, dynamic>> confessions =
      database.collection('confessions');
  static CollectionReference<Map<String, dynamic>> emegencyNumbers =
      database.collection('emegencyNumbers');
  static CollectionReference<Map<String, dynamic>> locations =
      database.collection('locations');
  static CollectionReference<Map<String, dynamic>> comments =
      database.collection('comments');

  static Future<Map<String, dynamic>?> getDocumentData(
      CollectionReference<Map<String, dynamic>> docRef, String? docId) async {
    final doc = docRef.doc(docId);
    final snapshot = await doc.get();

    if (snapshot.exists) {
      return snapshot.data();
    }
    return null;
  }
}
