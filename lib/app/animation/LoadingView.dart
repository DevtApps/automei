import 'dart:ffi';

import 'package:automei/app/provider/AppStatus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingView extends StatefulWidget {
  @override
  _LoadingViewState createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppStatus>(
      builder: (c, app, child) => IgnorePointer(
        ignoring: !app.isLoading!,
        child: child ??
            AnimatedOpacity(
              opacity: app.isLoading! ? 1.0 : 0.0,
              duration: Duration(milliseconds: 400),
              child: Container(
                color: Colors.black.withAlpha(140),
                alignment: Alignment.center,
                child: Container(
                  width: 60,
                  height: 60,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.indigo,
                      borderRadius: BorderRadius.circular(500),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(180),
                          spreadRadius: 0,
                          blurRadius: 8,
                        )
                      ]),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    value: null,
                  ),
                ),
              ),
            ),
      ),
    );
  }
}
