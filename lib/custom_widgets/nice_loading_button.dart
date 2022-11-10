import 'package:flutter/material.dart';
import 'package:plugin_sample/custom_widgets/custom_circle_indicator.dart';
import 'package:plugin_sample/custom_widgets/opacity_animation.dart';
import 'package:plugin_sample/utils.dart';

class NiceLoadingButton extends StatefulWidget {
  final String? text;
  final bool? loading;
  final VoidCallback? onPressed;
  final Color color;
  final Color highlightColor;
  final Color textColor;
  final Color disableColor;
  final double borderRadius;
  final Icon? icon;
  final bool isBig;
  final bool isWrapText;
  final EdgeInsets padding;
  final Color? borderColor;
  final bool isExpandedText;
  final bool isSmallScreen;
  final bool isFullWidthLoader;
  final bool isIconAfterText;

  const NiceLoadingButton(
    this.text, {
    required this.onPressed,
    this.loading = false,
    this.color = const Color(0xff00a1f1),
    this.highlightColor = const Color(0xff0098E3),
    this.disableColor = const Color(0xff00a1f1),
    this.borderRadius = xSmallPadding,
    this.icon,
    this.isBig = false,
    this.isWrapText = false,
    this.textColor = Colors.white,
    this.padding = const EdgeInsets.symmetric(horizontal: middlePadding),
    this.borderColor,
    this.isExpandedText = false,
    this.isSmallScreen = false,
    this.isFullWidthLoader = false,
    this.isIconAfterText = false,
    Key? key,
  }) : super(key: key);

  @override
  NiceLoadingButtonState createState() => NiceLoadingButtonState();
}

class NiceLoadingButtonState extends State<NiceLoadingButton> {
  var isHighlighted = false;

  @override
  Widget build(BuildContext context) {
    Widget child;

    Widget getButtonTextWidget() {
      return Text(
        widget.text!,
        textAlign: TextAlign.center,
        strutStyle: const StrutStyle(
          forceStrutHeight: true,
        ),
        style: body1.merge(
          TextStyle(
            color: widget.textColor,
            fontWeight: FontWeight.w700,
            fontSize: widget.isSmallScreen ? 14.0 : 16.0,
          ),
        ),
      );
    }

    if ((widget.icon == null || widget.isIconAfterText) && widget.loading!) {
      child = SizedBox(
        width: widget.isFullWidthLoader ? double.infinity : null,
        child: const OpacityAnimation(
          child: CustomCircleIndicator(),
        ),
      );
    } else {
      child = Row(
        mainAxisSize: widget.isWrapText ? MainAxisSize.min : MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        key: const Key(
          'btn_loading',
        ),
        children: widget.isIconAfterText
            ? <Widget>[
                if (widget.text != null)
                  widget.isExpandedText
                      ? Expanded(
                          child: getButtonTextWidget(),
                        )
                      : getButtonTextWidget(),
                if (widget.icon != null) ...[
                  widget.icon!,
                ],
              ]
            : <Widget>[
                if (widget.icon != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 2.0,
                    ),
                    child: widget.icon,
                  ),
                if (widget.icon != null)
                  const SizedBox(
                    width: 5,
                  ),
                if (widget.text != null)
                  widget.isExpandedText
                      ? Expanded(
                          child: getButtonTextWidget(),
                        )
                      : getButtonTextWidget()
              ],
      );
    }

    Color getButtonColor() {
      if (widget.onPressed == null) {
        return widget.disableColor;
      }
      if (isHighlighted) {
        return widget.highlightColor;
      }

      return widget.color;
    }

    return InkWell(
      onTap: widget.loading!
          ? null
          : widget.onPressed == null
              ? null
              : () {
                  hideKeyboard(context);
                  if (widget.onPressed != null) {
                    widget.onPressed!();
                  }
                },
      onHighlightChanged: (flag) {
        setState(() {
          isHighlighted = flag;
        });
      },
      borderRadius: BorderRadius.circular(
        widget.borderRadius,
      ),
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: getButtonColor(),
          borderRadius: BorderRadius.circular(
            widget.borderRadius,
          ),
          border: (widget.borderColor != null)
              ? Border.all(
                  width: 1.0,
                  color: widget.borderColor!,
                )
              : null,
        ),
        height: widget.isBig
            ? middlePadding * 2 + middlePadding + 1
            : smallPadding * 2 + middlePadding + 1,
        child: child,
      ),
    );
  }
}
