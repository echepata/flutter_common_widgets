import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/components/buttons/circular_icon_button.dart';

class PrimaryCircularIconButton extends StatelessWidget {
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

  const PrimaryCircularIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.elevation = 1,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    var scheme = Theme.of(context).colorScheme;
    return CircularIconButton(
      semanticsLabel: semanticsLabel,
      elevation: elevation,
      onTap: onTap,
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      icon: icon,
    );
  }
}
