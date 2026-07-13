import '../../../core/constants/app_assets.dart';
import '../models/product_model.dart';

const List<ProductModel> mockProducts = [

  ProductModel(
    id: "1",
    name: "Royal Canin Adult Dog Food",
    image: AppAssets.product1,
    price: 899,
    oldPrice: 1099,
    rating: 4.8,
  ),

  ProductModel(
    id: "2",
    name: "Premium Cat Dry Food",
    image: AppAssets.product2,
    price: 799,
    oldPrice: 999,
    rating: 4.7,
  ),

  ProductModel(
    id: "3",
    name: "Royal Canin Puppy Food",
    image: AppAssets.product1,
    price: 699,
    oldPrice: 899,
    rating: 4.6,
  ),

  ProductModel(
    id: "4",
    name: "Healthy Cat Treat",
    image: AppAssets.product2,
    price: 499,
    oldPrice: 699,
    rating: 4.5,
  ),

];