import 'package:get/get.dart';
import '../../app/data/models/address_model.dart';
import '../../app/data/repositories/address_repository.dart';

/// Address CRUD controller.
class AddressController extends GetxController {
  final repo = AddressRepository();
  final addresses = <Address>[].obs;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  void load() {
    addresses.value = repo.all();
  }

  void save() {
    repo.saveAll(addresses);
  }

  void add(Address address) {
    addresses.add(address);
    save();
  }

  void edit(Address address) {
    final index = addresses.indexWhere((e) => e.id == address.id);
    if (index >= 0) {
      addresses[index] = address;
      addresses.refresh();
      save();
    }
  }

  void remove(Address address) {
    addresses.removeWhere((e) => e.id == address.id);
    save();
  }
}
