import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:JobNex/core/common/widget/error.dart';
import 'package:JobNex/core/common/widget/loading.dart';
import 'package:JobNex/core/theme/app_pallete.dart';
import 'package:JobNex/core/util/change_to_time_ago.dart';
import 'package:JobNex/core/util/show_snack_bar.dart';
import 'package:JobNex/features/post/presentation/bloc/post_bloc.dart';
import 'package:JobNex/features/post/presentation/pages/comment_list_page.dart';
import 'package:JobNex/features/post/presentation/widgets/post_owner.dart';
import 'package:JobNex/features/post/presentation/widgets/react_and_comment_bar.dart';
import 'package:toastification/toastification.dart';

class PostDetailPage extends StatefulWidget {
  static const routeName = '/post-detail-page';

  final String post_id;
  const PostDetailPage({super.key, required this.post_id});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage>
    with SingleTickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    context.read<PostBloc>().add(PostGetPostById(widget.post_id));
    scrollController = ScrollController();
    scrollController.addListener(scrollListiner);
    animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    sizeAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    ));
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(scrollListiner);
    scrollController.dispose();
    animationController.dispose();
    super.dispose();
  }

  void scrollListiner() {
    if (scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      animationController.reverse();
    } else if (scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Post Detail")),
      body: BlocConsumer<PostBloc, PostState>(
        buildWhen: (previous, current) =>
            current is PostGetPostByIdSuccessState,
        listenWhen: (previous, current) => current is PostFailure,
        listener: (context, state) {
          if (state is PostFailure) {
            SnackBars.showToastification(
                context, state.message, ToastificationType.error);
          }
        },
        builder: (context, state) {
          // Loading
          if (state is PostLoading) {
            return const LoadingWidget();
          }

          // Failure
          if (state is PostFailure) {
            return ErrorWidgets(errorMessage: state.message);
          }

          // Success
          if (state is PostGetPostByIdSuccessState) {
            return StreamBuilder(
              stream: state.post,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LoadingWidget();
                } else if (snapshot.hasError) {
                  return ErrorWidgets(errorMessage: "${snapshot.error}");
                }

                final post = snapshot.data!;

                //

                return Column(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: size.height,
                        width: size.width,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FadeInRight(
                                    from: 20,
                                    duration: const Duration(milliseconds: 300),
                                    delay: const Duration(milliseconds: 300),
                                    animate: true,
                                    curve: Curves.easeIn,
                                    child: PostOwner(
                                      post: post,
                                      created_at:
                                          changeToTimeAgo("${post.created_at}"),
                                    ),
                                  ),
                                  SizedBox(height: size.height / 20),
                                  FadeInRight(
                                      from: 40,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      delay: const Duration(milliseconds: 300),
                                      animate: true,
                                      curve: Curves.easeIn,
                                      child: Text(post.post_title)),
                                  SizedBox(height: size.height / 20),
                                  FadeInRight(
                                    from: 60,
                                    duration: const Duration(milliseconds: 300),
                                    delay: const Duration(milliseconds: 300),
                                    animate: true,
                                    curve: Curves.easeIn,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl: post.image,
                                        fit: BoxFit.cover,
                                        height: size.width / 2,
                                        width: size.width,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: size.height / 20),
                                  FadeInRight(
                                    from: 80,
                                    duration: const Duration(milliseconds: 300),
                                    delay: const Duration(milliseconds: 300),
                                    animate: true,
                                    curve: Curves.easeIn,
                                    child: Text(post.post_body),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizeTransition(
                      sizeFactor: sizeAnimation,
                      child: InkWell(
                          highlightColor: AppPallete.lightBlue,
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                                context, CommentListPage.routeName,
                                arguments: post);
                          },
                          child: ReactAndCommentBar(post: post)),
                    ),
                  ],
                );
              },
            );
          }
          return const ErrorWidgets(errorMessage: "No active state.");
        },
      ),
    );
  }
}
