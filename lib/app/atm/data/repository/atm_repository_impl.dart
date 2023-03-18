import 'package:atm_simulator/app/atm/domain/entity/atm.dart';
import 'package:atm_simulator/app/atm/domain/entity/creditor.dart';
import 'package:atm_simulator/app/atm/domain/entity/customer.dart';
import 'package:atm_simulator/app/atm/domain/entity/debtor.dart';
import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart';
import 'package:atm_simulator/core/exception/app_exception.dart';
import 'package:atm_simulator/core/extension/int_extension.dart';
import 'package:atm_simulator/core/extension/string_extension.dart';
import 'package:atm_simulator/core/util/pin_encrypter.dart';
import 'package:atm_simulator/export.dart';
import 'package:collection/collection.dart';
import 'package:dartz/dartz.dart';
import 'package:sprintf/sprintf.dart';

class AtmRepositoryImpl implements AtmRepository {
  final PinEncrypter pinEncrypter;

  const AtmRepositoryImpl({required this.pinEncrypter});

  @override
  Future<Either<Atm, AppException>> logIn({
    required String command,
    required Atm atm,
  }) async {
    try {
      if (atm.activeCustomer != null) {
        return right(const AppException(loginAlreadyLoggedIn));
      }

      final commands = command.split(' ');

      if (commands.length != 3) {
        return right(const AppException(loginInvalidParams));
      }

      final username = commands[1].toLowerCase();
      final pin = commands[2];

      if (username.contains(RegExp(r'[^\w\s]'))) {
        return right(const AppException(loginInvalidUsername));
      }

      if (username.length < 3 || username.length > 10) {
        return right(const AppException(loginUsernameLength));
      }

      if (int.tryParse(pin) == null) {
        return right(const AppException(loginPinMustNumeric));
      }

      if (pin.length != 6) {
        return right(const AppException(loginPinMustSixDigits));
      }

      final customer = atm.customers.firstWhereOrNull(
        (customer) => customer.username == username,
      );

      if (customer != null) {
        final matchedPin = pinEncrypter.comparePin(pin, customer.pin);

        if (!matchedPin) {
          return right(const AppException(loginPinNotMatch));
        }

        final updatedHistory = atm.history.toList();
        updatedHistory.addAll([
          '> $command',
          'Welcome back, ${customer.username.toSentenceCase()}!',
          'Your balance is : ${customer.balance.toDollar()}',
        ]);

        final newAtm = atm.copyWith(
          activeCustomer: customer,
          history: updatedHistory,
        );

        return left(newAtm);
      }

      final updatedHistory = atm.history.toList();
      updatedHistory.addAll([
        '> $command',
        'Hello, ${username.toSentenceCase()}!',
        'Your balance is : ${0.toDollar()}',
      ]);

      final newCustomer = Customer(
        username: username,
        pin: pinEncrypter.encrypt(pin),
        balance: 0,
      );

      final newAtm = atm.copyWith(
        activeCustomer: newCustomer,
        customers: [...atm.customers.map((customer) => customer), newCustomer],
        history: updatedHistory,
      );

      return left(newAtm);
    } catch (e, s) {
      logger.e(e, s);
      return right(const AppException(loginCommandFailed));
    }
  }

  @override
  Future<Either<Atm, AppException>> logOut({required Atm atm}) async {
    try {
      if (atm.activeCustomer == null) {
        return right(const AppException(logoutAlreadyLoggedOut));
      }

      final updatedHistory = atm.history.toList();
      updatedHistory.addAll([
        '> logout',
        'Good bye, ${atm.activeCustomer!.username.toSentenceCase()}!',
      ]);

      final newAtm = Atm(
        customers: atm.customers,
        history: updatedHistory,
      );

      return left(newAtm);
    } catch (e, s) {
      logger.e(e, s);
      return right(const AppException(logoutCommandFailed));
    }
  }

  @override
  Future<Either<Atm, AppException>> checkBalance({required Atm atm}) async {
    try {
      if (atm.activeCustomer == null) {
        return right(const AppException(balanceNotLoggedIn));
      }

      final updatedHistory = atm.history.toList();
      updatedHistory.addAll([
        '> balance',
        'Your balance is : ${atm.activeCustomer!.balance.toDollar()}',
      ]);

      final newAtm = atm.copyWith(history: updatedHistory);

      return left(newAtm);
    } catch (e, s) {
      logger.e(e, s);
      return right(const AppException(balanceCommandFailed));
    }
  }

