part of 'tasks_bloc.dart';

class TasksState extends Equatable {
  final List<Task> pendingTasks;
  final List<Task> completedTasks;
  final List<Task> favoriteTasks;
  final List<Task> removeTasks;
  const TasksState({
    this.pendingTasks = const <Task>[],
    this.completedTasks = const <Task>[],
    this.favoriteTasks = const <Task>[],
    this.removeTasks = const <Task>[],
  });

  @override
  List<Object> get props =>
      [pendingTasks, removeTasks, completedTasks, favoriteTasks];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pendingTasks': pendingTasks.map((x) => x.toMap()).toList(),
      'removeTasks': removeTasks.map((x) => x.toMap()).toList(),
      'completedTasks': completedTasks.map((x) => x.toMap()).toList(),
      'favoriteTasks': favoriteTasks.map((x) => x.toMap()).toList(),
    };
  }

  factory TasksState.fromMap(Map<String, dynamic> map) {
    return TasksState(
      pendingTasks: List<Task>.from(
        map['pendingTasks']?.map(
          (x) => Task.fromMap(x),
        ),
      ),
      removeTasks: List<Task>.from(
        map['removeTasks']?.map(
          (x) => Task.fromMap(x),
        ),
      ),
      completedTasks: List<Task>.from(
        map['completedTasks']?.map(
          (x) => Task.fromMap(x),
        ),
      ),
      favoriteTasks: List<Task>.from(
        map['favoriteTasks']?.map(
          (x) => Task.fromMap(x),
        ),
      ),
    );
  }
}
