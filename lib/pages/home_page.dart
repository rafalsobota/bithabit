import 'package:bithabit/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:bithabit/providers/goals.dart';
import 'package:bithabit/widgets/app_drawer.dart';
import 'package:bithabit/widgets/goal_tile.dart';
import 'package:bithabit/widgets/new_goal_tile.dart';
import 'package:bithabit/widgets/plane_animation.dart';
import 'package:bithabit/widgets/transparent_app_bar.dart';

import 'auth_page.dart';

class HomePage extends StatelessWidget {
  Widget _mainPage(Goals goalsData) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
            Align(
              alignment: Alignment.center,
              child: Container(
                constraints: const BoxConstraints(
                  maxWidth: 800,
                ),
                child: ListView(
                  children: [
                    const TransparentAppBar(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ...goalsData.activeGoals
                            .map(
                              (goal) => GoalTile(
                                goal,
                                key: ValueKey(goal.id),
                              ),
                            )
                            .toList(),
                        if (goalsData.areGoalsLoaded)
                          const NewGoalTile(
                            key: ValueKey(
                              'new-goal',
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final goalsData = context.watch<Goals>();
    final isAuth = context.watch<Auth>().isAuth;
    if (!isAuth) {
      Future.delayed(Duration.zero, () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AuthPage(),
          ),
        );
      });
    }

    if (goalsData.areDailyGoalsFinished) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    }

    return _mainPage(goalsData);
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
