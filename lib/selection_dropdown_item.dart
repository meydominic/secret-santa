// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class SelectionDropdownItem extends StatelessWidget {
  final String name;

  const SelectionDropdownItem({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: false,
          onChanged: (value) {},
        ),
        Text(name)
      ],
    );
  }
}
