import 'package:flutter/material.dart';

class BasicInput extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextInputType? keyboardType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool showPasswordToggle;
  final bool enabled;
  final int? maxLines;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? initialValue;
  final bool readOnly;
  final bool showCounter;
  final Color? fillColor;
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? border;
  final String? errorText;
  final String? helperText;
  final bool? filled;
  final TextCapitalization textCapitalization;
  final ValueChanged<bool>? onPasswordToggle;

  const BasicInput({
    Key? key,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.prefixIcon,
    this.suffixIcon,
    this.showPasswordToggle = false,
    this.enabled = true,
    this.maxLines = 1,
    this.maxLength,
    this.textInputAction,
    this.onFieldSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.initialValue,
    this.readOnly = false,
    this.showCounter = false,
    this.fillColor,
    this.contentPadding,
    this.border,
    this.errorText,
    this.helperText,
    this.filled = true,
    this.textCapitalization = TextCapitalization.none,
    this.onPasswordToggle,
  }) : super(key: key);

  @override
  State<BasicInput> createState() => _BasicInputState();
}

class _BasicInputState extends State<BasicInput> {
  late bool _obscureText;
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
  }

  @override
  void dispose() {
    // Only dispose the controller if we created it
    if (widget.controller == null) {
      _controller.dispose();
    }
    // Only dispose the focus node if we created it
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return TextFormField(
      style: TextStyle(
        color: Colors.white,
        fontSize: 16.0,
        fontWeight: FontWeight.bold,
      ),
      controller: _controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      autofocus: widget.autofocus,
      initialValue: widget.initialValue,
      readOnly: widget.readOnly,
      textCapitalization: widget.textCapitalization,
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: const TextStyle(
          color: Colors.white,
        ),
        hintText: widget.hintText,
        prefixIcon: widget.prefixIcon,
        suffixIcon: _buildSuffixIcon(

        ),
        filled: widget.filled,
        fillColor: Colors.transparent ?? theme.colorScheme.surface,
        contentPadding: widget.contentPadding ?? const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: widget.border ?? const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        errorText: widget.errorText,
        hintStyle: const TextStyle(
          color: Colors.white,
        ),
        helperText: widget.helperText,
        counterText: widget.showCounter ? null : '',
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.showPasswordToggle) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility : Icons.visibility_off,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
          widget.onPasswordToggle?.call(_obscureText);
        },
      );
    }
    return widget.suffixIcon;
  }
}

