// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';

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
    print(dummy); // avoid it from being optimized
  }

  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance.addPostFrameCallback((Duration timeStamp) {
      if (mounted) {
        setState(() {});
      }
    });

    // mimic when build/layout is near deadline
    final Stopwatch stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < const Duration(milliseconds: 15)) {
      dummy++;
    }
    stopwatch.stop();

    return const SizedBox();
  }
}
