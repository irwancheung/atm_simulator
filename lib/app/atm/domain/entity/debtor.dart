import 'dart:convert';

import 'package:equatable/equatable.dart';

class Debtor extends Equatable {
  final String username;
  final int amount;

  const Debtor({required this.username, required this.amount});

  Debtor copyWith({
    String? username,
    int? amount,
  }) {
    return Debtor(
      username: username ?? this.username,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'amount': amount,
    };
  }

  factory Debtor.fromMap(Map<String, dynamic> map) {
    return Debtor(
      username: map['username'] as String,
      amount: map['amount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Debtor.fromJson(String source) =>
      Debtor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [username, amount];
}
