import 'package:fpdart/fpdart.dart';
import 'package:freezed_example/core/error/failure.dart';
import 'package:freezed_example/core/usecase/usecase.dart';
import 'package:freezed_example/features/chat/domain/repository/chat_repository.dart';

class DeleteConversation
    implements FutureUseCase<Null, DeleteConversationParams> {
  final ChatRepository chatRepository;
  const DeleteConversation(this.chatRepository);

  @override
  Future<Either<Failure, Null>> call(DeleteConversationParams params) async {
    return await chatRepository.deleteConversation(
        chatroom_id: params.chatroom_id);
  }
}

class DeleteConversationParams {
  final String chatroom_id;
  const DeleteConversationParams({
    required this.chatroom_id,
  });
}