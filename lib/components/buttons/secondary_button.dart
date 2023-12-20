import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/components/buttons/button_size.dart';
import 'package:flutter_common_widgets/presentation_layer/helpers/global_variables.dart';

class SecondaryButton extends StatelessWidget {
  final Function() onPressed;
  final String? buttonTitle;
  final bool enabled;
  final bool isLoading;
  final Widget? child;
  final ButtonSize buttonSize;

  /// This label is used to wrap the button with something that we can target in
  /// tests. The same semantics label can be reused in different places, but it
  /// should not appear twice in one screen, so this should be something specific
  /// to the context where this button is included.
  ///
  /// If there are multiple instances of the same button in a page (like in a loop)
  /// consider adding a suffix to each one, like "\_1", "\_2", "\_3" , etc. This way
  /// we can target each one independently on our tests
  final String semanticsLabel;

  /// Creates a secondary button
  ///
  /// Either [buttonTitle] or [child] must be non-null. If both [buttonTitle]
  /// and [child] are provided, the widget will implement [buttonTitle].
  const SecondaryButton({
    this.buttonTitle,
    required this.onPressed,
    this.enabled = true,
    this.isLoading = false,
    this.child,
    this.buttonSize = ButtonSize.normal,
    super.key,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    // Set child widget
    Widget? child;
    if (isLoading) {
      child = const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(color: Colors.white),
      );
    } else if (buttonTitle != null) {
      child = Text(
        buttonTitle!,
        textAlign: TextAlign.center,
      );
    } else if (this.child != null) {
      child = this.child!;
    }

    // Set onPressed callback
    Function()? onPressed;
    if (enabled) {
      onPressed = (isLoading) ? null : this.onPressed;
    } else {
      onPressed = null;
    }

    return Semantics(
      label: semanticsLabel,
      button: true,
      enabled: enabled,
      excludeSemantics: true,
      child: ElevatedButton(
        style: getButtonStyle(context),
        onPressed: onPressed,
        child: child,
      ),
    );
  }

  ButtonStyle getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    Map<ButtonSize, ButtonStyle> map = {
      ButtonSize.big: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(stdPadding * 2),
        backgroundColor: theme.dividerColor,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      ButtonSize.normal: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(stdPadding),
        backgroundColor: theme.dividerColor,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      ButtonSize.small: ElevatedButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(
          horizontal: stdPadding,
          vertical: stdPadding * .25,
        ),
        backgroundColor: theme.dividerColor,
        foregroundColor: theme.colorScheme.onSurface,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    };

    return map.containsKey(buttonSize)
        ? map[buttonSize] as ButtonStyle
        : map[ButtonSize.normal] as ButtonStyle;
  }
}
