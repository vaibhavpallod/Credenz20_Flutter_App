import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SerializedForm(),
    );
  }
}

class SerializedFormBloc extends FormBloc<String, String> {
  final name = TextFieldBloc(
    name: 'name',
  );

  final gender = SelectFieldBloc(
    name: 'gender',
    items: ['male', 'female'],
  );

  final birthDate = InputFieldBloc<DateTime, Object>(
    name: 'birthDate',
    toJson: (value) => value.toUtc().toIso8601String(),
  );

  SerializedFormBloc() {
    addFieldBlocs(
      fieldBlocs: [
        name,
        gender,
        birthDate,
      ],
    );
  }

  @override
  void onSubmitting() async {
    emitSuccess(
      canSubmitAgain: true,
      successResponse: JsonEncoder.withIndent('    ').convert(
        state.toJson(),
      ),
    );
  }
}

class SerializedForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SerializedFormBloc(),
      child: Builder(
        builder: (context) {
          final formBloc = context.bloc<SerializedFormBloc>();

          return Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: AppBar(title: Text('Serialized Form')),
              floatingActionButton: FloatingActionButton(
                onPressed: formBloc.submit,
                child: Icon(Icons.send),
              ),
              body: FormBlocListener<SerializedFormBloc, String, String>(
                onSuccess: (context, state) {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(state.successResponse),
                    duration: Duration(seconds: 2),
                  ));
                },
                child: SingleChildScrollView(
                  physics: ClampingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        TextFieldBlocBuilder(
                          textFieldBloc: formBloc.name,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Name',
                            prefixIcon: Icon(Icons.people),
                          ),
                        ),
                        RadioButtonGroupFieldBlocBuilder<String>(
                          selectFieldBloc: formBloc.gender,
                          itemBuilder: (context, value) =>
                          value[0].toUpperCase() + value.substring(1),
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            prefixIcon: SizedBox(),
                          ),
                        ),
                        DateTimeFieldBlocBuilder(
                          dateTimeFieldBloc: formBloc.birthDate,
                          format: DateFormat('dd-mm-yyyy'),
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(2100),
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            prefixIcon: Icon(Icons.calendar_today),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class LoadingDialog extends StatelessWidget {
  static void show(BuildContext context, {Key key}) => showDialog<void>(
    context: context,
    useRootNavigator: false,
    barrierDismissible: false,
    builder: (_) => LoadingDialog(key: key),
  ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

  static void hide(BuildContext context) => Navigator.pop(context);

  LoadingDialog({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Center(
        child: Card(
          child: Container(
            width: 80,
            height: 80,
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  SuccessScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.tag_faces, size: 100),
            SizedBox(height: 10),
            Text(
              'Success',
              style: TextStyle(fontSize: 54, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            RaisedButton.icon(
              onPressed: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => SerializedForm())),
              icon: Icon(Icons.replay),
              label: Text('AGAIN'),
            ),
          ],
        ),
      ),
    );
  }
}
/*Form(
                      key: _key,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            RadioButtonGroupFieldBlocBuilder<String>(
                              selectFieldBloc: formBloc.gender,
                              itemBuilder: (context, value) =>
                              value[0].toUpperCase() + value.substring(1),
                              decoration: InputDecoration(
                                labelText: 'Gender',
                                prefixIcon: SizedBox(),
                              ),
                            ),
                            Stack(
                              children: <Widget>[
                                Container(
                                  child: Card(
                                      color: Colors.grey.shade800,
                        margin: EdgeInsets.fromLTRB(2, 10, 2, 10),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(children: [
                              TextFormField(
                                controller: p1,
                                validator: (value) {
                                  return value.isNotEmpty
                                      ? null
                                      : "Invalid Field";
                                },
                                decoration: InputDecoration(
                                    hintText: "Participant 1*",
                                    hintStyle:
                                    TextStyle(color: Colors.grey)),
                              ),
                              //Text("Participant 2: "),
                              TextFormField(
                                controller: p2,
                                decoration: InputDecoration(
                                    hintText: "Participant 2",
                                    hintStyle:
                                    TextStyle(color: Colors.grey)),
                              ),
                              //Text("Participant 3: "),
                              TextFormField(
                                controller: p3,
                                decoration: InputDecoration(
                                    hintText: "Participant 3",
                                    hintStyle:
                                    TextStyle(color: Colors.grey)),
                              ),
                              //Text("Participant 3: "),
                              TextFormField(
                                controller: p4,
                                decoration: InputDecoration(
                                    hintText: "Participant 4",
                                    hintStyle:
                                    TextStyle(color: Colors.grey)),
                              ),
                            ]),
                          )),
                                  //width: double.infinity,
                                  //height: 200,
                                  margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                                  padding: EdgeInsets.only(bottom: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Color.fromARGB(255, 51, 204, 255), width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                    shape: BoxShape.rectangle,
                                  ),
                                ),
                                Positioned(
                                    left: 50,
                                    top: 12,
                                    child: Container(
                                      padding: EdgeInsets.only(bottom: 10, left: 5, right: 5),
                                      color: Colors.grey.shade800,
                                      child: Text(
                                        'Enter Usernames',
                                        style: TextStyle(color: Colors.black, fontSize: 12),
                                      ),
                                    )),
                              ],
                            ),
                            Card(
                                margin: EdgeInsets.fromLTRB(2, 10, 2, 10),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(children: [
                                    Text(
                                      "Enter Usernames: ",
                                      textAlign: TextAlign.left,
                                    ),
                                    TextFormField(
                                      controller: p1,
                                      validator: (value) {
                                        return value.isNotEmpty
                                            ? null
                                            : "Invalid Field";
                                      },
                                      decoration: InputDecoration(
                                          hintText: "Participant 1*",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                    ),
                                    //Text("Participant 2: "),
                                    TextFormField(
                                      controller: p2,
                                      decoration: InputDecoration(
                                          hintText: "Participant 2",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                    ),
                                    //Text("Participant 3: "),
                                    TextFormField(
                                      controller: p3,
                                      decoration: InputDecoration(
                                          hintText: "Participant 3",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                    ),
                                    //Text("Participant 3: "),
                                    TextFormField(
                                      controller: p4,
                                      decoration: InputDecoration(
                                          hintText: "Participant 4",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                    ),
                                  ]),
                                )),
                            Card(
                              margin: EdgeInsets.fromLTRB(2, 10, 2, 10),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      "Enter Emails: ",
                                      textAlign: TextAlign.left,
                                    ),
                                    TextFormField(
                                      controller: e1,
                                      validator: (value) {
                                        return value.isNotEmpty
                                            ? null
                                            : "Invalid Field";
                                      },
                                      decoration: InputDecoration(
                                          hintText: "Email 1*",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                    ),
                                    //Text("Participant 2: "),
                                    TextFormField(
                                      controller: e2,
                                      decoration: InputDecoration(
                                          hintText: "Email 2",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Card(
                                margin: EdgeInsets.fromLTRB(2, 10, 2, 10),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      Text(
                                        "Select Category: ",
                                        textAlign: TextAlign.left,
                                      ),
                                      Container(
                                        //height: 300,
                                        //width: 300,
                                        child: ListView.builder(
                                          itemBuilder: (context, index) {
                                            return Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Radio(
                                                      value: options[index],
                                                      groupValue: selectedValue,
                                                      onChanged: (s) {
                                                        setState(() {
                                                          selectedValue = s;
                                                        });
                                                      }),
                                                  Text(options[index]),
                                                ],
                                              ),
                                            );
                                          },
                                          itemCount: options.length,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                        ),
                                      ),
                                    ]))),
                            Card(
                                margin: EdgeInsets.fromLTRB(2, 10, 2, 10),
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(children: [
                                      Text(
                                        "Select Category: ",
                                        textAlign: TextAlign.left,
                                      ),
                                      Container(
                                        child: ListView.builder(
                                          itemBuilder: (context, index) {
                                            return Container(
                                              child: Row(
                                                children: <Widget>[
                                                  Radio(
                                                      value: options1[index],
                                                      groupValue:
                                                          selectedValue1,
                                                      onChanged: (s) {
                                                        selectedValue1 = s;
                                                        setState(() {});
                                                      }),
                                                  Text(options1[index]),
                                                ],
                                              ),
                                            );
                                          },
                                          itemCount: options1.length,
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                        ),
                                      ),
                                    ]))),
                            RaisedButton(
                              child: Text("Submit"),
                              onPressed: () {
                                if (_key.currentState.validate()) {
                                  _key.currentState.save();
                                  Navigator.of(context).pop();
                                }
                              },
                            )
                          ],
                        ),
                      ),
                    ),*/

/*

actions: [
RaisedGradientButton(
height: 35,
width: 60,
gradient: LinearGradient(colors: commonGradient),
child: activeStep == 0 ? Text("Cancel") : Text("Back"),
onPressed: () {
if (activeStep == 1) {
setState(() {
activeStep = 0;
});
} else
Navigator.of(context).pop();
},
),
RaisedGradientButton(
height: 35,
width: 60,
gradient: LinearGradient(colors: commonGradient),
child: activeStep == 0 ? Text('Next') : Text("Submit"),
onPressed: () {
if (activeStep == 0) {
setState(() {
activeStep = 1;
});
} else
Navigator.of(context).pop();
},
),
],
*/










