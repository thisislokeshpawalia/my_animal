import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/data/product_repository.dart';
import '../../home/models/product_model.dart';
import '../../home/provider/product_provider.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

final searchResultsProvider = FutureProvider.autoDispose<List<Product>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  final category = ref.watch(selectedCategoryProvider);
  final repository = ref.read(productRepositoryProvider);
  
  return repository.fetchProducts(query: query, category: category);
});
