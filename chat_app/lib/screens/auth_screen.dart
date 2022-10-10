import 'dart:io';

import 'package:chat_app/widgets/auth/auth_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthSCreen extends StatefulWidget {
  const AuthSCreen({Key? key}) : super(key: key);

  @override
  State<AuthSCreen> createState() => _AuthSCreenState();
}

class _AuthSCreenState extends State<AuthSCreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  void _submitAuthForm(
    String email,
    String password,
    String username,
    File image,
    bool isLogin,
    BuildContext ctx,
  ) async {
    var authResult;

    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        final ref = FirebaseStorage.instance
            .ref()
            .child('user_image')
            .child(authResult.user.uid + '.jpg');

        await ref.putFile(image).whenComplete(() async {
          final url = await ref.getDownloadURL();

          await FirebaseFirestore.instance
              .collection('users')
              .doc(authResult.user.uid)
              .set({
            'username': username,
            'email': email,
            'image_url': url,
          });
        });
      }
    } on FirebaseAuthException catch (e) {
      var message = 'An error occured';

      if (e.message != null) {
        message = e.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Extra error: $e');

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: AuthForm(_submitAuthForm, _isLoading),
    );
  }
}
