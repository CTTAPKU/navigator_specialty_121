import 'package:flutter/material.dart';
import '../../../constans/app_colors.dart';
import '../../../services/path_painter.dart';
import 'indoor_map_data.dart';

class IndoorMap extends StatefulWidget {
  const IndoorMap({super.key});

  @override
  State<IndoorMap> createState() => _IndoorMapState();
}

class _IndoorMapState extends State<IndoorMap> {
  final TransformationController _controller = TransformationController();

  int selectedFloor = 1;
  String selectedCabinet = "221";
  int selectedCabinetFloor = 2;
  int? startLocalIndex;

  @override
  void initState() {
    super.initState();
    _controller.value = Matrix4.identity()
      ..translate(-100.0, -100.0)
      ..scale(1.5);
    startLocalIndex = 0;
  }

  List<int> findPath(Map<int, List<int>> graph, int start, int goal) {
    final queue = <List<int>>[[start]];
    final visited = <int>{};
    while (queue.isNotEmpty) {
      final path = queue.removeAt(0);
      final node = path.last;
      if (node == goal) return path;
      if (visited.contains(node)) continue;
      visited.add(node);
      for (final neighbor in graph[node] ?? []) {
        if (!visited.contains(neighbor)) {
          queue.add([...path, neighbor]);
        }
      }
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {

    final offsets = {
      1: 0,
      2: MapData.floorPoints[1]!.length,
      3: MapData.floorPoints[1]!.length + MapData.floorPoints[2]!.length,
    };

    final globalEdges = MapData.buildGlobalEdges();

    final allCabinets = [
      ...MapData.floorCabinets[1]!.entries.map((e) => {'name': e.key, 'floor': 1}),
      ...MapData.floorCabinets[2]!.entries.map((e) => {'name': e.key, 'floor': 2}),
      ...MapData.floorCabinets[3]!.entries.map((e) => {'name': e.key, 'floor': 3}),
    ];

    int getCabinetGlobalIndex(int floor, String cabinet) {
      final cabinetsOnFloor = MapData.floorCabinets[floor];
      if (cabinetsOnFloor == null || !cabinetsOnFloor.containsKey(cabinet)) {
        throw Exception("Кабінет $cabinet не знайдено на поверсі $floor");
      }
      final index = cabinetsOnFloor[cabinet]!;

      return offsets[floor]! + index;
    }

    final stairsFloorIndex = {1: 7, 2: 0, 3: 0};
    final stairsGlobalIndex = {
      1: offsets[1]! + stairsFloorIndex[1]!,
      2: offsets[2]! + stairsFloorIndex[2]!,
      3: offsets[3]! + stairsFloorIndex[3]!,
    };

    final image = MapData.floorImages[selectedFloor]!;
    final imageSize = MapData.imageSizes[selectedFloor]!;
    final points = MapData.floorPoints[selectedFloor]!;
    final cabinets = MapData.floorCabinets[selectedFloor]!;
    final floorOffset = offsets[selectedFloor]!;

    final int targetGlobal = getCabinetGlobalIndex(selectedCabinetFloor, selectedCabinet);
    final int? startGlobal =
    (startLocalIndex != null) ? floorOffset + startLocalIndex! : null;

    List<int> getFullPath() {
      if (startGlobal == null) return [];

      if (selectedFloor == selectedCabinetFloor) {
        return findPath(globalEdges, startGlobal, targetGlobal);
      }
      final stairsStart = stairsGlobalIndex[selectedFloor]!;
      final stairsEnd = stairsGlobalIndex[selectedCabinetFloor]!;
      final pathToStairs = findPath(globalEdges, startGlobal, stairsStart);
      final pathFromStairs = findPath(globalEdges, stairsEnd, targetGlobal);

      if (pathToStairs.isEmpty || pathFromStairs.isEmpty) return [];
      return [...pathToStairs, ...pathFromStairs.skip(1)];
    }

    final path = getFullPath();

    final pathOnCurrentFloor = path
        .where((globalIndex) =>
    globalIndex >= floorOffset &&
        globalIndex < floorOffset + points.length)
        .map((globalIndex) => globalIndex - floorOffset)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryBackground,
        title: Text("Мапа коледжу",
            style: TextStyle(
                color: AppColors.text,
                fontFamily: 'NotoSans',
                fontWeight: FontWeight.w600)),
        centerTitle: true,
        shape: Border(bottom: BorderSide(color: AppColors.primary, width: 2)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondaryBackground,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: '${selectedCabinet}_${selectedCabinetFloor}',
                  dropdownColor: AppColors.secondaryBackground,
                  iconEnabledColor: AppColors.primary,
                  style: TextStyle(
                    color: AppColors.text,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'NotoSans',
                  ),
                  items: allCabinets.map((cab) {
                    final name = cab['name'] as String;
                    final floor = cab['floor'] as int;
                    return DropdownMenuItem<String>(
                      value: '${name}_$floor',
                      child: Text('$name (поверх $floor)'),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      final parts = val.split('_');
                      setState(() {
                        selectedCabinet = parts[0];
                        selectedCabinetFloor = int.parse(parts[1]);
                      });
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final scaleX = constraints.maxWidth / imageSize.width;
                final scaleY = constraints.maxHeight / imageSize.height;
                final scale = scaleX < scaleY ? scaleX : scaleY;

                final scaledPoints =
                points.map((p) => Offset(p.dx * scale, p.dy * scale)).toList();
                final scaledPath =
                pathOnCurrentFloor.map((i) => scaledPoints[i]).toList();

                return GestureDetector(
                  onTapUp: (details) {
                    final Matrix4 matrix = _controller.value;
                    final Matrix4 inverseMatrix = Matrix4.inverted(matrix);

                    final Offset tap = details.localPosition;
                    final Offset tapOnImage = MatrixUtils.transformPoint(inverseMatrix, tap);

                    int? nearestIndex;
                    double minDist = double.infinity;
                    for (int i = 0; i < scaledPoints.length; i++) {
                      final d = (tapOnImage - scaledPoints[i]).distance;
                      if (d < minDist) {
                        minDist = d;
                        nearestIndex = i;
                      }
                    }
                    if (nearestIndex != null && minDist < 30) {
                      setState(() {
                        startLocalIndex = nearestIndex;
                      });
                    }
                  },
                  child: InteractiveViewer(
                    transformationController: _controller,
                    minScale: 1,
                    maxScale: 5,
                    child: Stack(
                      children: [
                        Image.asset(
                          image,
                          width: imageSize.width * scale,
                          height: imageSize.height * scale,
                          fit: BoxFit.contain,
                        ),
                        CustomPaint(
                          painter: PathPainter(scaledPath),
                          size: Size(imageSize.width * scale, imageSize.height * scale),
                        ),
                        ...List.generate(points.length, (i) {
                          final point = scaledPoints[i];
                          final isStart = startLocalIndex == i;
                          final isCabinet = cabinets.values.contains(i);
                          return Positioned(
                            left: point.dx - (isStart ? 7 : isCabinet ? 5 : 3),
                            top: point.dy - (isStart ? 7 : isCabinet ? 5 : 3),
                            child: Container(
                              width: isStart ? 14 : isCabinet ? 10 : 6,
                              height: isStart ? 14 : isCabinet ? 10 : 6,
                              decoration: BoxDecoration(
                                color: isStart
                                    ? Colors.red
                                    : isCabinet
                                    ? Colors.green
                                    : AppColors.accent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Colors.white,
                                    width: 1),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                final floor = i + 1;
                final isSelected = selectedFloor == floor;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected
                          ? AppColors.primary
                          : AppColors.secondaryBackground,
                      foregroundColor: isSelected ? Colors.white : AppColors.text,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: AppColors.primary),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      elevation: isSelected ? 2 : 0,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedFloor = floor;
                        startLocalIndex = 0;
                      });
                    },
                    child: Text('Поверх $floor'),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
