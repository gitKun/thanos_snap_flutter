import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class AnimatableSprite extends StatelessWidget {
  final ui.Image img;
  final int showIndex;

  const AnimatableSprite({
    Key key,
    @required this.img,
    this.showIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: CustomPaint(
        painter: _SpritesPainter(
          img,
          showIndex: showIndex,
        ),
      ),
    );
  }
}

class _SpritesPainter extends CustomPainter {
  final ui.Image _img; // 图片
  Paint mainPaint;

  int _showIndex = 0;

  _SpritesPainter(
    this._img, {
    @required int showIndex,
  }) {
    this._showIndex = showIndex;
    mainPaint = Paint();
  }

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    Rect rect = Offset(0, 0) & size;
    // 裁剪绘制区域
    canvas.clipRect(rect);
    if (_img != null) {
      double showSize = _img.height.toDouble();
      Rect src = Rect.fromLTRB(
        _showIndex * showSize,
        0,
        (_showIndex + 1) * showSize,
        showSize,
      );
      // src: _img将要显示的区域, rect: _img将要显示的区域实际被绘制的区域
      canvas.drawImageRect(_img, src, rect, mainPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is _SpritesPainter) {
      _SpritesPainter oldPainter = oldDelegate;
      if (oldPainter._showIndex != this._showIndex ||
          oldPainter.mainPaint != this.mainPaint) {
        return true;
      }
    }
    return false;
  }
}
