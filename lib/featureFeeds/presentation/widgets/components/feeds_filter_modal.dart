import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

/// Filter modal for feeds
class FeedsFilterModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FeedsFilterModal({super.key, required this.onFiltersApplied});

  @override
  State<FeedsFilterModal> createState() => _FeedsFilterModalState();
}

class _FeedsFilterModalState extends State<FeedsFilterModal> {
  String _selectedRank = 'Semua';
  String _selectedSort = 'Terbaru';
  bool _onlyWithImages = false;

  final List<String> _ranks = [
    'Semua',
    'Pemula',
    'Perunggu',
    'Perak',
    'Emas',
    'Platinum',
    'Berlian',
  ];

  final List<String> _sortOptions = [
    'Terbaru',
    'Terpopuler',
    'XP Tertinggi',
    'Streak Terpanjang',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primary, AppColors.accent],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingM),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Filter Postingan',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              fontFamily: AppTypography.headerFont,
                              color: AppColors.gray900,
                            ),
                          ),
                          Text(
                            'Sesuaikan pencarian Anda',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.gray600,
                              fontFamily: AppTypography.bodyFont,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close, color: AppColors.gray500),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingXl),

                // Rank filter
                Text(
                  'Berdasarkan Rank',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray800,
                    fontFamily: AppTypography.bodyFont,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingM),
                Wrap(
                  spacing: AppConstants.spacingS,
                  runSpacing: AppConstants.spacingS,
                  children:
                      _ranks
                          .map(
                            (rank) => _buildFilterChip(
                              rank,
                              _selectedRank == rank,
                              () => setState(() => _selectedRank = rank),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: AppConstants.spacingL),

                // Sort filter
                Text(
                  'Urutkan Berdasarkan',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray800,
                    fontFamily: AppTypography.bodyFont,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingM),
                Wrap(
                  spacing: AppConstants.spacingS,
                  runSpacing: AppConstants.spacingS,
                  children:
                      _sortOptions
                          .map(
                            (sort) => _buildFilterChip(
                              sort,
                              _selectedSort == sort,
                              () => setState(() => _selectedSort = sort),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: AppConstants.spacingL),

                // Additional filters
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingM),
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.image_outlined,
                        color: AppColors.gray600,
                        size: 20,
                      ),
                      const SizedBox(width: AppConstants.spacingM),
                      Expanded(
                        child: Text(
                          'Hanya postingan dengan gambar',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.gray700,
                            fontFamily: AppTypography.bodyFont,
                          ),
                        ),
                      ),
                      Switch(
                        value: _onlyWithImages,
                        onChanged:
                            (value) => setState(() => _onlyWithImages = value),
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXl),

                // Action buttons
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.gray300),
                        ),
                        child: TextButton(
                          onPressed: () => _resetFilters(),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.spacingL,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Reset',
                            style: TextStyle(
                              color: AppColors.gray600,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              fontFamily: AppTypography.bodyFont,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingM),
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.accent],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: _applyFilters,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: AppConstants.spacingL,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.2,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: AppConstants.spacingS),
                                  Text(
                                    'Terapkan Filter',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontFamily: AppTypography.bodyFont,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingM,
          vertical: AppConstants.spacingS,
        ),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [AppColors.primary, AppColors.accent],
                  )
                  : null,
          color: isSelected ? null : AppColors.gray100,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Colors.transparent : AppColors.gray300,
            width: 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white : AppColors.gray700,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontFamily: AppTypography.bodyFont,
          ),
        ),
      ),
    );
  }

  void _resetFilters() {
    setState(() {
      _selectedRank = 'Semua';
      _selectedSort = 'Terbaru';
      _onlyWithImages = false;
    });
  }

  void _applyFilters() {
    final filters = {
      'rank': _selectedRank,
      'sort': _selectedSort,
      'onlyWithImages': _onlyWithImages,
    };

    widget.onFiltersApplied(filters);
    Navigator.of(context).pop();
  }
}
