import 'dart:convert';
import 'package:atm_simulator/app/atm/domain/entity/customer.dart';
import 'package:equatable/equatable.dart';

class Atm extends Equatable {
  final Customer? activeCustomer;
  final List<Customer> customers;
  final List<String> history;

  const Atm({
    this.activeCustomer,
    required this.customers,
    required this.history,
  });

  Atm copyWith({
    Customer? activeCustomer,
    List<Customer>? customers,
    List<String>? history,
  }) {
    return Atm(
      activeCustomer: activeCustomer ?? this.activeCustomer,
      customers: customers ?? this.customers,
      history: history ?? this.history,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'activeCustomer': activeCustomer?.toMap(),
      'customers': customers.map((x) => x.toMap()).toList(),
      'history': history,
    };
  }

  factory Atm.fromMap(Map<String, dynamic> map) {
    return Atm(
      activeCustomer: map['activeCustomer'] != null
          ? Customer.fromMap(map['activeCustomer'] as Map<String, dynamic>)
          : null,
      customers: List<Customer>.from(
        (map['customers'] as List<int>).map<Customer>(
          (x) => Customer.fromMap(x as Map<String, dynamic>),
        ),
      ),
      history: List<String>.from(
        map['history'] as List<String>,
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Atm.fromJson(String source) =>
      Atm.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  List<Object> get props => [customers, history];
}
