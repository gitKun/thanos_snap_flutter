import 'package:flutter/cupertino.dart';

class DustValue {
  final bool showDustImage;
  final bool animationToSnap;

  const DustValue({
    this.showDustImage,
    this.animationToSnap,
  });

  static const DustValue empty = DustValue(
    showDustImage: false,
    animationToSnap: false,
  );

  DustValue copyWith({
    bool showDustImage,
    bool showDustAnimation,
  }) {
    return DustValue(
      showDustImage: showDustImage ?? this.showDustImage,
      animationToSnap: showDustAnimation ?? this.animationToSnap,
    );
  }
}

class DustController extends ValueNotifier<DustValue> {
  DustController({bool showDust, bool showDustAnimation = false})
      : super(showDust == null
            ? DustValue.empty
            : DustValue(
                showDustImage: showDust, animationToSnap: showDustAnimation));

  void showDust() {
    value = DustValue(showDustImage: true, animationToSnap: false);
  }

  void hiddenDust() {
    value = DustValue(showDustImage: false, animationToSnap: false);
  }

  void startDustAnimation() {
    //value = value.copyWith(showDustAnimation: true);
    value = DustValue(showDustImage: true, animationToSnap: true);
  }

  void reverseDustAnimation() {
    //value = value.copyWith(showDustAnimation: true);
    value = DustValue(showDustImage: true, animationToSnap: false);
  }
}
