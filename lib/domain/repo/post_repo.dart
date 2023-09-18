import 'package:appflyer_poc/domain/models/post_model.dart';

abstract class PostRepository {
  Future<List<PostModel>> getPosts();
}
