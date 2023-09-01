import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

class ComptesPage extends StatefulWidget {
  @override
  _ComptesPageState createState() => _ComptesPageState();
}

class _ComptesPageState extends State<ComptesPage> {
  final authenticatedUser = Get.arguments;
  List<dynamic> requestData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final baseUrl =
        Uri.parse("http://192.168.1.18:8080/api/comptes/listecomptes");
    final userId = authenticatedUser.id.toString();

    final url = Uri.parse("$baseUrl?userId=$userId");

    final headers = {
      'Authorization': 'Bearer ${authenticatedUser.accessToken}'
    };

    final response = await http.get(url, headers: headers);
    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        requestData = json.decode(response.body);
        isLoading = false;
      });
    } else {
      isLoading = false;
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Backend Response'),
            content:
                Text('An error occurred. Status code: ${response.statusCode}'),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Accounts"),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: requestData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> currentItem = requestData[index];
                  return ListTile(
                    title: Text("Account Number ${currentItem['numero']}"),
                    subtitle: Text("Solde: ${currentItem['solde']}"),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {},
                  );
                },
              ),
      ),
    );
  }
}
