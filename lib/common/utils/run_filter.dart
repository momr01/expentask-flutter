List<T> runFilter<T>(
  String keyword,
  List<T> originalItems,
  bool Function(T item) filterCondition,
) {
  if (keyword.isEmpty) {
    return originalItems;
  }
  return originalItems.where(filterCondition).toList();
}
