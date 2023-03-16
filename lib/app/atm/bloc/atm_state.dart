part of 'atm_bloc.dart';

abstract class AtmState extends Equatable {
  const AtmState();
  
  @override
  List<Object> get props => [];
}

class AtmInitial extends AtmState {}
