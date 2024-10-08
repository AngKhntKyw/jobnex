import 'package:fpdart/fpdart.dart';
import 'package:JobNex/core/error/failure.dart';
import 'package:JobNex/core/usecase/usecase.dart';
import 'package:JobNex/features/chat/domain/repository/chat_repository.dart';

class UpdateTheme implements FutureUseCase<Null, UpdateThemeParams> {
  final ChatRepository chatRepository;
  const UpdateTheme(this.chatRepository);

  @override
  Future<Either<Failure, Null>> call(UpdateThemeParams params) async {
    return await chatRepository.updateTheme(
        receiver_id: params.receiver_id, theme: params.theme);
  }
}

class UpdateThemeParams {
  final String receiver_id;
  final int theme;
  const UpdateThemeParams({
    required this.receiver_id,
    required this.theme,
  });
}
