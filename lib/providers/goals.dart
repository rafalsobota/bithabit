import 'dart:convert';
import 'dart:math';

import 'package:bithabit/models/goal.dart';
import 'package:bithabit/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/config.dart';

import 'auth.dart';

class Goals with ChangeNotifier {
  Auth _auth;

  List<Goal> _goals = [];

  Config get config {
    return _auth.config;
  }

  String? get token {
    return _auth.token;
  }

  String? get userId {
    return _auth.userId;
  }

  String get databaseURL {
    return config.databaseUrl;
  }

  set auth(Auth value) {
    print('Goals.auth= ${value}');
    if (_auth.userId != value.userId) {
      _goals = [];
    }
    _auth = value;
    fetchAndSetGoals();
  }

  Goals({required Auth auth}) : _auth = auth {
    if (auth.isAuth) {
      fetchAndSetGoals();
    }
  }

  List<Goal> get goals {
    print('get goals ${_goals}');
    return [..._goals];
  }

  Goal getById(String id) {
    return _goals.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetGoals() async {
    print('fetchAndSetGoals 1');
    if (userId == null) {
      _goals = [];
      notifyListeners();
      return;
    }
    ;
    print('fetchAndSetGoals 2');
    final url = Uri.parse('$databaseURL/goals/$userId.json?auth=$token');
    final response = await http.get(url);
    final loadedGoals = <Goal>[];
    final extractedData = json.decode(response.body) as Map<String, dynamic>?;
    print('fetchAndSetGoals $extractedData');
    if (extractedData != null) {
      extractedData.forEach((goalId, goalData) {
        try {
          loadedGoals.add(
            Goal(
              id: goalId,
              description: goalData['description'] ?? 'No description',
              startDate: DateTime.tryParse(goalData['startDate'] ?? '') ??
                  DateTime.now().add(Duration(days: 100)),
              active: goalData['active'] ?? true,
              lastCompletionDate:
                  DateTime.tryParse(goalData['lastCompletionDate'] ?? ''),
              completionDays: goalData['completionDays'] ?? 0,
            ),
          );
        } catch (error) {
          print(error);
        }
      });
      print('parsed goals ${loadedGoals}');
      _goals = loadedGoals.reversed.toList();
    }
    // print('setting goals to ${sampleGoals}');
    // _goals = sampleGoals;
    notifyListeners();
  }

  Future<void> addGoal(Goal goal) async {
    if (_auth == null) return;
    final url = Uri.parse(
      '$databaseURL/goals/$userId.json?auth=$token',
    );
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'description': goal.description,
          'startDate': goal.startDate.toIso8601String(),
          'active': goal.active,
          'completionDays': goal.completionDays,
          'lastCompletionDate': goal.lastCompletionDate?.toIso8601String(),
        }),
      );
      final data = json.decode(response.body);
      final newGoal = Goal(
        id: data['name'],
        description: goal.description,
        startDate: goal.startDate,
        active: goal.active,
        completionDays: goal.completionDays,
        lastCompletionDate: goal.lastCompletionDate,
      );
      _goals.add(newGoal);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> completeGoal(String id) async {
    if (_auth == null) return;
    final goalIndex = _goals.indexWhere((currentGoal) => currentGoal.id == id);
    if (goalIndex < 0) {
      print('Goal not found for id ${id}');
      return Future.value();
    }
    final goal = _goals[goalIndex];

    if (!goal.toDoToday) {
      print('Attempt to complete goal which is not marked as todo');
      return Future.value();
    }

    final updatedGoal = Goal(
      id: goal.id,
      active: goal.realCompletionDays == 20 ? false : true,
      description: goal.description,
      lastCompletionDate: DateTime.now(),
      startDate: goal.startDate,
      completionDays: goal.realCompletionDays + 1,
    );

    await updateGoal(updatedGoal);
  }

  Future<void> uncompleteGoal(String id) async {
    if (_auth == null) return;
    final goalIndex = _goals.indexWhere((currentGoal) => currentGoal.id == id);
    if (goalIndex < 0) {
      print('Goal not found for id ${id}');
      return Future.value();
    }
    final goal = _goals[goalIndex];

    if (!goal.completedToday) {
      print(
          'Attempt to uncomplete goal which is not marked as completed today');
      return Future.value();
    }

    final updatedGoal = Goal(
      id: goal.id,
      active: true,
      description: goal.description,
      startDate: goal.startDate,
      lastCompletionDate: DateTime.now().subtract(Duration(days: 1)),
      completionDays: goal.realCompletionDays - 1,
    );

    await updateGoal(updatedGoal);
  }

  Future<void> renameGoal(String id, String description) async {
    if (_auth == null) return;
    final goalIndex = _goals.indexWhere((currentGoal) => currentGoal.id == id);
    if (goalIndex < 0) {
      print('Goal not found for id ${id}');
      return Future.value();
    }
    final goal = _goals[goalIndex];

    final updatedGoal = Goal(
      id: goal.id,
      active: goal.active,
      description: description,
      lastCompletionDate: goal.lastCompletionDate,
      startDate: goal.startDate,
      completionDays: goal.realCompletionDays,
    );

    await updateGoal(updatedGoal);
  }

  Future<void> updateGoal(Goal goal) async {
    if (_auth == null) return;
    final goalIndex =
        _goals.indexWhere((currentGoal) => currentGoal.id == goal.id);
    if (goalIndex < 0) {
      print('Goal not found for id ${goal.id}');
      return Future.value();
    }
    final oldGoal = _goals[goalIndex];
    _goals[goalIndex] = goal;
    notifyListeners();
    try {
      final url = Uri.parse(
        '$databaseURL/goals/$userId/${goal.id}.json?auth=$token',
      );
      final response = await http.put(
        url,
        body: json.encode({
          'description': goal.description,
          'startDate': goal.startDate.toIso8601String(),
          'active': goal.active,
          'completionDays': goal.completionDays,
          'lastCompletionDate': goal.lastCompletionDate?.toIso8601String(),
        }),
      );
      if (response.statusCode >= 400) {
        print(response.body);
        throw HttpException('Update failed');
      }
    } catch (error) {
      print(error);
      _goals[goalIndex] = oldGoal;
      notifyListeners();
      rethrow;
    }
  }

  void deleteGoal(String id) {
    final url = Uri.parse('$databaseURL/goals/$userId/$id.json?auth=$token');
    final existingGoalIndex = _goals.indexWhere((goal) => goal.id == id);
    final existingGoal = _goals[existingGoalIndex];
    _goals.removeAt(existingGoalIndex);
    http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw HttpException('Could not delete product.');
      }
    }).catchError((_) {
      _goals.insert(existingGoalIndex, existingGoal);
      notifyListeners();
    });
    notifyListeners();
  }

  List<Goal> get dailyGoals {
    return _goals.where((element) => element.toDoToday).toList();
  }

  List<Goal> get completedDailyGoals {
    return _goals.where((element) => element.completedToday).toList();
  }

  bool get areDailyGoalsFinished {
    return dailyGoals.isEmpty && completedDailyGoals.isNotEmpty;
  }

  List<Goal> get activeGoals {
    return _goals.where((element) => element.active).toList();
  }

  List<Goal> get finishedGoals {
    return _goals.where((element) => element.isFinished).toList();
  }

  List<Goal> get waitingGoals {
    return _goals
        .where((element) => !element.isFinished && element.active == false)
        .toList();
  }
}
