import 'package:fluxfoot_user/features/address/model/address_model.dart';

abstract class ShippingAddressState {}

class AddAddressInitial extends ShippingAddressState {}

class ShippingAddressLoading extends ShippingAddressState {}

class ShippingAddressListLoaded extends ShippingAddressState {
  final List<AddressModel> addresses;
  ShippingAddressListLoaded(this.addresses);
}

class AddAddressSuccess extends ShippingAddressState {}

class ShippingAddressFailure extends ShippingAddressState {
  final String error;
  ShippingAddressFailure({required this.error});
}
