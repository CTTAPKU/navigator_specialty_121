import 'package:flutter/material.dart';

class IndoorMap extends StatefulWidget {
  const IndoorMap({super.key});

  @override
  State<IndoorMap> createState() => _IndoorMapState();
}

class _IndoorMapState extends State<IndoorMap> {
  final TransformationController _controller = TransformationController();
  final Offset userEntryPoint = Offset(1280, 2000);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final scale = 1.0;
      final Size screenSize = MediaQuery.of(context).size;

      final dx = -userEntryPoint.dx * scale + screenSize.width / 2;
      final dy = -userEntryPoint.dy * scale + screenSize.height / 2;

      _controller.value =
          Matrix4.identity()
            ..scale(scale)
            ..translate(dx / scale, dy / scale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InteractiveViewer(
        transformationController: _controller,
        child: Image.asset("assets/images/firstFloor.jpg"),
        constrained: false,
      ),
    );
  }
}
