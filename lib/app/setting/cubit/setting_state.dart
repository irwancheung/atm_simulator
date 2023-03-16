part of 'setting_cubit.dart';

enum AppTheme {
  light,
  dark,
}

class SettingState extends Equatable {
  final AppTheme theme;
  const SettingState({required this.theme});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'theme': theme.name,
    };
  }

  factory SettingState.fromMap(Map<String, dynamic> map) {
    return SettingState(
      theme: AppTheme.values.firstWhere((theme) => theme.name == map['theme']),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [theme];
}
