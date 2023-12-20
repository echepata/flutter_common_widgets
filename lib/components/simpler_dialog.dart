import 'package:flutter/material.dart';

class SimplerDialog extends SimpleDialog {
  const SimplerDialog({
    super.key,
    super.title,
    EdgeInsetsGeometry? titlePadding,
    super.titleTextStyle,
    super.children,
    EdgeInsetsGeometry? contentPadding,
    super.backgroundColor,
    super.elevation,
    super.semanticLabel,
    EdgeInsets? insetPadding,
    super.clipBehavior = Clip.none,
    super.shape,
    super.alignment,
  }) : super(
          titlePadding:
              titlePadding ?? const EdgeInsets.fromLTRB(32, 32, 32, 0.0),
          contentPadding: contentPadding ?? const EdgeInsets.all(32),
          insetPadding: insetPadding ??
              const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        );
}
