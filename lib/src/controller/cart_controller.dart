import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_order/generated/locale_keys.g.dart';
import 'package:food_order/src/repository/repository.dart';
import 'package:food_order/src/utils/functions.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../models/model.dart';
import '../route/generated_route.dart';

class CartController extends ControllerMVC {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Cart> carts = <Cart>[];
  List<Cart> checkOutCarts = <Cart>[];
  double vat = 10;
  double taxAmount = 0.0;
  double deliveryFee = 50.0;
  int cartCount = 0;
  double subTotal = 0.0;
  double total = 0.0;
  bool isLoading;
  final _functions = Functions();

  CartController() {
    this.scaffoldKey = new GlobalKey<ScaffoldState>();
    isLoading = false;
  }

  Future<void> refreshCarts() async {
    listenForCarts();
  }

  void listenForCarts() async {
    setState(() {
      isLoading = true;
    });
    final List<Cart> _carts = await getCart();
    setState(() {
      carts.addAll(_carts);
      isLoading = false;
    });
    print('length: ${carts.length}');
  }

  // void listenForCarts({String message}) async {
  //   final Stream<Cart> stream = await getCart();
  //   stream.listen((Cart _cart) {
  //     if (!carts.contains(_cart)) {
  //       setState(() {
  //         carts.add(_cart);
  //       });
  //     }
  //   }, onError: (a) {
  //     scaffoldKey.currentState.showSnackBar(SnackBar(
  //       content: Text(LocaleKeys.verify_internet_connection).tr(),
  //     ));
  //   }, onDone: () {
  //     if (message != null) {
  //       scaffoldKey.currentState.showSnackBar(SnackBar(
  //         content: Text(message).tr(),
  //       ));
  //     }
  //   });
  // }

  // void listenForCartsCount({String message}) async {
  //   final Stream<int> stream = await getCartCount();
  //   stream.listen((int _count) {
  //     setState(() {
  //       this.cartCount = _count;
  //     });
  //   }, onError: (a) {
  //     scaffoldKey.currentState.showSnackBar(SnackBar(
  //       content: Text(LocaleKeys.verify_internet_connection).tr(),
  //     ));
  //   }, onDone: () {
  //     if (message != null) {
  //       scaffoldKey.currentState.showSnackBar(SnackBar(
  //         content: Text(message).tr(),
  //       ));
  //     }
  //   });
  // }

  void removeFromCart(Cart _cart) async {
    setState(() {
      this.carts.remove(_cart);
      this.checkOutCarts.remove(_cart);
    });
    // TODO: call remove cart api
    // removeCart(_cart).then((value) {
    //   scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text(LocaleKeys.the_food_was_removed_from_your_cart
    //         .tr(namedArgs: {'foodName': _cart.food.name})),
    //   ));
    // });
  }

  void addToWishList(Cart cart) {
    // TODO: call add food to wishlist api
  }

  void calculateSubtotal() async {
    subTotal = 0;
    checkOutCarts.forEach((cart) {
      if (cart.food.discount == 0) {
        subTotal += cart.quantity * cart.food.price;
      } else {
        double discountedPrice =
            cart.food.price - ((cart.food.discount * cart.food.price) / 100);
        subTotal += cart.quantity * discountedPrice;
      }
    });
    taxAmount = (subTotal + deliveryFee) * vat / 100;
    total = subTotal + taxAmount + deliveryFee;
    setState(() {});
  }

  bool checkCartSelected(Cart cart) {
    Cart existingItem = checkOutCarts.firstWhere(
        (item) => item.food.name == cart.food.name,
        orElse: () => null);
    if (existingItem != null) {
      return true;
    } else {
      return false;
    }
  }

  listenCartClicked(Cart cart) {
    Cart existingItem = checkOutCarts.firstWhere(
        (item) => item.food.name == cart.food.name,
        orElse: () => null);
    setState(() {
      if (existingItem != null)
        checkOutCarts.remove(cart);
      else
        checkOutCarts.add(cart);

      calculateSubtotal();
    });
  }

  incrementQuantity(Cart cart) {
    if (cart.quantity <= 99) {
      setState(() {
        ++cart.quantity;
        updateCart(cart);
        calculateSubtotal();
      });
    }
  }

  decrementQuantity(Cart cart) {
    if (cart.quantity > 1) {
      setState(() {
        --cart.quantity;
        updateCart(cart);
        calculateSubtotal();
      });
    }
  }

  void checkOut() {
    if (checkOutCarts.length == 0) {
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          LocaleKeys.no_cart_item.tr(),
        ),
      ));
    } else {
      // TODO: call order checkout api

      Navigator.of(context).pushNamed(checkoutRoute);
    }
  }

  void userLogin() async {
    final message = await Navigator.of(context).pushNamed(loginRoute);
    setState(() {
      _functions.showMessageWithAction(scaffoldKey, context, message);
    });
  }
}
