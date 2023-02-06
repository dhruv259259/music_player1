import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:music_player/second_page.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

import 'control.dart';




class first extends StatefulWidget {

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  control1 c1 = Get.put(control1());
  final player = AudioPlayer();

  // baner ad
  BannerAd myBanner = BannerAd(
    adUnitId: 'ca-app-pub-3185429566857502/3850460535',
    size: AdSize.smartBanner,
    request: AdRequest(),
    listener: BannerAdListener(
      // Called when an ad is successfully received.
      onAdLoaded: (Ad ad) => print('Ad loaded.'),
      // Called when an ad request failed.
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        // Dispose the ad here to free resources.
        ad.dispose();
        print('Ad failed to load: $error');
      },
      // Called when an ad opens an overlay that covers the screen.
      onAdOpened: (Ad ad) => print('Ad opened.'),
      // Called when an ad removes an overlay that covers the screen.
      onAdClosed: (Ad ad) => print('Ad closed.'),
      // Called when an impression occurs on the ad.
      onAdImpression: (Ad ad) => print('Ad impression.'),
    ),
  );

  static final AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  int maxFailedLoadAttempts = 3;
  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;
  RewardedAd? _rewardedAd;
  int _numRewardedLoadAttempts = 0;
  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: Platform.isAndroid
            ? 'ca-app-pub-3185429566857502/1913997688'
            : 'ca-app-pub-3940256099942544/1712485313',
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }
  void _showRewardedAd() {
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        _createRewardedAd();

      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        });
    _rewardedAd = null;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    c1.permition();
   // c1.getsongs();
    myBanner.load();
    _createRewardedAd();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    myBanner.dispose();
    _rewardedAd!.dispose();
  }
