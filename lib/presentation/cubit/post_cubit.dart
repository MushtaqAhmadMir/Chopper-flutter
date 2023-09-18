import 'package:appflyer_poc/domain/models/post_model.dart';
import 'package:appflyer_poc/domain/usecase/post_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_state.dart';
part 'post_cubit.freezed.dart';

enum PostState { initial, loading, loaded, error }

class PostCubit extends Cubit<PostState> {
  PostCubit(this._getPostsUseCase) : super(PostState.initial);
  final GetPostsUseCase _getPostsUseCase;
  List<PostModel> posts = [];

  void fetchPosts() async {
    emit(PostState.loading);
    try {
      posts = await _getPostsUseCase.execute();
      emit(PostState.loaded);
    } catch (e) {
      emit(PostState.error);
    }
  }
}
