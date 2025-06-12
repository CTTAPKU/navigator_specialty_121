import 'package:diploma/constans/app_colors.dart';
import 'package:flutter/material.dart';
import '../../services/data_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherDetailScreen extends StatelessWidget {
  final String teacherId;

  const TeacherDetailScreen({super.key, required this.teacherId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBackground,
        title: Text(
          'Про викладача',
          style: TextStyle(color: AppColors.text, fontFamily: 'NotoSans'),
        ),
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: DataService().fetchTeacherById(teacherId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data?.data() as Map<String, dynamic>?;

          if (data == null) {
            return const Center(child: Text('Дані не знайдено'));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        data['photoUrl'] ?? '',
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 120,
                          height: 120,
                          color: AppColors.secondaryBackground,
                          child: Icon(Icons.person, size: 60, color: AppColors.primary),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data['name'] ?? '',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Кабінет: ${data['room'] ?? 'Невідомо'}',
                            style: TextStyle(fontSize: 16, color: AppColors.text, fontFamily: 'NotoSans'),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Предмети: ${(data['subjects'] as List<dynamic>?)?.join(', ') ?? 'Немає даних'}',
                            style: TextStyle(fontSize: 16, color: AppColors.text, fontFamily: 'NotoSans'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Цікаві факти: ${data['bio'] ?? 'Немає даних'}',
                  style: TextStyle(fontSize: 16, color: AppColors.text, fontFamily: 'NotoSans'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}