import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;

  /// retry callback only for initial load / API failure
  final VoidCallback? onRetry;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    this.title = "No Users Found",
    this.subtitle = "Nothing to show here",
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image.asset(imagePath, height: 180, fit: BoxFit.contain),
            Icon(
              icon ?? Icons.sentiment_dissatisfied_outlined,
              size: 80,
              color: Colors.grey,
            ),

            const SizedBox(height: 20),

            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: 8),

            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 20),

            /// Show Retry ONLY when NOT searching
            if (onRetry != null)
              ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
          ],
        ),
      ),
    );
  }
}
