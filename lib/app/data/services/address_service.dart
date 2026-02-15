import 'package:get_storage/get_storage.dart';
import '../models/address_model.dart';

/// Local storage-backed address service.
class AddressService {
  final box = GetStorage();

  List<Address> all() {
    final data = box.read('addresses');
    if (data == null) return [];
    return List<Map>.from(data).map((e) => Address.fromJson(e)).toList();
  }

  void saveAll(List<Address> addresses) {
    box.write('addresses', addresses.map((e) => e.toJson()).toList());
  }
}
