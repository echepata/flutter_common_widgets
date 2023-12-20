import 'package:fleetcutter_helpers/string_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// Creates a TextFormField for number with proper validation.

class BasicFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool required;
  final String labelText;
  final String hintText;
  final bool readOnly;
  final Function(String?)? validator;
  final bool enabled;
  final bool multiline;
  final int? length;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final TextInputType? textInputType;
  final bool enableAutocorrect;
  final bool enableSuggestion;
  final bool isDatePicker;
  final bool autoFocus;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final TextStyle? textStyle;
  final int? minLines;
  final bool isShowCounterText;
  final int? maxLength;
  final int? minLength;
  final bool? withCustomValidator;
  final FocusNode? focusNode;
  final String? error;
  final TextCapitalization textCapitalization;
  final FieldType fieldType;
  static final DateFormat _customDateFormat = DateFormat('MMMM dd, yyyy');
  final String semanticsLabel;
  final List<String>? autofillHints;

  const BasicFormField(
    this.controller, {
    super.key,
    this.labelText = 'Input',
    this.hintText = '',
    this.required = true,
    this.enabled = true,
    this.readOnly = false,
    this.multiline = false,
    this.validator,
    this.length,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.textInputType,
    this.enableAutocorrect = true,
    this.enableSuggestion = true,
    this.autoFocus = false,
    this.isDatePicker = false,
    this.firstDate,
    this.lastDate,
    this.textStyle,
    this.minLines,
    this.maxLength = 500,
    this.minLength = 0,
    this.withCustomValidator = false,
    this.isShowCounterText = true,
    this.fieldType = FieldType.decorated,
    this.focusNode,
    this.error,
    required this.semanticsLabel,
    this.textCapitalization = TextCapitalization.none,
    this.autofillHints,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = _customDateFormat;
    final inputDecorationTheme = theme.inputDecorationTheme;

    int? minLines;
    if (multiline) {
      minLines = (this.minLines != null) ? this.minLines : 6;
    }

    // Used TextInputType.visiblePassword to disable suggestions as
    // setting enableSuggestions to false doesn't work
    TextInputType? inputType = textInputType;
    if (!enableSuggestion) inputType = TextInputType.visiblePassword;

    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (_, __, ___) {
        return Semantics(
          label: semanticsLabel,
          textField: true,
          readOnly: readOnly,
          enabled: enabled,
          excludeSemantics: true,
          child: TextFormField(
            style: textStyle,
            obscureText: textInputType == TextInputType.visiblePassword &&
                enableSuggestion,
            onTap: isDatePicker
                ? () async {
                    DateTime initialValue = lastDate ?? DateTime.now();
                    try {
                      initialValue = dateFormat.parseLoose(controller.text);
                    } on FormatException {
                      // do nothing
                    }
                    DateTime? pickedDate = await showDatePicker(
                      fieldLabelText: labelText,
                      context: context,
                      initialDate: initialValue,
                      firstDate: firstDate ?? DateTime(1900),
                      lastDate: lastDate ?? DateTime.now(),
                      initialEntryMode: DatePickerEntryMode.calendarOnly,
                    );
                    if (pickedDate != null) {
                      controller.text = dateFormat.format(pickedDate);
                    }
                  }
                : onTap,
            // any number you need (It works as the rows for the textarea)
            minLines: minLines,
            keyboardType: multiline ? TextInputType.multiline : inputType,
            maxLines: multiline ? null : 1,
            maxLength: multiline ? 100 : maxLength,
            buildCounter: ((
              context, {
              required currentLength,
              required isFocused,
              maxLength,
            }) {
              return multiline ? Text('$currentLength/$maxLength') : null;
            }),
            decoration: _getFieldDecoration(inputDecorationTheme, theme),
            inputFormatters: length != null
                ? [LengthLimitingTextInputFormatter(length)]
                : null,
            cursorColor: inputDecorationTheme.focusedBorder!.borderSide.color,
            validator: (value) {
              if (value!.isEmpty) {
                if (required) return "$labelText can't be empty.";
              } else if (value.length < minLength!) {
                return "Please enter a valid $labelText";
              } else {
                if (labelText.contains('Email')) {
                  if (!StringHelper.isEmailValid(value)) {
                    return 'Please enter valid email address';
                  }
                }
                if (validator != null) return validator!(value);
                return null;
              }
              return null;
            },
            controller: controller,
            onChanged: onChanged,
            onFieldSubmitted: focusNode != null
                ? onSubmitted
                : (value) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
            autocorrect: enableAutocorrect,
            enableSuggestions: enableSuggestion,
            textInputAction: labelText.contains('Search')
                ? TextInputAction.search
                : TextInputAction.done,
            autofocus: autoFocus,
            enabled: enabled,
            readOnly: readOnly,
            focusNode: focusNode,
            textCapitalization: textCapitalization,
            autofillHints: autofillHints,
          ),
        );
      },
    );
  }

  InputDecoration _getFieldDecoration(
    InputDecorationTheme inputDecorationTheme,
    ThemeData theme,
  ) {
    Map<FieldType, InputDecoration> map = {
      FieldType.plain: InputDecoration(
        border: InputBorder.none,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        hintText: hintText,
        suffixIcon: suffixIcon,
      ),
      FieldType.decorated: InputDecoration(
        fillColor: inputDecorationTheme.fillColor,
        filled: inputDecorationTheme.filled,
        counterText: (isShowCounterText) ? null : "",
        enabledBorder: inputDecorationTheme.enabledBorder,
        disabledBorder: inputDecorationTheme.disabledBorder,
        focusedBorder: inputDecorationTheme.focusedBorder,
        errorBorder: inputDecorationTheme.errorBorder,
        focusedErrorBorder: inputDecorationTheme.focusedErrorBorder,
        labelText: labelText + (required ? '' : ''),
        suffixIconConstraints: const BoxConstraints(minHeight: 24),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        contentPadding: inputDecorationTheme.contentPadding,
        errorText: error,
        errorMaxLines: 2,
      ),
    };

    return map.containsKey(fieldType)
        ? map[fieldType] as InputDecoration
        : map[FieldType.plain] as InputDecoration;
  }
}

enum FieldType { plain, decorated }
