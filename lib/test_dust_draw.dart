import 'package:flutter/material.dart';
import 'package:thanos_snap_flutter/image_load.dart';
import 'aniamte/dust_effect_draw.dart';
import 'dart:ui' as ui;

class TestDustDrawDemo extends StatefulWidget {
  @override
  _TestDustDrawDemoState createState() => _TestDustDrawDemoState();
}

class _TestDustDrawDemoState extends State<TestDustDrawDemo>
    with SingleTickerProviderStateMixin {
  ui.Image _image;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadImage();
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
  }

  _loadImage() {
    ImageLoader.loader
        .loadImageByProvider(AssetImage('images/baidu.png'))
        .then((value) {
      setState(() {
        _image = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      alignment: Alignment.center,
      child: _drawImage(),
    );
  }

  Widget _drawImage() {
    if (_image == null) {
      return Container();
    }
    return Container(

      child: DustEffectDraw(
        image: _image,
        animationController: _controller,
        rebuildHeader: true,
      ),
    );
  }
}
