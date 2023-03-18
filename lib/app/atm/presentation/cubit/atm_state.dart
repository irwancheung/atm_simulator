part of 'atm_cubit.dart';

class AtmState extends Equatable {
  final Atm atm;

  const AtmState({
    required this.atm,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'atm': atm.toMap(),
    };
  }

  factory AtmState.fromMap(Map<String, dynamic> map) {
    return AtmState(atm: Atm.fromMap(map['atm'] as Map<String, dynamic>));
  }

  @override
  List<Object> get props => [atm];
}
