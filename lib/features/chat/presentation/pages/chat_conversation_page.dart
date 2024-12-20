import 'package:JobNex/features/chat/data/model/video_call.dart';
import 'package:JobNex/features/chat/presentation/pages/test_verification_code.dart';
import 'package:JobNex/features/chat/presentation/pages/text_video_call_page.dart';
import 'package:JobNex/features/chat/presentation/pages/vc_call_page.dart';
import 'package:JobNex/features/chat/presentation/widgets/preview_reply_widget.dart';
import 'package:JobNex/features/chat/presentation/provider/chat_input_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:JobNex/core/common/widget/error.dart';
import 'package:JobNex/core/common/widget/loading.dart';
import 'package:JobNex/core/theme/app_pallete.dart';
import 'package:JobNex/core/util/show_snack_bar.dart';
import 'package:JobNex/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:JobNex/features/chat/presentation/pages/chat_information_page.dart';
import 'package:JobNex/features/chat/presentation/widgets/chat_conversation_app_bar.dart';
import 'package:JobNex/features/chat/presentation/widgets/chat_inputs.dart';
import 'package:JobNex/features/chat/presentation/widgets/message_list_widget.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

class ChatConversationPage extends StatefulWidget {
  static const routeName = '/chat-conversation-page';

  final Map<String, dynamic> receiverData;
  final String chatRoomId;
  const ChatConversationPage({
    super.key,
    required this.receiverData,
    required this.chatRoomId,
  });

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final fireAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;
  final messageController = TextEditingController();

  @override
  void initState() {
    context.read<ChatBloc>().add(ChatGetChatRoomData(widget.chatRoomId));
    super.initState();
  }

  void call() async {
    await fireStore
        .collection('users')
        .doc(widget.receiverData['user_id'])
        .collection('video_call')
        .doc(fireAuth.currentUser!.uid)
        .set(VideoCall(
          caller_id: fireAuth.currentUser!.uid,
          receiver_id: widget.receiverData['user_id'],
          is_accepted: false,
        ).toJson());

    //
    await fireStore
        .collection('users')
        .doc(fireAuth.currentUser!.uid)
        .collection('video_call')
        .doc(widget.receiverData['user_id'])
        .set(VideoCall(
          caller_id: fireAuth.currentUser!.uid,
          receiver_id: widget.receiverData['user_id'],
          is_accepted: false,
        ).toJson());
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final fireAuth = FirebaseAuth.instance;

    return BlocConsumer<ChatBloc, ChatState>(
      buildWhen: (previous, current) => current is ChatGetChatRoomDataSuccuess,
      listenWhen: (previous, current) => current is ChatFailure,
      listener: (context, state) {
        if (state is ChatFailure) {
          SnackBars.showToastification(
              context, state.message, ToastificationType.error);
        }
      },
      builder: (context, state) {
        if (state is ChatLoading) {
          return const Scaffold(body: LoadingWidget());
        }
        //
        if (state is ChatFailure) {
          return Scaffold(body: ErrorWidgets(errorMessage: state.message));
        }
        if (state is ChatGetChatRoomDataSuccuess) {
          return StreamBuilder(
            stream: state.chatRoomData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingWidget();
              } else if (snapshot.hasError) {
                return ErrorWidgets(errorMessage: snapshot.error.toString());
              }
              final chatRoomData = snapshot.data!.data()!;

              return ChangeNotifierProvider(
                create: (context) => ChatInputProvider(),
                lazy: true,
                builder: (context, child) {
                  return Scaffold(
                    appBar: AppBar(
                      title: InkWell(
                        enableFeedback: true,
                        highlightColor: AppPallete.lightBlue,
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onTap: () {
                          !chatRoomData['block'] ||
                                  chatRoomData['block_by'] ==
                                      fireAuth.currentUser!.uid
                              ? Navigator.pushNamed(
                                  context,
                                  ChatInformationPage.routeName,
                                  arguments: {
                                    "receiverData": widget.receiverData,
                                    "chatRoomId": widget.chatRoomId,
                                    "chatRoomData": chatRoomData,
                                  },
                                )
                              : null;
                        },
                        child: ChatConversationAppBar(
                          receiverData: widget.receiverData,
                          chatRoomData: chatRoomData,
                          size: size,
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const VcCallPage(),
                                ));
                          },
                          icon: const Icon(Iconsax.video_bold),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const TestVerificationCodePage(),
                                ));
                          },
                          icon: const Icon(Iconsax.call_bold),
                        ),
                        IconButton(
                          onPressed: () {
                            call();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TestVideoCallPage(
                                  receiverData: widget.receiverData,
                                ),
                              ),
                            );
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) =>
                            //           const VideoCallingPage(),
                            //     ));
                          },
                          icon: const Icon(Iconsax.video_bold),
                        ),
                        IconButton(
                          onPressed: () {
                            !chatRoomData['block'] ||
                                    chatRoomData['block_by'] ==
                                        fireAuth.currentUser!.uid
                                ? Navigator.pushNamed(
                                    context,
                                    ChatInformationPage.routeName,
                                    arguments: {
                                      "receiverData": widget.receiverData,
                                      "chatRoomId": widget.chatRoomId,
                                      "chatRoomData": chatRoomData
                                    },
                                  )
                                : null;
                          },
                          icon: const Icon(Iconsax.info_circle_bold),
                        ),
                      ],
                    ),
                    body: Column(
                      children: [
                        // Messages List
                        Expanded(
                          child: Center(
                            child: MessageListWidget(
                              receiverData: widget.receiverData,
                              messageController: messageController,
                              chatRoomData: chatRoomData,
                            ),
                          ),
                        ),

                        // Preview Reply
                        PreviewReplyWidget(receiverData: widget.receiverData),

                        // Chat Inputs
                        !chatRoomData['block']
                            ? ChatInputs(
                                receiverData: widget.receiverData,
                                messageController: messageController,
                                chatListData: chatRoomData,
                              )
                            : Card(
                                child: Text(
                                    "${chatRoomData['block_by'] == fireAuth.currentUser!.uid ? "You" : "Other"} blocked."),
                              ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        }
        return const Scaffold();
      },
    );
  }
}
