import 'package:connect_if/ui/themes/class_themes.dart';
import 'package:flutter/material.dart';

class BioBox extends StatefulWidget {
  final String text;

  const BioBox({
    super.key,
    required this.text,
  });

  @override
  State<BioBox> createState() => _BioBoxState();
}

class _BioBoxState extends State<BioBox> {
  bool _expanded = false;

  bool get _showToggle => widget.text.trim().length > 120;

  @override
  Widget build(BuildContext context) {
    final hasBio = widget.text.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppThemeCustom.gray100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: hasBio
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.text,
                    maxLines: _expanded ? null : 3,
                    overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
                    style: TextStyle(color: AppThemeCustom.gray800),
                  ),
                  if (_showToggle)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => setState(() => _expanded = !_expanded),
                        child: Text(
                          _expanded ? 'Ver menos' : 'Ver mais',
                          style: TextStyle(color: AppThemeCustom.green500),
                        ),
                      ),
                    ),
                ],
              )
            : Row(
                children: [
                  const SizedBox(width: 8),
                  Text(
                    'Sem bio...',
                    style: TextStyle(color: AppThemeCustom.gray600, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
      ),
    );
  }
}