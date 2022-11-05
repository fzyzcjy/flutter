// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class NearFullTimePage extends StatefulWidget {
  const NearFullTimePage({super.key});

  @override
  State<NearFullTimePage> createState() => _NearFullTimePageState();
}

class _NearFullTimePageState extends State<NearFullTimePage> {
  int dummy = 0;

  @override
  void initState() {
    super.initState();
    print(
        'NearFullTimePage initState dummy=$dummy'); // avoid it from being optimized

    // num isolate should not be too many, o/w seems to make main thread
    // cannot be executed (?)
    // https://github.com/fzyzcjy/flutter_smooth/issues/163#issuecomment-1304381360
    for (int i = 0; i < 3; i++) {
      print('NearFullTimePage setup isolates #$i');
      compute(_heavyFunction, i);
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('NearFullTimePage build');

    () async {
      await SchedulerBinding.instance.endOfFrame;
      if (mounted) {
        setState(() {});
      }
    }();

    // mimic when build/layout is near deadline
    final Stopwatch stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < const Duration(microseconds: 14500 + 16667 * 5)) {
      dummy++;
    }
    stopwatch.stop();

    return const SizedBox();
  }
}

// https://github.com/fzyzcjy/flutter_smooth/issues/163#issuecomment-1304379821
void _heavyFunction(int index) {
  print('_heavyFunction start index=$index');
  int dummy = 0;
  for (int i = 0; i < 1000000000; ++i) {
    dummy += index.hashCode * i;
  }
  print(
      '_heavyFunction end index=$index dummy=$dummy'); // avoid it from being optimized
}
