import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';

/*
await audioPlayer.play(url);

//or
//await audioPlayer.play(localPath, isLocal: true);

// 一些控制API
await audioPlayer.pause();
await audioPlayer.stop();
await audioPlayer.resume();
*/

class AudioplayersPage extends StatefulWidget {

  @override
  _AudioplayersPageState createState() => _AudioplayersPageState();
}

class _AudioplayersPageState extends State<AudioplayersPage> {

  // AudioPlayer _audioPlayer = new AudioPlayer();
  // AudioCache _player = AudioCache();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: new Text("AudioplayersPage"),
        ),
        body: Container(
          color: Colors.green,
          child: IconButton(icon: Icon(Icons.play_arrow), onPressed: (){
            _play();
          }),
        ),
    );
  }

  void _play() async {
    print('play---');
    // int result = await _audioPlayer.play('assets/video/test.mp3', isLocal: true);
    // if (result == 1) {
    //   print('play success');
    // } else {
    //   print('play failed');
    // }

    // _player.play('assets/video/test.mp3');
  }

//   @override
//   void dispose() {
//     //释放
//     _audioPlayer.dispose();
//     _durationSubscription.cancel();
//     _positionSubscription.cancel();
//     _playerCompleteSubscription.cancel();
//     _playerErrorSubscription.cancel();
//     _playerStateSubscription.cancel();
//     super.dispose();
//   }
//
//   _initAudioPlayer() {
//     // Ideal for long media files or streams.
//     mode =PlayerMode.MEDIA_PLAYER;
//     /// 初始化
//     _audioPlayer = AudioPlayer(mode: mode);
//
//     _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
//       setState(() => _duration = duration);
//       // // TODO implemented for iOS, waiting for android impl
//       // if (Theme.of(context).platform == TargetPlatform.iOS) {
//       //   // (Optional) listen for notification updates in the background
//       //   _audioPlayer.startHeadlessService();
//       //
//       //   // set at least title to see the notification bar on iOS.
//       //   _audioPlayer.setNotification(
//       //       title: 'App Name',
//       //       artist: 'Artist or blank',
//       //       albumTitle: 'Name or blank',
//       //       imageUrl: 'url or blank',
//       //       forwardSkipInterval: const Duration(seconds: 30), // default is 30s
//       //       backwardSkipInterval: const Duration(seconds: 30), // default is 30s
//       //       duration: duration,
//       //       elapsedTime: Duration(seconds: 0));
//       // }
//     });
//
//     /// 监听进度
//     _positionSubscription = _audioPlayer.onAudioPositionChanged.listen((p) => setState(() {
//       _position = p;
//     }));
//
//     /// 播放完成
//     _playerCompleteSubscription = _audioPlayer.onPlayerCompletion.listen((event) {
//       //_onComplete();
//       setState(() {
//         _position = Duration();
//       });
//     });
//
//     /// 监听报错
//     _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
//       print('audioPlayer error : $msg');
//       setState(() {
//         //_playerState = PlayerState.stopped;
//         _duration = Duration(seconds: 0);
//         _position = Duration(seconds: 0);
//       });
//     });
//
//     /// 播放状态改变
//     _audioPlayer.onPlayerStateChanged.listen((state) {
//       if (!mounted) return;
//       setState(() {
//
//       });
//     });
//
//     /// iOS中来自通知区域的玩家状态变化流。
//     _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
//       if (!mounted) return;
//     });
//
// //    _playingRouteState = PlayingRouteState.speakers;
//   }
//
//   /// 开始播放
//   void _play() async {
//     final playPosition = (
//         _position != null &&
//         _duration != null &&
//         _position.inMilliseconds > 0 &&
//         _position.inMilliseconds < _duration.inMilliseconds)
//         ? _position
//         : null;
//
//     final result = await _audioPlayer.play(url, position: playPosition);
//
//     if (result == 1) {
//       print('succes');
//     }
//
//     // default playback rate is 1.0
//     // this should be called after _audioPlayer.play() or _audioPlayer.resume()
//     // this can also be called everytime the user wants to change playback rate in the UI
//     _audioPlayer.setPlaybackRate(playbackRate: 1.0);
//
//   }
//
//   /// 暂停
//   void _pause() async {
//     final result = await _audioPlayer.pause();
//     if (result == 1){
//       print('succes');
//     }
//   }
//
//   /// 停止播放
//   _stop() async {
//     final result = await _audioPlayer.stop();
//     if (result == 1) {
//       setState(() {
//         _position = Duration();
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: new Text("AudioplayersPage"),
//         ),
//         body: Column(
//           children: <Widget>[
//             // Text(_position != null ? '${_positionText ?? ''} / ${_durationText}' : _duration != null ? _durationText : '',),
//             Padding(
//               padding: EdgeInsets.all(12.0),
//               child: Stack(
//                 children: [
//                   Slider(
//                     onChanged: (v) {
//                       final Position = v * _duration.inMilliseconds;
//                       _audioPlayer
//                           .seek(Duration(milliseconds: Position.round()));
//                     },
//                     value: (_position != null &&
//                         _duration != null &&
//                         _position.inMilliseconds > 0 &&
//                         _position.inMilliseconds < _duration.inMilliseconds)
//                         ? _position.inMilliseconds / _duration.inMilliseconds
//                         : 0.0,
//                   ),
//                 ],
//               ),
//             ),
//             Row(
//               children: <Widget>[
//                 IconButton(icon: Icon(Icons.play_arrow), onPressed: (){
//                   _play();
//                 }),
//                 IconButton(icon: Icon(Icons.pause), onPressed: (){
//                   _pause();
//                 }),
//                 IconButton(icon: Icon(Icons.stop), onPressed: (){
//                   _stop();
//                 }),
//               ],
//             )
//           ],
//         )
//     );
//   }
}