import 'dart:convert' show jsonDecode, utf8;
import 'package:flutter/material.dart';
import 'package:flutter_django_projects/DjangoModel.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Django App",
      home: Anasayfa(),
    );
  }
}

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  List<Users> users = [];

  Future<DjangoModel?> callUsers() async {
    String url = "http://192.168.1.4:8000/users/?format=json";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var result = djangoModelFromJson(utf8.decode(response.bodyBytes));
      return result;
    } else {
      print("Response hatası => ${response.statusCode}");
    }
  }

  Future<DjangoModel?> _refreshPage(BuildContext context) async {
    return callUsers();
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (context) => UsersAdd())),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text("Anasayfa"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _refreshPage(context);
          });
        },
        child: FutureBuilder<DjangoModel?>(
          future: callUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.users!.length,
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 5),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    margin:
                        EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              offset: Offset(1, 1),
                              blurRadius: 11,
                              spreadRadius: 1),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            child: Text(snapshot.data!.users![index].name![0]),
                          ),
                          title: Text(
                            snapshot.data!.users![index].name!,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          subtitle: Text(snapshot.data!.users![index].lastName!,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Yaş: ${snapshot.data!.users![index].age!}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                            Text(
                                "Üniversite: ${snapshot.data!.users![index].university!}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                            Text("Meslek: ${snapshot.data!.users![index].job!}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ); // For child objects
            } else if (snapshot.hasError) {
              return Center(
                  child: Text("Bilinmeyen bir hata oluştu: ${snapshot.data} "));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class UsersAdd extends StatefulWidget {
  const UsersAdd({Key? key}) : super(key: key);

  @override
  _UsersAddState createState() => _UsersAddState();
}

class _UsersAddState extends State<UsersAdd> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController nameCt = TextEditingController();
  TextEditingController lastNameCt = TextEditingController();
  TextEditingController ageCt = TextEditingController();
  TextEditingController universityCt = TextEditingController();
  TextEditingController jobCt = TextEditingController();

  Future callPostUsers() async {
    String url = "http://192.168.1.4:8000/users/";
    Map body = {
      "name": "${nameCt.text}",
      "last_name": "${lastNameCt.text}",
      "age": "${ageCt.text}",
      "university": "${universityCt.text}",
      "job": "${jobCt.text}"
    };
    var response = await http.post(Uri.parse(url), body: body);
    print(response.body);
    if (response.statusCode == 201) {
      var result = jsonDecode(response.body);
      return result;
    } else {
      print("Response hatası => ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Kullanıcı Ekle"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: nameCt,
                    decoration: InputDecoration(hintText: "İsim"),
                    validator: (value) {
                      if (value!.length == 0) return "İsim alanı boş olamaz.";
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: lastNameCt,
                    decoration: InputDecoration(hintText: "Soysisim"),
                    validator: (value) {
                      if (value!.length == 0)
                        return "Soyisim alanı boş olamaz.";
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: ageCt,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: "Yaş"),
                    validator: (value) {
                      if (value!.length == 0)
                        return "Yaş alanı boş olamaz.";
                      else if (value.length > 2) {
                        return "Lütfen geçerli bir aralık girin.";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: universityCt,
                    decoration: InputDecoration(hintText: "Üniversite"),
                    validator: (value) {
                      if (value!.length == 0)
                        return "Üniversite alanı boş olamaz.";

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: jobCt,
                    decoration: InputDecoration(hintText: "İş"),
                    validator: (value) {
                      if (value!.length == 0) return "İş alanı boş olamaz.";

                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          formKey.currentState!.save();
                          callPostUsers().then((value) {
                            print("Value => $value");
                            if (value['status']) {
                              scaffoldKey.currentState!.showSnackBar(SnackBar(
                                content: Text("İşlem Başarılı."),
                                backgroundColor: Colors.green,
                              ));
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.of(context).pop();
                              });
                            } else {
                              scaffoldKey.currentState!.showSnackBar(SnackBar(
                                content: Text("İşlem Başarısız."),
                                backgroundColor: Colors.green,
                              ));
                            }
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          side: BorderSide(color: Colors.blue, width: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Kaydet",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
