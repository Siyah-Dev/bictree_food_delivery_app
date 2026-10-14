
import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/widgets/app_primary_button.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/route_names.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../shared/presentation/widgets/food_category_selector.dart';
import '../../../home/presentation/widgets/home_bottom_navigation.dart';
import '../constants/search_filter_options.dart';
import '../models/search_filter_criteria.dart';
import '../widgets/filter_category_chips.dart';
import '../widgets/filter_screen_header.dart';
import '../widgets/price_range_slider.dart';
import '../widgets/rating_sort_selector.dart';

class SearchFilterScreen extends StatefulWidget {
  const SearchFilterScreen({super.key});

  @override
  State<SearchFilterScreen> createState() => _SearchFilterScreenState();
}

class _SearchFilterScreenState extends State<SearchFilterScreen> {
  String _selectedCategory = 'Snacks';
  int _minimumRating = 4;
  double _maximumPrice = 10;

  late Set<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = SearchFilterOptions.initialSelectionFor(
      _selectedCategory,
    ).toSet();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _selectedTags = SearchFilterOptions.initialSelectionFor(
        category,
      ).toSet();
    });
  }

  void _onChipSelectionChanged(String option) {
    setState(() {
      if (!_selectedTags.add(option)) {
        _selectedTags.remove(option);
      }
    });
  }

  void _applyFilters() {
    context.pop(
      SearchFilterCriteria(
        category: _selectedCategory,
        selectedTags: _selectedTags.toList(),
        minimumRating: _minimumRating,
        maximumPrice: _maximumPrice,
      ),
    );
  }

  void _onNavigationTap(int index) {
    switch (index) {
      case 0:
        context.go(RouteNames.home);
        break;
      case 1:
        context.go(RouteNames.menu);
        break;
      case 2:
        AppSnackBar.show(
          context,
          message: 'Favorites are coming soon.',
        );
        break;
      case 3:
        AppSnackBar.show(
          context,
          message: 'Orders are coming soon.',
        );
        break;
      case 4:
        AppSnackBar.show(
          context,
          message: 'Support is outside this task.',
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryOptions = SearchFilterOptions.chipsFor(
      _selectedCategory,
    );

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          FilterScreenHeader(
            onBack: () => context.pop(),
            onCartTap: () {
              AppSnackBar.show(
                context,
                message: 'Cart is coming next.',
              );
            },
            onProfileTap: () {
              AppSnackBar.show(
                context,
                message: 'Profile is outside this task.',
              );
            },
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(26, 13, 26, 22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionTitle('Categories'),
                    const SizedBox(height: 7),
                    FoodCategorySelector(
                      selectedCategory: _selectedCategory,
                      onCategorySelected: _onCategorySelected,
                      style: FoodCategoryStyle.home,
                    ),
                    const SizedBox(height: 8),
                    const _SectionDivider(),
                    const SizedBox(height: 12),

                    const _SectionTitle('Sort by'),
                    const SizedBox(height: 8),
                    RatingSortSelector(
                      rating: _minimumRating,
                      onRatingChanged: (rating) {
                        setState(() => _minimumRating = rating);
                      },
                    ),
                    const SizedBox(height: 12),
                    const _SectionDivider(),
                    const SizedBox(height: 11),

                    const _SmallSectionLabel('Categories'),
                    const SizedBox(height: 10),
                    FilterCategoryChips(
                      options: categoryOptions,
                      selectedOptions: _selectedTags,
                      onSelectionChanged: _onChipSelectionChanged,
                    ),
                    const SizedBox(height: 17),
                    const _SectionDivider(),
                    const SizedBox(height: 17),

                    const Text(
                      'Price',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    PriceRangeSlider(
                      value: _maximumPrice,
                      onChanged: (price) {
                        setState(() => _maximumPrice = price);
                      },
                    ),
                    const SizedBox(height: 35),
                    Center(
                      child: AppPrimaryButton(
                          label: 'Apply',
                          isLoading: false,
                          onPressed: _applyFilters,
                        ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: HomeBottomNavigation(
        selectedIndex: -1,
        onItemSelected: _onNavigationTap,
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _SmallSectionLabel extends StatelessWidget {
  const _SmallSectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
      ),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      thickness: 0.7,
      color: AppColors.dividerColor,
    );
  }
}
