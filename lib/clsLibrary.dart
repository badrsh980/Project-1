//Library class: Manages the library's book inventory, including adding, deleting, updating, and querying books
import 'package:library_project_using_dart/clsBook.dart';
import 'package:library_project_using_dart/InputReader.dart';
import 'dart:io';

enum enMode { EmptyMode, UpdateMode, AddNewMode }

enum enSaveResults { svFailEmptyObject, svSucceeded, svFailBookNameIsExists }

class clsLibrary extends ClsBook {
  enMode _Mode;
  double _price;
  int _quantity;
  bool _MarkedForDelete = false;

  static clsLibrary _ConvertLineToLibraryObject(String line,
      [String separator = "#//#"]) {
    List<String> libraryData = line.split(separator);

    return clsLibrary(
      enMode.UpdateMode, // Set the mode to EnMode.UpdateMode
      libraryData[0], // <-- Problematic line
      libraryData[1],
      libraryData[2],
      double.parse(libraryData[3]),
      int.parse(libraryData[4]),
    );
  }

  // Method to get an empty Library object
  static clsLibrary _getEmptyLibrary() {
    return clsLibrary(enMode.EmptyMode, '', '', '', 0.0, 0);
  }

  static clsLibrary GetNewLBookObj(String title) {
    return clsLibrary(enMode.AddNewMode, 'title', '', '', 0, 0);
  }

  static String _ConvertLibraryObjectToLine(clsLibrary book,
      [String separator = "#//#"]) {
    String stClientRecord = "";
    stClientRecord += book.title + separator;
    stClientRecord += book.author + separator;
    stClientRecord += book.category + separator;
    stClientRecord += book.price.toString() + separator;
    stClientRecord += book.quantity.toString();
    return stClientRecord;
  }

  static List<clsLibrary> _loadLibraryDataFromFile() {
    List<clsLibrary> libraries = [];

    try {
      File file = File('Books.txt');
      if (file.existsSync()) {
        List<String> lines = file.readAsLinesSync();
        for (String line in lines) {
          clsLibrary library = _ConvertLineToLibraryObject(line);
          libraries.add(library);
        }
      } else {
        print('File not found: Books.txt');
      }
    } catch (e, stackTrace) {
      print('Error loading data from file: $e');
      print('Stack trace: $stackTrace');
    }
    return libraries;
  }

  static void _saveLibraryDataToFile(List<clsLibrary> libraries) {
    try {
      File file = File('Books.txt');
      IOSink sink = file.openWrite();
      // Use FileMode.write to overwrite the file
      for (clsLibrary Book in libraries) {
        if (Book._MarkedForDelete == false) {
          String dataLine = _ConvertLibraryObjectToLine(Book);
          sink.write('$dataLine\n');
        }
      }
      sink.close();
    } catch (e) {
      print('Error saving data to file: $e');
    }
  }

  void _update() {
    List<clsLibrary> _libraries = _loadLibraryDataFromFile();

    for (int i = 0; i < _libraries.length; i++) {
      if (_libraries[i].title.toLowerCase() == title.toLowerCase()) {
        _libraries[i] = this;
        break;
      }
    }

    _saveLibraryDataToFile(_libraries);
  }

  void _AddDataLineToFile(String stDataLine) {
    var myFile = File('Books.txt');
    var sink = myFile.openWrite(mode: FileMode.append);

    if (sink != null) {
      sink.write('$stDataLine\n');
      sink.close();
    }
  }

  void _AddNew() {
    _AddDataLineToFile(_ConvertLibraryObjectToLine(this));
  }

  clsLibrary(enMode Mode, String title, String author, String category,
      double price, int quantity)
      : _price = price,
        _quantity = quantity,
        _Mode = Mode,
        super(title, author, category);

  bool IsEmpty() {
    return (_Mode == enMode.EmptyMode);
  }

  // Getter and Setter for price
  double get price => _price;
  set price(double price) {
    _price = price;
  }

  // Getter and Setter for quantity
  int get quantity => _quantity;
  set quantity(int quantity) {
    _quantity = quantity;
  }

  void Printdata() {
    print("Book Card:    ");
    print("-------------------------");
    print("Book title    : $title");
    print("Book author   : $author");
    print("Book category : $category");
    print("Book price    : $_price");
    print("Book quantity : $_quantity");
    print("-------------------------");
  }

  static clsLibrary Find(String title) {
    try {
      File file = File('Books.txt');
      if (file.existsSync()) {
        List<String> lines = file.readAsLinesSync();
        for (String line in lines) {
          clsLibrary Book = _ConvertLineToLibraryObject(line);
          if (Book.title.toLowerCase() == title.toLowerCase()) {
            return Book; // Found the book, return it
          }
        }
      }
    } catch (e) {
      print('Error reading data from file: $e');
      return clsLibrary._getEmptyLibrary();
    }

    print("No books found with the given title.");
    return clsLibrary
        ._getEmptyLibrary(); // Book not found, return an empty library object
  }

  static bool isBookExist(String searchTitle) {
    clsLibrary Book = clsLibrary.Find(searchTitle);
    return (!Book.IsEmpty());
  }

  bool Delete() {
    List<clsLibrary> libraries = _loadLibraryDataFromFile();

    for (clsLibrary book in libraries) {
      if (book.title.toLowerCase() == title.toLowerCase()) {
        // found book
        book._MarkedForDelete = true;
        break;
      }
    }
    _saveLibraryDataToFile(libraries);
    _getEmptyLibrary();
    return true;
  }

  static List<clsLibrary> GetBooksList() {
    return _loadLibraryDataFromFile();
  }

  static clsLibrary findByCategory(String category) {
    List<clsLibrary> libraries = _loadLibraryDataFromFile();

    for (clsLibrary book in libraries) {
      if (book.category == category) {
        // found book
        return book;
      }
    }

    // No match found, return empty book
    return _getEmptyLibrary();
  }

  enSaveResults save() {
    switch (_Mode) {
      case enMode.EmptyMode:
        {
          return enSaveResults.svFailEmptyObject;
        }
      case enMode.UpdateMode:
        {
          _update();
          return enSaveResults.svSucceeded;
        }
      case enMode.AddNewMode:
        {
          if (clsLibrary.isBookExist(title)) {
            return enSaveResults.svFailBookNameIsExists;
          } else {
            _AddNew();
            _Mode = enMode.UpdateMode;
            return enSaveResults.svFailBookNameIsExists;
          }
        }
    }
  }
}
