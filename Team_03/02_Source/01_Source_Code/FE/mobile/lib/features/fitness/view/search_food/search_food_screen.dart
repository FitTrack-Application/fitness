import 'package:flutter/material.dart';
import 'package:mobile/features/fitness/view/search_food/widget/food_item.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/search_food_viewmodel.dart';
import '../food_detail/food_detail_screen.dart';

class SearchFoodScreen extends StatefulWidget {
  const SearchFoodScreen({super.key});

  @override
  State<SearchFoodScreen> createState() => _SearchFoodScreenState();
}

class _SearchFoodScreenState extends State<SearchFoodScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _searchController.addListener(() {
      context.read<SearchFoodViewModel>().filterFoods(query: _searchController.text);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final viewModel = context.read<SearchFoodViewModel>();
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      viewModel.loadFoods(offset: viewModel.foods.length);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchFoodViewModel>();
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Search Food', style: textTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for a food',
                  hintStyle: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  fillColor: colorScheme.surfaceContainerHighest,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                ),
                style: textTheme.bodyMedium,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: viewModel.filteredFoods.length +
                  (viewModel.isFetchingMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == viewModel.filteredFoods.length) {
                  return const Center(child: CircularProgressIndicator());
                }
                final food = viewModel.filteredFoods[index];
                return FoodItemWidget(
                  food: food,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FoodDetailScreen(foodId: food.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}