  @override
  Future<Either<Atm, AppException>> deposit({
    required String command,
    required Atm atm,
  }) async {
    try {
      if (atm.activeCustomer == null) {
        return right(const AppException(depositNotLoggedIn));
      }

      final commands = command.split(' ');

      if (commands.length != 2) {
        return right(const AppException(depositInvalidParams));
      }

      if (int.tryParse(commands[1]) == null) {
        return right(const AppException(depositInvalidAmount));
      }

      final amount = int.tryParse(commands[1])!;

      if (amount <= 0) {
        return right(const AppException(depositInvalidAmount));
      }

      final updatedActiveCustomer = atm.activeCustomer!.copyWith(
        balance: atm.activeCustomer!.balance + amount,
      );

      final updatedCustomers =
          _updateCustomers(atm.customers, updatedActiveCustomer, null);

      final updatedHistory = atm.history.toList();
      updatedHistory.addAll([
        '> $command',
        'You balance now is : ${updatedActiveCustomer.balance.toDollar()}',
      ]);

      final newAtm = atm.copyWith(
        activeCustomer: updatedActiveCustomer,
        customers: updatedCustomers,
        history: updatedHistory,
      );

      return left(newAtm);
    } catch (e, s) {
      logger.e(e, s);
      return right(const AppException(depositCommandFailed));
    }
  }

  @override
  Future<Either<Atm, AppException>> withdraw({
    required String command,
    required Atm atm,
  }) async {
    try {
      if (atm.activeCustomer == null) {
        return right(const AppException(withdrawNotLoggedIn));
      }

      final commands = command.split(' ');

      if (commands.length != 2) {
        return right(const AppException(withdrawInvalidParams));
      }

      if (int.tryParse(commands[1]) == null) {
        return right(const AppException(withdrawInvalidAmount));
      }

      final amount = int.tryParse(commands[1])!;

      if (amount <= 0) {
        return right(const AppException(withdrawInvalidAmount));
      }

      if (amount > atm.activeCustomer!.balance) {
        return right(const AppException(withdrawInsufficientBalance));
      }

      final updatedActiveCustomer = atm.activeCustomer!.copyWith(
        balance: atm.activeCustomer!.balance - amount,
      );

      final updatedCustomers =
          _updateCustomers(atm.customers, updatedActiveCustomer, null);

      final updatedHistory = atm.history.toList();
      updatedHistory.addAll([
        '> $command',
        'You balance now is : ${updatedActiveCustomer.balance.toDollar()}',
      ]);

      final newAtm = atm.copyWith(
        activeCustomer: updatedActiveCustomer,
        customers: updatedCustomers,
        history: updatedHistory,
      );

      return left(newAtm);
    } catch (e, s) {
      logger.e(e, s);
      return right(const AppException(withdrawCommandFailed));
    }
  }

