
import 'package:equatable/equatable.dart';
import 'package:fluxfoot_user/features/home/models/seller_model.dart'; // Adjust path

abstract class SellerState extends Equatable {
  const SellerState();

  @override
  List<Object?> get props => [];
}

// 1. Initial State (Before any action is taken)
class SellerInitial extends SellerState {}

// 2. Loading State (While fetching from Firestore)
class SellerLoading extends SellerState {}

// 3. Success State (When seller data is ready)
class SellerLoaded extends SellerState {
  final SellerModel seller;

  const SellerLoaded(this.seller);

  @override
  List<Object?> get props => [seller];
}

// 4. Error State (If something goes wrong)
class SellerError extends SellerState {
  final String message;

  const SellerError(this.message);

  @override
  List<Object?> get props => [message];
}
