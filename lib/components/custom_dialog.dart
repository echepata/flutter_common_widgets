import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/components/column_with_gaps.dart';
import 'package:flutter_common_widgets/components/headings.dart';
import 'package:flutter_common_widgets/components/theme_extension.dart';
import 'package:flutter_common_widgets/global_variables.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? buttons;

  const CustomAlertDialog({
    required this.title,
    required this.body,
    this.buttons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GV.stdPadding),
      ),
      child: Container(
        width: 400,
        padding: EdgeInsets.all(GV.stdPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              button: true,
              label: 'Close dialog',
              excludeSemantics: true,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.close,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            ColumnWithGaps(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                HeadingLarge(
                  title,
                  color: theme.isDark
                      ? theme.colorScheme.onSurface
                      : theme.colorScheme.secondary,
                ),
                body,
                if (buttons is Widget) buttons!,
              ],
            )
          ],
        ),
      ),
    );
  }
}
