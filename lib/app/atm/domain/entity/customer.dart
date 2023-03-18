import 'dart:convert';
import 'package:atm_simulator/app/atm/domain/entity/creditor.dart';
import 'package:atm_simulator/app/atm/domain/entity/debtor.dart';
import 'package:equatable/equatable.dart';

class Customer extends Equatable {
  final String username;
  final String pin;
  final int balance;
  final Creditor? creditor;
  final Debtor? debtor;

  const Customer({
    required this.username,
    required this.pin,
    required this.balance,
    this.creditor,
    this.debtor,
  });

  Customer copyWith({
    String? username,
    String? pin,
    int? balance,
    Creditor? creditor,
    Debtor? debtor,
  }) {
    return Customer(
      username: username ?? this.username,
      pin: pin ?? this.pin,
      balance: balance ?? this.balance,
      creditor: creditor ?? this.creditor,
      debtor: debtor ?? this.debtor,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'pin': pin,
      'balance': balance,
      'creditor': creditor?.toMap(),
      'debtor': debtor?.toMap(),
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
      username: map['username'] as String,
      pin: map['pin'] as String,
      balance: map['balance'] as int,
      creditor: map['creditor'] != null
          ? Creditor.fromMap(map['creditor'] as Map<String, dynamic>)
          : null,
      debtor: map['debtor'] != null
          ? Debtor.fromMap(map['debtor'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [username, pin, balance];
}
