import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:risto_widgets/extensions.dart';

/// A standardized text input field matching the Risto design language.
class RistoTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? title;
  final String? hint;
  final bool isSecret;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? borderColor;
  final Color? fillColor;
  final Color? focusedBorderColor;
  final Color? errorBorderColor;

  final TextStyle? textStyle;
  final TextStyle? titleStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;

  final Widget? innerLeading;
  final Widget? innerTrailing;
  final Widget? outerLeading;
  final Widget? outerTrailing;

  final double outerSpacing;

  /// The visual height of the outer action buttons. Defaults to 54.0.
  final double? fieldHeight;

  final EdgeInsetsGeometry? contentPadding;
  final TextAlignVertical? textAlignVertical;
  final int? maxLength;
  final String? counterText;
  final bool isDense;
  final bool readOnly;
  final TapRegionCallback? onTapOutside;
  final bool horizontalLayout;

  const RistoTextField({
    super.key,
    this.controller,
    this.title,
    this.hint,
    this.isSecret = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.inputFormatters,
    this.margin,
    this.borderRadius = 12.0,
    this.borderColor,
    this.fillColor,
    this.focusedBorderColor,
    this.errorBorderColor,
    this.textStyle,
    this.titleStyle,
    this.hintStyle,
    this.errorStyle,
    this.innerLeading,
    this.innerTrailing,
    this.outerLeading,
    this.outerTrailing,
    this.outerSpacing = 10.0,
    this.fieldHeight,
    this.contentPadding,
    this.textAlignVertical,
    this.maxLength,
    this.counterText,
    this.isDense = false,
    this.readOnly = false,
    this.onTapOutside,
    this.horizontalLayout = false,
  });

  // ===========================================================================
  // FACTORIES
  // ===========================================================================

  factory RistoTextField.search({
    Key? key,
    TextEditingController? controller,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    FocusNode? focusNode,
    Widget? outerLeading,
    Widget? outerTrailing,
    double outerSpacing = 10.0,
    double? fieldHeight,
    EdgeInsetsGeometry? contentPadding,
    Color? fillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    Color? errorBorderColor,
    EdgeInsetsGeometry? margin,
    double borderRadius = 15.0,
    Widget? innerLeading,
    Widget? innerTrailing,
    int? maxLength,
    bool isDense = true,
  }) {
    return RistoTextField(
      key: key,
      controller: controller,
      hint: hint ?? 'Search...',
      innerLeading: innerLeading ?? const Icon(Icons.search),
      innerTrailing: innerTrailing,
      keyboardType: TextInputType.text,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      outerLeading: outerLeading,
      outerTrailing: outerTrailing,
      outerSpacing: outerSpacing,
      fieldHeight: fieldHeight,
      contentPadding: contentPadding,
      fillColor: fillColor,
      borderColor: borderColor,
      focusedBorderColor: focusedBorderColor,
      errorBorderColor: errorBorderColor,
      isDense: isDense,
      margin: margin,
      borderRadius: borderRadius,
      maxLength: maxLength,
      counterText: '',
    );
  }

  factory RistoTextField.password({
    Key? key,
    TextEditingController? controller,
    String? title,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    FocusNode? focusNode,
    EdgeInsetsGeometry? margin,
    double borderRadius = 12.0,
    Widget? innerLeading,
    bool horizontalLayout = false,
    Color? fillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    EdgeInsetsGeometry? contentPadding,
    double? fieldHeight,
  }) {
    return RistoTextField(
      key: key,
      controller: controller,
      title: title ?? 'Password',
      hint: hint ?? '••••••••',
      isSecret: true,
      innerLeading: innerLeading ?? const Icon(Icons.lock_outline),
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      margin: margin,
      borderRadius: borderRadius,
      horizontalLayout: horizontalLayout,
      fillColor: fillColor,
      borderColor: borderColor,
      focusedBorderColor: focusedBorderColor,
      contentPadding: contentPadding,
      fieldHeight: fieldHeight,
      counterText: '',
    );
  }

  factory RistoTextField.email({
    Key? key,
    TextEditingController? controller,
    String? title,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    FocusNode? focusNode,
    EdgeInsetsGeometry? margin,
    double borderRadius = 12.0,
    bool horizontalLayout = false,
    Color? fillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    EdgeInsetsGeometry? contentPadding,
    double? fieldHeight,
  }) {
    return RistoTextField(
      key: key,
      controller: controller,
      title: title ?? 'Email',
      hint: hint ?? 'example@email.com',
      keyboardType: TextInputType.emailAddress,
      innerLeading: const Icon(Icons.email_outlined),
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      margin: margin,
      borderRadius: borderRadius,
      horizontalLayout: horizontalLayout,
      fillColor: fillColor,
      borderColor: borderColor,
      focusedBorderColor: focusedBorderColor,
      contentPadding: contentPadding,
      fieldHeight: fieldHeight,
      counterText: '',
    );
  }

  factory RistoTextField.number({
    Key? key,
    TextEditingController? controller,
    String? title,
    String? hint,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    void Function(String)? onSubmitted,
    FocusNode? focusNode,
    EdgeInsetsGeometry? margin,
    double borderRadius = 12.0,
    Widget? innerLeading,
    Widget? innerTrailing,
    bool horizontalLayout = false,
    bool allowDecimals = true,
    Color? fillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    EdgeInsetsGeometry? contentPadding,
    double? fieldHeight,
  }) {
    return RistoTextField(
      key: key,
      controller: controller,
      title: title,
      hint: hint ?? '0',
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimals),
      inputFormatters: [
        allowDecimals
            ? FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
            : FilteringTextInputFormatter.digitsOnly,
      ],
      innerLeading: innerLeading ?? const Icon(Icons.numbers),
      innerTrailing: innerTrailing,
      validator: validator,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      focusNode: focusNode,
      margin: margin,
      borderRadius: borderRadius,
      horizontalLayout: horizontalLayout,
      fillColor: fillColor,
      borderColor: borderColor,
      focusedBorderColor: focusedBorderColor,
      contentPadding: contentPadding,
      fieldHeight: fieldHeight,
      counterText: '',
    );
  }

  @override
  State<RistoTextField> createState() => _RistoTextFieldState();
}

