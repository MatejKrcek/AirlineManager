import 'package:flutter/material.dart';
import 'dart:io';

class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading, this.signWithG);

  final bool isLoading;
  final void Function(
    String email,
    String password,
    String userName,
    bool isLogin,
    BuildContext ctx,
  ) submitFn;

  final Function() signWithG;

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var _userEmail = '';
  var _userName = '';
  var _userPassword = '';

  final _emailFocusNode = FocusNode();
  final _passFocusNode = FocusNode();
  final _userFocusNode = FocusNode();

  double min = 270;
  double max = 450;
  double minHei = 380;

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 300,
      ),
    );
    _slideAnimation =
        Tween<Offset>(begin: Offset(0, -1.0), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _emailFocusNode.dispose();
    _userFocusNode.dispose();
    _passFocusNode.dispose();
    _controller.dispose();
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus(); //close opened keaboards

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _isLogin,
        context,
      );
    } else {
      setState(() {
        if (_isLogin) {
          min = 340;
        } else {
          max = 430;
        }
      });
    }
  }

  void _switch() {
    if (!_isLogin) {
      _controller.forward();
    } else {
      _controller.reverse();
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
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.linear,
          height: !_isLogin ? 430 : 270,
          width: deviceSize.width * 0.8,
          constraints: BoxConstraints(minHeight: !_isLogin ? max : min),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      key: ValueKey('email'),
                      autocorrect: false,
                      focusNode: _emailFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(
                            _isLogin ? _passFocusNode : _userFocusNode);
                      },
                      textCapitalization: TextCapitalization.none,
                      enableSuggestions: false,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Email address',
                        hintText: 'Email address',
                        icon: Icon(Icons.email),
                      ),
                      onSaved: (value) {
                        _userEmail = value;
                      },
                    ),
                    if (!_isLogin) //if true, not added
                      AnimatedContainer(
                        constraints: BoxConstraints(
                          maxHeight: !_isLogin ? 120 : 0,
                          minHeight: !_isLogin ? 60 : 0,
                        ),
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: TextFormField(
                              key: ValueKey('username'),
                              focusNode: _userFocusNode,
                              onFieldSubmitted: (_) {
                                FocusScope.of(context)
                                    .requestFocus(_passFocusNode);
                              },
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              validator: (value) {
                                if (value.isEmpty || value.length < 4) {
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
                          ),
                        ),
                      ),
                    TextFormField(
                      key: ValueKey('password'),
                      textInputAction: TextInputAction.next,
                      focusNode: _passFocusNode,
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters long.';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Password',
                        icon: Icon(Icons.lock),
                      ),
                      onSaved: (value) {
                        _userPassword = value;
                      },
                      obscureText: true, //hide inpit **
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    if (widget.isLoading)
                      Container(
                        margin: EdgeInsets.only(top: 70),
                        child: CircularProgressIndicator(),
                      ),
                    if (!widget.isLoading)
                      RaisedButton(
                        child: Text(
                          _isLogin ? 'Login' : 'Sign Up',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: _trySubmit,
                        color: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    if (!widget.isLoading)
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                            _switch();
                          });
                        },
                        child: Text(_isLogin
                            ? 'Create a new account'
                            : 'I already have an account'),
                      ),
                    if (!widget.isLoading && !_isLogin)
                      AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.linear,
                        child: FadeTransition(
                          opacity: _opacityAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Divider(
                                            color: Colors.black,
                                            height: 36,
                                          )),
                                    ),
                                    Text("OR"),
                                    Expanded(
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 10.0, right: 10.0),
                                          child: Divider(
                                            color: Colors.black,
                                            height: 36,
                                          )),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 15),
                                  child: OutlineButton(
                                    splashColor: Colors.grey,
                                    onPressed: widget.signWithG,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    highlightElevation: 0,
                                    borderSide: BorderSide(color: Colors.grey),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 10, 0, 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Image(
                                              image: AssetImage(
                                                  "assets/google_logo.png"),
                                              height: 15.0),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              'Sign in with Google',
                                              style: TextStyle(
                                                //fontSize: 15,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
