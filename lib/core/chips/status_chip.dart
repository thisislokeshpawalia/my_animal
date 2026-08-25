import 'package:flutter/material.dart';

import 'app_chip.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    switch (status.toLowerCase()) {
      case "success":
        return AppChip(
          text: status,
          backgroundColor: Colors.green.shade100,
          textColor: Colors.green.shade800,
        );

      case "warning":
        return AppChip(
          text: status,
          backgroundColor: Colors.orange.shade100,
          textColor: Colors.orange.shade800,
        );

      case "error":
        return AppChip(
          text: status,
          backgroundColor: Colors.red.shade100,
          textColor: Colors.red.shade800,
        );

      default:
        return AppChip(text: status);
    }
  }
}