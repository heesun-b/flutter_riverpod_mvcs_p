import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_blog_start/core/constants/move.dart';
import 'package:flutter_riverpod_blog_start/model/post/post.dart';
import 'package:flutter_riverpod_blog_start/view/pages/post/detail_page/post_detail_page.dart';
import 'package:flutter_riverpod_blog_start/view/pages/post/home_page/components/post_home_list_item.dart';
import 'package:flutter_riverpod_blog_start/view/pages/post/home_page/post_home_page_view_model.dart';
import 'package:logger/logger.dart';

class PostHomeBody extends ConsumerWidget {
  const PostHomeBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Logger().d("PostHomeBody 그려짐");
    // postHomePageProvider.notifier 은 창고(view-model)에 접근하는 것
    // postHomePageProvider은 state 가져오는 것
    PostHomePageModel? model = ref.watch(postHomePageProvider);

    List<Post> posts = [];

    if (model != null) {
      posts = model.posts;
    }

    return ListView.separated(
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailPage(posts[index].id),
                ));
          },
          child: PostHomeListItem(posts[index]),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
