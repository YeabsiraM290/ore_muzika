import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart' as q;
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(
    const MaterialApp(
      home: SongList(),
    ),
  );
}

class SongList extends StatefulWidget {
  const SongList({Key? key}) : super(key: key);
  @override
  _SongListState createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  List<q.SongModel> allSongList = [];
  final q.OnAudioQuery _audioQuery = q.OnAudioQuery();
  bool isLoading = true;
  var audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    getAllSongList();
  }

  getAllSongList() async {
    PermissionStatus permissionResult = await Permission.storage.request();
    if (permissionResult == PermissionStatus.granted) {
      allSongList = await _audioQuery.querySongs();

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      // backgroundColor: Colors.black12,
      body: isLoading
          ? const CircularProgressIndicator()
          : ListView(
              children: [
                for (var i = 0; i < allSongList.length; i++)
                  Container(
                    key: ValueKey(allSongList[i]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          q.QueryArtworkWidget(
                            id: allSongList[i].id,
                            type: q.ArtworkType.AUDIO,
                            nullArtworkWidget: Container(
                              height: 50,
                              width: 50,
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    audioPlayer.setSource(
                                        allSongList[i].getMap['_data']);
                                  },
                                  child: Text(
                                    allSongList[i].title,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  "${allSongList[i].artist}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black38,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.more_vert_outlined)
                        ],
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}
