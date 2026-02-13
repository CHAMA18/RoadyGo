// ignore_for_file: unused_element

import 'dart:convert';
import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

class RideStatisticsCall {
  static Future<ApiCallResponse> call({
    String? entry2015812078 = '',
    String? entry1394646206 = '',
    String? entry950079055 = '',
    String? entry2001325259 = '',
    String? entry936029703 = '',
    String? entry792818010 = '',
    String? entry470321756 = '',
    String? entry1486521713 = '',
    String? entry1966883731 = '',
    String? entry1208328789 = '',
    String? entry465293445 = '',
    String? entry800518538 = '',
    String? entry1655301668 = '',
    String? entry1758107006 = '',
    String? entry659596845 = '',
    String? entry1621449952 = '',
  }) async {
    return ApiManager.instance.makeApiCall(
      callName: 'RideStatistics',
      apiUrl:
          'https://docs.google.com/forms/d/e/1FAIpQLSf7rid0vI6b1s09GHIlM04K2bQsF_6dVWxwQzviqOtKNE6aAQ/formResponse',
      callType: ApiCallType.GET,
      headers: {},
      params: {
        'entry.2015812078': entry2015812078,
        'entry.950079055': entry950079055,
        'entry.1394646206': entry1394646206,
        'entry.2001325259': entry2001325259,
        'entry.936029703': entry936029703,
        'entry.792818010': entry792818010,
        'entry.470321756': entry470321756,
        'entry.1486521713': entry1486521713,
        'entry.1966883731': entry1966883731,
        'entry.1208328789': entry1208328789,
        'entry.465293445': entry465293445,
        'entry.800518538': entry800518538,
        'entry.1655301668': entry1655301668,
        'entry.1758107006': entry1758107006,
        'entry.659596845': entry659596845,
        'entry.1621449952': entry1621449952,
      },
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }
}

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
