class ShoppingItem {
  String title;
  String description;
  double quantity;
  double price;
  String? assignedTo; // Person, der das Element zugewiesen ist

  ShoppingItem({
    required this.title,
    required this.description,
    required this.quantity,
    required this.price,
    required this.assignedTo,
  });
}
