import 'package:dio/dio.dart';
import 'package:flutter_riverpod_blog_start/core/constants/http.dart';
import 'package:flutter_riverpod_blog_start/dto/user_request.dart';
import 'package:flutter_riverpod_blog_start/dto/response_dto.dart';
import 'package:flutter_riverpod_blog_start/provider/session_provider.dart';
import 'package:logger/logger.dart';

import 'user.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._single();

  factory UserRepository() {
    return _instance;
  }

  UserRepository._single();

  Future<SessionUser> fetchJwtVerify() async {
    SessionUser sessionUser = SessionUser();
    String? deviceJwt = await secureStorage.read(key: "jwt");
    if(deviceJwt != null){
      try{
        Response response = await dio.get("/jwtToken", options: Options(
            headers: {
              "Authorization" : "$deviceJwt"
            }
        ));
        ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
        responseDTO.token = deviceJwt;
        responseDTO.data = User.fromJson(responseDTO.data);

        if(responseDTO.code == 1){
          sessionUser.loginSuccess(responseDTO.data, responseDTO.token!);
        }else{
          sessionUser.logoutSuccess();
        }
        return sessionUser;
      }catch(e){
        Logger().d("에러 이유 : "+e.toString());
        sessionUser.logoutSuccess();
        return sessionUser;
      }
    }else{
      sessionUser.logoutSuccess();
      return sessionUser;
    }
  }

Future<ResponseDTO> fetchJoin(JoinReqDTO joinReqDTO) async {
  try {
    Response response = await dio.post("/join", data: joinReqDTO.toJson());
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
    responseDTO.data = User.fromJson(responseDTO.data);
    return responseDTO;
  } catch (e) {
    return ResponseDTO(code: -1, msg: "username 중복");
  }
}

Future<ResponseDTO> fetchLogin(LoginReqDTO loginReqDTO) async {
    try{
      // 1. 통신 시작
      Response response = await dio.post("/login", data: loginReqDTO.toJson());

      // 2. DTO 파싱
      ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
      responseDTO.data = User.fromJson(responseDTO.data);

      // 3. 토큰 받기
      // headers가 배열을 리턴하기 때문에 first로 찾아와야함
      final authorization = response.headers["authorization"];
      if (authorization != null) {
        responseDTO.token = authorization.first;
      }
      return responseDTO;
    } catch (e) {
      return ResponseDTO(code: -1, msg: "유저네임 혹은 비번이 틀렸습니다");
    }
}}