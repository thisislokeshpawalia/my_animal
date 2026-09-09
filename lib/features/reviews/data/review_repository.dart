import '../../../core/network/api_client.dart';
import '../model/review_model.dart';

class ReviewRepository {
  final ApiClient _apiClient = ApiClient();

  Future<List<ReviewModel>> getReviewsByProduct(String productId) async {
    final response = await _apiClient.instance.get('/reviews/$productId');
    
    if (response.statusCode == 200) {
      final List data = response.data;
      return data.map((json) => ReviewModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load reviews');
    }
  }

  Future<ReviewModel> createReview(ReviewModel review) async {
    final body = review.toJson();
    body.remove('_id'); // let backend generate id

    final response = await _apiClient.instance.post(
      '/reviews/',
      data: body,
    );
    
    if (response.statusCode == 200) {
      return ReviewModel.fromJson(response.data);
    } else {
      throw Exception('Failed to create review: ${response.data}');
    }
  }
}
