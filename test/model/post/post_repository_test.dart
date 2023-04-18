
import 'package:dio/dio.dart';
import 'package:flutter_riverpod_blog_start/dto/response_dto.dart';
import 'package:flutter_riverpod_blog_start/model/post/post.dart';
import 'package:flutter_riverpod_blog_start/model/post/post_repository.dart';
import 'package:flutter_riverpod_blog_start/model/user/user.dart';

final dio = Dio(BaseOptions(
  baseUrl: "http://192.168.200.155:8080",
  contentType: "application/json; charset=utf-8",
));

void main() async {
  await fetchPostList_test();
  // await fetchJoin_test();
}

Future<void> fetchPostList_test() async {
  String jwt = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJjb3PthqDtgbAiLCJpZCI6MSwiZXhwIjoxNjgyNTgzODA0fQ.KpL5GBi_-qDEJtbxUwkmKn7mkWWqwyScV3jI1DiCRFMgDRGOkT0YOsfTOJUddevnZ_Ge50hOydCeNGU8OK5Eg";
  ResponseDTO responseDTO = await PostRepository().fetchPostList(jwt);
  print(responseDTO.code);
  print(responseDTO.msg);
  List<Post> postList = responseDTO.data;
  postList.forEach((element) { print(element.title);});
}
