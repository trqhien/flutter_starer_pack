import 'package:flutter/material.dart';
import 'package:widget_kit/text_styles/HMTextStyles.dart';

class HMText extends Text {
  final double? size;
  final Color? color;
  final bool upperCased;
  final FontWeight? weight;

  const HMText(
    String text,
    {Key? key,
    TextAlign align = TextAlign.start,
    TextStyle? style,
    int? maxLines,
    TextOverflow? overflow,
    this.weight,
    this.size,
    this.color,
    this.upperCased = false}
  ) : super(
    text,
    key: key,
    overflow: overflow,
    textAlign: align,
    maxLines: maxLines,
    style: style
  );

  @override
  Widget build(BuildContext context) {
    var _style = super.style ?? HMTextStyles.b1;

    if (color != null) {
      _style = _style.copyWith(color: color);
    }

    if (size != null) {
      _style = _style.copyWith(fontSize: size);
    }

    if (weight != null) {
      _style = _style.copyWith(fontWeight: weight);
    }

    return Text(
      upperCased ? super.data!.toUpperCase() : super.data!,
      key: super.key,
      textAlign: super.textAlign,
      maxLines: super.maxLines,
      overflow: super.overflow,
      style: _style,
    );
  }
}
