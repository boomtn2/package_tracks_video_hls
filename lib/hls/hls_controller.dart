import '/hls/model/video_track_resolution.dart';

import 'asms.dart';
import 'better_player_hls_utils.dart';

class HlsController {
  String? _cacheUrl;
  List<VideoTrackResolution>? _cacheTracks;

  Future<List<VideoTrackResolution>> getTracks(String url) async {
    if (_cacheUrl?.compareTo(url) != 0) {
      _cacheUrl ??= url;
      if (BetterPlayerAsmsUtils.isDataSourceAsms(url)) {
        final data = await BetterPlayerAsmsUtils.getDataFromUrl(url);
        if (data != null) {
          _cacheTracks = await BetterPlayerHlsUtils.parse(data, url);
          return _cacheTracks ?? [];
        }
        return [];
      }
    }

    return _cacheTracks ?? [];
  }
}
