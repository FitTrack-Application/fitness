import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/fitness/view/search_food/widget/food_item.dart';
import 'package:mobile/features/fitness/view/search_food/widget/my_food_item.dart';
import 'package:mobile/features/fitness/view/search_food/widget/recipe_item.dart';
import 'package:provider/provider.dart';
import '../../models/food.dart';
import '../../models/meal_log.dart';
import '../../models/recipe.dart';
import '../../viewmodels/diary_viewmodel.dart';
import '../../viewmodels/search_food_viewmodel.dart';
import '../search_exercise/widget/error_display.dart';


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
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  late TextEditingController _allController;
  late TextEditingController _myRecipesController;
  late TextEditingController _myFoodsController;

  Timer? _allDebounce;
  Timer? _myRecipesDebounce;
  Timer? _myFoodsDebounce;

  final TextEditingController _aiPromptController = TextEditingController();
  bool _showAIOverlay = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_scrollListener);


    _allController = TextEditingController();
    _myRecipesController = TextEditingController();
    _myFoodsController = TextEditingController();

    _allController.addListener(() => _debounceSearch(TabType.all));
    _myRecipesController.addListener(() => _debounceSearch(TabType.myRecipes));
    _myFoodsController.addListener(() => _debounceSearch(TabType.myFoods));

    Future.microtask(() {
      final vm = context.read<SearchFoodViewModel>();
      vm.loadInitialData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _allController.dispose();
    _myRecipesController.dispose();
    _myFoodsController.dispose();

    _allDebounce?.cancel();
    _myRecipesDebounce?.cancel();
    _myFoodsDebounce?.cancel();

    _aiPromptController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final viewModel = context.read<SearchFoodViewModel>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 && // Load before reaching the end
        !viewModel.isFetchingMore &&
        viewModel.hasMoreData) {
      viewModel.loadMoreFoods(tabType: TabType.all);
    }
  }

  void _onTabChanged() {
    final tabType;
    if(_tabController.index == 0)
      tabType = TabType.all;
    else if (_tabController.index == 1)
      tabType = TabType.myRecipes;
    else tabType = TabType.myFoods;

    context.read<SearchFoodViewModel>().searchFoods(query: _searchController.text,tabType: tabType);
  }


  void _retrySearch(TabType tabType) {
    // final isMyFood = _tabController.index == 1;
    // final controller = isMyFood ? _myRecipesController : _allController;
    final controller;
    switch (tabType){
      case TabType.all:
        controller = _allController;
      case TabType.myRecipes:
        controller = _myRecipesController;
      case TabType.myFoods:
        controller = _myFoodsController;
    }
    context.read<SearchFoodViewModel>().searchFoods(
      query: controller.text,
      tabType: tabType,
    );
  }

  void _debounceSearch(TabType tab) {
    final viewModel = context.read<SearchFoodViewModel>();
    Timer? timer;
    TextEditingController? controller;

    switch (tab) {
      case TabType.all:
        timer = _allDebounce;
        controller = _allController;
        break;
      case TabType.myRecipes:
        timer = _myRecipesDebounce;
        controller = _myRecipesController;
        break;
      case TabType.myFoods:
        timer = _myFoodsController as Timer?;
        controller = _myFoodsController;
        break;
    }

    timer?.cancel();

    final newTimer = Timer(const Duration(milliseconds: 500), () {
      viewModel.searchFoods(
        query: controller!.text,
        tabType: tab,
      );
    });

    switch (tab) {
      case TabType.all:
        _allDebounce = newTimer;
        break;
      case TabType.myRecipes:
        _myRecipesDebounce = newTimer;
        break;
      case TabType.myFoods:
        _myFoodsDebounce = newTimer;
        break;
    }
  }
  void _showAIChatDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ask AI for Food Suggestions'),
          content: TextField(
            controller: _aiPromptController,
            decoration: const InputDecoration(
              hintText: 'Enter your food query (e.g., "healthy breakfast ideas")',
              //hintStyle: Theme.of(rootContext).textTheme.bodyMedium,
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (_aiPromptController.text.trim().isNotEmpty) {
                  context.read<SearchFoodViewModel>().searchAIFoods(_aiPromptController.text);
                  Navigator.pop(context);
                  setState(() => _showAIOverlay = true);
                }
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchFoodViewModel>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Food'),
        actions: [
          IconButton(
            icon: const Icon(Icons.smart_toy),
            onPressed: _showAIChatDialog
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'My Recipes'),
            Tab(text: 'My Food'),
          ],
        ),
      ),
      body: Stack(
        children: [
          Consumer<SearchFoodViewModel>(
            builder: (context, viewModel, _) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildTab(viewModel,tabType:  TabType.all),
                  _buildTab(viewModel,tabType:  TabType.myRecipes),
                  _buildTab(viewModel,tabType:  TabType.myFoods),
                ],
              );
            },
          ),
          if (_showAIOverlay)
            Stack(
              children: [
                ModalBarrier(
                  color: Colors.black.withOpacity(0.5),
                  dismissible: true,
                  onDismiss: () => setState(() => _showAIOverlay = false),
                ),
                _buildAIFoodOverlay(viewModel),
              ],
            ),
        ]
      ),
    );
  }

  Widget _buildTab(SearchFoodViewModel viewModel, {required TabType tabType}) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        if (tabType == TabType.all)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: _allController,
                decoration: InputDecoration(
                  hintText: 'Search for food',
                  hintStyle: theme.textTheme.bodyMedium,
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  suffixIcon: _allController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _allController.clear();
                      context.read<SearchFoodViewModel>().searchFoods(query: '', tabType: tabType);
                    },
                  )
                      : null,
                ),
              ),
            ),
          ),
        if(tabType == TabType.myRecipes)
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
                          context.read<SearchFoodViewModel>().searchFoods(query: '',tabType: tabType);
                        },
                      )
                          : null,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final Recipe? newRecipe = await context.push('/create_recipe/${widget.mealLogId}/${mealTypeToString(widget.mealType)}');
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
        if(tabType == TabType.myFoods)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    controller: _allController,
                    decoration: InputDecoration(
                      hintText: 'Search for food',
                      hintStyle: theme.textTheme.bodyMedium,
                      prefixIcon: const Icon(Icons.search),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),
                      suffixIcon: _allController.text.isNotEmpty
                          ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _allController.clear();
                          context.read<SearchFoodViewModel>().searchFoods(query: '', tabType: tabType);
                        },
                      )
                          : null,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final Food? newFood = await context.push('/create_food/${widget.mealLogId}/${mealTypeToString(widget.mealType)}');
                  if (newFood != null && context.mounted) {
                    context.read<SearchFoodViewModel>().addMyFoodToList(newFood);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        '+ CREATE FOOD',
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
          child: _buildListView(viewModel, tabType),

        ),
      ],
    );
  }


  Widget _buildListView(SearchFoodViewModel viewModel, TabType tabType) {
    final items = switch (tabType) {
      TabType.all => viewModel.foods,
      TabType.myRecipes => viewModel.recipes,
      TabType.myFoods => viewModel.myFoods,
    };
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // if (viewModel.errorMessage.isNotEmpty) {
    //   return Center(
    //     child: ErrorDisplay(
    //       message: viewModel.errorMessage,
    //       onRetry: _retrySearch,
    //     ),
    //   );
    // }

    if (viewModel.foods.isEmpty) {
      return const SizedBox.shrink();
    }


    return ListView.builder(
      controller: _scrollController,
      itemCount: items.length,
      itemBuilder: (context, index) {
        if (index == items.length) {
          if (viewModel.loadMoreError.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ErrorDisplay(
                message: viewModel.loadMoreError,
                onRetry: () => viewModel.loadMoreFoods(tabType: tabType),
                compact: true,
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (tabType == TabType.myRecipes) {
          final recipe = viewModel.recipes[index];
          if (viewModel.recipes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.no_food, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    (_allController.text).isEmpty
                        ? 'No recipe available'
                        : 'No recipe found for "${_allController.text}"',
                  ),
                ],
              ),
            );
          }

          return RecipeItemWidget(
            recipe: recipe,
            onTap: () => context.push(
              '/recipe_detail/${widget.mealLogId}?mealType=${mealTypeToString(widget.mealType)}',
              extra: recipe,
            ),
            onAdd: () {
              //TODO handle add recipe to diary
            },
          );
        } else if (tabType == TabType.all){
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
        }
        else {
          final food = viewModel.myFoods[index];
          return MyFoodItemWidget(
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
        }
      },
    );
  }

  Widget _buildAIFoodOverlay(SearchFoodViewModel viewModel) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 100),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'AI Food Suggestions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _showAIOverlay = false),
                  ),
                ],
              ),
            ),
            if (viewModel.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (viewModel.errorMessage.isNotEmpty)
              Center(
                child: ErrorDisplay(
                  message: viewModel.errorMessage,
                  onRetry: () => context.read<SearchFoodViewModel>().searchAIFoods(_aiPromptController.text),
                ),
              )
            else if (viewModel.aiFoods.isEmpty)
                const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.no_food, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No AI-suggested foods found'),
                    ],
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: viewModel.aiFoods.length,
                    itemBuilder: (context, index) {
                      final food = viewModel.aiFoods[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(food.name),
                          subtitle: Text('${food.calories} kcal per ${food.servingUnit}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              final diaryViewModel = context.read<DiaryViewModel>();
                              diaryViewModel.addFoodToDiary(
                                mealLogId: widget.mealLogId,
                                foodId: food.id,
                                numberOfServings: food.numberOfServings,
                                servingUnitId: food.servingUnit.id,
                              );
                              setState(() => _showAIOverlay = false);
                            },
                          ),
                          onTap: () => context.push(
                              '/food/${widget.mealLogId}/${food.id}/add/100?mealType=${mealTypeToString(widget.mealType)}'),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }

}
