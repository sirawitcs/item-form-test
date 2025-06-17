import 'package:flutter/material.dart';

class CustomTextfieldWidget extends StatefulWidget {
  const CustomTextfieldWidget({
    super.key,
    this.controller,
    required this.hintText,
    this.validator,
    this.fieldKey,
    this.widget,
    this.maxLine,
    this.inputType,
  });
  final TextEditingController? controller;
  final String hintText;
  final FormFieldValidator<String>? validator;
  final GlobalKey<FormFieldState>? fieldKey;
  final Widget? widget;
  final int? maxLine;
  final TextInputType? inputType;

  @override
  State<CustomTextfieldWidget> createState() => _CustomTextfieldWidgetState();
}

class _CustomTextfieldWidgetState extends State<CustomTextfieldWidget> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: 40),
      child: TextFormField(
        controller: widget.controller,
        key: widget.fieldKey,
        validator: widget.validator,
        maxLines: widget.maxLine,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          label: Text(widget.hintText),
          alignLabelWithHint: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.blue, width: 1),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.redAccent, width: 1),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
        ),
      ),
    );
  }
}
