import 'package:flutter/material.dart';
import 'package:smart_select/smart_select.dart';
import '../widgets/icon_badge.dart';
import '../choices.dart' as choices;

class FeaturesModalHeader extends StatefulWidget {
  @override
  _FeaturesModalHeaderState createState() => _FeaturesModalHeaderState();
}

class _FeaturesModalHeaderState extends State<FeaturesModalHeader> {

  List<String> _month = ['apr'];
  String _framework = 'flu';
  List<String> _hero = ['bat', 'spi'];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 7),
        SmartSelect<String>.multiple(
          title: 'Month',
          value: _month,
          onChange: (state) => setState(() => _month = state.value),
          choiceItems: choices.months,
          choiceStyle: S2ChoiceStyle(
            activeColor: Colors.red
          ),
          modalFilter: true,
          modalHeaderStyle: const S2ModalHeaderStyle(
            elevation: 4,
            centerTitle: true,
            backgroundColor: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconTheme: IconThemeData(color: Colors.white),
            actionsIconTheme: IconThemeData(color: Colors.white),
          ),
          tileBuilder: (context, state) {
            return S2Tile.fromState(
              state,
              isTwoLine: true,
              leading: IconBadge(
                icon: const Icon(Icons.calendar_today),
                counter: state.value.length,
              ),
            );
          }
        ),
        const Divider(indent: 20),
        SmartSelect<String>.single(
          title: 'Frameworks',
          value: _framework,
          onChange: (state) => setState(() => _framework = state.value),
          choiceItems: choices.frameworks,
          modalConfig: S2ModalConfig(
            type: S2ModalType.popupDialog,
            headerStyle: S2ModalHeaderStyle(
              backgroundColor: Colors.blueGrey[50],
              centerTitle: true,
              elevation: 0,
            ),
          ),
          tileBuilder: (context, state) {
            return S2Tile.fromState(
              state,
              isTwoLine: true,
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(
                  '${state.valueDisplay[0]}',
                  style: TextStyle(color: Colors.white)
                ),
              ),
            );
          }
        ),
        const Divider(indent: 20),
        SmartSelect<String>.multiple(
          title: 'Super Hero',
          value: _hero,
          onChange: (state) => setState(() => _hero = state.value),
          choiceItems: choices.heroes,
          modalType: S2ModalType.bottomSheet,
          modalFilter: true,
          modalHeaderStyle: const S2ModalHeaderStyle(
            centerTitle: true,
          ),
          tileBuilder: (context, state) {
            return S2Tile.fromState(
              state,
              isTwoLine: true,
              leading: const CircleAvatar(
                backgroundImage: NetworkImage('https://source.unsplash.com/8I-ht65iRww/100x100'),
              ),
            );
          }
        ),
        const SizedBox(height: 7),
      ],
    );
  }
}