TextEditingController t=TextEditingController();
  Uint8List? albumArt;
  getimage()
  async {
    final metadata = await MetadataRetriever.fromFile(File(c1.songlist[4].data));
    albumArt = metadata.albumArt;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 6,
        child: Scaffold(
          appBar: AppBar(title: (c1.m.value==true)?TextField(style: TextStyle(color: Colors.white),onChanged: (value) {},
            decoration: InputDecoration(hintText: "Search your Music..",hintStyle: TextStyle(color: Colors.white)),):Text(
            "Music Player", style: TextStyle(color: Colors.white),),
            actions: [
              SearchBarAnimation(textEditingController:t,
                isSearchBoxOnRightSide: true,
                searchBoxWidth: 300,
                searchBoxColour: Colors.white30,
                enteredTextStyle: TextStyle(color: Colors.white),
                buttonColour: Colors.purpleAccent,
                cursorColour: Colors.white,
                isOriginalAnimation: false, trailingWidget:Icon(Icons.search,color: Colors.white),
                secondaryButtonWidget: Icon(Icons.clear,color: Colors.white,), buttonWidget:Icon(Icons.search,color: Colors.white,),

                onChanged: (value){
                  c1.songlist.where((element) => element.toString().contains(value)).toList();
                  print("l=${c1.songlist}");
                },
              ),
            ],
            backgroundColor: Color(0xFF1D2671),
            bottom: TabBar(
                labelColor: Colors.amber,
                unselectedLabelColor: Colors.white,
                automaticIndicatorColorAdjustment: true,
                indicatorColor: Colors.amber,
                isScrollable: true,
                tabs: [
                  Tab(
                    child: Text("SONGS"),
                  ),
                  Tab(
                    child: Text("ALBUMS"),
                  ),
                  Tab(
                    child: Text("FOLDERS"),
                  ),
                  Tab(
                    child: Text("PLAYLIST"),
                  ),
                  Tab(
                    child: Text("ARTISTS"),
                  ),
                  Tab(
                    child: Text("GENRES"),
                  ),
                ]),
          ),
          drawer: Drawer(child: Container(
            height: double.infinity, width: double.infinity,
            decoration: BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1D2671), Color(0xFFC33764)])),
            child: Column(children: [
              DrawerHeader(child: SizedBox(height: 250,width: 250,child: CircleAvatar(backgroundColor: Colors.purple,child: Icon(Icons.music_note_sharp,color: Colors.white,size: 130,),))),
              ListTile(leading: Icon(Icons.my_library_music_sharp,color: Colors.grey,),title: Text("Library",style: TextStyle(color: Colors.white),),),
              ListTile(leading: Icon(Icons.equalizer,color: Colors.grey,),title: Text("Equalizer",style: TextStyle(color: Colors.white),),),
              ListTile(leading: Icon(Icons.timer_rounded,color: Colors.grey,),title: Text("Sleep Timer",style: TextStyle(color: Colors.white),),),
              ListTile(leading: Icon(Icons.highlight_remove,color: Colors.grey,),title: Text("Remove Ads",style: TextStyle(color: Colors.white),),),
              ListTile(leading: Icon(Icons.music_note_rounded,color: Colors.grey,),title: Text("Free Ringtone",style: TextStyle(color: Colors.white),),),
              ListTile(leading: Icon(Icons.settings,color: Colors.grey,),title: Text("Settings",style: TextStyle(color: Colors.white),),),
            ],),
          )),
          body: TabBarView(children: [
            Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1D2671), Color(0xFFC33764)])),
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(height: 50, width: double.infinity,
                    child: ListTile(leading: Icon(
                      Icons.shuffle_rounded, color: Colors.amber,),title: Text("Shuffle All (${c1.songlist.length})",
                      style: TextStyle(color: Colors.white),),trailing: Wrap(children: [
                      Icon(Icons.list, color: Colors.white,),
                      Icon(Icons.sort, color: Colors.white,)
                    ],)),

                    color: Color(0xFF1D2671),),
                  RefreshIndicator(color: Colors.white,backgroundColor: Color(0xFF1D2671),child: FutureBuilder(future: c1.getsongs(),builder: (context, snapshot) {

                    if(snapshot.connectionState==ConnectionState.waiting)
                    {
                      return SizedBox(height: MediaQuery.of(context).size.height/1.5,width: 120,child: Center(child: Lottie.asset("image/72445-circular-lines.json"),));
                    }
                    else
                    {
                      return SizedBox(height: 530,width: double.infinity,
                          child: ListView.separated(itemCount: c1.songlist.length,
                            itemBuilder: (context, index) {
                              return Obx(() => GestureDetector(onTapCancel: () {
                                c1.list.value[index]=false;
                              },onTapDown: (details) {
                                c1.list.value[index]=true;
                              },onTapUp: (details) {
                                c1.list.value[index]=true;
                              },
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(context: context, builder: (context) {
                                      return Container(decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [Color(0xFF1D2671), Color(0xFFC33764)])),height: 80,width: double.infinity,
                                          child: ListTile(onTap: () {

                                            Navigator.push(context, MaterialPageRoute(builder: (context) {
                                              return second(index);
                                            },));
                                            _showRewardedAd();

                                          },
                                              title:MarqueeText(style: TextStyle(color: Colors.white),speed: 15,alwaysScroll: true,text: TextSpan(text: "${c1.songlist[index].title}"),),
                                              subtitle: Text(c1.printDuration(
                                                  Duration(milliseconds: c1.songlist[index].duration!)),style: TextStyle(color: Colors.white)),
                                              leading: (albumArt==null)?CircleAvatar(backgroundColor: Colors.purple,child: Icon(Icons.music_note,color: Colors.white,)):
                                              Image.memory(albumArt!,height: 250,width: 250,),
                                              trailing: Obx(() => Wrap(
                                                children: [
                                                  IconButton(onPressed: () async {
                                                    c1.list[c1.con.value]=!c1.list[c1.con.value];
                                                    if (c1.list[c1.con.value]) {
                                                      c1.play(index);
                                                      c1.play1.value=true;
                                                    } else {
                                                      c1.pause(index);
                                                    }
                                                  }, icon:(c1.list[c1.con.value]==true)? Icon(Icons.pause,color: Colors.white,): Icon(Icons.play_arrow,color: Colors.white,),),
                                                  IconButton(onPressed: () async {
                                                    c1.pause(c1.con.value);
                                                    Navigator.pop(context);
                                                  }, icon: Icon(Icons.clear,color: Colors.white,))
                                                ],
                                              ))
                                          )
                                      );
                                    },);
                                    if (c1.list[index]==true) {
                                      c1.play(index);
                                      // c1.play1.value=true;
                                    } else {
                                      c1.pause(index);
                                    }
                                  },
                                  child: ListTile(focusColor: Colors.amber,
                                    title: Text("${c1.songlist[index].title}",style: TextStyle(color: (c1.list.value[index]==true)?Colors.amber:Colors.white)),
                                    leading: (albumArt==null)?CircleAvatar(backgroundColor: Colors.purple,child: Icon(Icons.music_note,color: Colors.white,)):null,
                                    subtitle: Text(c1.printDuration(
                                        Duration(milliseconds: c1.songlist[index].duration!)),style: TextStyle(color: Colors.white)),
                                    trailing: Obx(() => Wrap(
                                      children: [
                                        (c1.list[index]==true)?SizedBox(height: 50,width: 50,child: Lottie.asset("image/18544-music-play.json")):Icon(Icons.music_note,color: Colors.transparent,),
                                       IconButton(onPressed: () {
                                         showModalBottomSheet(backgroundColor: Colors.transparent,context: context, builder: (context) {
                                           return Container(height: 380,width:double.infinity,decoration: BoxDecoration(
                                               borderRadius: BorderRadius.circular(20),
                                               gradient: LinearGradient(
                                                   begin: Alignment.topCenter,
                                                   end: Alignment.bottomCenter,
                                                   colors: [Color(0xFF1D2671), Color(0xFFC33764)])),child: Column(children: [
                                             ListTile(title:Text("${c1.songlist[index].title}",style: TextStyle(color: Colors.white)),
                                               trailing: Wrap(children: [
                                                 IconButton(onPressed: () {

                                                 }, icon: Icon(Icons.info,color: Colors.white,)),
                                                 IconButton(onPressed: () {

                                                 }, icon: Icon(Icons.share,color: Colors.white,))
                                               ]),),
                                             Divider(color: Colors.white),
                                             ListTile(leading: Icon(Icons.playlist_play_sharp,color: Colors.white,),title: Text("Play next",style: TextStyle(color: Colors.white),),),
                                             ListTile(leading: Icon(Icons.music_note_outlined,color: Colors.white,),title: Text("Add to queue",style: TextStyle(color: Colors.white)),),
                                             ListTile(leading: Icon(Icons.add_to_photos,color: Colors.white,),title: Text("Add to playlist",style: TextStyle(color: Colors.white)),),
                                             ListTile(leading: Icon(Icons.notification_important_rounded,color: Colors.white,),title: Text("Set as ringtone",style: TextStyle(color: Colors.white)),),
                                             ListTile(leading: Icon(Icons.delete,color: Colors.white,),title: Text("Delete from device",style: TextStyle(color: Colors.white)),),

                                           ]),);
                                         },);
                                       }, icon:Icon(Icons.more_vert_sharp,color: Colors.white,) )

                                      ],
                                    ),),


                                  ),
                                ),
                              ));
                            }, separatorBuilder: (BuildContext context, int index) {
                            return Divider();
                            },
                          ));
                    }
                  },) , onRefresh: () {
                    c1.songlist.clear();
                      c1.getsongs();
                    return Future(() => null);
                  },)



                ]),
              ),
            ),
            Container(height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF1D2671), Color(0xFFC33764)])),child: FutureBuilder(future: c1.Album(),builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting)
                {
                  return Center(child: CircularProgressIndicator(),);
                }
              else
                {
                  return ListView.builder(itemCount: c1.alubmlist.length,itemBuilder: (context, index) {
                    return ListTile(title: Text("${c1.alubmlist[index].artist}",style: TextStyle(color: Colors.white),),);
                  },);
                }
            },)),
            Container(),
            Container(),
            Container(),
            Container(),
          ]),
          bottomNavigationBar: InkWell(onTap: () {

          },child:  Container(
            color: Color(0xFFC33764),
              alignment: Alignment.center,
              child: AdWidget(ad: myBanner),
              width: double.infinity,
              height: 50),
          ),

        )

    );
  }
}
