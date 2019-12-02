import 'dart:async';

import 'dio_client.dart';
import 'post.dart';
import 'post_list.dart';

class PostApi {
  // dio instance
  final DioClient _dioClient;

  // rest-client instance
//  final RestClient _restClient;

  // injecting dio instance
//  PostApi(this._dioClient, this._restClient);
  PostApi(this._dioClient);

  /// Returns list of post in response
  Future<PostsList> getPosts() async {
    try {
      final res = await _dioClient.get("/posts");
      return PostsList.fromJson(res);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }

  Future<PostsList> getPostsByPage(int page ,[int limit = 10]) async =>
    PostsList(_slice((await getPosts()).posts, page * limit, page * limit + limit));

  Future<Post> getPost(int id) async {
    try {
      final res = await _dioClient.get("/posts/$id");
      return Post.fromMap(res);
    } catch (e) {
      print(e.toString());
      throw e;
    }
  }
  /*
  * List slice(List list, int begin, [int end]) =>
    list.getRange(begin, end == null ? list.length : end < 0 ? list.length + end : end).toList();
  * */
}


List _slice(List list, int begin, [int end]) =>
  list.getRange(begin, end == null ? list.length : end < 0 ? list.length + end : end).toList();