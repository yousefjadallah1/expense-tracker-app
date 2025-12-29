class ApiConstants {
  // For iOS Simulator
  static const String baseUrl =
      'https://expense-tracker-backend-1vpb.onrender.com';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh-token';

  // Wallet
  static const String wallet = '/wallet';
  static const String walletBudget = '/wallet/budget';
  static const String walletHistory = '/wallet/history';

  // Transactions
  static const String transactions = '/transactions';
}
