import 'package:flutter/material.dart';

/// Common reusable widget for displaying a Card with elevation and rounded corners.
/// 
/// @param child - The widget to display inside the Card
/// @param elevation - The shadow elevation (default: 4)
/// @param borderRadius - The border radius (default: 16)
/// @param margin - Optional margin around the Card
Widget cardContainer({
  required Widget child,
  double elevation = 4,
  double borderRadius = 16,
  EdgeInsets? margin,
}) {
  return Card(
    elevation: elevation,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
    margin: margin,
    child: child,
  );
}

/// Common reusable widget for displaying a ListView with separators, shrink wrap, and no scroll physics.
/// 
/// @param itemBuilder - Function that returns a Widget for each item
/// @param itemCount - The number of items to display
/// @param separatorBuilder - Function that returns a Widget between items (default: Divider)
/// @param shrinkWrap - Whether to shrink the list to fit its contents (default: true)
/// @param padding - Optional padding around the list
Widget listWithSeparators({
  required Widget Function(BuildContext context, int index) itemBuilder,
  required int itemCount,
  Widget Function(BuildContext context, int index)? separatorBuilder,
  bool shrinkWrap = true,
  EdgeInsets? padding,
}) {
  return ListView.separated(
    shrinkWrap: shrinkWrap,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: itemCount,
    separatorBuilder: separatorBuilder ?? (context, index) => const Divider(),
    itemBuilder: itemBuilder,
    padding: padding,
  );
}

/// Common reusable widget for an IconButton with tooltip and onPressed callback.
/// 
/// @param icon - The Icon to display
/// @param tooltip - The tooltip text
/// @param onPressed - The callback when the button is pressed
/// @param color - The color of the icon (default: Colors.grey)
/// @param size - The size of the icon (default: 20)
/// @param padding - Optional padding around the button
IconButtonWithTooltip({
  required Widget icon,
  required String tooltip,
  required VoidCallback onPressed,
  Color? color,
  double? size,
  EdgeInsets? padding,
}) {
  return IconButton(
    icon: icon,
    tooltip: tooltip,
    onPressed: onPressed,
    iconSize: size,
    color: color,
    padding: padding,
  );
}

/// Common reusable widget for an ElevatedButton with Material 3 styling.
/// 
/// @param onPressed - The callback when the button is pressed
/// @param icon - Optional Icon to display
/// @param label - The text label
/// @param backgroundColor - The background color (default: Colors.deepPurple.shade50)
/// @param foregroundColor - The text/icon color (default: Colors.deepPurple)
/// @param padding - The padding (default: EdgeInsets.symmetric(horizontal: 16, vertical: 12))
/// @param borderRadius - The border radius (default: 12)
/// @param disabled - Whether the button is disabled (default: false)
ElevatedButtonWithMaterial3({
  required VoidCallback onPressed,
  Widget? icon,
  required String label,
  Color backgroundColor = Colors.deepPurple.shade50,
  Color foregroundColor = Colors.deepPurple,
  EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  double borderRadius = 12,
  bool disabled = false,
}) {
  return ElevatedButton(
    onPressed: disabled ? null : onPressed,
    child: icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: 8),
              Text(label),
            ],
          )
        : Text(label),
    style: ElevatedButton.styleFrom(
      backgroundColor: disabled ? Colors.grey.shade300 : backgroundColor,
      foregroundColor: disabled ? Colors.grey.shade600 : foregroundColor,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 0,
    ),
  );
}

/// Common reusable widget for a TextButton with Material 3 styling.
/// 
/// @param onPressed - The callback when the button is pressed
/// @param icon - Optional Icon to display
/// @param label - The text label
/// @param color - The color of the button (default: Colors.deepPurple)
/// @param padding - The padding (default: EdgeInsets.zero)
/// @param borderRadius - The border radius (default: 12)
/// @param disabled - Whether the button is disabled (default: false)
TextButtonWithMaterial3({
  required VoidCallback onPressed,
  Widget? icon,
  required String label,
  Color color = Colors.deepPurple,
  EdgeInsets padding = EdgeInsets.zero,
  double borderRadius = 12,
  bool disabled = false,
}) {
  return TextButton(
    onPressed: disabled ? null : onPressed,
    child: icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon,
              const SizedBox(width: 8),
              Text(label),
            ],
          )
        : Text(label),
    style: TextButton.styleFrom(
      foregroundColor: disabled ? Colors.grey.shade600 : color,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
}

/// Common reusable widget for a Container with padding, decoration, and rounded corners.
/// 
/// @param child - The widget to display inside the Container
/// @param padding - The padding around the child
/// @param decoration - The BoxDecoration for the container
/// @param width - Optional width constraint
/// @param height - Optional height constraint
/// @param margin - Optional margin around the Container
ContainerWithDecoration({
  required Widget child,
  required EdgeInsets padding,
  required BoxDecoration decoration,
  double? width,
  double? height,
  EdgeInsets? margin,
}) {
  return Container(
    width: width,
    height: height,
    margin: margin,
    padding: padding,
    decoration: decoration,
    child: child,
  );
}

