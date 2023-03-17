import 'dart:convert';

import 'package:atm_simulator/app/atm/data/model/customer_model.dart';
import 'package:atm_simulator/app/atm/domain/entity/atm.dart';

class AtmModel extends Atm {
  const AtmModel({
    super.activeCustomer,
    required super.customers,
    required super.history,
    required super.updatedAt,
  });

  AtmModel copyWith({
    CustomerModel? activeCustomer,
    List<CustomerModel>? customers,
    List<String>? history,
    DateTime? updatedAt,
  }) {
    return AtmModel(
      activeCustomer: activeCustomer ?? this.activeCustomer,
      customers: customers ?? this.customers,
      history: history ?? this.history,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    final activeCustomerModel = activeCustomer as CustomerModel?;
    final customersModel =
        customers.map((customer) => customer as CustomerModel);

    return <String, dynamic>{
      'activeCustomer': activeCustomerModel?.toMap(),
      'customers': customersModel.map((x) => x.toMap()).toList(),
      'history': history,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory AtmModel.fromMap(Map<String, dynamic> map) {
    return AtmModel(
      activeCustomer: map['activeCustomer'] != null
          ? CustomerModel.fromMap(map['activeCustomer'] as Map<String, dynamic>)
          : null,
      customers: List<CustomerModel>.from(
        (map['customers'] as List<dynamic>).map<CustomerModel>(
          (x) => CustomerModel.fromMap(x as Map<String, dynamic>),
        ),
      ),
      history: List<String>.from(map['history'] as List<String>),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }

  String toJson() => json.encode(toMap());

  factory AtmModel.fromJson(String source) =>
      AtmModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
