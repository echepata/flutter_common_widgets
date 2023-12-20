import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/components/text_link.dart';

/// @author    Diego
/// @since     2022-07-08
/// @copyright 2022 Carshare Australia Pty Ltd.

class ErrorTextLink extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final TextStyle _style;
  final String semanticsLabel;

  const ErrorTextLink({
    super.key,
    this.onTap,
    required this.text,
    required this.semanticsLabel,
    TextStyle? style,
  }) : _style = style ?? TextLink.baseStyle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextLink(
      semanticsLabel: semanticsLabel,
      text: text,
      onTap: onTap,
      style: _style,
      color: theme.colorScheme.error,
    );
  }
}
