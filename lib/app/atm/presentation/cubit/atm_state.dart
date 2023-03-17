part of 'atm_cubit.dart';

class AtmState extends Equatable {
  final AtmModel atm;

  const AtmState({
    required this.atm,
  });

  AtmState copyWith({
    AtmModel? atm,
  }) {
    return AtmState(
      atm: atm ?? this.atm,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'atm': atm.toMap(),
    };
  }

  factory AtmState.fromMap(Map<String, dynamic> map) {
    return AtmState(
      atm: AtmModel.fromMap(map['atm'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AtmState.fromJson(String source) =>
      AtmState.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [atm];
}
