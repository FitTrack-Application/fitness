import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/fitness/view/search_food/widget/error_display.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/search_food_viewmodel.dart';
import 'widget/food_item.dart';

class SearchFoodScreen extends StatefulWidget {
  final int diaryId;

  const SearchFoodScreen({super.key, required this.diaryId});

  @override
  State<SearchFoodScreen> createState() => _SearchFoodScreenState();
}

class _SearchFoodScreenState extends State<SearchFoodScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    // Automatically load foods list when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchFoodViewModel>().searchFoods(query: '');
    });

    // Use debounce to avoid calling API too many times when user is typing
    _searchController.addListener(_debounceSearch);
  }

  void _debounceSearch() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      context
          .read<SearchFoodViewModel>()
          .searchFoods(query: _searchController.text);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _scrollListener() {
    final viewModel = context.read<SearchFoodViewModel>();
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent -
                200 && // Load before reaching the end
        !viewModel.isFetchingMore &&
        viewModel.hasMoreData) {
      viewModel.loadMoreFoods();
    }
  }

  void _retrySearch() {
    context
        .read<SearchFoodViewModel>()
        .searchFoods(query: _searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchFoodViewModel>();
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('Search Food', style: textTheme.titleMedium,),
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
                  hintText: 'Search for food',
                  hintStyle: theme.textTheme.bodyMedium,
                  prefixIcon: viewModel.isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            // When clearing text, still search with empty query rather than clearing results
                            viewModel.searchFoods(query: '');
                          },
                        )
                      : null,
                ),
              ),
            ),
          ),
          Expanded(
            child: _buildBody(viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SearchFoodViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (viewModel.errorMessage.isNotEmpty) {
      return Center(
        child: ErrorDisplay(
          message: viewModel.errorMessage,
          onRetry: _retrySearch,
        ),
      );
    }

    if (viewModel.foods.isEmpty) {
      // Change message when no results
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_food, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              _searchController.text.isEmpty
                  ? 'No foods available'
                  : 'No foods found for "${_searchController.text}"',
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: viewModel.foods.length + (viewModel.isFetchingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == viewModel.foods.length) {
          if (viewModel.loadMoreError.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ErrorDisplay(
                message: viewModel.loadMoreError,
                onRetry: () => viewModel.loadMoreFoods(),
                compact: true,
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final food = viewModel.foods[index];
        return FoodItemWidget(
          food: food,
          onTap: () {
            context.push('/food/${widget.diaryId}/${food.id}/add');
          },
        );
      },
    );
  }
}
