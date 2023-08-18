import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'model/builder.dart';
import 'model/choice_config.dart';
import 'model/choice_item.dart';
import 'model/choice_group.dart';
import 'choices_list.dart';
import './state/changes.dart';
import 'scrollbar.dart';
import 'text.dart';

/// grouped choices list widget
class S2ChoicesGrouped<T> extends StatelessWidget {

  /// list of string of group name
  final List<String> groupKeys;

  /// item builder of choice widget
  final Widget Function(S2Choice<T>) itemBuilder;

  /// list of item of choice data
  final List<S2Choice<T>> items;

  /// choices configuration
  final S2ChoiceConfig config;

  /// collection of builder widget
  final S2Builder<T> builder;

  /// current filter query
  final String query;

  final bool isMulti;

  covariant S2Changes<T> changes;
  /// default constructor
  S2ChoicesGrouped({
    Key key,
    @required this.groupKeys,
    @required this.itemBuilder,
    @required this.items,
    @required this.config,
    @required this.builder,
    @required this.query,
    @required this.isMulti,
    @required this.changes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: GlowingOverscrollIndicator(
          axisDirection: AxisDirection.down,
          color: config.overscrollColor ?? config.style?.activeColor,
          child: ListView.builder(
            itemCount: groupKeys.length,
            itemBuilder: (BuildContext context, int i) {
              final String groupKey = groupKeys[i];
              final List<S2Choice<T>> groupItems = _groupItems(groupKey);
              final S2ChoiceGroup group = S2ChoiceGroup(
                name: groupKey,
                count: groupItems.length,
                style: config.headerStyle,
              );
              bool isGroupEnabled = true;
              for (final item in groupItems) {
                if (!changes.contains(item.value)) {
                  isGroupEnabled = false;
                  break;
                }
              }
              // final isGroupEnabled = groupItems.forEach(() =>  ) == null;
              print(groupItems.map((e) => e.selected));
              print(isGroupEnabled);
              final Widget groupHeader = builder.choiceHeader?.call(context, group, query)
                ?? S2ChoicesGroupedHeader(
                    group: group,
                    query: query,
                    value: isGroupEnabled,
                    isMutli: isMulti,
                    onChanged: (val) {
                      groupItems.forEach((element) {
                        changes.commit(element.value, selected: val);
                      });
                    },
                  );
              final Widget groupChoices = S2ChoicesList<T>(
                config: config,
                builder: builder,
                items: groupItems,
                itemBuilder: itemBuilder,
              );
              return builder.choiceGroup?.call(context, groupHeader, groupChoices)
                ?? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    groupHeader,
                    groupChoices,
                  ],
                );
            },
          ),
        ),
      ),
    );
  }

  /// return a list of group items
  List<S2Choice<T>> _groupItems(String key) {
    return items.where((S2Choice<T> item) => item.group == key).toList();
  }
}

/// choice group header widget
class S2ChoicesGroupedHeader extends StatelessWidget {

  /// choices group data
  final S2ChoiceGroup group;

  /// current filter query
  final String query;

  final bool value;
  final void Function(bool) onChanged;

  final bool isMutli;

  /// default constructor
  S2ChoicesGroupedHeader({
    Key key,
    this.group,
    this.query,
    this.value,
    this.onChanged,
    this.isMutli,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = DefaultTextStyle.of(context).style;
    return Container(
      height: group.style.height,
      color: group.style.backgroundColor,
      padding: group.style.padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          S2Text(
            text: group.name,
            highlight: query,
            style: textStyle.merge(group.style.textStyle),
            highlightColor: group.style.highlightColor ?? Color(0xFFFFF176),
          ),
          const Spacer(),
          if (isMutli)
            Checkbox(
              value: value,
              onChanged: onChanged,
            ),
          Text(
            group.count.toString(),
            style: textStyle.merge(group.style.textStyle),
          ),
        ],
      ),
    );
  }
}