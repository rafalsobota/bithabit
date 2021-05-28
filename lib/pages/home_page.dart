import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:bithabit/providers/goals.dart';
import 'package:bithabit/widgets/app_drawer.dart';
import 'package:bithabit/widgets/goal_tile.dart';
import 'package:bithabit/widgets/new_goal_tile.dart';
import 'package:bithabit/widgets/plane_animation.dart';
import 'package:bithabit/widgets/transparent_app_bar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final goalsData = context.watch<Goals>();

    if (goalsData.areDailyGoalsFinished) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: AppDrawer(),
      body: Theme(
        data: ThemeData(
          brightness: goalsData.areDailyGoalsFinished
              ? Brightness.dark
              : Brightness.light,
        ),
        child: Stack(
          children: [
            goalsData.areDailyGoalsFinished ? PlaneAnimation() : Container(),
            ListView(
              children: [
                const TransparentAppBar(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ...goalsData.activeGoals
                        .map(
                          (goal) => GoalTile(goal),
                        )
                        .toList(),
                    const NewGoalTile(),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BitTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(),
      Container(),
    ]);
  }
}
