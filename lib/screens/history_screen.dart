import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<String> conversionHistory;
  final Function(int) onDeleteHistory;

  const HistoryScreen({
    Key? key,
    required this.conversionHistory,
    required this.onDeleteHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return conversionHistory.isEmpty
      ? const Center(child: Text("No conversion history yet"))
      : ListView.builder(
          itemCount: conversionHistory.length,
          itemBuilder: (context, index) {
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: ListTile(
                leading: const Icon(Icons.history),
                title: Text(conversionHistory[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onDeleteHistory(index),
                ),
              ),
            );
          },
        );
  }
}