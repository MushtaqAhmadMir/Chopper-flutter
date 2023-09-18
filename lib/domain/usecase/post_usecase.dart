import 'package:appflyer_poc/domain/models/post_model.dart';
import 'package:appflyer_poc/domain/repo/post_repo.dart';


class GetPostsUseCase {
  final PostRepository _postRepository;

  GetPostsUseCase(this._postRepository);

  Future<List<PostModel>> execute() {
    return _postRepository.getPosts();
  }
}
