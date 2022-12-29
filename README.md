# card_hero

A widget which allows basic container transform animations, without the limitiations of the OpenContainer widget in the animations package.

Based upon the local_hero package

## Usage

To be animated implicitly, a widget needs to be surrounded by a `CardHero` widget with a unique `tag`:

```dart
const CardHero(
    tag: 'my_widget_tag',
    child: MyWidget(),
),
```

A `CardHero` widget must have a `CardHeroScope` ancestor which hosts the animations properties (duration, curve, etc.).
At each frame we must have only one `CardHero` per tag, per `CardHeroScope`.

The following example needs to be updated to show the basic usage of a `CardHero` widget:

```dart
class _CardHeroPage extends StatelessWidget {
  const _CardHeroPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CardHeroScope(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: const _CardHeroPlayground(),
        ),
      ),
    );
  }
}

class _CardHeroPlayground extends StatefulWidget {
  const _CardHeroPlayground({
    Key key,
  }) : super(key: key);

  @override
  _CardHeroPlaygroundState createState() => _CardHeroPlaygroundState();
}

class _CardHeroPlaygroundState extends State<_CardHeroPlayground> {
  AlignmentGeometry alignment = Alignment.topLeft;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Align(
              alignment: alignment,
              child: const CardHero(
                tag: 'id',
                child: _Box(),
              ),
            ),
          ),
        ),
        RaisedButton(
          onPressed: () {
            setState(() {
              alignment = alignment == Alignment.topLeft
                  ? Alignment.bottomRight
                  : Alignment.topLeft;
            });
          },
          child: const Text('Move'),
        ),
      ],
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      width: 50,
      height: 50,
    );
  }
}
```
