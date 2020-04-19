import 'package:flutter/cupertino.dart';

class DustValue {
  final bool showDustImage;
  final bool showDustAnimation;

  const DustValue({
    this.showDustImage,
    this.showDustAnimation,
  });

  static const DustValue empty = DustValue(
    showDustImage: false,
    showDustAnimation: false,
  );

  DustValue copyWith({
    bool showDustImage,
    bool showDustAnimation,
  }) {
    return DustValue(
      showDustImage: showDustImage ?? this.showDustImage,
      showDustAnimation: showDustAnimation ?? this.showDustAnimation,
    );
  }
}

class DustController extends ValueNotifier<DustValue> {
  DustController({bool showDust, bool showDustAnimation = false})
      : super(showDust == null
            ? DustValue.empty
            : DustValue(showDustImage: showDust, showDustAnimation: showDustAnimation));

  void showDust() {
    value = DustValue(showDustImage: true, showDustAnimation: false);
  }

  void hiddenDust() {
    value = DustValue(showDustImage: false, showDustAnimation: true);
  }

  void startDustAnimation() {
    //value = value.copyWith(showDustAnimation: true);
    value = DustValue(showDustImage: true, showDustAnimation: true);
  }
}
