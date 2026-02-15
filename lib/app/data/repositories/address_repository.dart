import '../models/address_model.dart';
import '../services/address_service.dart';

/// Repository for address data.
class AddressRepository {
  final AddressService service;
  AddressRepository({AddressService? service}) : service = service ?? AddressService();

  List<Address> all() => service.all();

  void saveAll(List<Address> addresses) => service.saveAll(addresses);
}
