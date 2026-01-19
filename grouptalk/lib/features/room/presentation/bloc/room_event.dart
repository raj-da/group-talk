part of 'room_bloc.dart';

sealed class RoomEvent extends Equatable {
  const RoomEvent();

  @override
  List<Object> get props => [];
}

class LoadJoinedRooms extends RoomEvent {}

class LoadPublicRooms extends RoomEvent {}

class JoinRoomEvent extends RoomEvent {
  final String roomId;

  const JoinRoomEvent({required this.roomId});

  @override
  List<Object> get props => [roomId];
}

class CreateRoomEvent extends RoomEvent {
  final String name;
  final String subject;
  final String description;
  final bool isPublic;

  const CreateRoomEvent({
    required this.name,
    required this.subject,
    required this.description,
    required this.isPublic,
  });

  @override
  List<Object> get props => [name, subject, description, isPublic];
}
