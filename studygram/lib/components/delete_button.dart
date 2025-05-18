import 'package:flutter/material.dart';
import 'package:studygram/services/settings_model.dart';
import 'package:provider/provider.dart';

class DeleteButton extends StatelessWidget {
  final void Function() onPressed;
  const DeleteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Map<Size, dynamic> iconSize = {
      Size.small: 12.0,
      Size.medium: 14.0,
      Size.large: 16.0
    };

    return Consumer<Settings>(builder: (context, settings, child) {
      return IconButton(
        onPressed: onPressed,
        icon: const Icon(Icons.delete),
        iconSize: iconSize[settings.size],
      );
    });
  }
}
