import '/hls/model/video_track_resolution.dart';
import 'package:flutter/material.dart';

import 'hls_parser/hls_master_playlist.dart';
import 'hls_parser/hls_playlist_parser.dart';

///HLS helper class
sealed class BetterPlayerHlsUtils {
  BetterPlayerHlsUtils._();

  static Future<List<VideoTrackResolution>> parse(
      String data, String masterPlaylistUrl) async {
    try {
      return parseTracks(data, masterPlaylistUrl);
    } on Exception catch (exception) {
      debugPrint('[HLS][Resolution]  [ERROR] $exception');
      return [];
    }
  }

  static Future<List<VideoTrackResolution>> parseTracks(
      String data, String masterPlaylistUrl) async {
    List<VideoTrackResolution> tracks = [];
    try {
      final parsedPlaylist = await HlsPlaylistParser.create()
          .parseString(Uri.parse(masterPlaylistUrl), data);
      if (parsedPlaylist is HlsMasterPlaylist) {
        for (final variant in parsedPlaylist.variants) {
          tracks.add(
            VideoTrackResolution(
              width: variant.format.width,
              height: variant.format.height,
              bitRate: variant.format.bitrate,
            ),
          );
        }
      }
    } on Exception catch (exception) {
      debugPrint('[HLS][Resolution]  [ERROR] $exception');
    }
    return tracks;
  }

  // ///Parse subtitles from provided m3u8 url
  // static Future<List<BetterPlayerAsmsSubtitle>> parseSubtitles(
  //     String data, String masterPlaylistUrl) async {
  //   final List<BetterPlayerAsmsSubtitle> subtitles = [];
  //   try {
  //     final parsedPlaylist = await HlsPlaylistParser.create()
  //         .parseString(Uri.parse(masterPlaylistUrl), data);

  //     if (parsedPlaylist is HlsMasterPlaylist) {
  //       for (final Rendition element in parsedPlaylist.subtitles) {
  //         final hlsSubtitle = await _parseSubtitlesPlaylist(element);
  //         if (hlsSubtitle != null) {
  //           subtitles.add(hlsSubtitle);
  //         }
  //       }
  //     }
  //   } on Exception catch (exception) {
  //     BetterPlayerUtils.log('Exception on parseSubtitles: $exception');
  //   }

  //   return subtitles;
  // }

  // ///Parse HLS subtitles playlist. If subtitles are segmented (more than 1
  // ///segment is present in playlist), then setup subtitles as segmented.
  // ///Segmented subtitles are loading with JIT policy, when video is playing
  // ///to prevent massive load od video start. Segmented subtitles will have
  // ///filled segments list which contains start, end and url of subtitles based
  // ///on time in playlist.
  // static Future<BetterPlayerAsmsSubtitle?> _parseSubtitlesPlaylist(
  //     Rendition rendition) async {
  //   try {
  //     final HlsPlaylistParser hlsPlaylistParser = HlsPlaylistParser.create();
  //     final subtitleData =
  //         await BetterPlayerAsmsUtils.getDataFromUrl(rendition.url.toString());
  //     if (subtitleData == null) {
  //       return null;
  //     }

  //     final parsedSubtitle =
  //         await hlsPlaylistParser.parseString(rendition.url, subtitleData);
  //     final hlsMediaPlaylist = parsedSubtitle as HlsMediaPlaylist;
  //     final hlsSubtitlesUrls = <String>[];

  //     final List<BetterPlayerAsmsSubtitleSegment> asmsSegments = [];
  //     final bool isSegmented = hlsMediaPlaylist.segments.length > 1;
  //     int microSecondsFromStart = 0;
  //     for (final Segment segment in hlsMediaPlaylist.segments) {
  //       final split = rendition.url.toString().split('/');
  //       var realUrl = '';
  //       for (var index = 0; index < split.length - 1; index++) {
  //         // ignore: use_string_buffers
  //         realUrl += '${split[index]}/';
  //       }
  //       if (segment.url?.startsWith('http') == true) {
  //         realUrl = segment.url!;
  //       } else {
  //         realUrl += segment.url!;
  //       }
  //       hlsSubtitlesUrls.add(realUrl);

  //       if (isSegmented) {
  //         final int nextMicroSecondsFromStart =
  //             microSecondsFromStart + segment.durationUs!;
  //         microSecondsFromStart = nextMicroSecondsFromStart;
  //         asmsSegments.add(
  //           BetterPlayerAsmsSubtitleSegment(
  //             Duration(microseconds: microSecondsFromStart),
  //             Duration(microseconds: nextMicroSecondsFromStart),
  //             realUrl,
  //           ),
  //         );
  //       }
  //     }

  //     int targetDuration = 0;
  //     if (parsedSubtitle.targetDurationUs != null) {
  //       targetDuration = parsedSubtitle.targetDurationUs! ~/ 1000;
  //     }

  //     bool isDefault = false;

  //     if (rendition.format.selectionFlags != null) {
  //       isDefault =
  //           Util.checkBitPositionIsSet(rendition.format.selectionFlags!, 1);
  //     }

  //     return BetterPlayerAsmsSubtitle(
  //         name: rendition.format.label,
  //         language: rendition.format.language,
  //         url: rendition.url.toString(),
  //         realUrls: hlsSubtitlesUrls,
  //         isSegmented: isSegmented,
  //         segmentsTime: targetDuration,
  //         segments: asmsSegments,
  //         isDefault: isDefault);
  //   } on Exception catch (exception) {
  //     BetterPlayerUtils.log('Failed to process subtitles playlist: $exception');
  //     return null;
  //   }
  // }

  // static Future<List<BetterPlayerAsmsAudioTrack>> parseLanguages(
  //     String data, String masterPlaylistUrl) async {
  //   final List<BetterPlayerAsmsAudioTrack> audios = [];
  //   final parsedPlaylist = await HlsPlaylistParser.create()
  //       .parseString(Uri.parse(masterPlaylistUrl), data);
  //   if (parsedPlaylist is HlsMasterPlaylist) {
  //     for (int index = 0; index < parsedPlaylist.audios.length; index++) {
  //       final Rendition audio = parsedPlaylist.audios[index];
  //       audios.add(BetterPlayerAsmsAudioTrack(
  //         id: index,
  //         label: audio.name,
  //         language: audio.format.language,
  //         url: audio.url.toString(),
  //       ));
  //     }
  //   }

  //   return audios;
  // }
}
