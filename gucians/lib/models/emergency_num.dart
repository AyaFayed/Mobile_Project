class EmergencyNum {
  String id;
  String name;
  String number;

  EmergencyNum({required this.id, required this.name, required this.number});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'number': number};

  static EmergencyNum fromJson(Map<String, dynamic> json) =>
      EmergencyNum(id: json['id'], name: json['name'], number: json['number']);
}
