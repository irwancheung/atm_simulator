import 'dart:convert';

import 'package:atm_simulator/app/atm/domain/entity/customer.dart';

class CustomerModel extends Customer {
  const CustomerModel({
    required super.username,
    required super.pin,
    required super.balance,
  });

  CustomerModel copyWith({
    String? username,
    String? pin,
    int? balance,
  }) {
    return CustomerModel(
      username: username ?? this.username,
      pin: pin ?? this.pin,
      balance: balance ?? this.balance,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'pin': pin,
      'balance': balance,
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      username: map['username'] as String,
      pin: map['pin'] as String,
      balance: map['balance'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory CustomerModel.fromJson(String source) =>
      CustomerModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
