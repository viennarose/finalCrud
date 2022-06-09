import 'dart:convert';

import 'package:http/http.dart' as http;

class Createddata {

  Future datacreate(customerNametext,  ordertext, pricetext, quantitytext, totaltext ) async {
    final response =
    await http.post(Uri.parse('http://192.168.254.107:8000/api/deliveries'),
        body: jsonEncode({
          "customerName":customerNametext,
          "order":ordertext,
          "price":pricetext,
          "quantity":quantitytext,
          "total":totaltext,
        }),
        headers: {
          'Content-type': 'application/json',
        });
    print(response.statusCode);
    if (response.statusCode == 201) {
      print('Data Created Successfully');
    } else {
      print('err');
    }
  }

}

