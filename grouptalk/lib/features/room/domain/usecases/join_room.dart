import 'package:dartz/dartz.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/room/domain/repositories/room_repository.dart';

class JoinRoom {
  final RoomRepository repository;

  JoinRoom({required this.repository});

  Future<Either<Failure, void>> call({required String roomId}) {
    return repository.joinRoom(roomId: roomId);
  }
}
