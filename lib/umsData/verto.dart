import 'package:lovely/umsData/vertoBase.dart';

class Verto {
  final String a;
  VertoBase vertobase = VertoBase();

  static Map payload = {
    '__LASTFOCUS': '',
    '__EVENTTARGET': 'txtU',
    '__EVENTARGUMENT': '',
    '__VIEWSTATE': '',
    '__VIEWSTATEGENERATOR': 'DD46A77E',
    '__SCROLLPOSITIONX': '0',
    '__SCROLLPOSITIONY': '0',
    '__EVENTVALIDATION': '',
    'txtU': '',
    'TxtpwdAutoId_8767': '',
    'DropDownList1': '1'
  };
  static var log1token = ['__VIEWSTATE', '__EVENTVALIDATION'];
  static var log2Dict = {
    'ddlStartWith': 'default3.aspx',
    'iBtnLogins.x': '0',
    'iBtnLogins.y': '0',
  };
  static var holdPageData = Null;

  Verto(this.a);

  Future initiater({required String regNum, required String password}) async {
    print("ok initiator started ");

    VertoBase vertobase = VertoBase();
    var loginpage = await vertobase.get('https://ums.lpu.in/lpuums/');
    payload['txtU'] = regNum;
    var updatedPayLoadOne = await vertobase.keySetter(loginpage, payload);
    print('payload received');

    var userLoginPage = await vertobase.post(
        url: 'https://ums.lpu.in/lpuums/', payload: updatedPayLoadOne);
    var lastupdatedPayLoad =
        await vertobase.keySetter(userLoginPage, updatedPayLoadOne);
    lastupdatedPayLoad['TxtpwdAutoId_8767'] = password;
    lastupdatedPayLoad['iBtnLogins.x'] = '0';
    lastupdatedPayLoad['iBtnLogins.y'] = '0';
    lastupdatedPayLoad['ddlStartWzith'] = 'StudentDashboard.aspx';
    lastupdatedPayLoad['__EVENTTARGET'] = '';
    // ignore: unused_local_variable
    var finalDestination = await vertobase.post(
        url: 'https://ums.lpu.in/lpuums/', payload: lastupdatedPayLoad);
    var onelastdestination =
        await vertobase.get('https://ums.lpu.in/lpuums/default3.aspx');
    String name = await vertobase.getTheName(onelastdestination);
    if (name == '') {
      return '';
    } else if (name != '') {
      print(name + 'this is the name');
      return name;
    }
  }
}
