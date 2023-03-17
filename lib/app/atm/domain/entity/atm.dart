import 'package:atm_simulator/app/atm/domain/entity/customer.dart';
import 'package:equatable/equatable.dart';

class Atm extends Equatable {
  final Customer? activeCustomer;
  final List<Customer> customers;
  final List<String> history;
  final DateTime updatedAt;

  const Atm({
    this.activeCustomer,
    required this.customers,
    required this.history,
    required this.updatedAt,
  });

  @override
  List<Object> get props => [customers, history, updatedAt];
}
