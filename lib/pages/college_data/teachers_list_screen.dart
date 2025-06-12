import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diploma/constans/app_colors.dart';
import 'package:flutter/material.dart';
import 'teacher_detail_screen.dart';
import '../../services/data_service.dart';

class TeachersListScreen extends StatefulWidget {
  const TeachersListScreen({super.key});

  @override
  State<TeachersListScreen> createState() => _TeachersListScreenState();
}

class _TeachersListScreenState extends State<TeachersListScreen> {
  List<QueryDocumentSnapshot> _allTeachers = [];
  List<QueryDocumentSnapshot> _filteredTeachers = [];
  late Future<List<QueryDocumentSnapshot>> _teachersFuture;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _teachersFuture = _initTeachers();
  }

  Future<List<QueryDocumentSnapshot>> _initTeachers() async {
    final teachers = await DataService().fetchTeachers();
    _allTeachers = teachers;
    _filteredTeachers = _allTeachers;
    return _allTeachers;
  }

  void _filterTeachers(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTeachers = _allTeachers
          .where((doc) => doc['name']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBackground,
        title: Text("Викладачі", style: TextStyle(color: AppColors.text, fontFamily: 'NotoSans')),
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
      ),
      body: FutureBuilder<List<QueryDocumentSnapshot>>(
        future: _teachersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    onChanged: _filterTeachers,
                    decoration: InputDecoration(
                      hintText: 'Пошук викладача...',
                      hintStyle: TextStyle(color: AppColors.text.withOpacity(0.5)),
                      prefixIcon: Icon(Icons.search, color: AppColors.text),
                      filled: true,
                      fillColor: AppColors.secondaryBackground,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.accent, width: 2),
                      ),
                    ),
                    style: TextStyle(color: AppColors.text, fontFamily: 'NotoSans'),
                    cursorColor: AppColors.accent,
                  )),
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredTeachers.length,
                  itemBuilder: (context, index) {
                    final doc = _filteredTeachers[index];
                    final name = doc['name'];
                    return ListTile(
                      title: Text(name, style: TextStyle(color: AppColors.text, fontFamily: 'NotoSans')),
                      trailing: Icon(Icons.arrow_forward_ios, color: AppColors.primary),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeacherDetailScreen(teacherId: doc.id),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}