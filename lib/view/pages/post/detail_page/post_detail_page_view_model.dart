

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_blog_start/dto/response_dto.dart';
import 'package:flutter_riverpod_blog_start/model/post/post.dart';
import 'package:flutter_riverpod_blog_start/model/post/post_repository.dart';
import 'package:flutter_riverpod_blog_start/provider/session_provider.dart';
import 'package:flutter_riverpod_blog_start/view/pages/post/home_page/post_home_page_view_model.dart';

//창고
class PostDetailPageViewModel extends StateNotifier<PostDetailPageModel?>{
  PostDetailPageViewModel(super.state);

//action
  // 초기화는 notify 붙이기
  void notifyInit(int id, String jwt) async {
    ResponseDTO responseDTO = await PostRepository().fetchPost(jwt, id);
    state = PostDetailPageModel(post:responseDTO.data);
  }

  void notifyRemove(int id) {
    Post post = state!.post;
    if(post.id == id) {
      state = null;
      // ref.read(postHomePageProvider.notifier).notifyRemove(id);
    }
  }

  void notifyUpdate(Post updatePost) {
    state = PostDetailPageModel(post: updatePost);
  }
}

//데이터
class PostDetailPageModel {
  Post post;
  PostDetailPageModel({required this.post});
}

//창고 관리자 - 페이지 최초 로딩 시 init(초기화) 바로 실행 = controller를 때리지 않기 때문
final postDetailPageProvider
= StateNotifierProvider.family.autoDispose<PostDetailPageViewModel,PostDetailPageModel?, int>((ref, postId) {
  SessionUser sessionUser = ref.read(sessionProvider);
  return PostDetailPageViewModel(null)..notifyInit(postId, sessionUser.jwt!);});