class _RistoTextFieldState extends State<RistoTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.isSecret;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderCol =
        widget.borderColor ?? theme.colorScheme.outline.withCustomOpacity(0.5);
    final focusCol = widget.focusedBorderColor ?? theme.primaryColor;
    final errorCol = widget.errorBorderColor ?? theme.colorScheme.error;

    final resolvedInnerTrailing = widget.isSecret
        ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: theme.iconTheme.color?.withCustomOpacity(0.6),
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          )
        : widget.innerTrailing;

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: widget.fillColor ?? theme.cardColor,

      // THE FIX: No constraints! A vertical padding of 15 perfectly yields a 54px high
      // visual box with standard Flutter fonts. The text stays centered, and the box
      // doesn't squish when errors appear.
      contentPadding:
          widget.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 15),

      hintText: widget.hint,
      hintStyle: widget.hintStyle ?? TextStyle(color: theme.hintColor),
      errorStyle: widget.errorStyle,
      prefixIcon: widget.innerLeading,
      suffixIcon: resolvedInnerTrailing,
      counterText: widget.counterText,
      isDense: widget.isDense,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(color: borderCol),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(color: borderCol),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(color: focusCol, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(color: errorCol),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        borderSide: BorderSide(color: errorCol, width: 2),
      ),
    );

    Widget textFieldWidget = TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      obscureText: _obscureText,
      textAlignVertical: widget.textAlignVertical ?? TextAlignVertical.center,
      keyboardType:
          widget.keyboardType ??
          (widget.isSecret
              ? TextInputType.visiblePassword
              : TextInputType.text),
      inputFormatters: widget.inputFormatters,
      validator: widget.validator,
      onChanged: widget.onChanged,
      onFieldSubmitted: widget.onSubmitted,
      maxLength: widget.maxLength,
      readOnly: widget.readOnly,
      style: widget.textStyle ?? theme.textTheme.bodyLarge,
      decoration: inputDecoration,
      onTapOutside:
          widget.onTapOutside ?? (event) => FocusScope.of(context).unfocus(),
    );

    // Apply outer leading/trailing widgets
    if (widget.outerLeading != null || widget.outerTrailing != null) {
      final double targetHeight = widget.fieldHeight ?? 54.0;

      textFieldWidget = Row(
        // THE FIX 2: CrossAxisAlignment.start locks the outer buttons to the top
        // of the TextField. When the error text appears below, it won't move the buttons!
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.outerLeading != null) ...[
            SizedBox(height: targetHeight, child: widget.outerLeading!),
            SizedBox(width: widget.outerSpacing),
          ],

          Expanded(child: textFieldWidget),

          // Allowed to grow downwards organically
          if (widget.outerTrailing != null) ...[
            SizedBox(width: widget.outerSpacing),
            SizedBox(height: targetHeight, child: widget.outerTrailing!),
          ],
        ],
      );
    }

    if (widget.title == null) {
      return Padding(
        padding: widget.margin ?? EdgeInsets.zero,
        child: textFieldWidget,
      );
    }

    if (widget.horizontalLayout) {
      return Padding(
        padding: widget.margin ?? EdgeInsets.zero,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Text(
                  widget.title!,
                  style:
                      widget.titleStyle ??
                      theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
            Expanded(flex: 5, child: textFieldWidget),
          ],
        ),
      );
    }

    return Padding(
      padding: widget.margin ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(
              widget.title!,
              style:
                  widget.titleStyle ??
                  theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          textFieldWidget,
        ],
      ),
    );
  }
}
