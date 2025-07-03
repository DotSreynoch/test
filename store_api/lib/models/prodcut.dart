class Product {
  int? productId;
  String productName;
  double price;
  int stock;

  Product({
    this.productId,
    required this.productName,
    required this.price,
    required this.stock,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    productId: json['PRODUCTID'],
    productName: json['PRODUCTNAME'],
    price: (json['PRICE'] as num).toDouble(),
    stock: json['STOCK'],
  );

  Map<String, dynamic> toJson() => {
    "PRODUCTNAME": productName,
    "PRICE": price,
    "STOCK": stock,
  };
}
