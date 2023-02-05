import 'package:flutter/material.dart';

class CupertinoSwitchTile extends StatelessWidget {
  const CupertinoSwitchTile({
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final bool title;
  final bool value;
  final void Function(bool)? onChanged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: Text('メニュー', style: TextStyle(fontSize: 25),),
        centerTitle: true,
      ),
      body: SwitchListTile(
        title: const Text('通知', style: TextStyle(fontSize: 25),),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}