import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:grouptalk/features/room/domain/entities/room_entity.dart';
import 'package:grouptalk/features/room/domain/usecases/create_room.dart';
import 'package:grouptalk/features/room/domain/usecases/get_all_rooms.dart';
import 'package:grouptalk/features/room/domain/usecases/get_joined_rooms.dart';
import 'package:grouptalk/features/room/domain/usecases/join_room.dart';

part 'room_event.dart';
part 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final CreateRoom createRoom;
  final GetJoinedRooms getJoinedRooms;
  final GetAllRooms getAllRooms;
  final JoinRoom joinRoom;

  RoomBloc({
    required this.createRoom,
    required this.getJoinedRooms,
    required this.getAllRooms,
    required this.joinRoom,
  }) : super(RoomInitial()) {
    on<RoomEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<CreateRoomEvent>(_onCreateRoom);
    on<LoadJoinedRooms>(_onLoadJoinedRooms);
    on<LoadPublicRooms>(_onLoadPublicRooms);
    on<JoinRoomEvent>(_onJoinRoom);
  }

  Future<void> _onLoadJoinedRooms(
    LoadJoinedRooms event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoading());

    final result = await getJoinedRooms();

    result.fold(
      (failure) => emit(RoomError(message: failure.failureMassage)),
      (rooms) => emit(RoomLoaded(rooms: rooms)),
    );
  }

  Future<void> _onLoadPublicRooms(
    LoadPublicRooms event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoading());

    final result = await getAllRooms();

    result.fold(
      (failure) => emit(RoomError(message: failure.failureMassage)),
      (rooms) => emit(RoomLoaded(rooms: rooms)),
    );
  }

  Future<void> _onJoinRoom(JoinRoomEvent event, Emitter<RoomState> emit) async {
    emit(RoomLoading());

    final result = await joinRoom(roomId: event.roomId);

    result.fold(
      (failure) => emit(RoomError(message: failure.failureMassage)),
      (_) => emit(RoomActionSuccess()),
    );
  }

  Future<void> _onCreateRoom(
    CreateRoomEvent event,
    Emitter<RoomState> emit,
  ) async {
    emit(RoomLoading());

    final result = await createRoom(
      description: event.description,
      isPublic: event.isPublic,
      name: event.name,
      subject: event.subject,
    );

    result.fold(
      (failure) => emit(RoomError(message: failure.failureMassage)),
      (room) => emit(RoomCreated(room: room)),
    );
  }
}
