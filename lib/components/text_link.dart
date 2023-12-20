import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/components/theme_extension.dart';

/// @author    Diego
/// @since     2022-07-08
/// @copyright 2022 Carshare Australia Pty Ltd.

class TextLink extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final TextStyle _style;
  final Color? color;
  final String semanticsLabel;

  static const baseStyle = TextStyle();

  const TextLink({
    super.key,
    this.onTap,
    required this.text,
    required this.semanticsLabel,
    TextStyle? style,
    this.color,
  }) : _style = style ?? baseStyle;

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    bool isDark = Theme.of(context).isDark;
    return Semantics(
      label: semanticsLabel,
      link: true,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          splashFactory: NoSplash.splashFactory,
        ),
        child: Text(
          text,
          style: _style.copyWith(
            decoration: TextDecoration.underline,
            color: color ?? (isDark ? scheme.onSurface : scheme.primary),
          ),
        ),
      ),
    );
  }
}
