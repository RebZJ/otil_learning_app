import 'package:flutter/material.dart';
import 'package:flutter_gradients/flutter_gradients.dart';
import 'package:otil/options_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:simple_animations/simple_animations.dart';

class FadeIn extends StatefulWidget {
  final double delay;
  final Widget child;
  final direction;

  FadeIn(this.delay, this.direction, this.child);

  @override
  _FadeInState createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> {
  double begin = 40.0;
  double end = 0.0;

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 1.0)),
      Track("translateX").add(
          Duration(milliseconds: 500),
          Tween(
              begin: (widget.direction == "left" ? begin : -begin),
              end: (widget.direction == "left" ? end : end)),
          curve: Curves.easeOutCubic)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (300 * widget.delay).round()),
      duration: tween.duration,
      tween: tween,
      child: widget.child,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: Offset(animation["translateX"], 0), child: child),
      ),
    );
  }
}

class Screen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  // or as a local variable
  AudioCache player = AudioCache();
  bool isSwitched = false;
  @override
  void initState() {
    super.initState();
    player.play('intro_jingle.wav');
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<OptionsModel>(
      builder: (context, child, model) => AnimatedContainer(
          duration: Duration(milliseconds: 500),
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [(model.isSwitched == true ? 0.6 : 0.3), 0.9],
            colors: [
              (model.isSwitched == true
                  ? Colors.indigo[800]
                  : Colors.indigo[600]),
              (model.isSwitched == true
                  ? Colors.pink[500]
                  : Colors.pinkAccent[200]),
            ],
          )),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            floatingActionButton: //this goes in as one of the children in our column
                FadeIn(
              5,
              'right',
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Challenge Mode",
                    style: TextStyle(color: Colors.white),
                  ),
                  Switch(
                    value: model.isSwitched,
                    onChanged: (value) {
                      model.isitSwitched(value);

                      return model.isSwitched;
                    },
                    activeTrackColor: Colors.lightBlueAccent,
                    activeColor: Colors.blue,
                  ),
                ],
              ),
            ),
            body: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Logostack(),
                    ),
                    Homepagebuttons()
                  ],
                ),
              ),
            ),
          )),
    );
  }
}

class Homepagebuttons extends StatefulWidget {
  @override
  _HomepagebuttonsState createState() => _HomepagebuttonsState();
}

class _HomepagebuttonsState extends State<Homepagebuttons> {
  @override
  Widget build(BuildContext context) {
    return FadeIn(
      3,
      "left",
      SizedBox(
        width: 120,
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 25, 0, 5),
                child: MenuButtons(head: "New Entry", route: '/entrypage'),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                  child: MenuButtons(head: 'Entires', route: '/entrylist')),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                  child: MenuButtons(head: 'Categories', route: '/categories')),
              Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 5),
                  child: MenuButtons(head: 'Options', route: '/options')),
            ],
          ),
        ),
      ),
    );
  }
}

//menu button (singular) this is build into a column of them
class MenuButtons extends StatefulWidget {
  final String head;
  final String route;
  const MenuButtons(
      {this.head, this.route = '/def'}); //def is just default route dw about it

  @override
  _MenuButtonsState createState() => _MenuButtonsState();
}

class _MenuButtonsState extends State<MenuButtons> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      splashColor: Colors.blueAccent,
      minWidth: 120.0,
      onPressed: () => Navigator.pushNamed(context, widget.route),
      child: Text(
        widget.head,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      padding: EdgeInsets.all(10),
    );
  }
}

class Logostack extends StatefulWidget {
  const Logostack({
    Key key,
  }) : super(key: key);

  @override
  _LogostackState createState() => _LogostackState();
}

class _LogostackState extends State<Logostack> {
  final Shader linearGradient1 = FlutterGradient.landingAircraft().createShader(
      Rect.fromCenter(center: Offset(0, 0), width: 100, height: 100));

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      0,
      "right",
      ScopedModelDescendant<OptionsModel>(
        builder: (BuildContext context, Widget child, OptionsModel model) =>
            Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "OTIL",
              style: TextStyle(
                  fontFamily: 'lato',
                  letterSpacing: 10,
                  foreground: Paint()..shader = linearGradient1,
                  fontSize: 80),
            ),
            AnimatedContainer(
              curve: Curves.easeInToLinear,
              duration: Duration(milliseconds: 250),
              height: (model.isSwitched == true ? 30 : 0),
              child: AnimatedOpacity(
                duration: Duration(
                  milliseconds: 550,
                ),
                opacity: (model.isSwitched == true ? 1 : 0),
                child: Text(
                  "Challenge",
                  style: TextStyle(
                      foreground: Paint()..shader = linearGradient1,
                      fontFamily: 'lato',
                      fontSize: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                Icons.book,
                color: Colors.white,
                size: 40.0,
                semanticLabel: 'Logo',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
