import 'package:flutter/material.dart';

class CategoryHelper {
  static const Map<String, IconData> icons = {
    'food': Icons.restaurant_outlined,
    'transport': Icons.directions_car_outlined,
    'shopping': Icons.shopping_bag_outlined,
    'bills': Icons.receipt_long_outlined,
    'entertainment': Icons.movie_outlined,
    'health': Icons.favorite_outline,
    'other': Icons.category_outlined,
  };

  static const Map<String, Color> colors = {
    'food': Color(0xFFFFB74D),
    'transport': Color(0xFF64B5F6),
    'shopping': Color(0xFFBA68C8),
    'bills': Color(0xFF4DB6AC),
    'entertainment': Color(0xFFFF8A65),
    'health': Color(0xFFE57373),
    'other': Color(0xFF90A4AE),
  };

  static const Map<String, String> labels = {
    'food': 'Food',
    'transport': 'Transport',
    'shopping': 'Shopping',
    'bills': 'Bills',
    'entertainment': 'Entertainment',
    'health': 'Health',
    'other': 'Other',
  };

  static IconData getIcon(String category) {
    return icons[category.toLowerCase()] ?? Icons.category_outlined;
  }

  static Color getColor(String category) {
    return colors[category.toLowerCase()] ?? const Color(0xFF90A4AE);
  }

  static String getLabel(String category) {
    return labels[category.toLowerCase()] ?? 'Other';
  }
}
