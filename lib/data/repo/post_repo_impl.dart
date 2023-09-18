import 'package:appflyer_poc/data/service/post_service.dart';
import 'package:appflyer_poc/domain/models/post_model.dart';
import 'package:appflyer_poc/domain/repo/post_repo.dart';


class PostRepositoryImplementation extends PostRepository {
  final PostService _postService;

  PostRepositoryImplementation(this._postService);

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await _postService.getPosts();
    print('respone$response');
    if (response.isSuccessful) {
      final List<Map<String, dynamic>> postMaps = response.body!;
      final List<PostModel> posts =
          postMaps.map((map) => PostModel.fromJson(map)).toList();
      return posts;
    } else {
      throw Exception('Failed to fetch posts');
    }
  }
}
