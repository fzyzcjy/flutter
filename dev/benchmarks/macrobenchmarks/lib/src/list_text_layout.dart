// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class ColumnOfText extends StatefulWidget {
  const ColumnOfText({super.key});

  @override
  State<ColumnOfText> createState() => ColumnOfTextState();
}

class ColumnOfTextState extends State<ColumnOfText> with SingleTickerProviderStateMixin {
  bool _showText = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _showText = !_showText;
          });
          _controller
            ..reset()
            ..forward();
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: OverflowBox(
        alignment: Alignment.topCenter,
        maxHeight: double.infinity,
        child: !_showText
            ? Container()
            : Column(
                children: List<Widget>.generate(30, (int index) {
                  // hack: use [LayoutBuilder] to put all build time into layout
                  // time, since we are prototyping "slow layout" problem
                  return LayoutBuilder(
                    builder: (_, __) => SizedBox(
                      height: 24,
                      child: ListTile(
                        dense: true,
                        visualDensity: VisualDensity.compact,
                        leading: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircleAvatar(
                            child: Text('G$index'),
                          ),
                        ),
                        title: Text(
                          'Foo contact from $index-th local contact' * 5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 5),
                        ),
                        subtitle: Text('+91 88888 8800$index'),
                      ),
                    ),
                  );
                }),
              ),
      ),
    );
  }
}
