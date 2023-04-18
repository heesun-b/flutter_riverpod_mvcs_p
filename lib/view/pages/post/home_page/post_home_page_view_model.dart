

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_blog_start/dto/response_dto.dart';
import 'package:flutter_riverpod_blog_start/model/post/post.dart';
import 'package:flutter_riverpod_blog_start/model/post/post_repository.dart';
import 'package:flutter_riverpod_blog_start/provider/session_provider.dart';

//창고
class PostHomePageViewModel extends StateNotifier<PostHomePageModel?>{
  PostHomePageViewModel(super.state);


//action
  void init(String jwt) async {
    ResponseDTO responseDTO = await PostRepository().fetchPostList(jwt);
    state = PostHomePageModel(posts: responseDTO.data);
  }

  void add(Post post) {
    List<Post> posts = state!.posts;
    List<Post> newPosts = [...posts, post];
    state = PostHomePageModel(posts: newPosts);
  }

  void remove(int id) {
    List<Post> posts = state!.posts;
    List<Post> newPosts = posts.where((element) => element.id != id).toList();
    state = PostHomePageModel(posts: newPosts);
  }

  void update(Post post) {
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
final postHomePageProvider
= StateNotifierProvider<PostHomePageViewModel,PostHomePageModel?>((ref) {
  SessionUser sessionUser = ref.read(sessionProvider);
  return PostHomePageViewModel(null)..init(sessionUser.jwt!);});
