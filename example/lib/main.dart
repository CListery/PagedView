import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:paged_view/paged.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        PagedLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('zh', 'CN')],
      locale: const Locale('zh', 'CN'),
      localeResolutionCallback:
          (Locale? locale, Iterable<Locale> supportedLocales) {
        print("change language");
        return locale;
      },
      localeListResolutionCallback: (locales, supportLocales) {
        print('当前语言环境: $locales');
      },
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  // final PagedConfigureController controller = Get.put(PagedConfigureController());

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: buildFastLoader(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  final _pageSize = 20;
  var count = 0;

  PagedView<int, String> buildFastLoader() {
    // return FastLoader<int, String>.grid(
    //   firstPageKey: 1,
    //   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //     childAspectRatio: 100 / 150,
    //     crossAxisSpacing: 10,
    //     mainAxisSpacing: 10,
    //     crossAxisCount: 5,
    //   ),
    //   builderDelegate: PagedChildBuilderDelegate(
    //     itemBuilder: (
    //       BuildContext context,
    //       String item,
    //       int index,
    //     ) {
    //       return Container(
    //         color: Colors.grey.shade200,
    //         child: const Icon(
    //           Icons.image,
    //           size: 40,
    //         ),
    //       );
    //     },
    //   ),
    //   onPullDown: (controller) async {
    //     print('onRefresh');
    //     // await Future.delayed(const Duration(seconds: 5));
    //   },
    //   onPageRequest: (pageKey, controller) async {
    //     print('onPageRequest: $pageKey');
    //     // _fetchPage(pageKey, controller);
    //     return await Future.delayed(const Duration(seconds: 2), () {
    //       // throw Exception('eeeee');
    //       if (count >= 2) {
    //         // throw Exception('eeeee');
    //         return null;
    //       }
    //       count++;
    //       return List.generate(20, (index) => '$index');
    //     });
    //   },
    //   onNextPageKey: (currentPageKey, currentSize, appendSize, controller) {
    //     print('onNextPageKey: $currentPageKey $currentSize $appendSize');
    //     if (appendSize >= _pageSize) {
    //       return currentPageKey += 1;
    //     }
    //   },
    // );

    return PagedView<int, String>.list(
      firstPageKey: 1,
      builderDelegate: PagedChildBuilderDelegate(itemBuilder: (
              BuildContext context,
              String item,
              int index,
              ) {
        return Text(item);
      }),
      separatorBuilder: (ctx, index) => const Divider(),
      onPullDown: (controller) async {
        print('onRefresh');
        // await Future.delayed(const Duration(seconds: 5));
      },
      onPageRequest: (pageKey, controller) async {
        print('onPageRequest: $pageKey');
        // _fetchPage(pageKey, controller);
        return await Future.delayed(const Duration(seconds: 2), () {
          // throw Exception('eeeee');
          if (count >= 2) {
            // throw Exception('eeeee');
            return null;
          }
          count++;
          return List.generate(20, (index) => '$index');
        });
      },
      onNextPageKey: (currentPageKey, currentSize, appendSize, controller) {
        print('onNextPageKey: $currentPageKey $currentSize $appendSize');
        if (appendSize >= _pageSize) {
          return currentPageKey += 1;
        }
      },
    );
  }
}
