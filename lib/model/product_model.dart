class ProductModel {
  final String id;
  final String name;
  final double price;
  final double rating;
  final String description;
  final String imageUrl;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.description,
    required this.imageUrl,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["_id"] ?? '',
      name: json['name'] ?? '',
      price:
          (json["price"] is int)
              ? (json["price"] as int).toDouble()
              : (json["price"] as double),
      rating:
          (json["rating"] is int)
              ? (json["rating"] as int).toDouble()
              : (json["rating"] as double),
      description: json["description"] ?? '',
      imageUrl: json["imageUrl"] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'price': price,
      'rating': rating,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
