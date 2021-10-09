
import 'package:flutter/material.dart';
import 'package:widget_kit/text_styles/HMTextStyles.dart';
import 'package:widget_kit/texts/HMText.dart';

class HMButton extends StatefulWidget {
  final HMButtonType status;
  final Function()? onTap;
  final String? title;
  final Widget? child;
  final Color textColor;
  final bool isWhiteBackground;
  final bool havePadding;
  final double height;
  final bool haveShadow;
  final bool isSafeArea;
  final Color buttonColor;
  final Color borderColor;
  final Color? disabledColor;
  final double radius;

  HMButton({
    this.status = HMButtonType.enable,
    this.onTap,
    this.title,
    this.child,
    this.textColor = Colors.black,
    this.isWhiteBackground = true,
    this.havePadding = false,
    this.height = 40,
    this.haveShadow = false,
    this.isSafeArea = true,
    this.buttonColor = const Color(0xffFF37A5),
    this.disabledColor,
    this.borderColor = Colors.transparent,
    this.radius = 4,
  }) : assert(title == null || child == null, 'Cannot provide both title and child');

  @override
  _HMButtonState createState() => _HMButtonState();
}

class _HMButtonState extends State<HMButton> {
  @override
  Widget build(BuildContext context) {
    Widget content = widget.child != null
      ? widget.child!
      : HMText(
          widget.title ?? "",
          style: HMTextStyles.h5,
          color: widget.status != HMButtonType.disable
            ? widget.textColor
            : Colors.white.withOpacity(0.25)
        );

    Widget child = Container(
      // color: widget.isWhiteBackground ? Colors.white : Colors.transparent,
      //color: Colors.blue,
      padding: EdgeInsets.all(widget.havePadding ? 16 : 0),
      child: TextButton(
        onPressed: widget.status == HMButtonType.enable 
          ? widget.onTap 
          : null,
        style: ButtonStyle(
          elevation: MaterialStateProperty.resolveWith<double>((states) {
            if (states.contains(MaterialState.disabled)) {
              return widget.haveShadow && widget.status != HMButtonType.disable ? 2 : 0;
            }
            return widget.haveShadow && widget.status != HMButtonType.disable 
              ? 3 
              : 0;
          }),
          shape: MaterialStateProperty.resolveWith<OutlinedBorder>((states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.radius),
            side: BorderSide(
              color: widget.borderColor,
              width: 1,
            ),
          )),
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
            if (states.contains(MaterialState.disabled)) {
              return widget.disabledColor 
                ?? (widget.status == HMButtonType.loading
                  ? Color(0xffD2D6DA)
                  : widget.buttonColor.withOpacity(0.25)
                );
            }

            return widget.status != HMButtonType.disable
              ? widget.status == HMButtonType.loading
                ? Color(0xffD2D6DA)
                : widget.buttonColor
              : Color(0xffFF37A5).withOpacity(0.25);
          })
        ),
        child: Container(
          // width: double.infinity,
          height: widget.height,
          child: Align(
            alignment: Alignment.center,
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) => ScaleTransition(
                child: child,
                scale: animation,
              ),
              child: widget.status != HMButtonType.loading
                ? content
                : Center(
                    child: Container(
                      width: 20,
                      height: 20,
                      child: Theme(
                        data: Theme.of(context),
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                        ),
                      ),
                    ),
                  ),
            ),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
        ),
      ),
    );

    return widget.isSafeArea ? SafeArea(child: child) : child;
  }
}

enum HMButtonType { loading, disable, enable }
