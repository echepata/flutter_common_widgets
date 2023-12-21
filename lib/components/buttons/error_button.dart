import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_common_widgets/components/buttons/button_size.dart';
import 'package:flutter_common_widgets/global_variables.dart';

class ErrorButton extends StatelessWidget {
  final Function() onPressed;
  final String buttonTitle;
  final bool enabled;
  final bool isLoading;
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

  const ErrorButton({
    required this.buttonTitle,
    required this.onPressed,
    required this.semanticsLabel,
    this.enabled = true,
    super.key,
    this.isLoading = false,
    this.buttonSize = ButtonSize.normal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      button: true,
      enabled: enabled,
      label: semanticsLabel,
      excludeSemantics: true,
      child: ElevatedButton(
        onPressed: enabled && !isLoading ? onPressed : null,
        style: getButtonStyle(context),
        child: isLoading
            ? SpinKitChasingDots(
                size: 20,
                color: theme.colorScheme.onError,
              )
            : Text(buttonTitle),
      ),
    );
  }

  ButtonStyle getButtonStyle(BuildContext context) {
    final theme = Theme.of(context);
    Map<ButtonSize, ButtonStyle> map = {
      ButtonSize.big: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(GV.stdPadding * 2),
        backgroundColor: theme.colorScheme.error,
        foregroundColor: theme.colorScheme.onError,
      ),
      ButtonSize.normal: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(GV.stdPadding),
        backgroundColor: theme.colorScheme.error,
        foregroundColor: theme.colorScheme.onError,
      ),
      ButtonSize.small: ElevatedButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.symmetric(
          horizontal: GV.stdPadding,
          vertical: GV.stdPadding * .25,
        ),
        backgroundColor: theme.colorScheme.error,
        foregroundColor: theme.colorScheme.onError,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    };

    return map.containsKey(buttonSize)
        ? map[buttonSize] as ButtonStyle
        : map[ButtonSize.normal] as ButtonStyle;
  }
}
