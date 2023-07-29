class IpAddressModel {
  IpAddressModel({
    required this.ipAddress,
  });

  String ipAddress;

  factory IpAddressModel.fromJson(Map<String, dynamic> json) {
    return IpAddressModel(ipAddress: json['ip'] ?? '-');
  }
}