// Mocks generated by Mockito 5.3.2 from annotations
// in atm_simulator/test/app/atm/domain/use_case/transfer_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:atm_simulator/app/atm/domain/entity/atm.dart' as _i5;
import 'package:atm_simulator/app/atm/domain/repository/atm_repository.dart'
    as _i3;
import 'package:atm_simulator/core/exception/app_exception.dart' as _i6;
import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AtmRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAtmRepository extends _i1.Mock implements _i3.AtmRepository {
  @override
  _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>> logIn({
    required String? command,
    required _i5.Atm? atm,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #logIn,
          [],
          {
            #command: command,
            #atm: atm,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
            _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #logIn,
            [],
            {
              #command: command,
              #atm: atm,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
                _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #logIn,
            [],
            {
              #command: command,
              #atm: atm,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>);
  @override
  _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>> logOut(
          {required _i5.Atm? atm}) =>
      (super.noSuchMethod(
        Invocation.method(
          #logOut,
          [],
          {#atm: atm},
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
            _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #logOut,
            [],
            {#atm: atm},
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
                _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #logOut,
            [],
            {#atm: atm},
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>);
  @override
  _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>> checkBalance({
    required String? command,
    required _i5.Atm? atm,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #checkBalance,
          [],
          {
            #command: command,
            #atm: atm,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
            _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #checkBalance,
            [],
            {
              #command: command,
              #atm: atm,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
                _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #checkBalance,
            [],
            {
              #command: command,
              #atm: atm,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>);
  @override
  _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>> deposit({
    required String? command,
    required _i5.Atm? atm,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #deposit,
          [],
          {
            #command: command,
            #atm: atm,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
            _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #deposit,
            [],
            {
              #command: command,
              #atm: atm,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
                _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #deposit,
            [],
            {
              #command: command,
              #atm: atm,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>);
  @override
  _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>> withdraw({
    required String? command,
    required _i5.Atm? atm,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #withdraw,
          [],
          {
            #command: command,
            #atm: atm,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
            _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #withdraw,
            [],
            {
              #command: command,
              #atm: atm,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
                _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #withdraw,
            [],
            {
              #command: command,
              #atm: atm,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>);
  @override
  _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>> transfer({
    required String? command,
    required _i5.Atm? atm,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #transfer,
          [],
          {
            #command: command,
            #atm: atm,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
            _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #transfer,
            [],
            {
              #command: command,
              #atm: atm,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
                _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #transfer,
            [],
            {
              #command: command,
              #atm: atm,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>);
  @override
  _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>> showHelp({
    required String? command,
    required _i5.Atm? atm,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #showHelp,
          [],
          {
            #command: command,
            #atm: atm,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
            _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #showHelp,
            [],
            {
              #command: command,
              #atm: atm,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
                _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #showHelp,
            [],
            {
              #command: command,
              #atm: atm,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>);
  @override
  _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>> clearCommands({
    required String? command,
    required _i5.Atm? atm,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #clearCommands,
          [],
          {
            #command: command,
            #atm: atm,
          },
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
            _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #clearCommands,
            [],
            {
              #command: command,
              #atm: atm,
            },
          ),
        )),
        returnValueForMissingStub:
            _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>.value(
                _FakeEither_0<_i5.Atm, _i6.AppException>(
          this,
          Invocation.method(
            #clearCommands,
            [],
            {
              #command: command,
              #atm: atm,
            },
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Atm, _i6.AppException>>);
}
