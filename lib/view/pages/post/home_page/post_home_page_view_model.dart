

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_blog_start/dto/response_dto.dart';
import 'package:flutter_riverpod_blog_start/model/post/post.dart';
import 'package:flutter_riverpod_blog_start/model/post/post_repository.dart';
import 'package:flutter_riverpod_blog_start/provider/session_provider.dart';

//창고
class PostHomePageViewModel extends StateNotifier<PostHomePageModel?>{
  PostHomePageViewModel(super.state);

//action
  // 초기화는 notify 붙이기
  void notifyInit(String jwt) async {
    ResponseDTO responseDTO = await PostRepository().fetchPostList(jwt);
    state = PostHomePageModel(posts: responseDTO.data);
  }

  void notifyAdd(Post post) {
    List<Post> posts = state!.posts;
    List<Post> newPosts = [...posts, post];
    state = PostHomePageModel(posts: newPosts);
  }

  void notifyRemove(int id) {
    List<Post> posts = state!.posts;
    List<Post> newPosts = posts.where((element) => element.id != id).toList();
    state = PostHomePageModel(posts: newPosts);
  }

  void notifyUpdate(Post post) {
    List<Post> posts = state!.posts;
    List<Post> newPosts = posts.map((e) => e.id == post.id ? post : e).toList();
    state = PostHomePageModel(posts: newPosts);
  }
}

//데이터
class PostHomePageModel {
  List<Post> posts;
  PostHomePageModel({required this.posts});
}

//창고 관리자 - 페이지 최초 로딩 시 init(초기화) 바로 실행 = controller를 때리지 않기 때문
// autoDispose = 페이지가 pop될 때 해당 페이지에 대한 데이터를 자동으로 삭제시켜줌 
// - 이렇게 해주지 않으면 필요없는 데이터가 계속 누적
final postHomePageProvider
= StateNotifierProvider.autoDispose<PostHomePageViewModel,PostHomePageModel?>((ref) {
  SessionUser sessionUser = ref.read(sessionProvider);
  return PostHomePageViewModel(null)..notifyInit(sessionUser.jwt!);});
