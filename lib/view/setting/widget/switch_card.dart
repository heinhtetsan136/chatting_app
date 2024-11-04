import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class SwitchCard<T> extends StatelessWidget {
  final String title;
  final T current, first, second;
  final Widget firstWidget, secondWidget;
  final Function(T)? onTap;

  const SwitchCard({
    super.key,
    required this.title,
    required this.current,
    required this.first,
    required this.second,
    required this.firstWidget,
    required this.secondWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textColor = theme.textTheme.bodyLarge?.color;

    final Map<T, Widget> data = {};

    data.addEntries([
      MapEntry(
          first,
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: firstWidget,
          )),
      MapEntry(
        second,
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: secondWidget,
        ),
      )
    ]);

    return Padding(
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
      ),
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: textColor,
          ),
        ),
        trailing: SizedBox(
          width: 60,
          child: AnimatedToggleSwitch.dual(
            onChanged: (value) {
              this.onTap?.call(value);
            },
            onTap: (t) {
              final v = t.tapped?.value;
              if (v != null) this.onTap?.call(v);
            },
            style: const ToggleStyle(
              backgroundColor: Color.fromRGBO(230, 230, 230, 1),
              indicatorColor: Colors.transparent,
            ),
            animationOffset: const Offset(10, 0),
            spacing: 8,
            indicatorSize: const Size(30, 30),
            borderWidth: 0,
            height: 35,
            second: second,
            current: current,
            first: first,
            iconBuilder: (i) {
              return data[i]!;
            },
          ),
        ),
      ),
    );
  }
}
