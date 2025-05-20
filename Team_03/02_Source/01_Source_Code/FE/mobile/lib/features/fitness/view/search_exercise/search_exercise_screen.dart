import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/fitness/models/exercise.dart';
import 'package:mobile/features/fitness/view/search_exercise/widget/error_display.dart';
import 'package:mobile/features/fitness/viewmodels/diary_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/search_exercise_viewmodel.dart';
import 'widget/exercise_item.dart';

class SearchExerciseScreen extends StatefulWidget {
  final String workoutLogId;

  const SearchExerciseScreen({
    super.key,
    required this.workoutLogId,
  });

  @override
  State<SearchExerciseScreen> createState() => _SearchExerciseScreenState();
}

class _SearchExerciseScreenState extends State<SearchExerciseScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  //Timer? _debounceTimer;
  Timer? _allDebounce;
  late TextEditingController _allController;
  late TextEditingController _myExercisesController;
  Timer? _myExercisesDebounce;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_scrollListener);

    _allController = TextEditingController();
    _myExercisesController = TextEditingController();

    _allController.addListener(() => _debounceSearch(isMyExercise: false));
    _myExercisesController.addListener(() => _debounceSearch(isMyExercise: true));

    // Automatically load exercises list when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context
          .read<SearchExerciseViewModel>()
          .searchExercises(query: '', isMyExercise: _tabController.index == 1);
    });

    // Use debounce to avoid calling API too many times when user is typing
    //_searchController.addListener(_debounceSearch);
  }

  void _debounceSearch({required bool isMyExercise}) {
    final timer = isMyExercise ? _myExercisesDebounce : _allDebounce;
    timer?.cancel();

    final controller = isMyExercise ? _myExercisesController : _allController;

    final newTimer = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchExerciseViewModel>().searchExercises(
        query: controller.text,
        isMyExercise: isMyExercise,
      );
    });

    if (isMyExercise) {
      _myExercisesDebounce = newTimer;
    } else {
      _allDebounce = newTimer;
    }
  }

  void _onTabChanged() {
    final isMyExercise = _tabController.index == 1;
    context.read<SearchExerciseViewModel>().searchExercises(
      query: isMyExercise ? _myExercisesController.text : _allController.text,
      isMyExercise: isMyExercise,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _allController.dispose();
    _myExercisesController.dispose();
    _allDebounce?.cancel();
    _myExercisesDebounce?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final viewModel = context.read<SearchExerciseViewModel>();
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
        !viewModel.isFetchingMore &&
        viewModel.hasMoreData) {
      viewModel.loadMoreExercises(isMyExercise: _tabController.index == 1);
    }
  }

  void _retrySearch() {
    final isMyExercise = _tabController.index == 1;
    final controller = isMyExercise ? _myExercisesController : _allController;

    context.read<SearchExerciseViewModel>().searchExercises(
      query: controller.text,
      isMyExercise: isMyExercise,
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SearchExerciseViewModel>();
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('Search Exercise', style: textTheme.titleMedium),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'All Exercises'),
            Tab(text: 'My Exercises')
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBody(viewModel, isMyExercise: true),
                _buildBody(viewModel, isMyExercise: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SearchExerciseViewModel viewModel, {required bool isMyExercise}) {
    final theme = Theme.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        if (isMyExercise)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: _allController,
                decoration: InputDecoration(
                  hintText: 'Search for exercise',
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
                      context.read<SearchExerciseViewModel>().searchExercises(query: '', isMyExercise: false);
                    },
                  )
                      : null,
                ),
              ),
            ),
          ),
        if(!isMyExercise)
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    controller: _allController,
                    decoration: InputDecoration(
                      hintText: 'Search for your exercise',
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
                          context.read<SearchExerciseViewModel>().searchExercises(query: '', isMyExercise: false);
                        },
                      )
                          : null,
                    ),
                  ),
                ),
              ),

              TextButton(
                onPressed: () async {
                  final Exercise? newExercise = await context.push('/create_my_exercise');

                  if (newExercise != null && context.mounted) {
                    //context.read<SearchExerciseViewModel>().addExerciseToList(newExercise);
                  }

                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        '+ CREATE YOUR EXERCISE',
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
          child: _buildListView(viewModel, isMyExercise: isMyExercise),
        ),
      ],
    );
  }


  Widget _buildListView(SearchExerciseViewModel viewModel, {required bool isMyExercise}) {
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

    if (viewModel.exercises.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.no_food, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              (_allController.text).isEmpty
                  ? 'No exercises available'
                  : 'No exercises found for "${_allController.text}"',
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: viewModel.exercises.length + (viewModel.isFetchingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == viewModel.exercises.length) {
          if (viewModel.loadMoreError.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ErrorDisplay(
                message: viewModel.loadMoreError,
                onRetry: () => viewModel.loadMoreExercises(isMyExercise: isMyExercise),
                compact: true,
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if(!isMyExercise){
          final exercise = viewModel.exercises[index];
          return ExerciseItemWidget(
            exercise: exercise,
            onTap: () =>context.push('/exerciseDetails/${widget.workoutLogId}/${exercise.id}?'),
            // onAdd: () {
            //   final diaryViewModel = context.read<DiaryViewModel>();
            //   diaryViewModel.addExerciseToDiary(
            //     workoutLogId: widget.workoutLogId,
            //     exerciseId: exercise.id,
            //     duration: exercise.,
            //   );
            // },
          );
        } else {
          final exercise = viewModel.myExercises[index];
          return ExerciseItemWidget(
            exercise: exercise,
            onTap: () =>context.push('/exerciseDetails/${widget.workoutLogId}/${exercise.id}?'),
          );
        }
      },
    );
  }

  //@override
  // Widget build(BuildContext context) {
  //   final viewModel = context.watch<SearchExerciseViewModel>();
  //   final theme = Theme.of(context);
  //   final textTheme = Theme.of(context).textTheme;
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       leading: IconButton(
  //         icon: const Icon(Icons.arrow_back),
  //         onPressed: () => Navigator.pop(context),
  //       ),
  //       centerTitle: true,
  //       title: Text('Search Exercise', style: textTheme.titleMedium),
  //       bottom: TabBar(
  //         controller: _tabController,
  //         tabs: const [
  //           Tab(text: 'All Exercises'),
  //           Tab(text: 'My Exercises'),
  //         ],
  //       ),
  //     ),
  //     body: Column(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  //           child: SizedBox(
  //             height: 50,
  //             child: TextField(
  //               controller: _searchController,
  //               decoration: InputDecoration(
  //                 hintText: 'Search for exercise',
  //                 hintStyle: theme.textTheme.bodyMedium,
  //                 prefixIcon: viewModel.isLoading
  //                     ? const SizedBox(
  //                   width: 24,
  //                   height: 24,
  //                   child: Padding(
  //                     padding: EdgeInsets.all(8.0),
  //                     child: CircularProgressIndicator(
  //                       strokeWidth: 2,
  //                     ),
  //                   ),
  //                 )
  //                     : const Icon(Icons.search),
  //                 contentPadding: const EdgeInsets.symmetric(vertical: 10),
  //                 suffixIcon: _searchController.text.isNotEmpty
  //                     ? IconButton(
  //                   icon: const Icon(Icons.clear),
  //                   onPressed: () {
  //                     _searchController.clear();
  //                     viewModel.searchExercises(
  //                         query: '', isMyExercise: _tabController.index == 1);
  //                   },
  //                 )
  //                     : null,
  //               ),
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: TabBarView(
  //             controller: _tabController,
  //             children: [
  //               _buildBody(viewModel, isMyExercise: false),
  //               _buildBody(viewModel, isMyExercise: true),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget _buildBody(SearchExerciseViewModel viewModel,
  //     {required bool isMyExercise}) {
  //   if (viewModel.isLoading) {
  //     return const Center(
  //       child: CircularProgressIndicator(),
  //     );
  //   }
  //
  //   if (viewModel.errorMessage.isNotEmpty) {
  //     return Center(
  //       child: ErrorDisplay(
  //         message: viewModel.errorMessage,
  //         onRetry: _retrySearch,
  //       ),
  //     );
  //   }
  //
  //   if (viewModel.exercises.isEmpty) {
  //     return Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           const Icon(Icons.fitness_center, size: 64, color: Colors.grey),
  //           const SizedBox(height: 16),
  //           Text(
  //             _searchController.text.isEmpty
  //                 ? 'No exercises available'
  //                 : 'No exercises found for "${_searchController.text}"',
  //           ),
  //         ],
  //       ),
  //     );
  //   }
  //
  //   return ListView.builder(
  //     controller: _scrollController,
  //     itemCount: viewModel.exercises.length + (viewModel.isFetchingMore ? 1 : 0),
  //     itemBuilder: (context, index) {
  //       if (index == viewModel.exercises.length) {
  //         if (viewModel.loadMoreError.isNotEmpty) {
  //           return Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: ErrorDisplay(
  //               message: viewModel.loadMoreError,
  //               onRetry: () =>
  //                   viewModel.loadMoreExercises(isMyExercise: isMyExercise),
  //               compact: true,
  //             ),
  //           );
  //         }
  //         return const Padding(
  //           padding: EdgeInsets.all(16.0),
  //           child: Center(child: CircularProgressIndicator()),
  //         );
  //       }
  //
  //       if (viewModel.exercises.isEmpty) {
  //         return const SizedBox.shrink();
  //       } else {
  //         final exercise = viewModel.exercises[index];
  //         return ExerciseItemWidget(
  //           exercise: exercise,
  //           onTap: () {
  //             context.push('/exercise/${widget.workoutLogId}/${exercise.id}/add');
  //           },
  //         );
  //       }
  //     },
  //   );
  // }
}
