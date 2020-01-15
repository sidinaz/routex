import 'package:rxdart/rxdart.dart';

class BaseViewModel{
  CompositeSubscription disposeBag = CompositeSubscription();
  void start(){

  }

  void dispose(){
    disposeBag.clear();
  }
}