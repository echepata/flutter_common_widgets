import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/components/buttons/button_size.dart';
import 'package:flutter_common_widgets/presentation_layer/helpers/global_variables.dart';

class SelectedOutlinedButton extends StatelessWidget {
  final Function()? onPressed;
  final String buttonTitle;
  final bool enabled;
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

  const SelectedOutlinedButton({
    required this.buttonTitle,
    this.onPressed,
    this.enabled = true,
    this.buttonSize = ButtonSize.normal,
    super.key,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color mainColor = theme.colorScheme.primary;

    return Semantics(
      label: semanticsLabel,
      button: true,
      excludeSemantics: true,
      enabled: enabled,
      child: OutlinedButton(
        style: getButtonStyle(context, mainColor),
        onPressed: enabled ? onPressed : null,
        child: Text(
          buttonTitle,
          style: TextStyle(color: mainColor),
        ),
      ),
    );
  }

  ButtonStyle getButtonStyle(BuildContext context, Color mainColor) {
    Map<ButtonSize, ButtonStyle> map = {
      ButtonSize.big: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(stdPadding * 2),
        side: buttonBorderSide(
          context,
          mainColor,
        ),
        foregroundColor: mainColor,
      ),
      ButtonSize.normal: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(stdPadding),
        side: buttonBorderSide(
          context,
          mainColor,
        ),
        foregroundColor: mainColor,
      ),
      ButtonSize.small: OutlinedButton.styleFrom(
        minimumSize: Size.zero,
        padding: const EdgeInsets.symmetric(
          horizontal: stdPadding,
          vertical: stdPadding * .25,
        ),
        side: buttonBorderSide(
          context,
          mainColor,
        ),
        foregroundColor: mainColor,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    };

    return map.containsKey(buttonSize)
        ? map[buttonSize] as ButtonStyle
        : map[ButtonSize.normal] as ButtonStyle;
  }

  BorderSide buttonBorderSide(
    BuildContext context,
    Color mainColor,
  ) {
    return OutlinedButtonTheme.of(context)
        .style!
        .side!
        .resolve({})!.copyWith(color: mainColor);
  }
}
