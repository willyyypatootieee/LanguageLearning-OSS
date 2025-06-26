import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../data/constants/auth_constants.dart';

/// Date picker component for authentication forms
class AuthDatePicker extends StatelessWidget {
  final String labelText;
  final DateTime? selectedDate;
  final VoidCallback onTap;
  final String hintText;

  const AuthDatePicker({
    super.key,
    required this.labelText,
    required this.selectedDate,
    required this.onTap,
    required this.hintText,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.gray900,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppConstants.spacingXs),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: AuthConstants.inputHeight,
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingM,
              vertical: AppConstants.spacingS,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.gray300),
              borderRadius: BorderRadius.circular(AuthConstants.borderRadius),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedDate != null
                            ? _formatDate(selectedDate!)
                            : hintText,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color:
                              selectedDate != null
                                  ? AppColors.gray900
                                  : AppColors.gray400,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.calendar_today, color: AppColors.gray400, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
