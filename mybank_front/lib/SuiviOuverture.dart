import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SuiviOuverturePage extends StatefulWidget {
  @override
  _SuiviOuverturePageState createState() => _SuiviOuverturePageState();
}

class _SuiviOuverturePageState extends State<SuiviOuverturePage> {
  final authenticatedUser = Get.arguments;
  List<dynamic> requestData = [];
  List<dynamic> filteredData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final baseUrl = "http://192.168.1.18:8080/api/demandeouverture";
    final userId = authenticatedUser.id.toString();

    final url = Uri.parse("$baseUrl?userId=$userId");

    final headers = {
      'Authorization': 'Bearer ${authenticatedUser.accessToken}',
      'Content-Type': 'application/json',
    };

    final response = await http.get(url, headers: headers);

    print("Response Status Code: ${response.statusCode}");
    print("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        requestData = json.decode(response.body);
        filteredData = requestData
            .where((item) => item['user']['id'] == authenticatedUser.id)
            .toList();
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
        title: Text("Track account opening"),
      ),
      body: Center(
        child: isLoading
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> currentItem = filteredData[index];

                  return ListTile(
                    title:
                        Text("Account opening request N° ${currentItem['id']}"),
                    subtitle: Text("Statut: ${currentItem['statut']}"),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {},
                  );
                },
              ),
      ),
    );
  }
}
