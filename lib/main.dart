import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<dynamic> fetchData() async {
    final response = await http.get(Uri.parse('https://localhost:8080/data'));

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetching Data Example'),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              // Check the type of data
              var data = snapshot.data;

              if (data is String) {
                // If the data is a string, try to decode it
                try {
                  var decodedData = json.decode(data);
                  return Text('Data from server: $decodedData');
                } catch (e) {
                  // Handle decoding error
                  return Text('Error decoding data: $e');
                }
              } else {
                // If the data is not a string, display it directly
                return Text('Data from server: $data');
              }
            }
          },
        ),
      ),
    );
  }
}
