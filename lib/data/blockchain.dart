import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:tokenization_flutter/data/smart_contract.dart';

class Block {
  int index;
  DateTime timestamp;
  String data;  // Task description or token reward
  String previousHash;
  late String hash;

  Block(this.index, this.timestamp, this.data, this.previousHash) {
    hash = calculateHash();
  }

  String calculateHash() {
    return sha256.convert(utf8.encode('$index$timestamp$data$previousHash')).toString();
  }
}

class Blockchain {
  List<Block> chain = [];

  Blockchain() {
    // Create the genesis block (the first block in the chain)
    chain.add(createGenesisBlock());
  }

  Block createGenesisBlock() {
    return Block(0, DateTime.now(), "Genesis Block", "0");
  }

  Block get latestBlock {
    return chain.last;
  }

  // Add a block for a completed task
  void addTaskBlock(String taskData, String user) {
    Block block = Block(
      chain.length,
      DateTime.now(),
      taskData,
      latestBlock.hash,
    );
    chain.add(block);
  }

  // Add a block for a token reward event
  void addRewardBlock(String user, int amount) {
    String rewardData = "User $user received $amount tokens";
    Block rewardBlock = Block(
      chain.length,
      DateTime.now(),
      rewardData,
      latestBlock.hash,
    );
    chain.add(rewardBlock);
    print("Added reward block: $rewardData");
  }

  // Get the correct user token balance from SmartContract
  int getUserTokenBalance(String user, SmartContract smartContract) {
    return smartContract.tokenBalances[user] ?? 0;
  }
}
