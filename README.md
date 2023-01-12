# material_hero

A widget which allows basic container transform animations, without the limitiations of the OpenContainer widget in the animations package.

Based upon the local_hero package

## Usage

To be animated implicitly, a widget needs to be surrounded by a `MaterialHero` widget with a unique `tag`:

```dart
const MaterialHero(
    tag: 'my_widget_tag',
    child: MyWidget(),
),
```

A `MaterialHero` widget must have a `MaterialHeroScope` ancestor which hosts the animations properties (duration, curve, etc.).
At each frame we must have only one `MaterialHero` per tag, per `MaterialHeroScope`.

The following example needs to be updated to show the basic usage of a `MaterialHero` widget:

```dart
class _MaterialHeroPage extends StatelessWidget {
  const _MaterialHeroPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MaterialHeroScope(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: const _MaterialHeroPlayground(),
        ),
      ),
    );
  }
}

class _MaterialHeroPlayground extends StatefulWidget {
  const _MaterialHeroPlayground({
    Key key,
  }) : super(key: key);

  @override
  _MaterialHeroPlaygroundState createState() => _MaterialHeroPlaygroundState();
}

class _MaterialHeroPlaygroundState extends State<_MaterialHeroPlayground> {
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
              child: const MaterialHero(
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
