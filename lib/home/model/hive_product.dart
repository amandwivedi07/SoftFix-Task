import 'package:hive/hive.dart';

part 'hive_product.g.dart';

@HiveType(typeId: 1)
class Product extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late num price;

  @HiveField(3)
  late String image;

  @HiveField(4)
  late num ratingCount;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    required this.ratingCount,
  });
}
