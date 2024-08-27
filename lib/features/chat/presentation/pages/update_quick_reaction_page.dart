import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_example/core/common/widget/error.dart';
import 'package:freezed_example/core/common/widget/loading.dart';
import 'package:freezed_example/core/theme/app_pallete.dart';
import 'package:freezed_example/core/util/show_snack_bar.dart';
import 'package:freezed_example/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:toastification/toastification.dart';

class UpdateQuickReactionPage extends StatefulWidget {
  static const routeName = '/update-quick_reaction-page';

  final Map<String, dynamic> receiverData;
  final Map<String, dynamic> chatListData;

  const UpdateQuickReactionPage({
    super.key,
    required this.receiverData,
    required this.chatListData,
  });

  @override
  State<UpdateQuickReactionPage> createState() =>
      _UpdateQuickReactionPageState();
}

class _UpdateQuickReactionPageState extends State<UpdateQuickReactionPage> {
  late String quickReact;
  bool updateReact = false;

  @override
  void initState() {
    quickReact = widget.chatListData['quick_react'];
    super.initState();
  }

  void updateQuickReaction() {
    context.read<ChatBloc>().add(
        ChatUpdateQuickReaction(widget.receiverData['user_id'], quickReact));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quick reaction"),
        actions: [
          if (updateReact)
            IconButton(
              onPressed: updateQuickReaction,
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
        ],
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        listener: (context, state) {
          if (state is ChatUpdateQuickReactionSuccess) {
            SnackBars.showToastification(
                context,
                "Changed quick react successfully.",
                ToastificationType.success);
            Navigator.pop(context);
          }
          if (state is ChatFailure) {
            SnackBars.showToastification(
                context, state.message, ToastificationType.error);
          }
        },
        builder: (context, state) {
          if (state is ChatLoading) {
            return const LoadingWidget(caption: "");
          }
          if (state is ChatFailure) {
            return ErrorWidgets(errorMessage: state.message);
          }
          return Column(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const BubbleSpecialThree(
                              text: "What?",
                              color: Color(0xFF1B97F3),
                              tail: false,
                              isSender: false,
                            ),
                            BubbleSpecialThree(
                              text: "What is your name?",
                              color: Color(widget.chatListData['theme']),
                              tail: false,
                              isSender: true,
                            ),
                            const BubbleSpecialThree(
                              text: "Fuck You Too",
                              color: Color(0xFF1B97F3),
                              tail: false,
                              isSender: false,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                enabled: false,
                                decoration: const InputDecoration(
                                    hintText: "Write something..."),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Text(
                              quickReact,
                              style: const TextStyle(fontSize: 30),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    setState(() {
                      quickReact = emoji.emoji;
                      updateReact = true;
                    });
                  },
                  onBackspacePressed: () {},
                  config: const Config(
                    checkPlatformCompatibility: false,
                    emojiViewConfig: EmojiViewConfig(
                      horizontalSpacing: 10,
                      verticalSpacing: 10,
                      emojiSizeMax: 25,
                      gridPadding: EdgeInsets.zero,
                      backgroundColor: AppPallete.scaffoldBackgroundColor,
                      columns: 7,
                      buttonMode: ButtonMode.MATERIAL,
                    ),
                    swapCategoryAndBottomBar: false,
                    bottomActionBarConfig: BottomActionBarConfig(
                      enabled: false,
                    ),
                    categoryViewConfig: CategoryViewConfig(
                      categoryIcons: CategoryIcons(),
                      recentTabBehavior: RecentTabBehavior.NONE,
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      backgroundColor: AppPallete.scaffoldBackgroundColor,
                      iconColorSelected:
                          AppPallete.elevatedButtonBackgroundColor,
                      indicatorColor: AppPallete.elevatedButtonBackgroundColor,
                      showBackspaceButton: false,
                      backspaceColor: AppPallete.elevatedButtonBackgroundColor,
                      dividerColor: AppPallete.grey,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}