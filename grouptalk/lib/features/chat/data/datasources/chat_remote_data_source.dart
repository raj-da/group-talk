import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:grouptalk/core/error/exception.dart';
import 'package:grouptalk/features/chat/data/model/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<void> sendMessage({required MessageModel message});
  Future<List<MessageModel>> getMessages({required String roomId});
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final FirebaseFirestore firestore;

  ChatRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> sendMessage({required MessageModel message}) async {
    try {
      await firestore
          .collection('rooms')
          .doc(message.roomId)
          .collection('messages')
          .add(message.toFirestore());
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<MessageModel>> getMessages({required String roomId}) async {
    try {
      final snapshot = await firestore
          .collection('rooms')
          .doc(roomId)
          .collection('messages')
          .orderBy('createdAt')
          .get();

      return snapshot.docs
          .map(
            (doc) => MessageModel.fromFirestore(json: doc.data(), id: doc.id),
          )
          .toList();
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }
}
