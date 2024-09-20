
import 'blockchain.dart';

class SmartContract {
  Map<String, int> taskCount = {};  // Track tasks for each user
  Map<String, bool> userConsent = {};  // Track if the user agreed to receive tokens
  Map<String, int> tokenBalances = {};  // Track token balances for each user
  late Blockchain blockchain;  // Reference to Blockchain

  // Constructor to accept Blockchain instance
  SmartContract(this.blockchain);

  // Function to complete a task and possibly reward tokens
  void completeTask(String user) {
    if (!taskCount.containsKey(user)) {
      taskCount[user] = 0;
    }
    taskCount[user] = taskCount[user]! + 1;

    print('User $user has completed ${taskCount[user]} tasks.');

    // Check if the user is eligible for token reward after every 5 tasks
    if (taskCount[user]! % 5 == 0 && userConsent[user] == true) {
      rewardTokens(user, 10);  // Reward tokens after completing 5 tasks
    }
  }

  // User agrees to receive tokens
  void agreeToReceiveTokens(String user) {
    userConsent[user] = true;
    print('User $user has agreed to receive tokens.');
  }

  // Reward tokens to the user and log the event
  void rewardTokens(String user, int amount) {
    if (!tokenBalances.containsKey(user)) {
      tokenBalances[user] = 0;
    }
    tokenBalances[user] = tokenBalances[user]! + amount;
    print("User $user has been rewarded with $amount tokens. Total: ${tokenBalances[user]} tokens.");

    // Add a block to the blockchain for the token reward
    blockchain.addRewardBlock(user, amount);  // Add token reward transaction as a new block
  }

  // Optional: Revoke token agreement
  void revokeConsent(String user) {
    userConsent[user] = false;
    print('User $user has revoked consent to receive tokens.');
  }
}


