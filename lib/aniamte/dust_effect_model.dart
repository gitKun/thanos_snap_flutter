import 'dart:math';
import 'dart:ui' as ui;

class DustEffectModel {
  ui.Image image;

  DustEffectModel(this.image);

  Point get translate {
    if (_translate != null) {
      return _translate;
    }
    double radian1 = pi / 12 * (Random().nextDouble() - 0.5);
    double random = pi * 2 * (Random().nextDouble() - 0.5);
    double transX = 30 * cos(random);
    double transY = 15 * sin(random);
    double realTransX = transX * cos(radian1) - transY * sin(radian1);
    double realTransY = transY * cos(radian1) + transX * sin(radian1);
    _translate = Point(realTransX, realTransY);
    return _translate;
  }

  double get rotation => _rotation;

  Point _translate;
  double _rotation = pi / 12 * (Random().nextDouble() - 0.5);
}
