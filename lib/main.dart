import 'package:flutter/material.dart';
import 'package:thanos_snap_flutter/aniamte/dust_controller.dart';
import 'package:thanos_snap_flutter/aniamte/dust_effect_container.dart';
import 'package:thanos_snap_flutter/test_dust_draw.dart';
import 'aniamte/thanos_gauntlet.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DustController dustController;

  @override
  void initState() {
    super.initState();
    dustController = DustController(showDust: false, showDustAnimation: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 20)),
          Center(
            child: Text(
              '灭霸🤟',
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'images/baidu.png',
                  height: 40,
                  fit: BoxFit.fitHeight,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    '灭霸需要你消失!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          DustEffectContainer(
            dustController: dustController,
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/baidu.png',
                    height: 40,
                    fit: BoxFit.fitHeight,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text(
                      '灭霸需要你消失!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 20)),
          Center(
            child: Image.asset(
              'images/baidu.png',
              height: 40,
              fit: BoxFit.fitHeight,
            ),
          ),
          TestDustDrawDemo(),
        ],
      ),
      floatingActionButton: ThanosGauntlet(
        onPressed: (action) {
          if (action == ThanosGauntletAction.snap) {
            dustController.showDust();
          }
          if(action == ThanosGauntletAction.reverse) {

          }
        },
        onAnimationComplete: (action) {
          if (action == ThanosGauntletAction.snap) {
            dustController.startDustAnimation();
          }
          if (action == ThanosGauntletAction.reverse) {
            dustController.hiddenDust();
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
