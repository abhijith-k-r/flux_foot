part of 'shippin_address_bloc.dart';

abstract class ShippingAddressEvent {}

class LoadShippingAddresses extends ShippingAddressEvent {}

class UpdateShippingAddresses extends ShippingAddressEvent {
  final List<AddressModel> addresses;
  UpdateShippingAddresses(this.addresses);
}

class SaveNewAddress extends ShippingAddressEvent {
  final AddressModel address;
  SaveNewAddress({required this.address});
}

class UpdateAddress extends ShippingAddressEvent {
  final AddressModel address;
  UpdateAddress({required this.address});
}

class DeleteAddress extends ShippingAddressEvent {
  final String addressId;
  DeleteAddress({required this.addressId});
}
