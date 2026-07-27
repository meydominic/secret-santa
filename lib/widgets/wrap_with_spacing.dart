import 'package:flutter/material.dart';

/// Reusable widget for a Wrap with spacing and styling.
/// 
/// @param children - The list of children widgets
/// @param spacing - The horizontal spacing between children (default: 12)
/// @param runSpacing - The vertical spacing between rows (default: 12)
/// @param alignment - The alignment along the cross axis (default: Alignment.center)
/// @param verticalAlignment - The alignment along the vertical axis (default: VerticalAlignment.center)
WrapWithSpacing({
  required List<Widget> children,
  double spacing = 12,
  double runSpacing = 12,
  Alignment alignment = Alignment.center,
  VerticalAlignment verticalAlignment = VerticalAlignment.center,
}) {
  return Wrap(
    spacing: spacing,
    runSpacing: runSpacing,
    children: children,
    alignment: alignment,
    verticalAlignment: verticalAlignment,
  );
}
