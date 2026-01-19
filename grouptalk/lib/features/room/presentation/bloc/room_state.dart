part of 'room_bloc.dart';

sealed class RoomState extends Equatable {
  const RoomState();

  @override
  List<Object> get props => [];
}

final class RoomInitial extends RoomState {}

class RoomLoading extends RoomState {}

class RoomLoaded extends RoomState {
  final List<RoomEntity> rooms;

  const RoomLoaded({required this.rooms});

  @override
  List<Object> get props => [rooms];
}

class RoomActionSuccess extends RoomState {}

class RoomCreated extends RoomState {
  final RoomEntity room;

  const RoomCreated({required this.room});

  @override
  List<Object> get props => [room];
}

class RoomError extends RoomState {
  final String message;

  const RoomError({required this.message});

  @override
  List<Object> get props => [message];
}
