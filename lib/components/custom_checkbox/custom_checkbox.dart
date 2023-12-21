import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/components/row_with_gaps.dart';
import 'package:flutter_common_widgets/global_variables.dart';

class CustomCheckbox extends StatefulWidget {
  final Widget title;
  final bool? isChecked;
  final bool inverted;
  final TextStyle? textStyle;
  final String semanticsLabel;
  final ValueChanged<bool> onChanged;
  final double? gap;
  final CrossAxisAlignment? crossAxisAlignment;

  const CustomCheckbox({
    super.key,
    required this.title,
    this.isChecked = false,
    required this.onChanged,
    this.inverted = false,
    this.textStyle,
    required this.semanticsLabel,
    this.gap,
    this.crossAxisAlignment,
  });

  @override
  State<StatefulWidget> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool value;

  @override
  Widget build(BuildContext context) {
    value = widget.isChecked!;
    return Semantics(
      checked: value,
      label: '${widget.semanticsLabel} checkbox',
      excludeSemantics: true,
      child: GestureDetector(
        child: RowWithGaps(
          gap: 0.5 * GV.stdPadding,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment:
              widget.crossAxisAlignment ?? CrossAxisAlignment.center,
          children: widget.inverted ? getInvertedChildren() : getChildren(),
        ),
        onTap: () {
          setState(() {
            value = !value;
            widget.onChanged.call(value);
          });
        },
      ),
    );
  }

  List<Widget> getChildren() {
    final theme = Theme.of(context);
    return [
      Expanded(child: widget.title),
      if (widget.gap != null) SizedBox(width: widget.gap),
      Container(
        decoration: BoxDecoration(
          color: value
              ? theme.colorScheme.primary
              : theme.colorScheme.primary.withOpacity(.40),
          borderRadius: BorderRadius.circular(5),
        ),
        height: 25,
        width: 25,
        child: value
            ? const Icon(
                Icons.check_rounded,
                size: 20,
                color: Colors.white,
              )
            : null,
      ),
    ];
  }

  List<Widget> getInvertedChildren() {
    return getChildren().reversed.toList();
  }
}
