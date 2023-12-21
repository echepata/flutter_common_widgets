import 'package:flutter/material.dart';
import 'package:flutter_common_widgets/components/basic_form_field.dart';
import 'package:flutter_common_widgets/components/row_with_gaps.dart';
import 'package:flutter_common_widgets/global_variables.dart';

class EditableFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String fieldValue;
  final Widget fieldValueWidget;
  final bool isLoading;
  final Function()? onFieldValidate;
  final Function() onTapEdit;
  final bool isToggled;
  final TextInputType? textInputType;

  final String semanticsLabel;

  const EditableFormField({
    super.key,
    required this.fieldValue,
    required this.fieldValueWidget,
    this.onFieldValidate,
    required this.onTapEdit,
    this.labelText = '',
    this.hintText = '',
    this.isLoading = false,
    this.isToggled = false,
    this.textInputType = TextInputType.none,
    required this.semanticsLabel,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController editEmailController =
        TextEditingController(text: fieldValue);
    return Column(
      children: [
        if (!isToggled)
          RowWithGaps(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: fieldValueWidget),
              SizedBox(
                height: 24,
                width: 24,
                child: Semantics(
                  label: semanticsLabel,
                  button: true,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => onTapEdit(),
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            ],
          )
        else ...[
          BasicFormField(
            editEmailController,
            semanticsLabel: semanticsLabel,
            required: true,
            labelText: labelText,
            hintText: hintText,
            textInputType: textInputType,
            enabled: !isLoading,
            suffixIcon: isLoading
                ? Container(
                    padding: EdgeInsets.only(right: GV.stdPadding),
                    height: 20,
                    width: 40,
                    child: const CircularProgressIndicator(),
                  )
                : IconButton(
                    onPressed: () =>
                        onFieldValidate != null ? onFieldValidate!() : null,
                    icon: const Icon(Icons.check),
                  ),
          ),
        ],
      ],
    );
  }
}
