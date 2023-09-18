import 'package:chopper/chopper.dart';

part 'post_service.chopper.dart';

@ChopperApi(baseUrl: '/posts')
abstract class PostService extends ChopperService {
  @Get()
  Future<Response<List<Map<String, dynamic>>>> getPosts();

  static PostService create() {
    final client = ChopperClient(
      baseUrl: Uri.parse('https://jsonplaceholder.typicode.com'),
      services: [
        _$PostService(),
      ],
      converter: const JsonConverter(),
    );
    return _$PostService(client);
  }
}
