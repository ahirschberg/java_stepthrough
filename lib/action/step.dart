import 'dart:async';
import 'package:code_steps/action/action_region.dart';

class Step {
  String explanation;
  String code;
  Set<ActionRegion> regions;

  Step(this.explanation, this.code, this.regions) {
    this.regions ??= new Set<ActionRegion>();
  }

  Map toJson() {
    print('toJson called');
    return {'TODO': 'FIXME'};
  }

  static Step deserialize(Map data) {
    if (data['regions'] == null || data['code'] == null || data['explanation'] == null) {
      print('malformed step: ${data.keys}');
    }
    Set<ActionRegion> regions = (data['regions'] as List)
        .map((data_region) => ActionRegion.deserialize(data_region))
        .toSet();
    return new Step(data['explanation'], data['code'], regions);
  }
}
