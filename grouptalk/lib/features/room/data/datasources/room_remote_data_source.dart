import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:grouptalk/core/error/exception.dart';
import 'package:grouptalk/features/room/data/models/room_model.dart';

abstract class RoomRemoteDataSource {
  Future<RoomModel> createRoom({
    required String name,
    required String description,
    required bool isPublic,
    required String subject
  });

  Future<void> joinRoom({required String roomId});

  Future<List<RoomModel>> getAllPublicRooms();

  Future<List<RoomModel>> getJoinedRooms();
}

class RoomRemoteDataSourceImpl implements RoomRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  RoomRemoteDataSourceImpl({required this.firestore, required this.auth});

  @override
  Future<RoomModel> createRoom({
    required String name,
    required String description,
    required bool isPublic,
    required String subject
  }) async {
    try {
      final uid = auth.currentUser!.uid;
      final roomRef = firestore.collection('rooms').doc();

      // Create the room
      await roomRef.set({
        'name': name,
        'description': description,
        'ownerId': uid,
        'isPublic': isPublic,
        'createdAt': FieldValue.serverTimestamp(),
        'subject': subject,
      });

      // Adds creator to the group as a member
      await roomRef.collection('members').doc(uid).set({
        'joinedAt': FieldValue.serverTimestamp(),
      });

      // Adds group to users list of joined groups
      await firestore
          .collection('users')
          .doc(uid)
          .collection('joinedRooms')
          .doc(roomRef.id)
          .set({'joinedAt': FieldValue.serverTimestamp()});

      return RoomModel(
        id: roomRef.id,
        name: name,
        description: description,
        ownerId: uid,
        isPublic: isPublic,
        subject: subject
      );
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<RoomModel>> getAllPublicRooms() async {
    try {
      final snapshot = await firestore
          .collection('rooms')
          .where('isPublic', isEqualTo: true)
          .get();

      return snapshot.docs.map((doc) => RoomModel.fromFirestore(doc)).toList();
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<RoomModel>> getJoinedRooms() async {
    try {
      final uid = auth.currentUser!.uid;

      final joinedSnapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('joinedRooms')
          .get();

      final roomIds = joinedSnapshot.docs.map((d) => d.id);

      final rooms = <RoomModel>[];

      for (final id in roomIds) {
        final doc = await firestore.collection('rooms').doc(id).get();
        rooms.add(RoomModel.fromFirestore(doc));
      }

      return rooms;
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  @override
  Future<void> joinRoom({required String roomId}) async {
    try {
      final uid = auth.currentUser!.uid;

      // Add user to the group
      await firestore
          .collection('rooms')
          .doc(roomId)
          .collection('members')
          .doc(uid)
          .set({'joinedAt': FieldValue.serverTimestamp()});

      // Add group to users joined rooms
      await firestore
          .collection('users')
          .doc(uid)
          .collection('joinedRooms')
          .doc(roomId)
          .set({'joinedAt': FieldValue.serverTimestamp()});
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }
}
