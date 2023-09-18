import 'package:appflyer_poc/data/repo/post_repo_impl.dart';
import 'package:appflyer_poc/data/service/post_service.dart';
import 'package:appflyer_poc/domain/repo/post_repo.dart';
import 'package:appflyer_poc/domain/usecase/post_usecase.dart';
import 'package:appflyer_poc/presentation/cubit/post_cubit.dart';
import 'package:appflyer_poc/presentation/post_screen.dart';
import 'package:appsflyer_sdk/appsflyer_sdk.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
void main() {
  GetIt getIt = GetIt.instance;

  // Register your dependencies
  getIt.registerSingleton<PostService>(PostService.create());
  getIt.registerSingleton<PostRepositoryImplementation>(
      PostRepositoryImplementation(getIt<PostService>()));
  getIt.registerSingleton<GetPostsUseCase>(
      GetPostsUseCase(getIt<PostRepositoryImplementation>()));
  getIt.registerFactory<PostCubit>(() => PostCubit(getIt<GetPostsUseCase>()));
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late AppsflyerSdk _appsflyerSdk;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppsFlyerOptions appsFlyerOptions = AppsFlyerOptions(
      afDevKey: '2T8Ma6wcCyvifhL55KhCRh',
      showDebug: true,
      timeToWaitForATTUserAuthorization: 50, // for iOS 14.5
      // Optional field
      disableAdvertisingIdentifier: false, // Optional field
      disableCollectASA: false,
    ); // Optional field
    _appsflyerSdk = AppsflyerSdk(appsFlyerOptions);
    _appsflyerSdk.onAppOpenAttribution((res) {
      print("onAppOpenAttribution res: $res");
      // setState(() {
      //   _deepLinkData = res;
      // });
    });
    _appsflyerSdk.onInstallConversionData((res) {
      print("onInstallConversionData res: $res");
      // setState(() {
      //   _gcd = res;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    final postService = PostService.create();
    final postRepository = PostRepositoryImplementation(
        postService); // Create a concrete PostRepository instance
    final getPostsUseCase = GetPostsUseCase(postRepository);
    return MaterialApp(
      title: 'Flutter Demo',
      home: Scaffold(
          appBar: AppBar(title: const Text('App Flyer')),
          body:
              PostListScreen(getPostsUseCase) //appFlyerInit() //appFlyerInit(),
          ),
    );
  }

  FutureBuilder<dynamic> appFlyerInit() {
    return FutureBuilder(
      future: _appsflyerSdk.initSdk(
          registerConversionDataCallback: true,
          registerOnAppOpenAttributionCallback: false,
          registerOnDeepLinkingCallback: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            return Column(
              children: [
                const Text(
                  'Done intializing',
                ),
                ElevatedButton(
                  onPressed: () {
                    logEvent('eventName', {'Name': 'Mushtaq'});
                  },
                  child: const Text('Click to add event '),
                )
              ],
            );
          } else {
            return const Center(child: Text("Error initializing sdk"));
          }
        }
      },
    );
  }

  Future logEvent(String eventName, Map eventValues) {
    return _appsflyerSdk.logEvent(eventName, eventValues);
  }
}
//