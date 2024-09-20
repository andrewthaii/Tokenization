import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/task_local_storage.dart';
import '../../domain/entities/task.dart';
import '../../data/blockchain.dart';
import '../../data/smart_contract.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> listTask = [];
  List<Task> filterTask = [];
  bool isShowAllTasks = true;
  Blockchain blockchain = Blockchain();  // Instantiate the blockchain
  late SmartContract smartContract;  // Declare SmartContract

  TaskProvider() {
    isShowAllTasks = true;
    smartContract = SmartContract(blockchain);  // Pass the blockchain to SmartContract
  }

  Future<void> loadTasks() async {
    final savedTask = await TaskLocalStorage.loadTasks();
    if (savedTask != null) {
      listTask = savedTask;
      filterTask = savedTask;
    }
    notifyListeners();
  }

  void addTask(String title, String description, DateTime date) {
    final task = Task(
      id: const Uuid().v1(),
      title: title,
      description: description,
      date: date,
      isDone: false,
    );
    listTask.add(task);
    TaskLocalStorage.saveTasks(listTask);
    updateFilter();
  }

  void removeTask(String id) {
    listTask.removeWhere((element) => element.id == id);
    TaskLocalStorage.saveTasks(listTask);
    updateFilter();
  }

  void toggleTaskCompletion(String id) {
    final task = listTask.firstWhere((element) => element.id == id);
    task.isDone = !task.isDone;

    // Add the completed task to the blockchain if marked as done
    if (task.isDone) {
      String taskData = 'Task: ${task.title} completed';
      blockchain.addTaskBlock(taskData, 'userAddress');  // Replace 'userAddress' with actual user identifier
      smartContract.completeTask('userAddress');  // Execute smart contract task completion logic
      print('Added to blockchain: $taskData');
    }

    TaskLocalStorage.saveTasks(listTask);
    notifyListeners();
  }

  // Function to get user's token balance
  int getUserTokenBalance(String user) {
    return blockchain.getUserTokenBalance(user, smartContract);  // Get balance from Blockchain and SmartContract
  }

  void updateFilter() {
    filterTask = isShowAllTasks ? listTask : filterTasksToday(listTask);
    notifyListeners();
  }

  List<Task> filterTasksToday(List<Task> tasks) {
    final today = DateTime.now();
    final filteredTasks = tasks
        .where((element) =>
    element.date.day == today.day &&
        element.date.month == today.month &&
        element.date.year == today.year)
        .toList();
    return filteredTasks;
  }

  bool changeShowAllTasks() {
    isShowAllTasks = !isShowAllTasks;
    updateFilter();
    return isShowAllTasks;
  }

  // Trigger UI update when tokens are rewarded
  void rewardTokensToUser(String user, int amount) {
    smartContract.rewardTokens(user, amount);  // Reward tokens via SmartContract
    notifyListeners();  // Notify the UI that state has changed
  }

  List<Task> get tasks => listTask;
  List<Task> get filteredTasks => filterTask;
}
