class VideoTrackResolution {
  final int? width;
  final int? height;
  final int? bitRate;

  String get displayName => '$height';

  VideoTrackResolution(
      {required this.width, required this.height, required this.bitRate});
}
