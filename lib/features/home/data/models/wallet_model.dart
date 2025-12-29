class WalletModel {
  final String id;
  final int month;
  final int year;
  final double budget;
  final double spent;
  final double remaining;
  final int expenseCount;

  WalletModel({
    required this.id,
    required this.month,
    required this.year,
    required this.budget,
    required this.spent,
    required this.remaining,
    required this.expenseCount,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? json['_id'] ?? '',
      month: json['month'] ?? 1,
      year: json['year'] ?? 2025,
      budget: (json['budget'] ?? 0).toDouble(),
      spent: (json['spent'] ?? 0).toDouble(),
      remaining: (json['remaining'] ?? 0).toDouble(),
      expenseCount: json['expenseCount'] ?? 0,
    );
  }
}

class CategoryModel {
  final String category;
  final double total;
  final int percentage;

  CategoryModel({
    required this.category,
    required this.total,
    required this.percentage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      category: json['category'] ?? '',
      total: (json['total'] ?? 0).toDouble(),
      percentage: json['percentage'] ?? 0,
    );
  }
}

class TransactionModel {
  final String id;
  final String walletId;
  final String type; // 'expense' or 'income'
  final double amount;
  final String category;
  final String? description;
  final DateTime date;

  TransactionModel({
    required this.id,
    required this.walletId,
    required this.type,
    required this.amount,
    required this.category,
    this.description,
    required this.date,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['_id'] ?? json['id'] ?? '',
      walletId: json['walletId'] ?? '',
      type: json['type'] ?? 'expense',
      amount: (json['amount'] ?? 0).toDouble(),
      category: json['category'] ?? 'other',
      description: json['description'],
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'amount': amount,
      'category': category,
      'description': description,
      'date': date.toIso8601String(),
    };
  }

  bool get isExpense => type == 'expense';
}

class TransactionGroupModel {
  final String label;
  final List<TransactionModel> transactions;

  TransactionGroupModel({required this.label, required this.transactions});

  factory TransactionGroupModel.fromJson(Map<String, dynamic> json) {
    return TransactionGroupModel(
      label: json['label'] ?? '',
      transactions:
          (json['transactions'] as List?)
              ?.map((t) => TransactionModel.fromJson(t))
              .toList() ??
          [],
    );
  }
}

class HomeDataModel {
  final WalletModel wallet;
  final List<CategoryModel> topCategories;
  final List<TransactionGroupModel> transactionGroups;

  HomeDataModel({
    required this.wallet,
    required this.topCategories,
    required this.transactionGroups,
  });

  factory HomeDataModel.fromJson(Map<String, dynamic> json) {
    return HomeDataModel(
      wallet: WalletModel.fromJson(json['wallet'] ?? {}),
      topCategories:
          (json['topCategories'] as List?)
              ?.map((c) => CategoryModel.fromJson(c))
              .toList() ??
          [],
      transactionGroups:
          (json['transactionGroups'] as List?)
              ?.map((g) => TransactionGroupModel.fromJson(g))
              .toList() ??
          [],
    );
  }
}
