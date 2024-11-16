import 'dart:convert';
import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:submission_story_app/data/api/api_config.dart';
import 'package:http/http.dart' as http;
import 'package:submission_story_app/data/model/detail_story_model.dart';
import 'package:submission_story_app/data/model/list_story_model.dart';
import 'package:submission_story_app/data/model/request/register_request.dart';
import 'package:submission_story_app/data/model/response_model.dart';
import '../model/login_model.dart';
import '../model/request/login_request.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  final baseurl = ApiConfig.baseUrl;
  late String endPoint;

  /// login service with email and password
  Future<Either<String, LoginModel>> login(
      String email, String password) async {
    endPoint = "$baseurl/login";

    final response = await http.post(
      Uri.parse(endPoint),
      body: LoginRequest(email: email, password: password).toRawJson(),
      headers: {"Content-Type": "application/json"},
    );

    final Map<String, dynamic> data = json.decode(response.body);

    if (response.statusCode == 200) {
      return Right(LoginModel.fromJson(data));
    } else {
      return Left("${data['message']}");
    }
  }

  /// register service with email, name and password
  /// email must be unique
  /// password must be at least 8 characters
  Future<Either<String, ResponseModel>> register(
      String name, String email, String password) async {
    endPoint = "$baseurl/register";

    final response = await http.post(
      Uri.parse(endPoint),
      body:
          RegisterRequest(name: name, email: email, password: password).toRaw(),
      headers: {"Content-Type": "application/json"},
    );

    final Map<String, dynamic> data = json.decode(response.body);

    if (response.statusCode == 201) {
      return Right(ResponseModel.fromJson(data));
    } else {
      return Left("${data['message']}");
    }
  }

  /// fetch list of stories
  /// authorization with bearer token
  Future<ListStoryModel> fetchListStory(String token) async {
    endPoint = "$baseurl/stories";

    final response = await http.get(Uri.parse(endPoint), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return ListStoryModel.fromJson(data);
    } else {
      throw Exception("Failed to fetch list");
    }
  }

  /// fetch detail story with specific id
  /// authorization with bearer token
  Future<DetailStoryModel> fetchDetailStory(String token, String id) async {
    endPoint = "$baseurl/stories/$id";

    final response = await http.get(Uri.parse(endPoint), headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return DetailStoryModel.fromJson(data);
    } else {
      throw Exception("Failed to fetch data");
    }
  }

  /// post a new story
  /// photo must be a valid image file, max size 1MB
  /// latitude and longitude is optional
  /// authorization with bearer token
  Future<ResponseModel> postStory(String token, String description, File photo,
      double lat, double lon) async {
    endPoint = "$baseurl/stories";

    final request = http.MultipartRequest('post', Uri.parse(endPoint));

    request.fields['description'] = description;
    String fileName = photo.path.split('/').last;
    var fileExt = fileName.split('.').last;
    if (photo.path.isNotEmpty) {
      final imageFile = await http.MultipartFile.fromPath('photo', photo.path,
          filename: fileName, contentType: MediaType("image", fileExt));
      request.files.add(imageFile);
    }
    request.fields['lat'] = lat.toString();
    request.fields['lon'] = lon.toString();
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Authorization'] = 'Bearer $token';

    final response = await request.send();

    if (response.statusCode == 201) {
      final byteToString = await response.stream.bytesToString();

      final Map<String, dynamic> data = json.decode(byteToString);
      return ResponseModel.fromJson(data);
    } else {
      throw Exception("Failed to post data");
    }
  }
}