  @override
  Future<Either<Atm, AppException>> transfer({
    required String command,
    required Atm atm,
  }) async {
    try {
      if (atm.activeCustomer == null) {
        return right(const AppException(transferNotLoggedIn));
      }

      final commands = command.split(' ');

      if (commands.length != 3) {
        return right(const AppException(transferInvalidParams));
      }

      if (int.tryParse(commands[2]) == null) {
        return right(const AppException(transferInvalidAmount));
      }

      final amount = int.tryParse(commands[2])!;

      if (amount <= 0) {
        return right(const AppException(transferInvalidAmount));
      }

      final targetUsername = commands[1].toLowerCase();
      final targetCustomer = atm.customers.firstWhereOrNull(
        (customer) => customer.username == targetUsername,
      );

      if (targetCustomer == null) {
        return right(const AppException(transferTargetNotFound));
      }

      if (targetCustomer.username == atm.activeCustomer!.username) {
        return right(const AppException(transferSameAccount));
      }

      final activeCustomer = atm.activeCustomer!;

      if (amount > activeCustomer.balance) {
        final creditor = activeCustomer.creditor;
        final debtor = targetCustomer.debtor;

        if (creditor != null && creditor.username != targetUsername) {
          return right(
            AppException(
              sprintf(
                transferCreditorIsDifferent,
                [creditor.amount, creditor.username],
              ),
            ),
          );
        }

        if (debtor != null && debtor.username != activeCustomer.username) {
          return Right(
            AppException(
              sprintf(transferDebtorIsDifferent, [targetUsername]),
            ),
          );
        }

        final remainder = amount - activeCustomer.balance;

        final updatedActiveCustomer = activeCustomer.copyWith(
          balance: 0,
          creditor: creditor != null
              ? creditor.copyWith(amount: creditor.amount + remainder)
              : Creditor(username: targetUsername, amount: remainder),
        );

        final updatedTargetCustomer = targetCustomer.copyWith(
          balance: targetCustomer.balance + activeCustomer.balance,
          debtor: debtor != null
              ? debtor.copyWith(amount: debtor.amount + remainder)
              : Debtor(username: activeCustomer.username, amount: remainder),
        );

        final updatedCustomers = _updateCustomers(
          atm.customers,
          updatedActiveCustomer,
          updatedTargetCustomer,
        );

        final updatedHistory = atm.history.toList();
        updatedHistory.addAll([
          '> $command',
          'Transferred ${amount.toDollar()} to ${updatedTargetCustomer.username.toSentenceCase()}',
          'Your balance now is : ${updatedActiveCustomer.balance.toDollar()}',
          'You owed ${updatedActiveCustomer.creditor!.amount.toDollar()} to ${updatedTargetCustomer.username.toSentenceCase()}',
        ]);

        final newAtm = atm.copyWith(
          activeCustomer: updatedActiveCustomer,
          customers: updatedCustomers,
          history: updatedHistory,
        );

        return left(newAtm);
      }

      final updatedActiveCustomer = activeCustomer.copyWith(
        balance: atm.activeCustomer!.balance - amount,
      );

      final updatedTargetCustomer = targetCustomer.copyWith(
        balance: targetCustomer.balance + amount,
      );

      final updatedCustomers = _updateCustomers(
        atm.customers,
        updatedActiveCustomer,
        updatedTargetCustomer,
      );

      final updatedHistory = atm.history.toList();
      updatedHistory.addAll([
        '> $command',
        'Transferred ${amount.toDollar()} to ${updatedTargetCustomer.username.toSentenceCase()}',
        'Your balance now is : ${updatedActiveCustomer.balance.toDollar()}',
      ]);

      final newAtm = atm.copyWith(
        activeCustomer: updatedActiveCustomer,
        customers: updatedCustomers,
        history: updatedHistory,
      );

      return left(newAtm);
    } catch (e, s) {
      logger.e(e, s);
      return right(const AppException(transferCommandFailed));
    }
  }

  @override
  Future<Either<Atm, AppException>> showHelp({required Atm atm}) async {
    try {
      final updatedHistory = atm.history.toList();
      updatedHistory.addAll([
        '> help',
        '''
Available commands :
- login <username> <pin> : Log in user
- logout : Log out user
- balance : Check your balance
- deposit <amount> : Deposit this amount to your saving
- withdraw <amount> : Withdraw this amount from your saving
- transfer <target> <amount> : Transfer this amount to another customer
- clear : Clear the screen
- help : Show this help message
'''
      ]);

      final newAtm = atm.copyWith(history: updatedHistory);

      return left(newAtm);
    } catch (e, s) {
      logger.e(e, s);
      return right(const AppException(helpCommandFailed));
    }
  }

  @override
  Future<Either<Atm, AppException>> clearCommands({required Atm atm}) async {
    try {
      final updatedHistory = atm.activeCustomer != null
          ? const <String>[]
          : <String>[
              'Welcome to ATM Simulator',
              'Please type : `login <username> <pin>` to log in or register new account.',
            ];

      final newAtm = atm.copyWith(history: updatedHistory);

      return left(newAtm);
    } catch (e, s) {
      logger.e(e, s);
      return right(const AppException(clearCommandFailed));
    }
  }

  List<Customer> _updateCustomers(
    List<Customer> customers,
    Customer activeCustomer,
    Customer? targetCustomer,
  ) {
    return customers.map((customer) {
      if (customer.username == activeCustomer.username) {
        return activeCustomer;
      }

      if (targetCustomer != null &&
          customer.username == targetCustomer.username) {
        return targetCustomer;
      }

      return customer;
    }).toList();
  }
}
