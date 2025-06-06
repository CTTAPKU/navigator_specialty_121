import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diploma/constans/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AboutSpecialtyScreen extends StatefulWidget {
  const AboutSpecialtyScreen({super.key});

  @override
  State<AboutSpecialtyScreen> createState() => _AboutSpecialtyScreenState();
}

class _AboutSpecialtyScreenState extends State<AboutSpecialtyScreen> {
  late Future<List<Map<String, dynamic>>> contentList;

  Future<List<Map<String, dynamic>>> fetchContent() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('collegeData')
        .orderBy('order')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  void initState() {
    super.initState();
    contentList = fetchContent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            itemCount: data.length,
            itemBuilder: (context, index) {
              if (snapshot.hasData) {
                final item = data[index];
                final type = item['type'];
                final content = item['content'];
                
                if (type == 'text') {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.text,
                        fontFamily: 'NotoSans',
                      ),
                    ),
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
                    )
                  );
                } else {
                  // return const SizedBox.shrink();
                }
              }
              return null;
            },
          );
        },
      ),
    );
  }
}
