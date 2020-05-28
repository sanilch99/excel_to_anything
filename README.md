# exceltoanything

A package that allows you to transform your excel to the following format:
1. Excel To JSON
2. Excel to SQLite

## Getting Started


At current the package allows you to use the following two functions (note: currently xlsx file type gives perfect results):<br />
1.excelToJson()<br />
    \t- automatically lets you pick an excel file and returns a string containing the entire converted json<br /><br />
2.excelToSql({@required tableName,Database db,dbExist=true,tableExist=false,dbName})
    \t- lets you choose an excel file
    \t- also creates a db for you if dbExist is set to false,note that here dbName has to be given
    \t- create a table for you using the given header and automatically interprets the required data-type based on the rows of the data
    \t- parameters: tableName is required
    \t- note the primary key is set as the first column by default
<br />
For implementation have a look at the attached example file in the github repository.       

# Installing

### 1. Depend on it
Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  exceltoanything: ^0.0.1
```

### 2. Install it

You can install packages from the command line:

with `pub`:

```css
$  pub get
```

with `Flutter`:

```css
$  flutter packages get
```

### 3. Import it

Now in your `Dart` code, you can use: 

````dart
    import 'package:exceltoanything/exceltoanything.dart';
````


Currently Working On:-<br />
    1. Allowing update queries to already uploaded excel files<br />
    2. Converting given excel to pdf<br />
    3. incorporating more file types such as csv.<br />
    4. Allowing more data types currently supports TEXT,REAL,NULL AND INTEGER<br />
<br />
This package depends on several other packages such as [Excel](https://www.pub.dev/packages/excel),[Path Provider](https://pub.dev/packages/path_provider),
[SQFLITE](https://pub.dev/packages/sqflite),[File Picker](https://pub.dev/packages/file_picker). A great thanks to these packages as well for an improved implementation

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our 
[online documentation](https://flutter.dev/docs), which offers tutorials, 
samples, guidance on mobile development, and a full API reference.
