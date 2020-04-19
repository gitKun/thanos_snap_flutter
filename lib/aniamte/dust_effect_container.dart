import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:thanos_snap_flutter/aniamte/dust_effect_draw.dart';
import 'dart:ui' as ui;
import 'dust_controller.dart';

class DustEffectContainer extends StatefulWidget {
  final DustController dustController;
  final Widget child;

  const DustEffectContainer({
    Key key,
    this.dustController,
    this.child,
  }) : super(key: key);

  @override
  _DustEffectContainerState createState() => _DustEffectContainerState();
}

class _DustEffectContainerState extends State<DustEffectContainer>
    with SingleTickerProviderStateMixin {
  bool _showDust = false;
  ui.Image _image;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    widget.dustController.addListener(_didChangeDustValue);
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(DustEffectContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dustController != widget.dustController) {
      oldWidget.dustController.removeListener(_didChangeDustValue);
      widget.dustController.addListener(_didChangeDustValue);
    }
  }

  @override
  void dispose() {
    widget.dustController.removeListener(_didChangeDustValue);
    _controller.dispose();
    super.dispose();
  }

  void _didChangeDustValue() {
    if (widget.dustController.value.showDustImage) {
      _createImage();
    }
    setState(() {
      _showDust = widget.dustController.value.showDustImage;
      if(!_showDust) {
        _controller.reset();
      }
    });

    if (widget.dustController.value.animationToSnap && _realShowDust) {
      setState(() {
        _controller.reset();
        _controller.forward();
      });
    } else if(!widget.dustController.value.animationToSnap &&
        _realShowDust) {
      setState(() {
        _controller.reverse();
      });
    }
  }

  void _createImage() async {
    if (_image != null) return;
    try {
      RenderRepaintBoundary boundary =
          rootWidgetKey.currentContext.findRenderObject();
      this.uiImage = await boundary.toImage(pixelRatio: 2);
      return;
    } catch (e) {
      print(e);
    }
  }

  set uiImage(ui.Image newImage) {
    setState(() {
      _image = newImage;
      if (widget.dustController.value.animationToSnap && _realShowDust) {
        _controller.reset();
        _controller.forward();
      }
    });
  }

  GlobalKey rootWidgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [

          Opacity(
            opacity: _realShowDust ? 0 : 1,
            child: RepaintBoundary(
              key: rootWidgetKey,
              child: widget.child,
            ),
          ),
          _dustEffectWidget(context),
        ],
      ),
    );
  }

  bool get _realShowDust => _showDust && (_image != null);

  Widget _dustEffectWidget(BuildContext context) {
    if (!_realShowDust) {
      return Container(
        color: Colors.red,
        height: 0,
      );
    }
    return Container(
      height: _image.height.toDouble() / 2,
      width: _image.width.toDouble() / 2,
      child: DustEffectDraw(
        animationController: _controller,
        image: _image,
      ),
    );
  }
}
