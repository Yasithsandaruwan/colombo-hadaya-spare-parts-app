import 'package:flutter/material.dart';

class FooterStrip extends StatelessWidget {
  const FooterStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 36,
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: Text(
            "All rights reserved",
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
        ),
      ),
    );
  }
}
