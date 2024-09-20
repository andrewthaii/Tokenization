import 'package:flutter/material.dart';
import '../../data/blockchain.dart';  // Import the blockchain

class BlockchainView extends StatelessWidget {
  final Blockchain blockchain;  // Define the blockchain parameter

  // Constructor accepting blockchain as a required named parameter
  BlockchainView({required this.blockchain});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blockchain'),
      ),
      body: ListView.builder(
        itemCount: blockchain.chain.length,
        itemBuilder: (context, index) {
          Block block = blockchain.chain[index];
          return ListTile(
            title: Text('Block ${block.index}'),
            subtitle: Text(
              'Data: ${block.data}\nTimestamp: ${block.timestamp}\nHash: ${block.hash}\nPreviousHash:${block.previousHash}',
            ),
          );
        },
      ),
    );
  }
}
