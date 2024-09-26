import 'package:flutter/material.dart';

class DropdownWidget extends StatelessWidget {
  final String? topLabel;
  final String? hintText;
  final IconData? prefixIcon;
  final String? errorText;
  final List<String> items;
  final String? selectedItem;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;

  const DropdownWidget({
    super.key,
    this.topLabel,
    this.hintText,
    this.prefixIcon,
    this.errorText,
    required this.items,
    this.selectedItem,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle hintStyle = theme.inputDecorationTheme.hintStyle ??
        TextStyle(
          color: theme.colorScheme.onSurface.withOpacity(0.5),
          fontWeight: FontWeight.normal,
          fontSize: 12,
        );

    final TextStyle errorStyle = theme.inputDecorationTheme.errorStyle ??
        TextStyle(
          fontSize: 12,
          height: 1,
          color: theme.colorScheme.error,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (topLabel != null && topLabel!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              topLabel!,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 12,
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedItem,
            icon: Icon(Icons.arrow_drop_down, color: theme.colorScheme.onSurface.withOpacity(0.5)),
            decoration: InputDecoration(
              prefixIcon: prefixIcon != null
                  ? Icon(
                prefixIcon,
                color: theme.colorScheme.onSurface.withOpacity(0.5),
              )
                  : null,
              hintText: hintText,
              hintStyle: hintStyle,
              errorText: errorText,
              errorStyle: errorStyle,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.dividerColor.withOpacity(0.2),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.primary,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
          ),
        ),
      ],
    );
  }
}
