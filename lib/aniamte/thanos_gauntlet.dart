import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:thanos_snap_flutter/aniamte/animatable_sprite.dart';
import 'dart:ui' as ui;

import 'package:thanos_snap_flutter/image_load.dart';

enum ThanosGauntletAction {
  snap,
  reverse,
}

class ThanosGauntlet extends StatefulWidget {
  final void Function(ThanosGauntletAction action) onPressed;
  final void Function(ThanosGauntletAction action) onAnimationComplete;

  ThanosGauntlet(
      {@required this.onPressed, @required this.onAnimationComplete});

  @override
  _ThanosGauntletState createState() => _ThanosGauntletState();
}

class _ThanosGauntletState extends State<ThanosGauntlet>
    with TickerProviderStateMixin {
  ui.Image snapImg;
  ui.Image reverseImg;
  bool showSnap = true;

  int snapCount;
  AnimationController snapController;
  Animation snapAnimation;
  int reverseCount;
  AnimationController reverseController;
  Animation reverseAnimation;

  bool _isShowingAnimation = false;
  AudioCache _player;

  @override
  void initState() {
    super.initState();
    _player = AudioCache();
    _loadImage();
  }

  @override
  void dispose() {
    snapImg?.dispose();
    reverseImg?.dispose();

    snapAnimation?.removeListener(_handleAnimationChange);
    snapController?.dispose();
    reverseAnimation?.removeListener(_handleAnimationChange);
    reverseController?.dispose();

    _player?.clearCache();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (snapImg != null && reverseImg != null) {
      return GestureDetector(
        child: Container(
          height: 40,
          width: 40,
          child: AnimatableSprite(
            img: !showSnap ? snapImg : reverseImg,
            showIndex: !showSnap ? snapAnimation.value : reverseAnimation.value,
          ),
        ),
        onTap: _showAnimation,
      );
    } else {
      return Container();
    }
  }

  _loadImage() async {
    await Future.wait([
      ImageLoader.loader
          .loadImageByProvider(AssetImage('images/thanos_snap.png'))
          .then((img) {
        setState(() {
          snapImg = img;
          snapCount = img.width ~/ 80 - 1;
        });
      }),
      ImageLoader.loader
          .loadImageByProvider(AssetImage('images/thanos_time.png'))
          .then((img) {
        setState(() {
          reverseImg = img;
          reverseCount = img.width ~/ 80 - 1;
        });
      }),
    ]).whenComplete(() {
      if (snapImg != null && reverseImg != null) {
        _initAnimation();
      }
    });
    _player.loadAll(['thanos_snap_sound.mp3', 'thanos_reverse_sound.mp3']);
  }

  _initAnimation() {
    snapController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    snapAnimation = IntTween(
      begin: 0,
      end: snapCount,
    ).animate(snapController)
      ..addListener(_handleAnimationChange)
      ..addStatusListener(_handleAnimationStatus);

    reverseController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    reverseAnimation = IntTween(
      begin: 0,
      end: reverseCount,
    ).animate(reverseController)
      ..addListener(_handleAnimationChange)
      ..addStatusListener(_handleAnimationStatus);
  }

  _handleAnimationChange() {
    setState(() {
      // do nothing
    });
  }

  _handleAnimationStatus(AnimationStatus status) {
    // if (status == AnimationStatus.forward) {
    //   debugPrint('Animation begain!');
    // }

    if (status == AnimationStatus.completed) {
      _isShowingAnimation = false;
      widget.onAnimationComplete(
        !showSnap ? ThanosGauntletAction.snap : ThanosGauntletAction.reverse,
      );
    }
  }

  _showAnimation() {
    if (_isShowingAnimation) {
      return;
    }
    _isShowingAnimation = true;
    if (showSnap) {
      reverseController.reset();
      snapController.forward();
    } else {
      snapController.reset();
      reverseController.forward();
    }
    showSnap = !showSnap;

    widget.onPressed(
      !showSnap ? ThanosGauntletAction.snap : ThanosGauntletAction.reverse,
    );

    _player.play(
      !showSnap ? 'thanos_snap_sound.mp3' : 'thanos_reverse_sound.mp3',
    );
  }
}
