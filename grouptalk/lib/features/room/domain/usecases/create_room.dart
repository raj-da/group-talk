import 'package:dartz/dartz.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/room/domain/entities/room_entity.dart';
import 'package:grouptalk/features/room/domain/repositories/room_repository.dart';

class CreateRoom {
  final RoomRepository repository;

  CreateRoom({required this.repository});

  Future<Either<Failure, RoomEntity>> call({
    required String name,
    required String description,
    required bool isPublic,
    required String subject
  }) {
    return repository.createRoom(
      name: name,
      description: description,
      isPublic: isPublic,
      subject: subject
    );
  }
}
