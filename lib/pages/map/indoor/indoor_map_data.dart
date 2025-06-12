import 'package:flutter/material.dart';

class MapData {
  static const Map<int, String> floorImages = {
    1: "assets/images/firstFloor.jpg",
    2: "assets/images/secondFloor.jpg",
    3: "assets/images/thirdFloor.jpg",
  };

  static const Map<int, List<Offset>> floorPoints = {
    1: [
      Offset(1283, 2127),
      Offset(1283, 1703),
      Offset(1283, 1561),
      Offset(475, 1561),
      Offset(395, 1561),
      Offset(395, 1122),
      Offset(1594, 1561),
      Offset(1594, 1703),
      Offset(2125, 1561),
      Offset(2125, 910),
      Offset(475, 1638), // 107
    ],
    2: [
      Offset(1618, 1423),
      Offset(1618, 1331),
      Offset(2154, 1331),
      Offset(760, 1331),
      Offset(482, 1331),
      Offset(362, 1331),
      Offset(760, 1414), // 209
      Offset(482, 1414), // 207
      Offset(362, 1414), // 205
      Offset(402, 1333),
      Offset(402, 923),
      Offset(2154, 875),
      Offset(2222, 875), // 221
    ],
    3: [
      Offset(1619, 1413),
      Offset(1619, 1330),
      Offset(403, 1330),
      Offset(2263, 1330),
      Offset(2263, 1413), //315
      Offset(2151, 1330),
      Offset(2151, 860),
      Offset(2220, 860), // 317
    ],
  };

  static const Map<int, Map<int, List<int>>> floorEdges = {
    1: {
      0: [1],
      1: [0, 2, 3, 7],
      2: [1, 3, 6, 7],
      3: [2, 4, 10],
      4: [3, 5],
      5: [4],
      6: [2, 8],
      7: [1, 2],
      8: [6, 9],
      9: [8],
      10: [3], //107
    },
    2: {
      0: [1],
      1: [0,2,3,4,5,9],
      2: [1,3,4,5,9,11],
      3: [1,2,4,5,9,6],
      4: [1,2,3,5,9,7],
      5: [1,2,3,4,9,8],
      6: [3],
      7: [4],
      8: [5],
      9: [1,2,3,4,5,10],
      10: [9],
      11: [2,12],
      12: [11], // 221
    },
    3: {
      0: [1, 4],
      1: [0, 2, 5],
      2: [1],
      3: [4, 5],
      4: [0, 3],
      5: [1, 3, 6],
      6: [5, 7],
      7: [6], // 317
    },
  };

  static const Map<int, Map<String, int>> floorCabinets = {
    1: {
      "107": 10,
    },
    2: {
      "209": 6,
      "207": 7,
      "205": 8,
      "221": 12,
    },
    3: {
      "317": 7,
      "315": 4,
    },
  };

  static const Map<int, Size> imageSizes = {
    1: Size(2560, 2165),
    2: Size(2560, 1943),
    3: Size(2560, 1931),
  };

  static Map<int, List<int>> buildGlobalEdges() {
    final N1 = floorPoints[1]!.length;
    final N2 = floorPoints[2]!.length;


    final offset2 = N1;
    final offset3 = N1 + N2;

    final Map<int, List<int>> edges = {};

    floorEdges.forEach((floor, floorEdgeMap) {
      final offset = floor == 1 ? 0 : floor == 2 ? offset2 : offset3;
      for (final entry in floorEdgeMap.entries) {
        edges[entry.key + offset] = entry.value.map((i) => i + offset).toList();
      }
    });

    edges[7] = [...(edges[7] ?? []), offset2];
    edges[offset2] = [...(edges[offset2] ?? []), 7];

    edges[offset2] = [...(edges[offset2] ?? []), offset3];
    edges[offset3] = [...(edges[offset3] ?? []), offset2];

    return edges;
  }
}