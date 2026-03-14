class CakeCategory {
  final String title;
  final List<CakeCatalogItem> products;

  const CakeCategory({
    required this.title,
    required this.products,
  });
}

class CakeCatalogItem {
  final String id;
  final String title;
  final String imageUrl;
  final String description;
  final String price;
  final String size;
  final String prepTime;
  final String serves;
  final int likes;
  final bool featured;

  const CakeCatalogItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.price,
    required this.size,
    required this.prepTime,
    required this.serves,
    required this.likes,
    this.featured = false,
  });
}