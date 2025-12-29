import 'package:equatable/equatable.dart';
import '../../data/models/wallet_model.dart';

enum HomeStatus { initial, loading, success, failure }

class HomeState extends Equatable {
  final HomeStatus status;
  final HomeDataModel? homeData;
  final String? errorMessage;
  final bool isAddingTransaction;

  const HomeState({
    this.status = HomeStatus.initial,
    this.homeData,
    this.errorMessage,
    this.isAddingTransaction = false,
  });

  HomeState copyWith({
    HomeStatus? status,
    HomeDataModel? homeData,
    String? errorMessage,
    bool? isAddingTransaction,
  }) {
    return HomeState(
      status: status ?? this.status,
      homeData: homeData ?? this.homeData,
      errorMessage: errorMessage,
      isAddingTransaction: isAddingTransaction ?? this.isAddingTransaction,
    );
  }

  @override
  List<Object?> get props => [
    status,
    homeData,
    errorMessage,
    isAddingTransaction,
  ];
}
