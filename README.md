import 'package:export_tracks_video_stream/export_tracks_video_stream.dart';
import 'package:export_tracks_video_stream/hls/asms.dart';

 //Check url is type hls/dash
 BetterPlayerAsmsUtils.isDataSourceAsms(url);


 //get resolution
 final hls = HlsController();
    final response = await hls.getTracks(
        "https://video3.mobion.vn/uploads/2025/02/20/1740023136564/ffd65d761e82_abr.m3u8");
