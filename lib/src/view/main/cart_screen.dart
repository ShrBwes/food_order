import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_order/generated/locale_keys.g.dart';
import 'package:food_order/src/controller/cart_controller.dart';
import 'package:food_order/src/models/model.dart';
import 'package:food_order/src/repository/repository.dart';
import 'package:food_order/src/utils/app_config.dart' as config;
import 'package:food_order/src/widgets/widget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class CartScreen extends StatefulWidget {
  CartScreen({
    Key key,
    @required this.parentScaffoldKey,
    @required this.onContinuShoppingPressed,
  }) : super(key: key);

  final GlobalKey<ScaffoldState> parentScaffoldKey;
  final VoidCallback onContinuShoppingPressed;

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends StateMVC<CartScreen> {
  CartController _controller;

  _CartScreenState() : super(CartController()) {
    _controller = controller;
  }

  @override
  void initState() {
    _controller.listenForCarts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _appConfig = config.AppConfig(context);

    return (!currentUser.value.auth)
        ? MessageWidget(
            message: LocaleKeys.subtitle_login_register.tr(),
            buttonText: LocaleKeys.action_login_register.tr(),
            onButtonClicked: _controller.userLogin,
          )
        : RefreshIndicator(
            onRefresh: _controller.refreshCarts,
            child: _controller.isLoading
                ? ProgressDialog()
                : _controller.carts.length == 0
                    ? EmptyCartWidget(
                        controller: _controller,
                        onContinuShoppingPressed:
                            widget.onContinuShoppingPressed,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemCount: _controller.carts.length,
                              padding: EdgeInsets.symmetric(
                                vertical: _appConfig.verticalSpace(),
                              ),
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                    height: _appConfig.extraSmallSpace());
                              },
                              itemBuilder: (context, index) {
                                Cart cart = _controller.carts[index];
                                return CartItemWidget(
                                  controller: _controller,
                                  cart: cart,
                                  increment: () =>
                                      _controller.incrementQuantity(cart),
                                  decrement: () =>
                                      _controller.decrementQuantity(cart),
                                  onDeletePressed: () =>
                                      _controller.removeFromCart(cart),
                                  onWishListPressed: () =>
                                      _controller.addToWishList(cart),
                                  onCartSelected: () =>
                                      _controller.listenCartClicked(cart),
                                );
                              },
                            ),
                          ),
                          _controller.subTotal != 0
                              ? CheckoutFooter(
                                  deliveryFee: _controller.deliveryFee
                                      .toStringAsFixed(0),
                                  vat: _controller.vat.toString(),
                                  total: _controller.total.toStringAsFixed(2),
                                  buttonText: LocaleKeys.action_checkout.tr(),
                                  onButtonClick: _controller.checkOut,
                                )
                              : Offstage(),
                        ],
                      ),
          );
  }
}
