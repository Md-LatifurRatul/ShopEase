import 'package:e_commerce_project/model/products_item.dart';

class ProductModelDummy {
  List<ProductsItem>? products;
  int? total;
  int? skip;
  int? limit;

  ProductModelDummy({this.products, this.total, this.skip, this.limit});

  ProductModelDummy.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <ProductsItem>[];
      json['products'].forEach((v) {
        products!.add(ProductsItem.fromJson(v));
      });
    }
    total = json['total'];
    skip = json['skip'];
    limit = json['limit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['total'] = total;
    data['skip'] = skip;
    data['limit'] = limit;
    return data;
  }
}
