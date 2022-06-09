import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:finalcrud/api/function.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Createddata obj = Createddata();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController orderController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getdata();
    datadelete(id);
    obj.datacreate(customerNameController.text, orderController.text,
        priceController.text, quantityController.text, totalController.text);
  }

  List data = [];
  String? id;
  Future getdata() async {
    final response =
    await http.get(Uri.parse('http://192.168.254.107:8000/api/deliveries'));
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
      print('Add data$data');
    } else {
      print('err');
    }
  }

  Future datadelete(id) async {
    final response = await http
        .delete(Uri.parse('http://192.168.254.107:8000/api/deliveries/$id'));
    print(response.statusCode);

    if (response.statusCode == 200) {
      print('DELETE COMPLETE');
    } else {
      print('nOT dELET');
    }
  }

  Future update() async {
    final response = await http
        .put(Uri.parse('http://192.168.254.107:8000/api/deliveries/1'),
        body: jsonEncode({
          "customerName":customerNameController.text,
          "order":orderController.text,
          "price":priceController.text,
          "quantity":quantityController.text,
          "total":totalController.text,
        }),
        headers: {
          'Content-type': 'application/json; charset=UTF-8',
        });
    print(response.statusCode);
    if (response.statusCode == 200) {
      print('Data Update Successfully');
      customerNameController.clear();
      orderController.clear();
      priceController.clear();
      quantityController.clear();
      totalController.clear();

    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            child: Column(
              children: [
                TextField(
                  controller: customerNameController,
                  decoration: InputDecoration(
                    hintText: 'Name',
                  ),
                ),

                TextField(
                  controller: priceController,
                  decoration: InputDecoration(
                    hintText: 'Number',
                  ),
                ),
                TextField(
                  controller: quantityController,
                  decoration: InputDecoration(
                    hintText: 'Number',
                  ),
                ),
                TextField(
                  controller: totalController,
                  decoration: InputDecoration(
                    hintText: 'Number',
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            obj.datacreate(
                              customerNameController.text,
                              orderController.text,
                              priceController.text,
                              quantityController.text,
                              totalController.text,
                            );
                          });
                        },
                        child: Text('Submit')),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            update();
                          });
                        },
                        child: Text('Update')),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(

                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                    children: [
                                      Text(data[index]['customerName']),
                                    ]),
                                Row(
                                    children: [
                                      Text(data[index]['order']),
                                    ]),
                                Row(
                                    children: [
                                      Text(data[index]['quantity']),
                                    ]),
                                Row(
                                    children: [
                                      Text(data[index]['total']),
                                    ]),

                                Container(
                                  width: 100,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          onPressed: () {
                                            customerNameController.text =
                                            data[index]['customerName'];
                                            orderController.text =
                                            data[index]['order'];
                                            quantityController.text =
                                            data[index]['quantity'];
                                            priceController.text =
                                            data[index]['price'];
                                            totalController.text=
                                            data[index]['total'];
                                          },
                                          icon: Icon(Icons.edit)),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              datadelete(data[index]['id']);
                                            });
                                          },
                                          icon: Icon(Icons.delete))
                                    ],
                                  ),
                                ),
                              ],
                            ));
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

