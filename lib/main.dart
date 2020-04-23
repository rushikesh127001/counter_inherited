
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class CounterModel {
  final int count;
  CounterModel({this.count=0});
  @override
  bool operator ==(other) {
    return other.count==count;
  }
  int get hashcode=>count.hashCode;

  static CounterModel of(BuildContext context){

    final BindingClassScope scope= context.dependOnInheritedWidgetOfExactType();
    /*print(scope.runtimeType);
    print(scope.currentState);  testingggggggggggggg
    print(scope.currentState.runtimeType);*/
    return scope.currentState.model;
  }
  static void update(BuildContext context,CounterModel newmodel){
    final BindingClassScope scope=context.dependOnInheritedWidgetOfExactType();
    scope.currentState.updatemodel(newmodel);
  }
}

class BindingClassScope extends InheritedWidget{
  BindingClassScope({@required this.currentState,this.child});
  final Widget child;
  final _BindingClassState currentState;
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;//oldWidget.currentState.model!=currentState.model;
  }

}

class BindingClass extends StatefulWidget{
  final Widget child;
  final CounterModel initmodel;
  BindingClass({this.child,this.initmodel});

  _BindingClassState createState()=>_BindingClassState();

}

class _BindingClassState extends State<BindingClass>{
  CounterModel model;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    model=widget.initmodel;
  }
  void updatemodel(CounterModel newmodel){
    if(newmodel.count!=model.count)
      {setState(() {
        model=newmodel;
      });}
  }
  @override
  Widget build(BuildContext context) {
    print(this.runtimeType);
    print(this.widget.child);
    return BindingClassScope(
      child: widget.child,
      currentState: this,
      );

  }

}

class MyHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return BindingClass(
      initmodel: CounterModel(),
      child: View(),
    );
  }
}

class View extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Title"),),
      body: Center(
        child: Container(
          child: Column(
            children: [
              /*RaisedButton(onPressed: () {
                final BindingClassScope scope = context.dependOnInheritedWidgetOfExactType();
                print(scope.runtimeType);
                print(scope.currentState);
                print(scope.currentState.runtimeType);
              })*/
                Text("Counter : ${CounterModel.of(context).count}"),
                RaisedButton(
                     onPressed: (){

                       CounterModel newmodel=CounterModel.of(context);
                      CounterModel.update(context, CounterModel(count:newmodel.count+2));



                     }
                 )
            ],
          ),
        ),
      ),
    );
  }
}
/*
remember dont just blindly pass context..
for eg here u passed model.of method directly to MyHomePage widget who is a child of material app so in that context inhertied widget doesnt exits/...its below tht.class


*/