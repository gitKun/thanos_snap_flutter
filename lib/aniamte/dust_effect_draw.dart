import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:thanos_snap_flutter/image_load.dart';
import 'package:thanos_snap_flutter/bitmap.dart';
import 'dust_effect_model.dart';

class DustEffectDraw extends StatefulWidget {
  final AnimationController animationController;

  final ui.Image image;
  final bool rebuildHeader;

  const DustEffectDraw({
    Key key,
    @required this.animationController,
    @required this.image,
    this.rebuildHeader = true,
  })  : assert(
          animationController != null,
          'A non-null animationController must be provided to a DustEffectDraw widget.',
        ),
        super(key: key);

  @override
  _DustEffectDrawState createState() => _DustEffectDrawState();
}

class _DustEffectDrawState extends State<DustEffectDraw> {
  Animation _animation;
  List<DustEffectModel> dustModelList;

  ui.Image _image;

  @override
  void initState() {
    super.initState();
    _image = widget.image;
    loadImage();
    _initAnimation();
  }

  @override
  dispose() {
    _animation.removeListener(_handleAnimationChange);
    _animation.removeStatusListener(_handleAnimationStatusChange);
    super.dispose();
  }

  static int imageCount = 32;

  loadImage() async {
    ui.Image originImg = _image;
    _initImages(originImg);
  }

  /// 拆解图像
  _initImages(ui.Image image) async {
    ui.Image originImg = image;
    int imageHeight = originImg.height;
    int imageWidth = originImg.width;
    ByteData byteData = await originImg.toByteData();
    Uint8List originList = new Uint8List.view(byteData.buffer);
    int length = originList.length;
    // ARGB信息
    List<Uint8List> framePixels = new List(imageCount);
    for (int i = 0; i < imageCount; i++) {
      framePixels[i] = Uint8List(length);
    }
    // 遍历 originList
    for (int idx = 0; idx < length; idx++) {
      if (idx % 4 == 0 && idx > 3) {
        double column = (idx / 4) % imageWidth;
        // 每个循环2次
        for (int i = 0; i < 1; i++) {
          double factor = Random().nextDouble() + 2 * (column / imageWidth);
          int index = (imageCount * (factor / 3)).floor();
          Uint8List tmp = framePixels[index];
          tmp[idx - 1] = originList[idx - 1];
          tmp[idx - 2] = originList[idx - 2];
          tmp[idx - 3] = originList[idx - 3];
          tmp[idx - 4] = originList[idx - 4];
        }
      }
    }
    List<DustEffectModel> imageList = List();
    for (var e in framePixels) {
      ui.Image outputImage;
      if (widget.rebuildHeader) {
        Bitmap bitmap = Bitmap.fromHeadless(
          originImg.width,
          originImg.height,
          e,
        );
        outputImage = await bitmap.buildImage();
      } else {
        outputImage = await ImageLoader.loader.loadImageByUint8List(e);
      }
      DustEffectModel model = DustEffectModel(outputImage);
      imageList.add(model);
    }
    setState(() {
      this.dustModelList = imageList;
    });
  }

  /// 初始化动画
  _initAnimation() {
    _animation = IntTween(begin: 0, end: 10).animate(widget.animationController)
      ..addListener(_handleAnimationChange)
      ..addStatusListener(_handleAnimationStatusChange);
  }

  _handleAnimationChange() {
    setState(() {});
  }

  _handleAnimationStatusChange(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      // notify completed
    } else if (status == AnimationStatus.dismissed) {
      // // notify dismissed
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dustModelList != null) {
      return Opacity(
        opacity: 1 - _animation.value / 10.0,
        child: CustomPaint(
          painter: _DustEffectPainter(
            dustList: dustModelList,
            step: _animation.value / 10.0,
          ),
        ),
      );
    } else {
      return CustomPaint(
        painter: _DustEffectPlaceholderPainter(placeholderImage: _image),
      );
    }
  }
}

class _DustEffectPlaceholderPainter extends CustomPainter {
  Paint mPaint;
  ui.Image placeholderImage;
  _DustEffectPlaceholderPainter({@required this.placeholderImage}) {
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
    canvas.drawImageRect(image, src, rect, mPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

class _DustEffectPainter extends CustomPainter {
  Paint mPaint;
  double step;
  List<DustEffectModel> dustList;

  _DustEffectPainter({@required this.dustList, this.step}) {
    mPaint = Paint();
  }

  @override
  void paint(Canvas canvas, Size size) {
    Rect rect = Offset(0, 0) & size;
    int total = dustList.length;
    for (var model in dustList) {
      int index = dustList.indexOf(model);
      double realStep = step;
      if ((index / total) > 0.125 + step) {
        realStep = 0;
      }
      ui.Image image = model.image;
      Rect src = Rect.fromLTRB(
        0,
        0,
        image.width.toDouble(),
        image.height.toDouble(),
      );
      double rotation = model.rotation * realStep;
      Point translate = model.translate;
      canvas.save();
      // 计算画布中心轨迹圆半径
      double r = sqrt(pow(size.width, 2) + pow(size.height, 2));
      // 计算画布中心点初始弧度
      double startAngle = atan(size.height / size.width);
      // 计算画布初始中心点坐标
      Point p0 = Point(
        r * cos(startAngle),
        r * sin(startAngle),
      );
      // 需要旋转的弧度
      double xAngle = rotation;
      // 计算旋转后的画布中心点坐标
      Point px = Point(
        r * cos(xAngle + startAngle) - translate.x * realStep,
        r * sin(xAngle + startAngle) - translate.y * realStep,
      );
      // 先平移画布
      canvas.translate((p0.x - px.x) / 2, (p0.y - px.y) / 2);
      // 后旋转
      canvas.rotate(xAngle);
      canvas.drawImageRect(image, src, rect, mPaint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    if (oldDelegate is _DustEffectPainter) {
      _DustEffectPainter oldPainter = oldDelegate;
      if (oldPainter.step != this.step || oldPainter.mPaint != this.mPaint) {
        return true;
      }
    }
    return false;
  }
}

