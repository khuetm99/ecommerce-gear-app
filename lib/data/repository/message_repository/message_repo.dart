
import 'package:ecommerce_app/data/models/message_model.dart';

abstract class MessageRepository {
  /// Get 20 first messages
  Stream<List<MessageModel>> fetchRecentMessages({
    required String uid,
    required int messagesLimit,
  });

  /// Get more messages
  Future<List<MessageModel>> fetchPreviousMessages({
    required String uid,
    required int messagesLimit,
    required MessageModel lastMessage,
  });

  /// Get lastest message
  Future<MessageModel?> getLastestMessage({required String uid});

  /// Add message
  /// [uid] is user id
  /// [newItem] is data of new  message
  Future<void> addMessage(String uid, MessageModel message);

  /// Remove message
  /// [uid] is user id
  /// [cartItem] is data of  message
  Future<void> removeMessage(String uid, MessageModel message);
}
