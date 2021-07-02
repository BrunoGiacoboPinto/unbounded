import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unbounded Problem Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.blue[200],
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  Container(
                    height: 250,
                    child: Center(child: Text('Other stuff before it')),
                  ),
                  UnboundedTabView(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    labels: ['Tab1', 'Tab2', 'Tab3'],
                    pages: [
                      Container(
                        color: Colors.red,
                        height: 200,
                      ),
                      Container(
                        color: Colors.amber,
                        height: 300,
                      ),
                      Container(
                        color: Colors.purple,
                        height: 400,
                      ),
                    ],
                  ),
                  Container(
                    height: 150,
                    child: Center(child: Text('Other stuff after it')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UnboundedTabView extends StatefulWidget {
  const UnboundedTabView({
    Key? key,
    this.padding,
    this.labels,
    this.pages,
  }) : super(key: key);

  final List<String>? labels;
  final EdgeInsets? padding;
  final List<Widget>? pages;

  @override
  _UnboundedTabViewState createState() => _UnboundedTabViewState();
}

class _UnboundedTabViewState extends State<UnboundedTabView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabBarController;

  @override
  void initState() {
    super.initState();

    _tabBarController =
        TabController(length: widget.labels!.length, vsync: this);
  }

  @override
  void dispose() {
    _tabBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(() {
      if (_tabBarController.length != widget.labels!.length) {
        throw FlutterError(
          "Controller's length property (${_tabBarController.length}) does not match the "
          "number of tabs (${widget.labels!.length}) present in UnboundedTabBarView's labels property.",
        );
      }
      return true;
    }());

    return Padding(
      padding: widget.padding!,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Positioned.fill(
                  child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1, color: Colors.greenAccent),
                  ),
                ),
              )),
              TabBar(
                controller: _tabBarController,
                tabs: widget.labels!.map((e) => Tab(child: Text(e))).toList(),
              ),
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _UnboundedTabPagesView(
                controller: _tabBarController,
                pages: widget.pages,
              )
            ],
          ),
        ],
      ),
    );
  }
}

class _UnboundedTabPagesView extends StatefulWidget {
  const _UnboundedTabPagesView({
    Key? key,
    this.controller,
    this.pages,
  }) : super(key: key);

  final TabController? controller;
  final List<Widget>? pages;

  @override
  _UnboundedTabPagesViewState createState() => _UnboundedTabPagesViewState();
}

class _UnboundedTabPagesViewState extends State<_UnboundedTabPagesView>
    with SingleTickerProviderStateMixin {
  late Widget _currentPage;

  @override
  void initState() {
    super.initState();

    _currentPage = widget.pages!.first;

    widget.controller!.addListener(() {
      setState(() {
        _currentPage = widget.pages![widget.controller!.index];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [_currentPage],
    );
  }
}
