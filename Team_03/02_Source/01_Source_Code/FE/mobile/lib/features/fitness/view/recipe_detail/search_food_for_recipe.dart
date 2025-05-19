import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/fitness/view/search_food/widget/error_display.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/search_food_viewmodel.dart';
import '../search_food/widget/food_item.dart';

class SearchFoodForRecipeScreen extends StatefulWidget {
  //final String recipeId;

  const SearchFoodForRecipeScreen({
    super.key,
    //required this.recipeId,
  });

  @override
  State<SearchFoodForRecipeScreen> createState() => _SearchFoodForRecipeScreenState();
}

class _SearchFoodForRecipeScreenState extends State<SearchFoodForRecipeScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    _controller = TextEditingController();

    _controller.addListener(() => _debounceSearch());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchFoodViewModel>().searchFoods(query: '', isInMyRecipesTab: false);
    });
  }


  void _debounceSearch() {
    final timer = _debounce;
    timer?.cancel();

    final controller = _controller;

    final newTimer = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchFoodViewModel>().searchFoods(
        query: controller.text,
      );
    });
    _debounce = newTimer;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }


  void _scrollListener() {
    final viewModel = context.read<SearchFoodViewModel>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 && // Load before reaching the end
        !viewModel.isFetchingMore &&
        viewModel.hasMoreData) {
      viewModel.loadMoreFoods();
    }
  }

  void _retrySearch() {
    final controller =  _controller;

    context.read<SearchFoodViewModel>().searchFoods(
      query: controller.text,
    );
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
        title: Text('Add Food', style: textTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: _buildBody(viewModel))
        ],
      )
    );
  }

  Widget _buildBody(SearchFoodViewModel viewModel,) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Search for food',
                  hintStyle: theme.textTheme.bodyMedium,
                  prefixIcon: viewModel.isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                      : const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      context.read<SearchFoodViewModel>().searchFoods(query: '', isInMyRecipesTab: false);
                    },
                  )
                      : null,
                ),
              ),
            ),
          ),
        Expanded(
          child: _buildListView(viewModel),
        ),
      ],
    );
  }


  Widget _buildListView(SearchFoodViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_food, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              (_controller.text).isEmpty
                  ? 'No foods available'
                  : 'No foods found for "${_controller.text}"',
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
            onTap: () => (),
            onAdd: () => Navigator.pop(context, food) //TODO handle onAdd method here
          );

              },
    );
  }
}
