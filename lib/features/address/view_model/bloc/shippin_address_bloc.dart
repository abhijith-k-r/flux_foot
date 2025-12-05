import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:fluxfoot_user/core/services/firebase/address_repository.dart';
import 'package:fluxfoot_user/features/address/model/address_model.dart';
import 'package:fluxfoot_user/features/address/view_model/bloc/shippin_address_state.dart';

part 'shippin_address_event.dart';

class ShippingAddressBloc
    extends Bloc<ShippingAddressEvent, ShippingAddressState> {
  final AddressRepository _repository;
  StreamSubscription? _addressSubscription;

  // Rename to ShippingAddressBloc for consistency
  ShippingAddressBloc({required AddressRepository repository})
    : _repository = repository,
      super(AddAddressInitial()) {
    // Start in the Initial state instead of Loading to prevent crashes
    on<LoadShippingAddresses>(_onLoadShippingAddresses);
    on<UpdateShippingAddresses>(_onUpdateShippingAddresses);
    on<SaveNewAddress>(_onSaveNewAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAddress>(_onDeleteAddress);
  }

  Future<void> _onSaveNewAddress(
    SaveNewAddress event,
    Emitter<ShippingAddressState> emit,
  ) async {
    emit(ShippingAddressLoading());
    try {
      await _repository.saveAddress(address: event.address);
      // Emit success - the stream will automatically update the list
      emit(AddAddressSuccess());
    } catch (e) {
      // Catching the exception message thrown by the repository
      emit(ShippingAddressFailure(error: e.toString()));
    }
  }

  void _onLoadShippingAddresses(
    LoadShippingAddresses event,
    Emitter<ShippingAddressState> emit,
  ) {
    _addressSubscription?.cancel();
    
    emit(ShippingAddressLoading());

    // Call the correct repository method for streaming addresses
    _addressSubscription = _repository.getAddressesForCurrentUser().listen(
      (addresses) {
        add(UpdateShippingAddresses(addresses));
      },
      onError: (error) {
       
        emit(
          ShippingAddressFailure(
            error: 'Failed to fetch addresses. Please check your connection.',
          ),
        );
        add(UpdateShippingAddresses([]));
      },
      cancelOnError: false, 
    );
  }

  void _onUpdateShippingAddresses(
    UpdateShippingAddresses event,
    Emitter<ShippingAddressState> emit,
  ) {
    emit(ShippingAddressListLoaded(event.addresses));
  }

  Future<void> _onUpdateAddress(
    UpdateAddress event,
    Emitter<ShippingAddressState> emit,
  ) async {
    emit(ShippingAddressLoading());
    try {
      await _repository.updateAddress(address: event.address);
      emit(AddAddressSuccess());
    } catch (e) {
      emit(ShippingAddressFailure(error: e.toString()));
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddress event,
    Emitter<ShippingAddressState> emit,
  ) async {
    emit(ShippingAddressLoading());
    try {
      await _repository.deleteAddress(addressId: event.addressId);
      emit(AddAddressSuccess());
    } catch (e) {
      emit(ShippingAddressFailure(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _addressSubscription?.cancel();
    return super.close();
  }
}
