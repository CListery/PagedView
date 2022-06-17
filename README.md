# PagedView

auto split-page manager and pull-down/pull-up for flutter platform

## Use

- dependencies
  ```yaml
  dependencies:
    paged_view:
      git:
        url: https://github.com/CListery/PagedView.git
        ref: 0.0.3
  ```

- configure
  ```dart
  void main() {
    runApp(const MyApp());
  }
  
  class MyApp extends StatelessWidget {
    const MyApp({Key? key}) : super(key: key);
  
    final PagedConfigureController controller = Get.put(PagedConfigureController());
  
    @override
    Widget build(BuildContext context) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
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
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      );
    }
  }
  ```

- list
  ```dart
  Widget list(){
    return PagedView<int, String>.list(
      firstPageKey: 1,
      builderDelegate: PagedChildBuilderDelegate(itemBuilder: (
              BuildContext context,
              String item,
              int index) {
        return Text(item);
      }),
      separatorBuilder: (ctx, index) => const Divider(),
      onPullDown: (controller) async {
        // await Future.delayed(const Duration(seconds: 5));
      },
      onPageRequest: (pageKey, controller) async {
        return await Future.delayed(const Duration(seconds: 2), () {
          return List.generate(20, (index) => '$index');
        });
      },
      onNextPageKey: (currentPageKey, currentSize, appendSize, controller) {
        if (appendSize >= _pageSize) {
          return currentPageKey += 1;
        }
      },
    );
  }
  ```

- grid
  ```dart
  Widget grid(){
    return FastLoader<int, String>.grid(
      firstPageKey: 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        childAspectRatio: 100 / 150,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 5,
      ),
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (
          BuildContext context,
          String item,
          int index,
        ) {
          return Container(
            color: Colors.grey.shade200,
            child: const Icon(
              Icons.image,
              size: 40,
            ),
          );
        },
      ),
      onPullDown: (controller) async {
        // await Future.delayed(const Duration(seconds: 5));
      },
      onPageRequest: (pageKey, controller) async {
        return await Future.delayed(const Duration(seconds: 2), () {
          return List.generate(20, (index) => '$index');
        });
      },
      onNextPageKey: (currentPageKey, currentSize, appendSize, controller) {
        if (appendSize >= _pageSize) {
          return currentPageKey += 1;
        }
      },
    );
  }
  ```

## License ##

    MIT License
    
    Copyright (c) 2022 CYH
    
    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:
    
    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.
    
    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.