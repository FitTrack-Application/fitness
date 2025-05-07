// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mobile/features/fitness/models/exercise.dart';
// import 'package:mobile/features/fitness/view/search_exercise/widget/error_display.dart';
// import 'package:provider/provider.dart';
//
// import '../../viewmodels/search_exercise_viewmodel.dart';
// import 'widget/exercise_item.dart';
//
// class SearchExerciseScreen extends StatefulWidget {
//   final String workoutLogId;
//
//   const SearchExerciseScreen({
//     super.key,
//     required this.workoutLogId,
//   });
//
//   @override
//   State<SearchExerciseScreen> createState() => _SearchExerciseScreenState();
// }
//
// class _SearchExerciseScreenState extends State<SearchExerciseScreen>
//     with SingleTickerProviderStateMixin {
//   final ScrollController _scrollController = ScrollController();
//   final TextEditingController _searchController = TextEditingController();
//   Timer? _debounceTimer;
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 2, vsync: this);
//     _tabController.addListener(_onTabChanged);
//
//     _scrollController.addListener(_scrollListener);
//
//     // Automatically load exercises list when screen opens
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context
//           .read<SearchExerciseViewModel>()
//           .searchExercises(query: '', isMyExercise: _tabController.index == 1);
//     });
//
//     // Use debounce to avoid calling API too many times when user is typing
//     _searchController.addListener(_debounceSearch);
//   }
//
//   void _debounceSearch() {
//     if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
//
//     _debounceTimer = Timer(const Duration(milliseconds: 500), () {
//       context.read<SearchExerciseViewModel>().searchExercises(
//           query: _searchController.text, isMyExercise: _tabController.index == 1);
//     });
//   }
//
//   void _onTabChanged() {
//     final isMyExercise = _tabController.index == 1;
//     context.read<SearchExerciseViewModel>().searchExercises(
//         query: _searchController.text, isMyExercise: isMyExercise);
//   }
//
//   @override
//   void dispose() {
//     _scrollController.dispose();
//     _searchController.dispose();
//     _debounceTimer?.cancel();
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   void _scrollListener() {
//     final viewModel = context.read<SearchExerciseViewModel>();
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200 &&
//         !viewModel.isFetchingMore &&
//         viewModel.hasMoreData) {
//       viewModel.loadMoreExercises(isMyExercise: _tabController.index == 1);
//     }
//   }
//
//   void _retrySearch() {
//     context.read<SearchExerciseViewModel>().searchExercises(
//         query: _searchController.text, isMyExercise: _tabController.index == 1);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final viewModel = context.watch<SearchExerciseViewModel>();
//     final theme = Theme.of(context);
//     final textTheme = Theme.of(context).textTheme;
//
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//         title: Text('Add Exercise', style: textTheme.titleMedium),
//         bottom: TabBar(
//           controller: _tabController,
//           tabs: const [
//             Tab(text: 'All'),
//             Tab(text: 'My Exercises'),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//             child: SizedBox(
//               height: 50,
//               child: TextField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   hintText: 'Search for exercise',
//                   hintStyle: theme.textTheme.bodyMedium,
//                   prefixIcon: viewModel.isLoading
//                       ? const SizedBox(
//                     width: 24,
//                     height: 24,
//                     child: Padding(
//                       padding: EdgeInsets.all(8.0),
//                       child: CircularProgressIndicator(
//                         strokeWidth: 2,
//                       ),
//                     ),
//                   )
//                       : const Icon(Icons.search),
//                   contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                   suffixIcon: _searchController.text.isNotEmpty
//                       ? IconButton(
//                     icon: const Icon(Icons.clear),
//                     onPressed: () {
//                       _searchController.clear();
//                       viewModel.searchExercises(
//                           query: '', isMyExercise: _tabController.index == 1);
//                     },
//                   )
//                       : null,
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _tabController,
//               children: [
//                 _buildBody(viewModel, isMyExercise: false),
//                 _buildBody(viewModel, isMyExercise: true),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBody(SearchExerciseViewModel viewModel,
//       {required bool isMyExercise}) {
//     if (viewModel.isLoading) {
//       return const Center(
//         child: CircularProgressIndicator(),
//       );
//     }
//
//     if (viewModel.errorMessage.isNotEmpty) {
//       return Center(
//         child: ErrorDisplay(
//           message: viewModel.errorMessage,
//           onRetry: _retrySearch,
//         ),
//       );
//     }
//
//     if (viewModel.exercises.isEmpty) {
//       return Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.fitness_center, size: 64, color: Colors.grey),
//             const SizedBox(height: 16),
//             Text(
//               _searchController.text.isEmpty
//                   ? 'No exercises available'
//                   : 'No exercises found for "${_searchController.text}"',
//             ),
//           ],
//         ),
//       );
//     }
//
//     return ListView.builder(
//       controller: _scrollController,
//       itemCount: viewModel.exercises.length + (viewModel.isFetchingMore ? 1 : 0),
//       itemBuilder: (context, index) {
//         if (index == viewModel.exercises.length) {
//           if (viewModel.loadMoreError.isNotEmpty) {
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ErrorDisplay(
//                 message: viewModel.loadMoreError,
//                 onRetry: () =>
//                     viewModel.loadMoreExercises(isMyExercise: isMyExercise),
//                 compact: true,
//               ),
//             );
//           }
//           return const Padding(
//             padding: EdgeInsets.all(16.0),
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }
//
//         if (viewModel.exercises.isEmpty) {
//           return const SizedBox.shrink();
//         } else {
//           final exercise = viewModel.exercises[index];
//           return ExerciseItemWidget(
//             exercise: exercise,
//             onTap: () {
//               context.push('/exercise/${widget.workoutLogId}/${exercise.exerciseId}/add');
//             },
//           );
//         }
//       },
//     );
//   }
// }