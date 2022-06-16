/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time:  2019-09-06 23:18
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PagedLocalizations {
  final Locale locale;

  PagedLocalizations(this.locale);

  Map<String, PagedString> values = {
    'en': EnPagedString(),
    'zh': ChPagedString(),
  };

  PagedString? get currentLocalization {
    if (values.containsKey(locale.languageCode)) {
      return values[locale.languageCode];
    }
    return values["en"];
  }

  static const PagedLocalizationsDelegate delegate = PagedLocalizationsDelegate();

  static PagedLocalizations? of(BuildContext context) {
    return Localizations.of(context, PagedLocalizations);
  }
}

class PagedLocalizationsDelegate extends LocalizationsDelegate<PagedLocalizations> {
  const PagedLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return [
      'en',
      'zh',
    ].contains(locale.languageCode);
  }

  @override
  Future<PagedLocalizations> load(Locale locale) {
    return SynchronousFuture<PagedLocalizations>(PagedLocalizations(locale));
  }

  @override
  bool shouldReload(LocalizationsDelegate<PagedLocalizations> old) {
    return false;
  }
}

abstract class PagedString {
  String get tryAgain;

  String get firstPageExceptionTitle;

  String get firstPageExceptionMessage;

  String get newPageError;

  String get noItemsFoundTitle;

  String get noMoreItems;

  String get loading;
}

/// Chinese
class ChPagedString implements PagedString {
  @override
  String get firstPageExceptionMessage => '请稍候再试';

  @override
  String get firstPageExceptionTitle => '发生错误，加载失败';

  @override
  String get newPageError => '加载失败，点击重试';

  @override
  String get noItemsFoundTitle => '无数据';

  @override
  String get tryAgain => '再试一次';

  @override
  String get noMoreItems => '没有更多数据了';

  @override
  String get loading => '加载中…';
}

/// English
class EnPagedString implements PagedString {
  @override
  String get firstPageExceptionMessage => 'Please try again later';

  @override
  String get firstPageExceptionTitle => 'Something went wrong,Load Failed';

  @override
  String get newPageError => 'Load Failed,Tap to try again';

  @override
  String get noItemsFoundTitle => 'No items found';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get noMoreItems => 'No more data';

  @override
  String get loading => 'Loading…';
}
