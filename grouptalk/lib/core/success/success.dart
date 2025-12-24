import 'package:equatable/equatable.dart';

class Success extends Equatable {
  final String successMassage;
  const Success({this.successMassage = 'Success'});
  
  @override
  List<Object?> get props => throw UnimplementedError();
}
