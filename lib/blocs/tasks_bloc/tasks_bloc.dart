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
  }

  void _onAddTask(AddTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
      pendingTasks: List.from(state.pendingTasks)..add(event.task),
      completedTasks: state.completedTasks,
      favoriteTasks: state.favoriteTasks,
      removeTasks: state.removeTasks,
    ));
  }

  void _onUpdateTask(UpdateTask event, Emitter<TasksState> emit) {
    final state = this.state;
    final task = event.task;

    List<Task> pendingTasks = state.pendingTasks;
    List<Task> completedTasks = state.completedTasks;
    task.isDone == false
        ? {
            pendingTasks = List.from(pendingTasks)..remove(task),
            completedTasks = List.from(completedTasks)
              ..insert(0, task.copyWith(isDone: true)),
          }
        : {
            completedTasks = List.from(completedTasks)..remove(task),
            pendingTasks = List.from(pendingTasks)
              ..insert(0, task.copyWith(isDone: false)),
          };

    emit(TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      favoriteTasks: state.favoriteTasks,
      removeTasks: state.removeTasks,
    ));
  }

  void _onDeleteTask(DeleteTask event, Emitter<TasksState> emit) {
    final state = this.state;
    emit(TasksState(
      pendingTasks: state.pendingTasks,
      completedTasks: state.completedTasks,
      favoriteTasks: state.favoriteTasks,
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
        favoriteTasks: List.from(state.favoriteTasks)..remove(event.task),
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
    List<Task> favoriteTasks = state.favoriteTasks;
    if (event.task.isDone == false) {
      if (event.task.isFavourite == false) {
        var taskIndex = pendingTasks.indexOf(event.task);
        pendingTasks = List.from(pendingTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavourite: true));
        favoriteTasks.insert(0, event.task.copyWith(isFavourite: true));
      } else {
        var taskIndex = pendingTasks.indexOf(event.task);
        pendingTasks = List.from(pendingTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavourite: false));
        favoriteTasks.remove(event.task);
      }
    } else {
      if (event.task.isFavourite == false) {
        var taskIndex = completedTasks.indexOf(event.task);
        completedTasks = List.from(completedTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavourite: true));
        favoriteTasks.insert(0, event.task.copyWith(isFavourite: true));
      } else {
        var taskIndex = completedTasks.indexOf(event.task);
        completedTasks = List.from(completedTasks)
          ..remove(event.task)
          ..insert(taskIndex, event.task.copyWith(isFavourite: false));
        favoriteTasks.remove(event.task);
      }
    }
    emit(TasksState(
      pendingTasks: pendingTasks,
      completedTasks: completedTasks,
      favoriteTasks: favoriteTasks,
      removeTasks: state.removeTasks,
    ));
  }

  void _onEditTask(EditTask event, Emitter<TasksState> emit) {
    final state = this.state;
    List<Task> favouriteTasks = state.favoriteTasks;
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
        favoriteTasks: favouriteTasks,
        removeTasks: state.removeTasks,
      ),
    );
  }
}



  // void _onEditTask(EditTask event, Emitter<TasksState> emit) {
  //   final state = this.state;
  //   List<Task> favouriteTasks = state.favoriteTasks;
  //   if (event.oldTask.isFavorite == true) {
  //     favouriteTasks
  //       ..remove(event.oldTask)
  //       ..insert(0, event.newTask);
  //   }
  //   emit(
  //     TasksState(
  //       pendingTasks: List.from(state.pendingTasks)
  //         ..remove(event.oldTask)
  //         ..insert(0, event.newTask),
  //       completedTasks: state.completedTasks..remove(event.oldTask),
  //       favoriteTasks: favouriteTasks,
  //       removedTasks: state.removedTasks,
  //     ),
  //   );
  // }

  // void _onRestoreTask(RestoreTask event, Emitter<TasksState> emit) {
  //   final state = this.state;
  //   emit(
  //     TasksState(
  //       removedTasks: List.from(state.removedTasks)..remove(event.task),
  //       pendingTasks: List.from(state.pendingTasks)
  //         ..insert(
  //             0,
  //             event.task.copyWith(
  //               isDeleted: false,
  //               isDone: false,
  //               isFavourite: false,
  //             )),
  //       completedTasks: state.completedTasks,
  //       favoriteTasks: state.favoriteTasks,
  //     ),
  //   );
  // }

  // void _onDeleteAllTask(DeleteAllTasks event, Emitter<TasksState> emit) {
  //   final state = this.state;
  //   emit(
  //     TasksState(
  //       removedTasks: List.from(state.removedTasks)..clear(),
  //       pendingTasks: state.pendingTasks,
  //       completedTasks: state.completedTasks,
  //       favoriteTasks: state.favoriteTasks,
  //     ),
  //   );
  // }
