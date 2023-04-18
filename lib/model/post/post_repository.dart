import 'package:dio/dio.dart';
import 'package:flutter_riverpod_blog_start/core/constants/http.dart';
import 'package:flutter_riverpod_blog_start/dto/user_request.dart';
import 'package:flutter_riverpod_blog_start/dto/response_dto.dart';
import 'package:flutter_riverpod_blog_start/model/post/post.dart';
import 'package:flutter_riverpod_blog_start/model/user/user.dart';
import 'package:flutter_riverpod_blog_start/provider/session_provider.dart';
import 'package:logger/logger.dart';


class PostRepository {
  static final PostRepository _instance = PostRepository._single();

  factory PostRepository() {
    return _instance;
  }

  PostRepository._single();

  //dio interceptor 사용하면 편함
  Future<ResponseDTO> fetchPostList(String jwt) async {
    try {
      Response response = await dio.get("/post", options: Options(headers: {
        "Authorization": "$jwt"
      }));

      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      // 컬렉션 파싱하는 방법
      //responseDTO.data는 dynamic<dynamic> 상태?
      List<dynamic> mapList = responseDTO.data;
      List<Post> postList = mapList.map((e) => Post.fromJson(e)).toList();
      responseDTO.data = postList;
      return responseDTO;
    } catch (e) {
      return ResponseDTO(code: -1, msg: "실패 : ${e}");
    }
  }
}