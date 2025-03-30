import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import '../../viewmodels/search_food_viewmodel.dart';
import '../food_detail/food_detail_screen.dart';
import 'widget/food_item.dart';

class SearchFoodScreen extends StatefulWidget {
  const SearchFoodScreen({super.key});

  @override
  State<SearchFoodScreen> createState() => _SearchFoodScreenState();
}

class _SearchFoodScreenState extends State<SearchFoodScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);

    // Tự động tải danh sách foods khi màn hình được mở
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SearchFoodViewModel>().searchFoods(query: '');
    });

    // Sử dụng debounce để tránh gọi API quá nhiều lần khi người dùng đang gõ
    _searchController.addListener(() {
      _debounceSearch();
    });
  }

  // Biến cho debounce
  Timer? _debounceTimer;

  void _debounceSearch() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();

    setState(() {
      _isSearching = true;
    });

    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      context.read<SearchFoodViewModel>().searchFoods(query: _searchController.text);
      setState(() {
        _isSearching = false;
      });
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
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200 && // Tải trước khi đến cuối
        !viewModel.isFetchingMore &&
        viewModel.hasMoreData) {
      viewModel.loadMoreFoods(10);
    }
  }

  void _retrySearch() {
    context.read<SearchFoodViewModel>().searchFoods(query: _searchController.text);
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
                  prefixIcon: _isSearching
                      ? SizedBox(
                    width: 24,
                    height: 24,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.primary,
                      ),
                    ),
                  )
                      : Icon(Icons.search, color: colorScheme.primary),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  fillColor: colorScheme.surfaceContainerHighest,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: colorScheme.primary),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      // Khi xóa text, vẫn tìm kiếm với query rỗng thay vì xóa kết quả
                      viewModel.searchFoods(query: '');
                    },
                  )
                      : null,
                ),
                style: textTheme.bodyMedium,
              ),
            ),
          ),
          Expanded(
            child: _buildBody(viewModel, context),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(SearchFoodViewModel viewModel, BuildContext context) {
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

    if (viewModel.filteredFoods.isEmpty) {
      // Thay đổi thông báo khi không có kết quả nào
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
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: viewModel.filteredFoods.length + (viewModel.isFetchingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == viewModel.filteredFoods.length) {
          if (viewModel.loadMoreError.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ErrorDisplay(
                message: viewModel.loadMoreError,
                onRetry: () => viewModel.loadMoreFoods(10),
                compact: true,
              ),
            );
          }
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
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
    );
  }
}

// ErrorDisplay widget
class ErrorDisplay extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool compact;

  const ErrorDisplay({
    Key? key,
    required this.message,
    required this.onRetry,
    this.compact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (compact) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: 8),
          Flexible(child: Text(message, style: TextStyle(color: theme.colorScheme.error))),
          const SizedBox(width: 16),
          OutlinedButton(
            onPressed: onRetry,
            child: const Text('Retry'),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_off, size: 64, color: theme.colorScheme.error),
          const SizedBox(height: 16),
          Text(
            'Connection Error',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh),
            label: const Text('Try Again'),
          ),
        ],
      ),
    );
  }
}