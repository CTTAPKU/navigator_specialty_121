import 'package:diploma/constans/app_colors.dart';
import 'package:flutter/material.dart';

class AboutSpecialtyScreen extends StatelessWidget {
  const AboutSpecialtyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Text(
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras nec nunc maximus, viverra tellus id, semper libero. Etiam facilisis interdum interdum. Etiam libero neque, mattis ut augue sit amet, ultricies iaculis nisi. Etiam quis lorem nibh. Vestibulum rutrum tincidunt pharetra. Sed tempus gravida tempus. Fusce cursus, lorem sed rutrum varius, velit sapien consequat elit, vitae feugiat ligula nibh viverra velit. Aenean ullamcorper sollicitudin turpis euismod molestie. Quisque finibus laoreet aliquet. Suspendisse dolor lorem, bibendum vitae ullamcorper congue, maximus sodales ipsum. Nunc rutrum est at sollicitudin posuere. Ut iaculis arcu ac augue eleifend vestibulum. Nunc id lacinia massa, vitae hendrerit sem. Curabitur iaculis, est at tristique suscipit, nisi lectus placerat odio, sed iaculis lorem nunc id purus.",
        style: TextStyle(color: AppColors.text, fontFamily: 'NotoSans'),
      ),
    );
  }
}
