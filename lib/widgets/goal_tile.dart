import 'package:bithabit/models/goal.dart';
import 'package:bithabit/providers/goals.dart';
import 'package:bithabit/providers/sounds.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main_button.dart';
import 'secondary_button.dart';

class GoalTile extends StatefulWidget {
  final Goal goal;

  const GoalTile(
    this.goal, {
    Key? key,
  }) : super(key: key);

  @override
  _GoalTileState createState() => _GoalTileState();
}

class _GoalTileState extends State<GoalTile> {
  bool _editMode = false;
  String _title = '';

  @override
  void initState() {
    _title = widget.goal.description;
    super.initState();
  }

  void _save(String value) async {
    await context.read<Goals>().renameGoal(widget.goal.id, value);
    setState(() {
      _editMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final goalsData = context.watch<Goals>();
    final allFinished = goalsData.areDailyGoalsFinished;

    return Material(
      color: Colors.transparent,
      child: Column(
        children: [
          ListTile(
            key: ValueKey('goal-${widget.goal.id}-tile'),
            onTap: _editMode
                ? null
                : () async {
                    context.read<Sounds>().click();
                    if (widget.goal.completedToday) {
                      await context
                          .read<Goals>()
                          .uncompleteGoal(widget.goal.id);
                    } else {
                      await context.read<Goals>().completeGoal(widget.goal.id);
                    }
                  },
            onLongPress: _editMode
                ? null
                : () {
                    context.read<Sounds>().click();
                    setState(() {
                      _editMode = true;
                    });
                  },
            leading: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: allFinished ? 1 : 1,
                child: widget.goal.completedToday
                    ? Icon(
                        Icons.done,
                        color: allFinished ? Colors.white : Colors.green,
                      )
                    : const Icon(Icons.circle_outlined),
              ),
            ),
            title: _editMode
                ? TextFormField(
                    initialValue: widget.goal.description,
                    autofocus: true,
                    textInputAction: TextInputAction.send,
                    textCapitalization: TextCapitalization.sentences,
                    onFieldSubmitted: (value) async {
                      _save(value);
                    },
                    onChanged: (value) {
                      _title = value;
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
                : Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      widget.goal.description,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        color: allFinished ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
            subtitle: _editMode
                ? FittedBox(
                    alignment: Alignment.topRight,
                    fit: BoxFit.scaleDown,
                    child: ButtonBar(
                      children: [
                        SecondaryButton(
                          label: 'Delete',
                          danger: true,
                          onPressed: () {
                            context.read<Goals>().deleteGoal(widget.goal.id);
                          },
                        ),
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
                            _save(_title);
                          },
                        ),
                      ],
                    ),
                  )
                : null,
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: allFinished ? 2 : 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 82.0,
            ),
            margin: EdgeInsets.only(
              bottom: allFinished ? 10 : 0,
            ),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: allFinished ? 1 : 0,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white10,
                color: Colors.white,
                value: widget.goal.realCompletionDays / 21,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
