import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';

class BioBox extends StatelessWidget {
  final String text;

  const BioBox({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(25),

      decoration: BoxDecoration(
        color: AppThemeCustom.green100,
      ),

      width: double.infinity,

      child: Text(
        text.isNotEmpty ? text : 'Sem bio...',
        style: TextStyle(
          color: AppThemeCustom.gray800,
        ),
      ),
    );
  }
}