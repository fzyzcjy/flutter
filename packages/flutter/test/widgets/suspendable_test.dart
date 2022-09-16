import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('simple', (WidgetTester tester) async {
    SuspendableCoordinator.instance.pseudoRemainTime = 10;

    await tester.pumpWidget(const ColumnOfText());

    for (int i = 0; i < 5; ++i) {
      SuspendableCoordinator.instance.pseudoRemainTime = 10;
      await tester.pump();
    }
  });
}

// copied from: [list_text_layout.dart]
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
            // NOTE ADD Suspendable
            return Suspendable(
              // hack: use [LayoutBuilder] to put all build time into layout
              // time, since we are prototyping "slow layout" problem
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
    );
  }
}
