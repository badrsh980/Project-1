import 'dart:ffi';
import 'dart:async';
import 'dart:io';
import 'package:library_project_using_dart/clsLibrary.dart';
import 'package:library_project_using_dart/InputReader.dart';

void ReadBook(clsLibrary Book) {
  Book.title = InputReader.readText("Enter title");
  Book.author = InputReader.readText("Enter author");
  Book.category = InputReader.readText("Enter category");
  Book.price = InputReader.readDoubleNumber("Enter price");
  Book.quantity = InputReader.readIntNumber("Enter quantity");
}

void UpdateBook() {
  String title = "";
//EROOER 0 NEED TO BE FIXED
  title = InputReader.readText("Please Enter Book Title");

  while (!clsLibrary.isBookExist(title)) {
    title =
        InputReader.readText("Book Title is not found, choose another one :");
  }

  clsLibrary Book = clsLibrary.Find(title);
  Book.Printdata();

  print("Update Client Info :");
  print("--------------------------");
  ReadBook(Book);

  enSaveResults saveResults;
  saveResults = Book.save();

  switch (saveResults) {
    case enSaveResults.svSucceeded:
      {
        print("Accout Updated Successfully :> ");
        Book.Printdata();
        break;
      }
    case enSaveResults.svFailEmptyObject:
      {
        print("Error no thing to save");
        break;
      }
    case enSaveResults.svFailBookNameIsExists:
      {
        print(":::>");
      }
  }
}

void AddNewBook() {
  String title = "";

  title = InputReader.readText("Please Enter Book Title");
  while (clsLibrary.isBookExist(title)) {
    title = InputReader.readText("Book Title is used choose another one :");
  }

  clsLibrary NewBook = clsLibrary.GetNewLBookObj(title);
  ReadBook(NewBook);

  enSaveResults saveResults;
  saveResults = NewBook.save();

  switch (saveResults) {
    case enSaveResults.svSucceeded:
      {
        print("Account Addeded Successfully :-)");
        NewBook.Printdata();
        break;
      }
    case enSaveResults.svFailEmptyObject:
      {
        print("Error account was not saved because it's Empty");
        break;
      }
    case enSaveResults.svFailBookNameIsExists:
      {
        print("Error account was not saved because account number is used!");
        break;
      }
  }
}

void DeleteBook() {
  String title = "";
  title = InputReader.readText("Please Enter Book Title");

  while (!clsLibrary.isBookExist(title)) {
    title =
        InputReader.readText("Book Title is not found, choose another one :");
  }
  clsLibrary Book = clsLibrary.Find(title);
  Book.Printdata();

  String answer = InputReader.readText(
      "Are you sure you want to delete this Book y/n"); // You need to implement InputReader or use another method to read input.

  if (answer.toLowerCase() == 'y') {
    if (Book.Delete()) {
      print("Client Deleted Successfully :-)");
      Book.Printdata();
    } else {
      print("Error: Client Was Not Deleted");
    }
  }
}

void PrintBookRecordLine(clsLibrary Book) {
  print(
      "| ${Book.title.padRight(25)} | ${Book.author.padRight(20)} | ${Book.category.padRight(15)} | ${Book.price.toStringAsFixed(2).padLeft(10)} | ${Book.quantity.toString().padLeft(10)} |");
}

void ShowBooksList() {
  List<clsLibrary> BookList = clsLibrary.GetBooksList();

  if (BookList.isEmpty) {
    print('No books available in the library.');
  } else {
    print("Number of Books in Library  :");
    print(BookList.length);
    print(
        '==========================================================================================================');
    print(
        "| Title                     | Author               | Category        | Price      | Quantity   |");
    print(
        '==========================================================================================================');
    for (final book in BookList) {
      PrintBookRecordLine(book);
    }
    print(
        '==========================================================================================================');
  }
}

final _columnHeaders = ['Title', 'Author', 'Category', 'Price', 'Quantity'];
final _tableWidth = _columnHeaders.fold(
    0,
    (int length, header) =>
        length + header.length + 3); // 3 characters for padding and separators
final _columnWidth = [25, 20, 15, 10, 10]; // Adjust column widths as needed

void main() {
  bool isRunning = true;

  while (isRunning) {
    print("Library Management System");
    print("1. Find a Book");
    print("2. Add a New Book");
    print("3. Update a Book");
    print("4. Show Books List");
    print("5. Delete a Book");
    print("6. Exit");
    print("Enter your choice:");

    int choice = InputReader.readIntNumber();

    switch (choice) {
      case 1:
        clsLibrary Book =
            clsLibrary.Find(InputReader.readText("Enter name of Book"));
        Book.Printdata();
        break;
      case 2:
        AddNewBook();
        break;
      case 3:
        UpdateBook();
        break;
      case 4:
        ShowBooksList();
        break;
      case 5:
        DeleteBook();
        break;
      case 6:
        isRunning = false;
        break;
      default:
        print("Invalid choice. Please try again.");
        break;
    }
  }
}
