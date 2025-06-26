import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import 'auth_widgets.dart';

/// Login option selector component - allows user to choose between email or username
class AuthLoginOption extends StatelessWidget {
  final bool isEmailMode;
  final VoidCallback onToggle;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AuthLoginOption({
    super.key,
    required this.isEmailMode,
    required this.onToggle,
    required this.controller,
    this.validator,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Toggle buttons
        Row(
          children: [
            Expanded(
              child: _ToggleButton(
                text: 'Email',
                isSelected: isEmailMode,
                onTap: isEmailMode ? null : onToggle,
              ),
            ),
            const SizedBox(width: AppConstants.spacingS),
            Expanded(
              child: _ToggleButton(
                text: 'Username',
                isSelected: !isEmailMode,
                onTap: !isEmailMode ? null : onToggle,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.spacingM),

        // Input field
        AuthInputField(
          controller: controller,
          labelText: isEmailMode ? 'Alamat Email' : 'Username',
          hintText: isEmailMode ? 'Masukkan Email' : 'Masukkan Username',
          keyboardType:
              isEmailMode ? TextInputType.emailAddress : TextInputType.text,
          validator: validator,
        ),
      ],
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback? onTap;

  const _ToggleButton({
    required this.text,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.spacingS,
          horizontal: AppConstants.spacingM,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.gray300,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isSelected ? Colors.white : AppColors.gray600,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
