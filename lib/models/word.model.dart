class Word {
  final int? id;
  final String word;
  final String meaning;

  const Word({
    this.id,
    required this.word,
    required this.meaning,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
    };
  }

  // temp
  @override
  String toString() {
    return 'Word{id: $id, name: $word, meaning: $meaning}';
  }
}
