import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/review_repository.dart';
import '../model/review_model.dart';

final reviewRepositoryProvider = Provider((ref) => ReviewRepository());

// Fetch reviews for a specific product
final productReviewsProvider = FutureProvider.family<List<ReviewModel>, String>((ref, productId) {
  return ref.read(reviewRepositoryProvider).getReviewsByProduct(productId);
});

class SubmitReviewController extends StateNotifier<AsyncValue<void>> {
  final Ref ref;
  
  SubmitReviewController(this.ref) : super(const AsyncValue.data(null));

  Future<bool> submitReview(ReviewModel review) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(reviewRepositoryProvider).createReview(review);
      state = const AsyncValue.data(null);
      // Invalidate the reviews provider so it fetches the new review
      ref.invalidate(productReviewsProvider(review.productId));
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }
}

final submitReviewControllerProvider = StateNotifierProvider<SubmitReviewController, AsyncValue<void>>((ref) {
  return SubmitReviewController(ref);
});
