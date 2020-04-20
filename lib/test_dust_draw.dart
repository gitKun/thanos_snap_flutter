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
      alignment: Alignment.center,
      child: _drawImage(),
    );
  }

  Widget _drawImage() {
    if (_image == null) {
      return Container();
    }
    return Container(
      width: 40,
      height: 40,
      child: CustomPaint(
        painter: _AlphaPainter(placeholderImage: _image),
      ),
    );
  }
}

class _AlphaPainter extends CustomPainter {
  Paint mPaint;
  ui.Image placeholderImage;

  _AlphaPainter({@required this.placeholderImage}) {
    mPaint = Paint();
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset(0, 0) & size;
    ui.Image image = placeholderImage;
    Rect src = Rect.fromLTRB(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );
    print("Draw alpha image!");
    mPaint.color = Color.fromRGBO(0, 0, 0, 0.5);
    canvas.drawImageRect(image, src, rect, mPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
