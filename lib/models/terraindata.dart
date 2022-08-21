import 'package:flame/extensions.dart';

enum TerrainType {
  starter,
  random,
}

class TerrainData {
  final Image image;
  final Vector2 textureSize;
  final Vector2 texturePosition;
  final TerrainType type;

  const TerrainData({
    required this.image,
    required this.textureSize,
    required this.texturePosition,
    required this.type,
  });
}
