import 'package:appflyer_poc/domain/usecase/post_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:appflyer_poc/presentation/cubit/post_cubit.dart';
import 'package:get_it/get_it.dart';

class PostListScreen extends StatelessWidget {
  final GetPostsUseCase
      getPostsUseCase; // Create an instance of GetPostsUseCase

  PostListScreen(this.getPostsUseCase, {super.key});
  final postCubit = GetIt.instance<PostCubit>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return postCubit;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Post List'),
        ),
        body: BlocConsumer<PostCubit, PostState>(
          listener: (context, state) {
            if (state == PostState.error) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Error fetching posts'),
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<PostCubit>();

            if (state == PostState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state == PostState.loaded) {
              return ListView.builder(
                itemCount: cubit.posts.length,
                itemBuilder: (context, index) {
                  final post = cubit.posts[index];
                  return ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.body),
                  );
                },
              );
            } else {
              return const Text('No data available');
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: postCubit.fetchPosts,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
