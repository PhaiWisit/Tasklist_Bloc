import 'package:equatable/equatable.dart';
import 'package:flutter_tasks_app/models/task.dart';

import '../bloc_exports.dart';

part 'tasks_event.dart';
part 'tasks_state.dart';

class TasksBloc extends HydratedBloc<TasksEvent, TasksState> {
  TasksBloc() : super(const TasksState()) {
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<RemoveTask>(_onRemoveTask);
    on<MarkFavoriteOrUnfavoriteTask>(_onMarkFavoriteOrUnfavoriteTask);
    on<EditTask>(_onEditTask);
    on<RestoreTask>(_onRestoreTask);
    on<DeleteAllTasks>(_onDeleteAllTask);
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
      pendingTasks: List.from(state.pendingTasks)..add(event.task),
      completedTasks: state.completedTasks,
      favouriteTasks: state.favouriteTasks,
      removeTasks: state.removeTasks,
    ));
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {
    final state = this.state;
    final task = event.task;

    List<Task> pendingTasks = state.pendingTasks;
    List<Task> completedTasks = state.completedTasks;
    List<Task> favouriteTasks = state.favouriteTasks;
    if (task.isDone == false) {
      if (task.isFavourite == false) {
        pendingTasks = List.from(pendingTasks)..remove(task);
        completedTasks = List.from(completedTasks)
          ..insert(0, task.copyWith(isDone: true));
      } else {
        var taskIndex = favouriteTasks.indexOf(task);
        pendingTasks = List.from(pendingTasks)..remove(task);
        completedTasks = List.from(completedTasks)
          ..insert(0, task.copyWith(isDone: true));
        favouriteTasks = List.from(favouriteTasks)
          ..remove(task)
          ..insert(taskIndex, task.copyWith(isDone: true));
      }
    } else {
      if (task.isFavourite == false) {
        completedTasks = List.from(completedTasks)..remove(task);
        pendingTasks = List.from(pendingTasks)
          ..insert(0, task.copyWith(isDone: false));
      } else {
        var taskIndex = favouriteTasks.indexOf(task);
        completedTasks = List.from(completedTasks)..remove(task);
        pendingTasks = List.from(pendingTasks)..insert(0, task.copyWith(isDone: false));
        favouriteTasks = List.from(favouriteTasks)
          ..remove(task)
          ..insert(taskIndex, task.copyWith(isDone: false));
      }
    }
    // ? {
    //     pendingTasks = List.from(pendingTasks)..remove(task),
    //     completedTasks = List.from(completedTasks)
    //       ..insert(0, task.copyWith(isDone: true)),
    //   }
    // : {
    //     completedTasks = List.from(completedTasks)..remove(task),
    //     pendingTasks = List.from(pendingTasks)
    //       ..insert(0, task.copyWith(isDone: false)),
    //   };

    emit(TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      favouriteTasks: state.favouriteTasks,
      removeTasks: state.removeTasks,
    ));
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
      pendingTasks: state.pendingTasks,
      completedTasks: state.completedTasks,
      favouriteTasks: state.favouriteTasks,
      removeTasks: List.from(state.removeTasks)..remove(event.task),
    ));
  }

  void _onRemoveTask(RemoveTask event, Emitter<TasksState> emit) {
    final state = this.state;
    var removeTasks = List<Task>.from(state.removeTasks);
    removeTasks.add(event.task.copyWith(isDeleted: true));
    emit(
      TasksState(
        pendingTasks: List.from(state.pendingTasks)..remove(event.task),
        completedTasks: List.from(state.completedTasks)..remove(event.task),
        favouriteTasks: List.from(state.favouriteTasks)..remove(event.task),
        removeTasks: removeTasks,
        // removeTasks: List.from(
        //     state.removeTasks..add(event.task.copyWith(isDeleted: true)))
      ),
    );
  }

  @override
  TasksState? fromJson(Map<String, dynamic> json) {
    return TasksState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(TasksState state) {
    return state.toMap();
  }

  void _onMarkFavoriteOrUnfavoriteTask(
      MarkFavoriteOrUnfavoriteTask event, Emitter<TasksState> emit) {
    final state = this.state;
    List<Task> pendingTasks = state.pendingTasks;
    List<Task> completedTasks = state.completedTasks;
    List<Task> favouriteTasks = state.favouriteTasks;
    if (event.task.isDone == false) {
      if (event.task.isFavourite == false) {
        var taskIndex = pendingTasks.indexOf(event.task);
        pendingTasks = List.from(pendingTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavourite: true));
        favouriteTasks = List.from(favouriteTasks)
          ..insert(0, event.task.copyWith(isFavourite: true));
        // favouriteTasks.insert(0, event.task.copyWith(isFavourite: true));
      } else {
        var taskIndex = pendingTasks.indexOf(event.task);
        pendingTasks = List.from(pendingTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavourite: false));
        favouriteTasks = List.from(favouriteTasks)..remove(event.task);
        // favouriteTasks.remove(event.task);
      }
    } else {
      if (event.task.isFavourite == false) {
        var taskIndex = completedTasks.indexOf(event.task);
        completedTasks = List.from(completedTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavourite: true));
        favouriteTasks.insert(0, event.task.copyWith(isFavourite: true));
      } else {
        var taskIndex = completedTasks.indexOf(event.task);
        completedTasks = List.from(completedTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavourite: false));
        favouriteTasks.remove(event.task);
      }
    }
    emit(TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      favouriteTasks: favouriteTasks,
      removeTasks: state.removeTasks,
    ));
  }

  void _onEditTask(EditTask event, Emitter<TasksState> emit) {
    final state = this.state;
    List<Task> favouriteTasks = state.favouriteTasks;
    if (event.oldTask.isFavourite == true) {
      favouriteTasks
        ..remove(event.oldTask)
        ..insert(0, event.newTask);
    }
    emit(
      TasksState(
        pendingTasks: List.from(state.pendingTasks)
          ..remove(event.oldTask)
          ..insert(0, event.newTask),
        completedTasks: state.completedTasks..remove(event.oldTask),
        favouriteTasks: favouriteTasks,
        removeTasks: state.removeTasks,
      ),
    );
  }

  void _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(
      TasksState(
        removeTasks: List.from(state.removeTasks)..remove(event.task),
        pendingTasks: List.from(state.pendingTasks)
          ..insert(
              0,
              event.task.copyWith(
                isDeleted: false,
                isDone: false,
                isFavourite: false,
              )),
        completedTasks: state.completedTasks,
        favouriteTasks: state.favouriteTasks,
      ),
    );
  }

  void _onDeleteAllTask(DeleteAllTasks event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(
      TasksState(
        removeTasks: List.from(state.removeTasks)..clear(),
        pendingTasks: state.pendingTasks,
        completedTasks: state.completedTasks,
        favouriteTasks: state.favouriteTasks,
      ),
    );
  }
}
