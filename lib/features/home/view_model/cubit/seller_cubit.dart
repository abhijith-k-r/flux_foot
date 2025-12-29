import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluxfoot_user/core/services/firebase/seller_repository.dart';
import 'package:fluxfoot_user/features/home/view_model/cubit/seller_state.dart';

class SellerCubit extends Cubit<SellerState> {
  final SellerRepository _repository;

  SellerCubit(this._repository) : super(SellerInitial());

  Future<void> fetchSeller(String sellerId) async {
    emit(SellerLoading());
    try {
      final seller = await _repository.getSellerById(sellerId);
      emit(SellerLoaded(seller));
    } catch (e) {
      emit(SellerError(e.toString()));
    }
  }
}