/// Common reusable widget for a FilterChip with selected state and callback.
/// 
/// @param label - The label text
/// @param selected - Whether the chip is selected
/// @param onSelected - The callback when the chip is toggled
/// @param selectedColor - The color when selected (default: Colors.deepPurple.shade100)
/// @param backgroundColor - The default background color (default: Colors.grey.shade200)
/// @param checkmarkColor - The color of the checkmark when selected (default: Colors.deepPurple)
/// @param spacing - The horizontal spacing between chips (default: 6)
/// @param runSpacing - The vertical spacing between rows (default: 4)
/// @param padding - The padding around each chip (default: EdgeInsets.symmetric(horizontal: 12, vertical: 8))
/// @param borderRadius - The border radius (default: 8)
/// @param disabled - Whether the chip is disabled (default: false)
FilterChipWithCallback({
  required String label,
  required bool selected,
  required ValueChanged<bool> onSelected,
  Color selectedColor = Colors.deepPurple.shade100,
  Color backgroundColor = Colors.grey.shade200,
  Color checkmarkColor = Colors.deepPurple,
  double spacing = 6,
  double runSpacing = 4,
  EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  double borderRadius = 8,
  bool disabled = false,
}) {
  return FilterChip(
    label: Text(label),
    selected: selected,
    onSelected: disabled ? (_) : onSelected,
    selectedColor: selectedColor,
    backgroundColor: backgroundColor,
    checkmarkColor: checkmarkColor,
    spacing: spacing,
    runSpacing: runSpacing,
    padding: padding,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
  );
}

/// Common reusable widget for a DropdownButton with Material 3 styling.
/// 
/// @param items - The list of DropdownMenuItem widgets
/// @param value - The currently selected value
/// @param onChanged - The callback when a value is selected
/// @param decoration - The InputDecoration for the dropdown
/// @param borderRadius - The border radius (default: 12)
/// @param disabled - Whether the dropdown is disabled (default: false)
DropdownButtonWithMaterial3({
  required List<DropdownMenuItem<dynamic>> items,
  required dynamic value,
  required ValueChanged<dynamic> onChanged,
  required InputDecoration decoration,
  double borderRadius = 12,
  bool disabled = false,
}) {
  return DropdownButton<dynamic>(
    value: value,
    items: items,
    onChanged: disabled ? null : onChanged,
    decoration: decoration,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadius),
    ),
  );
}

/// Common reusable widget for a TextField with Material 3 styling.
/// 
/// @param controller - The TextEditingController
/// @param decoration - The InputDecoration for the field
/// @param onSubmitted - The callback when Enter is pressed
/// @param autofocus - Whether to autofocus on init (default: false)
/// @param readOnly - Whether the field is read-only (default: false)
/// @param disabled - Whether the field is disabled (default: false)
TextFieldWithMaterial3({
  required TextEditingController controller,
  required InputDecoration decoration,
  ValueChanged<String>? onSubmitted,
  bool autofocus = false,
  bool readOnly = false,
  bool disabled = false,
}) {
  return TextField(
    controller: controller,
    decoration: decoration,
    onSubmitted: onSubmitted,
    autofocus: autofocus,
    readOnly: readOnly,
    enabled: !disabled,
  );
}

/// Common reusable widget for a Row with aligned children and spacing.
/// 
/// @param children - The list of children widgets
/// @param mainAxisAlignment - The alignment along the main axis
/// @param crossAxisAlignment - The alignment along the cross axis
/// @param spacing - The spacing between children (default: 8)
/// @param mainAxisSize - The size along the main axis (default: MainAxisSize.min)
RowWithSpacing({
  required List<Widget> children,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  double spacing = 8,
  MainAxisSize mainAxisSize = MainAxisSize.min,
}) {
  return Row(
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    spacing: spacing,
    mainAxisSize: mainAxisSize,
    children: children,
  );
}

/// Common reusable widget for a Column with aligned children and spacing.
/// 
/// @param children - The list of children widgets
/// @param mainAxisAlignment - The alignment along the main axis
/// @param crossAxisAlignment - The alignment along the cross axis
/// @param spacing - The spacing between children (default: 8)
/// @param mainAxisSize - The size along the main axis (default: MainAxisSize.min)
ColumnWithSpacing({
  required List<Widget> children,
  MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  double spacing = 8,
  MainAxisSize mainAxisSize = MainAxisSize.min,
}) {
  return Column(
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    spacing: spacing,
    mainAxisSize: mainAxisSize,
    children: children,
  );
}

/// Common reusable widget for a Text with bold styling and optional color.
/// 
/// @param text - The text to display
/// @param bold - Whether the text should be bold (default: false)
/// @param color - The color of the text (default: Theme default)
/// @param fontSize - The font size (default: Theme default)
/// @param textAlign - The text alignment (default: TextAlign.start)
/// @param style - Optional TextStyle to override defaults
TextWithStyling({
  required String text,
  bool bold = false,
  Color? color,
  double? fontSize,
  TextAlign textAlign = TextAlign.start,
  TextStyle? style,
}) {
  return Text(
    text,
    style: style ??
        TextStyle(
          fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          color: color,
          fontSize: fontSize,
        ),
    textAlign: textAlign,
  );
}
