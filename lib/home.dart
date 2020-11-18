import 'package:flutter/material.dart';
import 'package:sql/helper/contact.dart';
import 'package:sql/model/contact_model.dart';

class SqlfliteDemoPage extends StatefulWidget {
  @override
  _SqlfliteDemoPageState createState() => _SqlfliteDemoPageState();
}

class _SqlfliteDemoPageState extends State<SqlfliteDemoPage> {
  @override
  // ignore: override_on_non_overriding_member
  final _formKey = GlobalKey<FormState>();
  Contact _contact = Contact(); //instance of Contact class
  List<Contact> _contacts = []; //empty list
  DatabaseHelper _dbHelper; //database helper
  @override
  void initState() {
    super.initState();
    setState(() {
      _dbHelper = DatabaseHelper.instance;
      print('**********DATABASE CONNECTED***********');
    });
    _refreshContactsList();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Sqlite Curd'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _form(),
            _list(),
          ],
        ),
      ),
    );
  }

  _form() => Container(
        color: Colors.blue,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Full Name"),
                onSaved: (val) => setState(() => _contact.name = val),
                validator: (val) =>
                    (val.length == 0 ? 'This field is required' : null),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Mobile Number"),
                onSaved: (val) => setState(() => _contact.mobileNumber = val),
                validator: (val) =>
                    (val.length == 0 ? 'This field is required' : null),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                child: RaisedButton(
                    onPressed: () => _onSubmit(),
                    child: Text("Submit"),
                    color: Colors.blue[700],
                    textColor: Colors.white),
              )
            ],
          ),
        ),
      );

  _refreshContactsList() async {
    List<Contact> x = await _dbHelper.fetchContacts();
    setState(() {
      _contacts = x;
    });
  }

  _onSubmit() async {
    var form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      await _dbHelper.insertContact(_contact);
      print(_contact.name);
      _refreshContactsList();
      _resetForm();
    }
  }

  _resetForm() {
    setState(() {
      _formKey.currentState.reset();
    });
  }

  _list() => Expanded(
        child: Container(
          color: Colors.amber,
          margin: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: ListView.builder(
            itemCount: _contacts.length,
            padding: EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.account_circle,
                      color: Colors.blue[700],
                    ),
                    title: Text(
                      _contacts[index].name,
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(_contacts[index].mobileNumber),
                    onTap: () {},
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete_sweep,
                        color: Colors.blue[700],
                      ),
                      onPressed: () async {
                        await _dbHelper.deletContact(_contacts[index].id);
                        _resetForm();
                        _refreshContactsList();
                      },
                    ),
                  ),
                  Divider(
                    height: 5.0,
                  )
                ],
              );
            },
          ),
        ),
      );
}
