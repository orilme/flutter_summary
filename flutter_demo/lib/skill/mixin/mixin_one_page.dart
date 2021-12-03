import 'package:flutter/material.dart';

/// 例子一
class MixinTestA {
  String getMessage() => 'A';
}

class MixinTestB {
  String getMessage() => 'B';
}

class MixinTestP {
  String getMessage() => 'P';
}

class MixinTestAB extends MixinTestP with MixinTestA, MixinTestB {}

class MixinTestBA extends MixinTestP with MixinTestB, MixinTestA {}

void testOne() {
  String result = '';
  MixinTestAB ab = MixinTestAB();
  result += ab.getMessage();
  MixinTestBA ba = MixinTestBA();
  result += ba.getMessage();
  print('MixinTest---${result}'); // MixinTest---BA
}

/// 例子二
class MixinTestTwoA {
  printMessage() => print('A');
}

class MixinTestTwoB {
  printMessage() => print('B');
}

mixin MixinTestTwoC on MixinTestTwoA {
  printMessage() {
    super.printMessage();
    print('C');
  }
}

class MixinTestTwoD with MixinTestTwoA, MixinTestTwoB, MixinTestTwoC {
  printMessage() => super.printMessage();
}

class MixinTestTwoF with MixinTestTwoA, MixinTestTwoC {
  printMessage() => super.printMessage();
}

void testTwo() {
  MixinTestTwoD().printMessage(); // B , C
  MixinTestTwoF().printMessage(); // A , C
}

/// 例子三
abstract class Animal {}

abstract class Mammal extends Animal {}

abstract class Bird extends Animal {}

abstract class Fish extends Animal {}

mixin Walker {
  void walk() {
    print("I'm walking");
  }
}

mixin Swimmer {
  void swim() {
    print("I'm swimming");
  }
}

mixin Flyer {
  void fly() {
    print("I'm flying");
  }
}
class Dolphin extends Mammal with Swimmer {}

class Bat extends Mammal with Walker, Flyer {}

class Cat extends Mammal with Walker {}

class Dove extends Bird with Walker, Flyer {}

class Duck extends Bird with Walker, Swimmer, Flyer {}

class Shark extends Fish with Swimmer {}

class FlyingFish extends Fish with Swimmer, Flyer {}


class MixinOnePage extends StatefulWidget {
  @override
  _MixinOnePageState createState() => _MixinOnePageState();
}

class _MixinOnePageState extends State<MixinOnePage> {
  @override
  void initState() {
    super.initState();
    testOne();
    testTwo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mixin"),
          backgroundColor: Colors.blue,
        ),
        body: Container(
          color: Colors.red,
        ),
    );
  }
}


