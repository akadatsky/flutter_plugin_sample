// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;

import 'package:flutter/material.dart';

const double _kDefaultIndicatorRadius = 10.5;

class CustomCircleIndicator extends StatefulWidget {
  final Color? tickColor;
  final Color? activeTickColor;

  const CustomCircleIndicator({
    Key? key,
    this.animating = true,
    this.radius = _kDefaultIndicatorRadius,
    this.tickColor = Colors.white,
    this.activeTickColor = const Color(0xff00a1f1),
  })  : assert(radius > 0),
        super(key: key);

  final bool animating;

  final double radius;

  @override
  _CustomCircleIndicatorState createState() => _CustomCircleIndicatorState();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomCircleIndicator &&
          runtimeType == other.runtimeType &&
          tickColor == other.tickColor &&
          activeTickColor == other.activeTickColor &&
          animating == other.animating &&
          radius == other.radius;

  @override
  int get hashCode =>
      tickColor.hashCode ^
      activeTickColor.hashCode ^
      animating.hashCode ^
      radius.hashCode;
}

class _CustomCircleIndicatorState extends State<CustomCircleIndicator>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  _CustomCircleIndicatorState();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    if (widget.animating) _controller!.repeat();
  }

  @override
  void didUpdateWidget(CustomCircleIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animating != oldWidget.animating) {
      if (widget.animating) {
        _controller!.repeat();
      } else {
        _controller!.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.radius * 2,
      width: widget.radius * 2,
      child: CustomPaint(
        painter: _CustomActivityIndicatorPainter(
          position: _controller,
          radius: widget.radius,
          tickColor: widget.tickColor,
          activeTickColor: widget.activeTickColor,
        ),
      ),
    );
  }
}

const double _twoPI = math.pi * 2.0;
const int _tickCount = 12;
const int _halfTickCount = _tickCount ~/ 2;

class _CustomActivityIndicatorPainter extends CustomPainter {
  final Color? tickColor;
  final Color? activeTickColor;

  _CustomActivityIndicatorPainter({
    this.position,
    required double radius,
    this.tickColor,
    this.activeTickColor,
  })  : tickFundamentalRRect = RRect.fromLTRBXY(
          -radius,
          1.0 * radius / _kDefaultIndicatorRadius,
          -radius / 2.0,
          -1.0 * radius / _kDefaultIndicatorRadius,
          1.0,
          1.0,
        ),
        super(repaint: position);

  final Animation<double>? position;
  final RRect tickFundamentalRRect;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint();

    canvas.save();
    canvas.translate(size.width / 2.0, size.height / 2.0);

    final int activeTick = (_tickCount * position!.value).floor();

    for (int i = 0; i < _tickCount; ++i) {
      final double t =
          (((i + activeTick) % _tickCount) / _halfTickCount).clamp(0.0, 1.0);
      paint.color = Color.lerp(activeTickColor, tickColor, t)!;
      canvas.drawRRect(tickFundamentalRRect, paint);
      canvas.rotate(-_twoPI / _tickCount);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CustomActivityIndicatorPainter oldPainter) {
    return oldPainter.position != position;
  }
}
