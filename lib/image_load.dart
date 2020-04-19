import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ImageLoader {
  ImageLoader._(); // 私有化构造器
  static final ImageLoader loader = ImageLoader._();

  Future<ui.Image> loadImageByProvider(
    ImageProvider provider, {
    ImageConfiguration config = ImageConfiguration.empty,
  }) async {
    Completer<ui.Image> completer = Completer<ui.Image>(); //完成的回调
    ImageStreamListener listener;
    ImageStream stream = provider.resolve(config); //获取图片流
    listener = ImageStreamListener((ImageInfo frame, bool sync) {
      //监听
      final ui.Image image = frame.image;
      completer.complete(image); //完成
      stream.removeListener(listener); //移除监听
    });
    stream.addListener(listener); //添加监听
    return completer.future; //返回
  }


  // 通过 Uint8List获取图片, 默认宽高 [width][height]
  Future<ui.Image> loadImageByUint8List(
      Uint8List list, {
        int width,
        int height,
      }) async {
    /*
    ui.Codec codec = await ui.instantiateImageCodec(list,
        targetWidth: width, targetHeight: height);
    ui.FrameInfo frame = await codec.getNextFrame();
    return frame.image;
     */
    final Completer<ui.Image> completer = new Completer();
    ui.decodeImageFromList(list, (ui.Image img) {
      return completer.complete(img);
    });
    return completer.future;
  }
}
