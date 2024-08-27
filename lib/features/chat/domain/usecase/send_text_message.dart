import 'package:fpdart/fpdart.dart';
import 'package:freezed_example/core/common/enum/message_type_enum.dart';
import 'package:freezed_example/core/error/failure.dart';
import 'package:freezed_example/core/usecase/usecase.dart';
import 'package:freezed_example/features/chat/domain/repository/chat_repository.dart';

class SendTextMessage implements FutureUseCase<Null, SendTextMessageParams> {
  final ChatRepository chatRepository;
  const SendTextMessage(this.chatRepository);

  @override
  Future<Either<Failure, Null>> call(SendTextMessageParams params) async {
    return await chatRepository.sendTextMessage(
      receiver_id: params.receiver_id,
      message: params.message,
      messageType: params.messageType,
    );
  }
}

class SendTextMessageParams {
  final String receiver_id;
  final String message;
  final MessageTypeEnum messageType;
  const SendTextMessageParams({
    required this.receiver_id,
    required this.message,
    required this.messageType,
  });
}