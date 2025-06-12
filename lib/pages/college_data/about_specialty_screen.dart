import 'package:diploma/constans/app_colors.dart';
import 'package:diploma/pages/college_data/teachers_list_screen.dart';
import 'package:diploma/services/data_service.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AboutSpecialtyScreen extends StatefulWidget {
  const AboutSpecialtyScreen({super.key});

  @override
  State<AboutSpecialtyScreen> createState() => _AboutSpecialtyScreenState();
}

class _AboutSpecialtyScreenState extends State<AboutSpecialtyScreen> {
  late Future<List<Map<String, dynamic>>> contentList;


  @override
  void initState() {
    super.initState();
    contentList = DataService().fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBackground,
        title: Text("Про спеціальність", style: TextStyle(color: AppColors.text, fontFamily: 'NotoSans')),
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: contentList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length + 1,
            itemBuilder: (context, index) {
              if (index < data.length) {
                final item = data[index];
                final type = item['type'];
                final content = item['content'];
                final imageUrl = item['imageUrl'] ?? '';
                final title = item['title'] ?? '';
                final description = item['description'] ?? '';
                if (type == 'text') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(content, style: TextStyle(fontSize: 16, color: AppColors.text, fontFamily: 'NotoSans')),
                  );
                } else if (type == 'video') {
                  final controller = YoutubePlayerController(
                    initialVideoId: content,
                    flags: const YoutubePlayerFlags(
                      autoPlay: false,
                      mute: false,
                      hideControls: false,
                      disableDragSeek: false,
                      useHybridComposition: true,
                    ),
                  );
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: YoutubePlayer(
                      controller: controller,
                      showVideoProgressIndicator: true,
                      bottomActions: [
                        const SizedBox.shrink(),
                        CurrentPosition(),
                        ProgressBar(isExpanded: true),
                        RemainingDuration(),
                      ],
                    ),
                  );
                } else if (type == 'auditorium') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(),
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text,
                            fontFamily: 'NotoSans',
                          ),
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: double.infinity,
                              height: 180,
                              color: AppColors.secondaryBackground,
                              child: Icon(Icons.image, size: 60, color: AppColors.primary),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: TextStyle(fontSize: 16, color: AppColors.text, fontFamily: 'NotoSans'),
                        ),
                        Divider()
                      ],
                    ),
                  );
                }
              } else {
                return Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Center(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      icon: const Icon(Icons.people),
                      label: const Text("Перейти до викладачів", style: TextStyle(fontFamily: 'NotoSans')),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const TeachersListScreen()));
                      },
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
