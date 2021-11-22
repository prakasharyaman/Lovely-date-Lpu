import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class VertoBase {
  Map<String, String> headers = {};

  get(String url) async {
    try {
      http.Response response = await http.get(Uri.parse(url), headers: headers);
      updateCookie(response: response);
      print('get request success');
      return response.body;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  post({required String url, required Map payload}) async {
    try {
      http.Response response =
          await http.post(Uri.parse(url), headers: headers, body: payload);
      updateCookie(response: response);
      print('post request success');
      return response.body;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  void updateCookie({required http.Response response}) {
    String? rawCookie = response.headers['set-cookie'];
    if (rawCookie != null) {
      int index = rawCookie.indexOf(';');
      headers['cookie'] =
          (index == -1) ? rawCookie : rawCookie.substring(0, index);
    }
  }

  tokenGetter(pageData, tokenList, payload) {
    for (int i = 0; i < tokenList.length; i++) {
      var document = parse(pageData);
      print("changing value of logintokn");
      print(tokenList[i]);
      payload.update(tokenList[i], (v) {
        print(document.getElementById(tokenList[i])!.attributes['value']);

        return document.getElementById(tokenList[i])!.attributes['value'];
      });
    }

    return payload;
  }

  keySetter(loginpage, Map payload) {
    var document = parse(loginpage);
    payload['__VIEWSTATE'] =
        document.getElementById('__VIEWSTATE')!.attributes['value'];
    payload['__EVENTVALIDATION'] =
        document.getElementById('__EVENTVALIDATION')!.attributes['value'];
    print(payload);
    return payload;
  }

  getTheName(umsHomePage) {
    var umsHomeData = parse(umsHomePage);
    var name;
    try {
      if (umsHomeData.getElementById('ctl00_cphHeading_Logoutout1_lblId') !=
          null) {
        name = umsHomeData
            .getElementById('ctl00_cphHeading_Logoutout1_lblId')!
            .text;

        print('name request success');
        return name;
      } else {
        return '';
      }
    } on Exception catch (e) {
      print(e);
      return '';
    }
  }
}
