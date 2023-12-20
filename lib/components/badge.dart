import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/presentation_layer/helpers/global_variables.dart';

/// @author    Diego
/// @since     2022-07-07
/// @copyright 2022 Carshare Australia Pty Ltd.

class Badge extends StatelessWidget {
  final String label;
  final BadgeStyle style;
  final BadgeSize size;
  final BoxDecoration? boxDecoration;
  final Color? backgroundColor;
  final Color? foregroundColor;

  static const double bgOpacity = 0.1;

  const Badge({
    super.key,
    required this.label,
    this.style = BadgeStyle.normal,
    this.size = BadgeSize.normal,
    this.boxDecoration,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration ?? getBoxDecoration(context),
      child: Padding(
        padding: getPadding(),
        child: Text(label, style: getTextStyle(context)),
      ),
    );
  }

  EdgeInsets getPadding() {
    const quarter = stdPadding * .25;
    Map<BadgeSize, EdgeInsets> map = {
      BadgeSize.big: const EdgeInsets.symmetric(
        vertical: quarter,
        horizontal: quarter * 3,
      ),
      BadgeSize.normal: const EdgeInsets.symmetric(
        vertical: quarter,
        horizontal: quarter * 2,
      ),
      BadgeSize.small: const EdgeInsets.symmetric(
        vertical: quarter / 2,
        horizontal: quarter,
      ),
    };

    return map.containsKey(size)
        ? map[size] as EdgeInsets
        : map[BadgeSize.normal] as EdgeInsets;
  }

  BoxDecoration getBoxDecoration(BuildContext context) {
    var theme = Theme.of(context);

    BoxDecoration baseDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(1000),
      border: Border.fromBorderSide(
        BorderSide(color: theme.colorScheme.outline),
      ),
      color: theme.colorScheme.outline.withOpacity(bgOpacity),
    );

    Map<BadgeStyle, BoxDecoration> map = {
      BadgeStyle.normal: baseDecoration,
      BadgeStyle.danger: _changeDecorationColor(
        baseDecoration,
        theme.colorScheme.error,
      ),
      BadgeStyle.failure: _changeDecorationColor(
        baseDecoration,
        theme.colorScheme.error,
      ),
      BadgeStyle.info: _changeDecorationColor(
        baseDecoration,
        theme.colorScheme.secondary,
      ),
      BadgeStyle.success: _changeDecorationColor(baseDecoration, Colors.green),
      BadgeStyle.warning: _changeDecorationColor(baseDecoration, Colors.amber),
    };

    return map.containsKey(style)
        ? map[style] as BoxDecoration
        : baseDecoration;
  }

  BoxDecoration _changeDecorationColor(
    BoxDecoration baseDecoration,
    Color color,
  ) {
    return baseDecoration.copyWith(
      border: baseDecoration.border is BoxBorder
          ? Border.fromBorderSide(
              baseDecoration.border!.top.copyWith(color: color),
            )
          : null,
      color: color.withOpacity(bgOpacity),
    );
  }

  TextStyle getTextStyle(BuildContext context) {
    double fontSize = Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14;
    TextStyle baseStyle =
        Theme.of(context).textTheme.bodyMedium ?? TextStyle(fontSize: fontSize);

    if (foregroundColor is Color) {
      baseStyle = baseStyle.copyWith(color: foregroundColor);
    }

    // ToDo: Maybe change the text style depending on the BadgeStyle?

    Map<BadgeSize, TextStyle> map = {
      BadgeSize.normal: baseStyle.copyWith(fontSize: fontSize),
      BadgeSize.small: baseStyle.copyWith(fontSize: fontSize / 1.5),
      BadgeSize.big: baseStyle.copyWith(fontSize: fontSize * 1.5),
    };

    return map.containsKey(size)
        ? map[size] as TextStyle
        : map[BadgeSize.normal] as TextStyle;
  }
}

enum BadgeStyle {
  info,
  warning,
  normal,
  danger,
  success,
  failure,
}

enum BadgeSize {
  normal,
  small,
  big,
}
