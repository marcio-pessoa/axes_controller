import 'package:flutter/material.dart';

class CardListTile extends StatelessWidget {
  final String name;
  final String? value;

  const CardListTile({super.key, required this.name, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 20, 0),
      child: TextField(
        controller: TextEditingController(text: value ?? '-'),
        readOnly: true,
        decoration: InputDecoration(labelText: name, border: InputBorder.none),
      ),
    );
  }
}
