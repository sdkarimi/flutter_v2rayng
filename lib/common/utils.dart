import 'package:flutter/cupertino.dart';

const defaultScrollPhysics = BouncingScrollPhysics();


extension PriceLable on int {
  String get withPriceLabel => '$this تومان';

}


const serverBoxName="servers";