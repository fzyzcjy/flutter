import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('simple', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: OverflowBox(
        alignment: Alignment.topCenter,
        maxHeight: double.infinity,
        child: Column(
          children: List<Widget>.generate(30, (int index) {
            return Suspendable(
              debugName: 'item-$index',
              child: LayoutBuilder(
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
              ),
            );
          }),
        ),
      ),
    ));

    await tester.pump();
    await tester.pump();
    await tester.pump();
  });
}
