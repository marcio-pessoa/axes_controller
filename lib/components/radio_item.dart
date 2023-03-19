import 'package:flutter/material.dart';

class RadioItem extends StatelessWidget {
  const RadioItem({
    super.key,
    required this.name,
    required this.id,
    required this.groupValue,
  });

  final String name;
  final String id;
  final String groupValue;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      leading: Radio(
        value: id,
        groupValue: groupValue,
        onChanged: (value) {
          Navigator.pop(context, value);
        },
      ),
      onTap: () {
        Navigator.pop(context, id);
      },
    );
  }
}
