//Library class: Manages the library's book inventory, including adding, deleting, updating, and querying books.

class ClsBook {
  String _title;
  String _author;
  String _category;

  // Constructor with initializer list
  ClsBook(String title, String author, String category)
      : _title = title,
        _author = author,
        _category = category;

  // Getter methods
  String get title => _title;
  String get author => _author;
  String get category => _category;

  // Setter methods
  set title(String title) {
    _title = title;
  }

  set author(String author) {
    _author = author;
  }

  set category(String category) {
    _category = category;
  }
}
