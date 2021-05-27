class Goal {
  final String id;
  final String description;
  final DateTime startDate;
  final bool active;
  final DateTime? lastCompletionDate;
  final int completionDays;

  Goal({
    required this.id,
    required this.description,
    required this.startDate,
    required this.active,
    this.lastCompletionDate,
    this.completionDays = 0,
  });

  DateTime get _lastCompletionDay {
    if (lastCompletionDate == null) {
      return DateTime(2021);
    }

    return DateTime(
      lastCompletionDate!.year,
      lastCompletionDate!.month,
      lastCompletionDate!.day,
    );
  }

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
    );
  }

  DateTime get _yesterday {
    return _today.subtract(const Duration(days: 1));
  }

  int get realCompletionDays {
    if (lastCompletionDate == null) {
      return 0;
    }

    if (_lastCompletionDay.isBefore(_yesterday)) {
      return 0;
    }

    return completionDays;
  }

  bool get isFinished {
    return completionDays >= 21;
  }

  bool get toDoToday {
    return active && _lastCompletionDay.isBefore(_today);
  }

  bool get completedToday {
    return _lastCompletionDay.isAtSameMomentAs(_today);
  }
}
