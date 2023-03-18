// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String username;
  final String pin;
  final int balance;

  const Customer({
    required this.username,
    required this.pin,
    required this.balance,
  });

  Customer copyWith({
    String? username,
    String? pin,
    int? balance,
  }) {
    return Customer(
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

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      username: map['username'] as String,
      pin: map['pin'] as String,
      balance: map['balance'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [username, pin, balance];
}
