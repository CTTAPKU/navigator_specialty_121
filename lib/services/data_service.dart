import 'package:cloud_firestore/cloud_firestore.dart';

class DataService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchContent() async {
    final snapshot = await _firestore.collection('collegeData').orderBy('order').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<QueryDocumentSnapshot>> fetchTeachers() async {
    final snapshot = await _firestore
        .collection('teachers')
        .orderBy('name')
        .get();
    return snapshot.docs;
  }

  Future<DocumentSnapshot> fetchTeacherById(String teacherId) async {
    return await _firestore.collection('teachers').doc(teacherId).get();
  }

}