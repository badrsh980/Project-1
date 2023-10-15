import 'dart:io';

class InputReader {
  static int readIntNumber(
      [String errorMessage = "Invalid Number, Enter again"]) {
    int number;
    while (true) {
      try {
        final input = stdin.readLineSync();
        if (input == null) {
          print("No input received. $errorMessage");
          continue;
        }
        number = int.parse(input);
        break;
      } catch (e) {
        print(errorMessage);
      }
    }
    return number;
  }

  static double readDoubleNumber(
      [String errorMessage = "Invalid Number, Enter again"]) {
    double number;
    while (true) {
      try {
        final input = stdin.readLineSync();
        if (input == null) {
          print("No input received. $errorMessage");
          continue;
        }
        number = double.parse(input);
        break;
      } catch (e) {
        print(errorMessage);
      }
    }
    return number;
  }

  static String readText(String message) {
    stdout.write("$message\n");
    final text = stdin.readLineSync();
    return text ?? ''; // Return an empty string if input is null.
  }
}
