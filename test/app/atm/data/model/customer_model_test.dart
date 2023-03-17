import 'package:atm_simulator/app/atm/data/model/customer_model.dart';
import 'package:atm_simulator/app/atm/domain/entity/customer.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tCustomerModel =
      CustomerModel(username: 'username', pin: 'pin', balance: 0);

  test('tCustomerModel should be a subclass of Customer entity', () {
    expect(tCustomerModel, isA<Customer>());
  });
}
