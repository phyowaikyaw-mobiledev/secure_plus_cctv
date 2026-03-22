class QuoteItem {
  QuoteItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });

  final String description;
  final int quantity;
  final double unitPrice;

  double get total => quantity * unitPrice;

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'total': total,
    };
  }
}

class Quote {
  Quote({
    required this.id,
    required this.customerName,
    required this.createdAt,
    required this.items,
  });

  final String id;
  final String customerName;
  final DateTime createdAt;
  final List<QuoteItem> items;

  double get subtotal =>
      items.fold(0, (sum, item) => sum + item.total);

  double get total => subtotal;

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'createdAt': createdAt.toUtc(),
      'items': items.map((e) => e.toMap()).toList(),
      'subtotal': subtotal,
      'total': total,
    };
  }
}

