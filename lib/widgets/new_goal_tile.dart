import 'package:bithabit/models/goal.dart';
import 'package:bithabit/providers/goals.dart';
import 'package:bithabit/providers/sounds.dart';
import 'package:bithabit/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_button.dart';

class NewGoalTile extends StatefulWidget {
  const NewGoalTile({
    Key? key,
  }) : super(key: key);

  @override
  _NewGoalTileState createState() => _NewGoalTileState();
}

class _NewGoalTileState extends State<NewGoalTile> {
  bool _editMode = false;

  String _title = '';

  void _submit(String value) async {
    await context.read<Goals>().addGoal(
          Goal(
            active: true,
            description: value,
            id: '',
            startDate: DateTime.now(),
          ),
        );
    setState(() {
      _editMode = false;
      _title = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final noGoals = context.watch<Goals>().activeGoals.isEmpty;

    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: _editMode
            ? null
            : () async {
                context.read<Sounds>().click();
                setState(() {
                  _editMode = true;
                });
              },
        leading: const Padding(
          padding: EdgeInsets.only(left: 16.0),
          child: Icon(Icons.add),
        ),
        title: _editMode
            ? TextFormField(
                initialValue: '',
                autofocus: true,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.send,
                onChanged: (value) {
                  _title = value;
                },
                onFieldSubmitted: (value) async {
                  _submit(value);
                },
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                ),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 8),
                  border: InputBorder.none,
                  filled: true,
                ),
              )
            : noGoals
                ? const Text(
                    'Add the first goal',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 30,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                : null,
        subtitle: _editMode
            ? ButtonBar(
                alignment: MainAxisAlignment.end,
                children: [
                  SecondaryButton(
                    label: 'Cancel',
                    onPressed: () {
                      setState(() {
                        _editMode = false;
                      });
                    },
                  ),
                  MainButton(
                    label: 'Save',
                    onPressed: () {
                      _submit(_title);
                    },
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
