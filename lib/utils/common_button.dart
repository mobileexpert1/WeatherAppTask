import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app_bloc/utils/helper.dart';

import 'medium_text_widget.dart';


class GeneralBtn extends StatefulWidget {
  const GeneralBtn({
    super.key,
    required this.title,
    required this.onTap,
    this.loading = false,
    this.colorLoading,
    this.color,
    this.textColor ,
    this.fontFamily ,
    this.xPadding,
    this.fontSize,
    this.yPadding,
    this.enable = true,
    this.leftIcon,
    this.rightIcon,
    this.iconColor,
    this.iconSize,
    this.borderRadius,
    this.lined,
    this.borderRadiusClass,
    this.borderColor,
    this.smallLoading = false,
    this.alignStart =false,
    this.fontWeight
  });

  final String title;
  final String? fontFamily;
  final Function? onTap;
  final bool loading;
  final Color? colorLoading;
  final Color? color;
  final Color? textColor;
  final double? xPadding;
  final double? yPadding;
  final double? fontSize;
  final bool enable;
  final Widget? leftIcon;
  final Widget? rightIcon;
  final Color? iconColor;
  final double? iconSize;
  final double? borderRadius;
  final bool? lined;
  final bool smallLoading;
  final BorderRadius? borderRadiusClass;
  final Color? borderColor;
  final bool alignStart;
  final FontWeight? fontWeight;

  @override
  GeneralBtnState createState() => GeneralBtnState();
}

class GeneralBtnState extends State<GeneralBtn> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: TextButton(
        onPressed: widget.enable
            ? widget.loading
            ? null
            : widget.onTap as void Function()?
            : null,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith(
                  (states) => widget.enable ? widget.color ?? Colors.blue : Colors.grey.withOpacity(0.5)),
          shape: MaterialStateProperty.resolveWith(
                (states) => RoundedRectangleBorder(
              side: BorderSide(
                color: widget.lined == true ? widget.borderColor ?? Colors.grey.withOpacity(0.3) : Colors.transparent,
                width: widget.lined == true ? 2 : 0,

              ),
              borderRadius: widget.borderRadiusClass ?? BorderRadius.circular(widget.borderRadius ?? 12),
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment:widget.alignStart?MainAxisAlignment.start: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.xPadding ?? 5,
                vertical: widget.yPadding ??
                    (defaultTargetPlatform == TargetPlatform.linux ||
                        defaultTargetPlatform == TargetPlatform.macOS ||
                        defaultTargetPlatform == TargetPlatform.windows
                        ? 10
                        : 0.0),
              ),
              child: widget.loading
                  ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  customLoader(height: 22, width: 22),
                  if (widget.smallLoading == false) ...{
                    10.0.spaceX,
                    BodyMediumText(
                      title: "Please Wait ",
                      titleTextAlign:  TextAlign.center,
                      titleColor: widget.colorLoading ?? (widget.enable ? Colors.white : Colors.black.withOpacity(0.6)),
                      fontSize: widget.fontSize ?? 14,
                      fontFamily: widget.fontFamily??"",
                      fontWeight: widget.fontWeight??FontWeight.w700,
                    ),
                  }
                ],
              )
                  : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.leftIcon != null) widget.leftIcon ?? const SizedBox.shrink(),
                  if (widget.leftIcon != null) 7.0.spaceX,
                  BodyMediumText(
                    title:  widget.title,
                    titleTextAlign:  TextAlign.center,
                    titleColor: widget.enable ? widget.textColor ?? Colors.white : Colors.black.withOpacity(0.6),
                    fontSize: widget.fontSize ?? 14,
                    fontFamily: widget.fontFamily??"",
                    fontWeight: widget.fontWeight??FontWeight.w700,
                  ),
                  if (widget.rightIcon != null) 7.0.spaceX,
                  if (widget.rightIcon != null) widget.rightIcon ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
