import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/components/buttons/circular_icon_button.dart';

class SecondaryCircularIconButton extends StatelessWidget {
  final Widget icon;

  final VoidCallback? onTap;

  final double elevation;

  /// This label is used to wrap the button with something that we can target in
  /// tests. The same semantics label can be reused in different places, but it
  /// should not appear twice in one screen, so this should be something specific
  /// to the context where this button is included.
  ///
  /// If there are multiple instances of the same button in a page (like in a loop)
  /// consider adding a suffix to each one, like "\_1", "\_2", "\_3" , etc. This way
  /// we can target each one independently on our tests
  final String semanticsLabel;

  const SecondaryCircularIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.elevation = 1,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CircularIconButton(
      semanticsLabel: semanticsLabel,
      elevation: elevation,
      onTap: onTap,
      backgroundColor: theme.dividerColor,
      foregroundColor: theme.colorScheme.onSurface,
      icon: icon,
    );
  }
}
