enum UploadPriority {
  high,
  medium,
  low,
}

abstract class Uploadable {
  UploadPriority get priority;
  double get sizeInMB;
}

class UploadQueueOptimizer {
  List<T> optimize<T extends Uploadable>(List<T> items) {
    final List<T> sortedItems = List.from(items);

    sortedItems.sort((a, b) {
      final priorityComparison = a.priority.index.compareTo(b.priority.index);

      if (priorityComparison != 0) {
        return priorityComparison;
      }

      return a.sizeInMB.compareTo(b.sizeInMB);
    });

    return sortedItems;
  }
}