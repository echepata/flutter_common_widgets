import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/components/column_with_gaps.dart';

class BulletList extends StatelessWidget {
  final List list;

  final double rowSpacing;

  final double indent;

  final double bulletSize;

  const BulletList({
    super.key,
    required List<Widget> this.list,
    this.rowSpacing = 0,
    this.indent = 5,
    this.bulletSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return ColumnWithGaps(
      gap: rowSpacing,
      children: list
          .map(
            (e) => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\u2022",
                  style: theme.textTheme.bodyLarge!.copyWith(
                    fontSize: bulletSize,
                  ),
                ),
                SizedBox(width: indent),
                Expanded(child: e)
              ],
            ),
          )
          .toList(),
    );
  }
}
