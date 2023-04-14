part of 'tasks_bloc.dart';

class TasksState extends Equatable {
  final List<Task> allTasks;
  final List<Task> removeTasks;
  const TasksState({
    this.allTasks = const <Task>[],
    this.removeTasks = const <Task>[],
  });

  @override
  List<Object> get props => [allTasks, removeTasks];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'allTasks': allTasks.map((x) => x.toMap()).toList(),
      'removeTasks': removeTasks.map((x) => x.toMap()).toList(),
    };
  }

  factory TasksState.fromMap(Map<String, dynamic> map) {
    return TasksState(
      allTasks: List<Task>.from(
        map['allTasks']?.map(
          (x) => Task.fromMap(x),
        ),
      ),
      removeTasks: List<Task>.from(
        map['removeTasks']?.map(
          (x) => Task.fromMap(x),
        ),
      ),
    );
  }
}
