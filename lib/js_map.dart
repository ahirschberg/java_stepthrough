// Wraps JSObjectImpl to allow key-value access, not available in js.dart 0.6.1
// credit to @matanlurey and @a14n for helping me with this:
//    https://github.com/dart-lang/sdk/issues/28194#issuecomment-269051789

@JS()
library jsmap;

import 'dart:collection';

import 'dart:developer';
import 'dart:js';
import 'package:js/js.dart';
import 'package:js/js_util.dart';

class JsMap<V> extends MapMixin<String, dynamic> {
  @JS('Object.keys')
  external static List<String> _getKeys(jsObject);

  var _jsObject;

  JsMap(this._jsObject);

  @override
  V operator [](Object key) {
    dynamic prop = getProperty(_jsObject, key.toString());

    // if the map is not generic
    if (V == dynamic) prop = new JsMap(prop);

    return prop;
  }

  @override
  operator []=(String key, dynamic value) => setProperty(_jsObject, key.toString(), value);

  @override
  remove(Object key) {
    throw "Not implemented yet for JsMap, sorry";
//    final value = this[key];
//    deleteProperty(_jsObject, key);
//    return value;
  }

  @override
  Iterable<String> get keys => _getKeys(_jsObject);

  @override
  bool containsKey(Object key) => hasProperty(_jsObject, key);

  @override
  void clear() => Maps.clear(this);
}
