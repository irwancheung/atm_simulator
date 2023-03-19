import 'dart:convert';

import 'package:equatable/equatable.dart';

class Creditor extends Equatable {
  final String username;
  final int amount;

  const Creditor({required this.username, required this.amount});

  Creditor copyWith({
    String? username,
    int? amount,
  }) {
    return Creditor(
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

  factory Creditor.fromMap(Map<String, dynamic> map) {
    return Creditor(
      username: map['username'] as String,
      amount: map['amount'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory Creditor.fromJson(String source) =>
      Creditor.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object?> get props => [username, amount];
}
