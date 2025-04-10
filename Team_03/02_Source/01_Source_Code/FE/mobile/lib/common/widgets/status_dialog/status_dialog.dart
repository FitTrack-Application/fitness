import 'package:flutter/material.dart';
import 'package:mobile/cores/constants/colors.dart';
import 'package:mobile/cores/constants/enums/status_enum.dart';

class StatusDialog extends StatelessWidget {
  final StatusType status;
  final String title;
  final String message;
  final VoidCallback? onOkPressed;

  const StatusDialog({
    super.key,
    required this.status,
    required this.title,
    required this.message,
    this.onOkPressed,
  });

  // Lấy màu sắc cho dialog và nút dựa trên trạng thái và theme
  Map<String, Color> _getColors(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    switch (status) {
      case StatusType.success:
        return {
          'background': isDarkTheme ? SupportColors.success200 : SupportColors.success100,
          'foreground': isDarkTheme ? SupportColors.success100 : SupportColors.success300,
        };
      case StatusType.warning:
        return {
          'background': isDarkTheme ? SupportColors.warning200 : SupportColors.warning100,
          'foreground': isDarkTheme ? SupportColors.warning100 : SupportColors.warning300,
        };
      case StatusType.error:
        return {
          'background': isDarkTheme ? SupportColors.error200 : SupportColors.error100,
          'foreground': isDarkTheme ? SupportColors.error100 : SupportColors.error300,
        };
    }
  }

  // Lấy icon dựa trên trạng thái
  IconData _getIcon() {
    switch (status) {
      case StatusType.success:
        return Icons.check_circle_outline;
      case StatusType.warning:
        return Icons.warning_amber_outlined;
      case StatusType.error:
        return Icons.error_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors(context);
    final icon = _getIcon();

    return AlertDialog(
      backgroundColor: colors['background'],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      contentPadding: const EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Icon(
            icon,
            size: 48,
            color: colors['foreground'],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colors['foreground'],
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors['foreground'],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 120,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colors['background'], // Màu nền của nút
                foregroundColor: colors['foreground'], // Màu chữ/icon của nút
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: colors['foreground'] ?? Colors.black, // Màu viền theo foreground, mặc định là đen nếu null
                ),
              ),
              onPressed: onOkPressed ?? () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

// Hàm tiện ích để hiển thị dialog
void showStatusDialog(
    BuildContext context, {
      required StatusType status,
      required String title,
      required String message,
      VoidCallback? onOkPressed,
    }) {
  showDialog(
    context: context,
    builder: (context) => StatusDialog(
      status: status,
      title: title,
      message: message,
      onOkPressed: onOkPressed,
    ),
  );
}