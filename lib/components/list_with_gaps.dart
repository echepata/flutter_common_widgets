import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/components/column_with_gaps.dart';
import 'package:flutter_common_widgets/components/row_with_gaps.dart';
import 'package:flutter_common_widgets/presentation_layer/helpers/global_variables.dart';

/// This widget can be used to switch easily between a column and a row with gaps
class ListWithGaps extends StatelessWidget {
  final double gap;

  // inherited properties
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final TextBaseline? textBaseline;
  final List<Widget> children;
  final ListDirection listDirection;

  const ListWithGaps({
    super.key,
    required this.children,
    this.gap = stdPadding,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    ListDirection? listDirection,
  }) : listDirection = listDirection ?? ListDirection.vertical;

  @override
  Widget build(BuildContext context) {
    return listDirection == ListDirection.vertical
        ? ColumnWithGaps(
            gap: gap,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: crossAxisAlignment,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
            textBaseline: textBaseline,
            children: children,
          )
        : RowWithGaps(
            gap: gap,
            mainAxisAlignment: mainAxisAlignment,
            mainAxisSize: mainAxisSize,
            crossAxisAlignment: crossAxisAlignment,
            textDirection: textDirection,
            verticalDirection: verticalDirection,
            textBaseline: textBaseline,
            children: children,
          );
  }
}

enum ListDirection {
  horizontal,
  vertical;

  bool get isHorizontal => this == ListDirection.horizontal;

  bool get isVertical => !isHorizontal;
}
