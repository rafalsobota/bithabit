import 'package:bithabit/models/goal.dart';
import 'package:bithabit/providers/auth.dart';
import 'package:bithabit/providers/goals.dart';
import 'package:bithabit/providers/sounds.dart';
import 'package:bithabit/widgets/app_drawer.dart';
import 'package:bithabit/widgets/main_button.dart';
import 'package:bithabit/widgets/new_goal_tile.dart';
import 'package:bithabit/widgets/plane_animation.dart';
import 'package:bithabit/widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      body: HomeBody(),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({
    Key? key,
  }) : super(key: key);

  void _createGoal() {
    print('create');
  }

  @override
  Widget build(BuildContext context) {
    final goalsData = context.watch<Goals>();

    if (goalsData.areDailyGoalsFinished) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }

    return Theme(
      data: ThemeData(
        brightness: goalsData.areDailyGoalsFinished
            ? Brightness.dark
            : Brightness.light,
      ),
      child: Stack(
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: goalsData.areDailyGoalsFinished ? 1 : 0,
            child: goalsData.areDailyGoalsFinished
                ? PlaneAnimation()
                : Container(),
          ),
          SafeArea(
            child: Column(
              children: [
                const TransparentAppBar(),
                Expanded(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ...goalsData.activeGoals
                            .map(
                              (goal) => GoalTile(goal),
                            )
                            .toList(),
                        NewGoalTile(),
                      ]),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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
    final goalsData = context.read<Goals>();

    return Material(
      color: Colors.transparent,
      child: ListTile(
        onTap: _editMode
            ? null
            : () async {
                context.read<Sounds>().click();
                if (widget.goal.completedToday) {
                  await context.read<Goals>().uncompleteGoal(widget.goal.id);
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
          child: widget.goal.completedToday
              ? Icon(Icons.task_alt)
              : Icon(Icons.circle_outlined),
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
                  fontSize: 30,
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
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
        subtitle: _editMode
            ? FittedBox(
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
            : context.read<Goals>().areDailyGoalsFinished
                ? Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                        '${widget.goal.realCompletionDays} / 21 days completed'),
                  )
                : null,
      ),
    );
  }
}

class TransparentAppBar extends StatelessWidget {
  const TransparentAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: IconButton(
            icon: Icon(
              Icons.menu,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black45
                  : Colors.white54,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
    );
  }
}
