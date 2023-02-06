import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';



class control1 extends GetxController
{
  RxList sear=[].obs;
  RxBool search=false.obs;

  RxBool m=false.obs;
  RxInt next=0.obs;

  final player = AudioPlayer();
  RxBool play1 = false.obs;

  //double current_time = 0;
  List<SongModel> songlist=[];
  List<AlbumModel> alubmlist=[];
  RxList<bool> list=<bool>[].obs;
  RxInt con=0.obs;
  RxDouble currentduretion=0.0.obs;
  RxDouble totalduretion=0.0.obs;


  OnAudioQuery _audioQuery = OnAudioQuery();
  permition()
  async {
    var status = await Permission.storage.status;
    if(status.isDenied)
    {
      Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
  }
  }
  Future getsongs()
  async {

    songlist = await _audioQuery.querySongs();
    //print("songs${songlist1}");
     list.value=List.filled(songlist.length,false);
     play1.value=true;
     return songlist;
  }


  Future Album()
  async {

    alubmlist = await _audioQuery.queryAlbums();
    //print("songs${songlist1}");
    list.value=List.filled(alubmlist.length,false);
    play1.value=true;
    return alubmlist;
  }

  pause(index)
  async {
    final duration = await player.setFilePath(songlist[index].data);
    player.stop();
    list.value=List.filled(songlist.length, false);

  }
  play(index)
  async {
    final duration = await player.setFilePath(songlist[index].data);
    player.play();
    list.value=List.filled(songlist.length, false);
    list.value[index]=true;
    con.value=index;
    print("hello");
  }
  String printDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "$twoDigitMinutes:$twoDigitSeconds";
    }
  }
  sliderduretion()
  {
    player.positionStream.listen((event) {

      currentduretion.value=event.inMilliseconds.toDouble();

    });
    player.setFilePath(songlist[con.value].data).then((value) {
      totalduretion.value=value!.inMilliseconds.toDouble();


    });
    player.processingStateStream.listen((event) {
      if(event==ProcessingState.completed)
      {
        con.value++;
        player.setFilePath(songlist[con.value].data).then((value) {
          totalduretion.value=value!.inMicroseconds.toDouble();
        },);
      }
    });
  }

}