// ignore_for_file: public_member_api_docs, sort_constructors_first
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

  @override
  List<Object> get props => [username, pin, balance];
}
