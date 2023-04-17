
import 'package:dio/dio.dart';
import 'package:flutter_riverpod_blog_start/core/constants/http.dart';
import 'package:flutter_riverpod_blog_start/dto/auth_request.dart';
import 'package:flutter_riverpod_blog_start/dto/response_dto.dart';
import 'package:logger/logger.dart';

import 'user.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._single();
  factory UserRepository() {
    return _instance;
  }
  UserRepository._single();

  Future<ResponseDTO> fetchJwtVerify() async {
    String? deviceJwt = await secureStorage.read(key: "jwt");
    Logger().d("토큰 : "+deviceJwt!);
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
        return responseDTO;
      }catch(e){
        Logger().d("에러 이유 : "+e.toString());
        return ResponseDTO();
      }
    }else{
      return ResponseDTO();
    }
  }

  Future<ResponseDTO> fetchJoin(JoinReqDTO joinReqDTO) async {
    Response response = await dio.post("/join", data: joinReqDTO.toJson());
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
    responseDTO.data = User.fromJson(responseDTO.data);
    return responseDTO;
  }

  Future<ResponseDTO> fetchLogin(LoginReqDTO loginReqDTO) async {
    // 1. 통신 시작
    Response response = await dio.post("/login", data: loginReqDTO.toJson());

    // 2. DTO 파싱
    ResponseDTO responseDTO = ResponseDTO.fromJson(response.data);
    responseDTO.data = User.fromJson(responseDTO.data);

    // 3. 토큰 받기
    final authorization = response.headers["authorization"];
    if(authorization != null){
      responseDTO.token = authorization.first;
    }
    return responseDTO;
  }
}