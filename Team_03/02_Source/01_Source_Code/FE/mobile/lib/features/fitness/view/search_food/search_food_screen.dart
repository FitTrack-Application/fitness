import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/fitness/models/meal_log.dart';
import 'package:mobile/features/fitness/view/search_food/widget/error_display.dart';
import 'package:provider/provider.dart';

import '../../models/recipe.dart';
import '../../viewmodels/diary_viewmodel.dart';
import '../../viewmodels/search_food_viewmodel.dart';
import 'widget/recipe_item.dart';
import 'widget/food_item.dart';

class SearchFoodScreen extends StatefulWidget {
  final String mealLogId;
  final MealType mealType;

  const SearchFoodScreen({
    super.key,
    required this.mealLogId,
    required this.mealType,
  });

  @override
  State<SearchFoodScreen> createState() => _SearchFoodScreenState();
}

class _SearchFoodScreenState extends State<SearchFoodScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  Timer? _allDebounce;
  late TextEditingController _allController;
  late TextEditingController _myRecipesController;
  Timer? _myRecipesDebounce;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_scrollListener);

    _allController = TextEditingController();
    _myRecipesController = TextEditingController();

    _allController.addListener(() => _debounceSearch(isMyFood: false));
    _myRecipesController.addListener(() => _debounceSearch(isMyFood: true));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchFoodViewModel>().searchFoods(query: '', isInMyRecipesTab: false);
    });
  }


  void _debounceSearch({required bool isMyFood}) {
    final timer = isMyFood ? _myRecipesDebounce : _allDebounce;
    timer?.cancel();

    final controller = isMyFood ? _myRecipesController : _allController;

    final newTimer = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchFoodViewModel>().searchFoods(
        query: controller.text,
        isInMyRecipesTab: isMyFood,
      );
    });

    if (isMyFood) {
      _myRecipesDebounce = newTimer;
    } else {
      _allDebounce = newTimer;
    }
  }


  void _onTabChanged() {
    final isMyFood = _tabController.index == 1;
    context.read<SearchFoodViewModel>().searchFoods(query: _searchController.text, isInMyRecipesTab: isMyFood);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _allController.dispose();
    _myRecipesController.dispose();
    _allDebounce?.cancel();
    _myRecipesDebounce?.cancel();
    _tabController.dispose();
    super.dispose();
  }


  void _scrollListener() {
    final viewModel = context.read<SearchFoodViewModel>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 && // Load before reaching the end
        !viewModel.isFetchingMore &&
        viewModel.hasMoreData) {
      viewModel.loadMoreFoods(isMyFood: _tabController.index == 1);
    }
  }

  void _retrySearch() {
    final isMyFood = _tabController.index == 1;
    final controller = isMyFood ? _myRecipesController : _allController;

    context.read<SearchFoodViewModel>().searchFoods(
      query: controller.text,
      isInMyRecipesTab: isMyFood,
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
        title: Text('Search food', style: textTheme.titleMedium),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              GoRouter.of(context).go('/scan');
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'My Recipes')
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBody(viewModel, isMyFood: true),
                _buildBody(viewModel, isMyFood: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SearchFoodViewModel viewModel, {required bool isMyFood}) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        if (isMyFood)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: _allController,
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
                  suffixIcon: _allController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _allController.clear();
                      context.read<SearchFoodViewModel>().searchFoods(query: '', isInMyRecipesTab: false);
                    },
                  )
                      : null,
                ),
              ),
            ),
          ),
        if(!isMyFood)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    controller: _allController,
                    decoration: InputDecoration(
                      hintText: 'Search for recipe',
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
                      suffixIcon: _allController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _allController.clear();
                          context.read<SearchFoodViewModel>().searchFoods(query: '', isInMyRecipesTab: false);
                        },
                      )
                          : null,
                    ),
                  ),
                ),
              ),

              TextButton(
                onPressed: () async {
                  final Recipe? newRecipe = await context.push('/create_recipe');

                  if (newRecipe != null && context.mounted) {
                    context.read<SearchFoodViewModel>().addRecipeToList(newRecipe);
                  }

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        '+ CREATE RECIPE',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          //color: colorScheme.primary,
                        ),

                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        Expanded(
          child: _buildListView(viewModel, isMyFood: isMyFood),
        ),
      ],
    );
  }


  Widget _buildListView(SearchFoodViewModel viewModel, {required bool isMyFood}) {
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
              (_allController.text).isEmpty
                  ? 'No foods available'
                  : 'No foods found for "${_allController.text}"',
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
                onRetry: () => viewModel.loadMoreFoods(isMyFood: isMyFood),
                compact: true,
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!isMyFood) {
          final recipe = viewModel.recipes[index];
          return RecipeItemWidget(
            recipe: recipe,
            onTap: () => context.push('/recipe_detail', extra: recipe),
            onAdd: (){
              final diaryViewModel = context.read<DiaryViewModel>();
              diaryViewModel.addFoodToDiary(
                mealLogId: widget.mealLogId,
                foodId: recipe.id,
                servingUnitId: 'GRAM',
                numberOfServings: 100,
              );
            },
          );
        } else {
          final food = viewModel.foods[index];
          return FoodItemWidget(
            food: food,
            onTap: () =>context.push('/food/${widget.mealLogId}/${food.id}/add/100?mealType=${mealTypeToString(widget.mealType)}'),
            onAdd: () {
              final diaryViewModel = context.read<DiaryViewModel>();
              diaryViewModel.addFoodToDiary(
                mealLogId: widget.mealLogId,
                foodId: food.id,
                servingUnitId:'9b0f9cf0-1c6e-4c1e-a3a1-8a9fddc20a0b',
                numberOfServings: 100,
              );
            },
          );
          ;
        }
      },
    );
  }
}
