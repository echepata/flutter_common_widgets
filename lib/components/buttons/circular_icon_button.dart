import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/components/theme_extension.dart';

class CircularIconButton extends StatelessWidget {
  final Widget icon;

  final VoidCallback? onTap;

  final double elevation;

  final Color? backgroundColor;

  final Color? foregroundColor;

  /// This label is used to wrap the button with something that we can target in
  /// tests. The same semantics label can be reused in different places, but it
  /// should not appear twice in one screen, so this should be something specific
  /// to the context where this button is included.
  ///
  /// If there are multiple instances of the same button in a page (like in a loop)
  /// consider adding a suffix to each one, like "\_1", "\_2", "\_3" , etc. This way
  /// we can target each one independently on our tests
  final String semanticsLabel;

  const CircularIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.elevation = 1,
    this.backgroundColor,
    this.foregroundColor,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).isDark;
    Color backgroundColor = isDark ? Colors.grey.shade800 : Colors.white;
    var scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: semanticsLabel,
      button: true,
      enabled: onTap != null,
      excludeSemantics: true,
      child: FloatingActionButton(
        heroTag: semanticsLabel.toLowerCase().replaceAll(' ', '_'),
        elevation: elevation,
        onPressed: onTap,
        backgroundColor: this.backgroundColor ?? backgroundColor,
        foregroundColor: foregroundColor ?? scheme.onSurface,
        child: icon,
      ),
    );
  }

  static Widget small({
    Key? key,
    required Widget icon,
    VoidCallback? onTap,
    double elevation = 1,
    required String semanticsLabel,
  }) {
    return Builder(
      builder: (context) {
        bool isDark = Theme.of(context).isDark;
        Color backgroundColor = isDark ? Colors.grey.shade800 : Colors.white;

        return Semantics(
          key: GlobalKey(debugLabel: semanticsLabel),
          child: FloatingActionButton.small(
            heroTag: semanticsLabel.toLowerCase().replaceAll(' ', '_'),
            elevation: elevation,
            onPressed: onTap,
            backgroundColor: backgroundColor,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            child: icon,
          ),
        );
      },
    );
  }
}
