import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_order/src/utils/app_config.dart' as config;
import 'package:food_order/src/utils/constants.dart';

import 'blink_widget.dart';

class ProgressDialog extends StatelessWidget {
  ProgressDialog({
    Key key,
  });

  @override
  Widget build(Object context) {
    final _appConfig = config.AppConfig(context);

    return Center(child: CircularProgressIndicator());
  }
}

class FoodHorizontalProgressDialog extends StatelessWidget {
  FoodHorizontalProgressDialog({
    Key key,
    @required this.size,
    @required this.itemCount,
  });
  final double size;
  final int itemCount;

  @override
  Widget build(Object context) {
    final _appConfig = config.AppConfig(context);

    return Container(
      width: _appConfig.appWidth(100),
      height: size,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return BlinkWidget(
            child: Container(
              width: size,
              height: size,
              padding: EdgeInsets.all(10.0),
              child: Image.asset(
                AppImages.noProductBackground,
                fit: BoxFit.fitWidth,
              ),
            ),
          );
        },
      ),
    );
  }
}

class FoodGridProgressDialog extends StatelessWidget {
  FoodGridProgressDialog({
    Key key,
    @required this.itemCount,
  });
  final int itemCount;

  @override
  Widget build(Object context) {
    final _appConfig = config.AppConfig(context);

    return GridView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio:
            (_appConfig.appWidth(100) * 0.5) / (_appConfig.appWidth(100) * 0.5),
      ),
      itemBuilder: (context, index) {
        return BlinkWidget(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Image.asset(
              AppImages.noProductBackground,
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
