import 'package:dartz/dartz.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/room/domain/entities/room_entity.dart';

abstract class RoomRepository {
  Future<Either<Failure, RoomEntity>> createRoom({
    required String name,
    required String description,
    required bool isPublic,
    required String subject
  });

  Future<Either<Failure, void>> joinRoom({required String roomId});

  Future<Either<Failure, List<RoomEntity>>> getAllRooms();

  Future<Either<Failure, List<RoomEntity>>> getJoinedRooms();
}
