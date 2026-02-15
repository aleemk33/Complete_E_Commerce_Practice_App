class Address {
  final String id;
  final String label;
  final String line1;
  final String city;
  final String zip;

  Address({
    required this.id,
    required this.label,
    required this.line1,
    required this.city,
    required this.zip,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'line1': line1,
        'city': city,
        'zip': zip,
      };

  factory Address.fromJson(Map data) => Address(
        id: data['id'],
        label: data['label'],
        line1: data['line1'],
        city: data['city'],
        zip: data['zip'],
      );
}
