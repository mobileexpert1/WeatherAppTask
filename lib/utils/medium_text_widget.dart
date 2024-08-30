import 'package:flutter/material.dart';

class BodyMediumText extends StatelessWidget {
  const BodyMediumText(
      {Key? key,
        required this.title,
        this.titleColor,
        this.titleTextAlign = TextAlign.left,
        this.maxLine,
        this.fontWeight,
        this.softWrap,
        this.fontStyle,
        this.textScaleFactor,
        this.fontHeight,
        this.textDecoration,
        this.fontFamily,
        this.overflow = TextOverflow.ellipsis,
        this.lineHeight,
        this.fontSize})
      : super(key: key);

  final String title;
  final Color? titleColor;
  final TextAlign titleTextAlign;
  final int? maxLine;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final bool? softWrap;
  final double? textScaleFactor;
  final double? fontHeight;
  final TextDecoration? textDecoration;
  final String? fontFamily;
  final double? lineHeight;
  final double? fontSize;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textScaleFactor: 1,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: titleColor ?? Theme.of(context).textTheme.bodyMedium?.color,
          fontWeight: fontWeight ?? FontWeight.w600,
          fontFamily: fontFamily ?? "",
          overflow: overflow,
          decoration: textDecoration,
          height: lineHeight,
          fontSize: fontSize??14),
      textAlign: titleTextAlign,
      maxLines: maxLine,
      overflow: overflow,
    );
  }
}