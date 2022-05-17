import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_miles/classes/Cache.dart';
import 'package:just_miles/classes/Localizations.dart';
import 'package:just_miles/classes/Styles.dart';

class MainButton extends StatelessWidget {
  final String textKey;
  final Function onPressed;
  final double _radius = 8;
  final bool isRequest;
  final String text;

  MainButton({this.textKey, this.onPressed, this.isRequest = false, this.text});

  @override
  Widget build(BuildContext context) {
    if (!isRequest) {
      return RaisedButton(
        elevation: 0,
        highlightElevation: 0,
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        color: Styles.primaryColor(),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_radius)),
        child: Text(Lang.getString(context, textKey) ?? this.text ?? "No Text",
            style: Styles.buttonTextStyle(), overflow: TextOverflow.visible),
        onPressed: onPressed,
      );
    } else {
      return ProgressButton(
        defaultWidget: Text(
            Lang.getString(context, textKey) ?? this.text ?? "No Text",
            style: Styles.buttonTextStyle(),
            overflow: TextOverflow.visible),
        progressWidget: CircularProgressIndicator(
          backgroundColor: Styles.secondaryColor(),
        ),
        color: Styles.primaryColor(),
        borderRadius: _radius,
        onPressed: () async {
          await onPressed();
          return () {
            // Optional returns is returning a VoidCallback that will be called
            // after the animation is stopped at the beginning.
            // A best practice would be to do time-consuming task in [onPressed],
            // and do page navigation in the returned VoidCallback.
            // So that user won't missed out the reverse animation.
          };
        },
      );
    }
  }
}

enum ProgressButtonState { Default, Processing }

class ProgressButton extends StatefulWidget {
  final Widget defaultWidget;
  final Widget progressWidget;
  final Function onPressed;
  final Color color;
  final double width;
  final double height;
  final double borderRadius;
  final bool animate;
  bool isForceStop = false;

  ProgressButton({
    Key key,
    @required this.defaultWidget,
    this.progressWidget,
    this.onPressed,
    this.color,
    this.width = double.infinity,
    this.height = 40.0,
    this.borderRadius = 2.0,
    this.animate = true,
  }) : super(key: key);

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton>
    with TickerProviderStateMixin {
  GlobalKey _globalKey = GlobalKey();
  Animation _anim;
  AnimationController _animController;
  Duration _duration = const Duration(milliseconds: 250);
  ProgressButtonState _state;
  double _width;
  double _height;
  double _borderRadius;

  @override
  dispose() {
    widget.isForceStop = true;
    _animController?.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _reset();
    super.deactivate();
  }

  @override
  void initState() {
    _reset();
    super.initState();
  }

  void _reset() {
    _state = ProgressButtonState.Default;
    _width = widget.width;
    _height = widget.height;
    _borderRadius = widget.borderRadius;
  }

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(_borderRadius),
      child: Container(
        key: _globalKey,
        height: _height,
        width: _width,
        child: RaisedButton(
          padding: EdgeInsets.all(0.0),
          color: widget.color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(_borderRadius)),
          child: _buildChildren(context),
          onPressed: widget.onPressed == null
              ? null
              : () async {
                  if (_state != ProgressButtonState.Default) {
                    return;
                  }

                  // The result of widget.onPressed() will be called as Function after button status is back to default.
                  var onDefault;
                  if (widget.animate) {
                    _toProcessing();
                    _forward((status) {
                      if (status == AnimationStatus.dismissed) {
                        _toDefault();
                        if (onDefault != null && onDefault is Function) {
                          onDefault();
                        }
                      }
                    });
                    onDefault = await widget.onPressed();

                    if (!widget.isForceStop) _animController.reverse();
                  } else {
                    _toProcessing();
                    onDefault = await widget.onPressed();
                    _toDefault();
                    if (onDefault != null && onDefault is Function) {
                      onDefault();
                    }
                  }
                },
        ),
      ),
    );
  }

  Widget _buildChildren(BuildContext context) {
    Widget ret;
    switch (_state) {
      case ProgressButtonState.Default:
        ret = widget.defaultWidget;
        break;
      case ProgressButtonState.Processing:
      default:
        ret = widget.progressWidget ?? widget.defaultWidget;
        break;
    }
    return ret;
  }

  void _toProcessing() {
    setState(() {
      _state = ProgressButtonState.Processing;
    });
  }

  void _toDefault() {
    if (mounted) {
      setState(() {
        _state = ProgressButtonState.Default;
      });
    } else {
      _state = ProgressButtonState.Default;
    }
  }

  void _forward(AnimationStatusListener stateListener) {
    double initialWidth = _globalKey.currentContext.size.width;
    double initialBorderRadius = widget.borderRadius;
    double targetWidth = _height;
    double targetBorderRadius = _height / 2;

    _animController = AnimationController(duration: _duration, vsync: this);
    _anim = Tween(begin: 0.0, end: 1.0).animate(_animController)
      ..addListener(() {
        setState(() {
          _width = initialWidth - ((initialWidth - targetWidth) * _anim.value);
          _borderRadius = initialBorderRadius -
              ((initialBorderRadius - targetBorderRadius) * _anim.value);
        });
      })
      ..addStatusListener(stateListener);

    _animController.forward();
  }
}
