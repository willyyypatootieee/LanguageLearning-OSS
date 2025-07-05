import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';

/// Search bar component for feeds
class FeedsSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final Function(String)? onUserSearch;
  final VoidCallback? onFilterTap;

  const FeedsSearchBar({
    super.key,
    required this.onSearchChanged,
    this.onUserSearch,
    this.onFilterTap,
  });

  @override
  State<FeedsSearchBar> createState() => _FeedsSearchBarState();
}

class _FeedsSearchBarState extends State<FeedsSearchBar>
    with TickerProviderStateMixin {
  late final TextEditingController _searchController;
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingL,
        vertical: AppConstants.spacingM,
      ),
      child: Row(
        children: [
          // Search bar
          Expanded(
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color:
                              _isSearchActive
                                  ? AppColors.primary.withValues(alpha: 0.3)
                                  : Colors.black.withValues(alpha: 0.08),
                          blurRadius: _isSearchActive ? 15 : 10,
                          offset: const Offset(0, 3),
                          spreadRadius: _isSearchActive ? 1 : 0,
                        ),
                      ],
                      border: Border.all(
                        color:
                            _isSearchActive
                                ? AppColors.primary.withValues(alpha: 0.5)
                                : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        widget.onSearchChanged(value);
                        // Also trigger user search if callback is provided
                        if (widget.onUserSearch != null) {
                          widget.onUserSearch!(value);
                        }
                      },
                      onTap: () {
                        setState(() {
                          _isSearchActive = true;
                        });
                        _animationController.forward();
                      },
                      onSubmitted: (value) {
                        setState(() {
                          _isSearchActive = false;
                        });
                        _animationController.reverse();
                      },
                      onEditingComplete: () {
                        setState(() {
                          _isSearchActive = false;
                        });
                        _animationController.reverse();
                      },
                      style: TextStyle(
                        fontSize: 15,
                        color: AppColors.gray800,
                        fontFamily: AppTypography.bodyFont,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Cari postingan, pengguna, atau topik...',
                        hintStyle: TextStyle(
                          color: AppColors.gray400,
                          fontFamily: AppTypography.bodyFont,
                        ),
                        prefixIcon: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color:
                                _isSearchActive
                                    ? AppColors.primary.withValues(alpha: 0.1)
                                    : AppColors.gray100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.search,
                            color:
                                _isSearchActive
                                    ? AppColors.primary
                                    : AppColors.gray500,
                            size: 20,
                          ),
                        ),
                        suffixIcon:
                            _searchController.text.isNotEmpty
                                ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    widget.onSearchChanged('');
                                    setState(() {
                                      _isSearchActive = false;
                                    });
                                    _animationController.reverse();
                                  },
                                  icon: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.gray200,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Icon(
                                      Icons.close,
                                      color: AppColors.gray600,
                                      size: 16,
                                    ),
                                  ),
                                )
                                : null,
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingM,
                          vertical: AppConstants.spacingM,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Filter button
          if (widget.onFilterTap != null) ...[
            const SizedBox(width: AppConstants.spacingM),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: widget.onFilterTap,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(AppConstants.spacingM),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.tune, color: AppColors.gray600, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          'Filter',
                          style: TextStyle(
                            color: AppColors.gray600,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: AppTypography.bodyFont,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
