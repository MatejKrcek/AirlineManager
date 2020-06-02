import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);

  final bool isLoading;
  final void Function(
    String userName,
    String airlineName,
    BuildContext ctx,
  ) submitFn;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var _userName = '';
  var _airlineName = '';

  final _airlineFocusNode = FocusNode();
  final _userFocusNode = FocusNode();

  @override
  void dispose() {
    super.dispose();
    _userFocusNode.dispose();
    _airlineFocusNode.dispose();
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus(); //close opened keaboards

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userName.trim(),
        _airlineName.trim(),
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        margin: EdgeInsets.all(20),
        child: Container(
          height: 240,
          width: deviceSize.width * 0.8,
          constraints: BoxConstraints(minHeight: 240),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      key: ValueKey('username'),
                      focusNode: _userFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_airlineFocusNode);
                      },
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty || value.length < 2) {
                          return 'Please enter a valid username';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Username',
                        hintText: 'Username',
                        icon: Icon(Icons.person),
                      ),
                      onSaved: (value) {
                        _userName = value;
                      },
                    ),
                    TextFormField(
                      key: ValueKey('airlineName'),
                      focusNode: _airlineFocusNode,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty || value.length < 2) {
                          return 'Please enter a valid airline name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Airline Name',
                        hintText: 'Airline Name',
                        icon: Icon(Icons.airplanemode_active),
                      ),
                      onSaved: (value) {
                        _airlineName = value;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading)
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: CircularProgressIndicator(),
                      ),
                    if (!widget.isLoading)
                      RaisedButton(
                        child: Text(
                          'Create account',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _trySubmit,
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
