import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:grouptalk/core/error/failure.dart';
import 'package:grouptalk/features/room/data/datasources/room_remote_data_source.dart';
import 'package:grouptalk/features/room/domain/entities/room_entity.dart';
import 'package:grouptalk/features/room/domain/repositories/room_repository.dart';

class RoomRepositoryImpl implements RoomRepository {
  final RoomRemoteDataSource remoteDataSource;

  RoomRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, RoomEntity>> createRoom({
    required String name,
    required String description,
    required bool isPublic,
    required String subject,
  }) async {
    try {
      final room = await remoteDataSource.createRoom(
        name: name,
        description: description,
        isPublic: isPublic,
        subject: subject,
      );
      return Right(room);
    } catch (e) {
      return Left(ServerFailure(failureMassage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RoomEntity>>> getAllRooms() async {
    try {
      final rooms = await remoteDataSource.getAllPublicRooms();
      return Right(rooms);
    } catch (e) {
      return Left(ServerFailure(failureMassage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RoomEntity>>> getJoinedRooms() async {
    debugPrint(
      'Get Hoined Rooms Repository ============================================================================>',
    );
    try {
      final rooms = await remoteDataSource.getJoinedRooms();
      return Right(rooms);
    } catch (e) {
      return Left(ServerFailure(failureMassage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> joinRoom({required String roomId}) async {
    try {
      await remoteDataSource.joinRoom(roomId: roomId);
      return Right(null);
    } catch (e) {
      return Left(ServerFailure(failureMassage: e.toString()));
    }
  }
}
