import 'package:dartz/dartz.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/room/domain/entities/room_entity.dart';
import 'package:grouptalk/features/room/domain/repositories/room_repository.dart';

class GetAllRooms {
  final RoomRepository repository;

  GetAllRooms({required this.repository});

  Future<Either<Failure, List<RoomEntity>>> call() => repository.getAllRooms();
}
