import 'package:flutter/material.dart';
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

  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? borderColor;
  final Color? fillColor;
  final Color? focusedBorderColor;

  final TextStyle? textStyle;
  final TextStyle? titleStyle;
  final TextStyle? hintStyle;
  final TextStyle? errorStyle;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  /// A widget displayed outside the text field, to its left.
  /// Wrap this in a `RistoDecorator` to easily add backgrounds and shadows.
  final Widget? outerLeading;

  /// A widget displayed outside the text field, to its right.
  /// Wrap this in a `RistoDecorator` to easily add backgrounds and shadows.
  final Widget? outerTrailing;

  /// Spacing between the text field and the [outerLeading] / [outerTrailing] widgets.
  final double outerSpacing;

  /// If provided, explicitly sets the height of the TextField.
  /// If [outerLeading] or [outerTrailing] are also used, they will beautifully stretch to match this exact height.
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
    this.margin,
    this.borderRadius = 12.0,
    this.borderColor,
    this.fillColor,
    this.focusedBorderColor,
    this.textStyle,
    this.titleStyle,
    this.hintStyle,
    this.errorStyle,
    this.prefixIcon,
    this.suffixIcon,
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

  factory RistoTextField.search({
    Key? key,
    TextEditingController? controller,
    String? hint,
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
    EdgeInsetsGeometry? margin,
    double borderRadius = 15.0,
    Widget? prefixIcon,
    int? maxLength,
    bool isDense = true,
  }) {
    return RistoTextField(
      key: key,
      controller: controller,
      hint: hint ?? 'Search...',
      prefixIcon: prefixIcon ?? const Icon(Icons.search),
      keyboardType: TextInputType.text,
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
      isDense: isDense,
      margin: margin,
      borderRadius: borderRadius,
      maxLength: maxLength,
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
    final borderCol = widget.borderColor ?? theme.colorScheme.outline;
    final focusCol = widget.focusedBorderColor ?? theme.primaryColor;

    final resolvedSuffix = widget.isSecret
        ? IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: theme.iconTheme.color?.withCustomOpacity(0.6),
            ),
            onPressed: () => setState(() => _obscureText = !_obscureText),
          )
        : widget.suffixIcon;

    final inputDecoration = InputDecoration(
      filled: true,
      fillColor: widget.fillColor ?? theme.cardColor,
      contentPadding:
          widget.contentPadding ??
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintText: widget.hint,
      hintStyle: widget.hintStyle ?? TextStyle(color: theme.hintColor),
      errorStyle: widget.errorStyle,
      prefixIcon: widget.prefixIcon,
      suffixIcon: resolvedSuffix,
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
        borderSide: BorderSide(color: theme.colorScheme.error),
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
      textFieldWidget = Row(
        crossAxisAlignment: widget.fieldHeight != null
            ? CrossAxisAlignment.stretch
            : CrossAxisAlignment.center,
        children: [
          if (widget.outerLeading != null) ...[
            widget.outerLeading!,
            SizedBox(width: widget.outerSpacing),
          ],
          Expanded(child: textFieldWidget),
          if (widget.outerTrailing != null) ...[
            SizedBox(width: widget.outerSpacing),
            widget.outerTrailing!,
          ],
        ],
      );

      if (widget.fieldHeight == null) {
        textFieldWidget = IntrinsicHeight(child: textFieldWidget);
      }
    }

    if (widget.fieldHeight != null) {
      textFieldWidget = SizedBox(
        height: widget.fieldHeight,
        child: textFieldWidget,
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
