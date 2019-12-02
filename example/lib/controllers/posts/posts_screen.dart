import 'package:example/controllers/posts/posts_manager.dart';
import 'package:example/model/post_list.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class PostsScreen extends StatefulWidget {
  final PostsManager _manager;

  PostsScreen(this._manager);

  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  var _postsList = PostsList([]);
  var _isLoading = false;
  var _sliderValue = 0.0;

  PostsManager get manager => widget._manager;

  @override
  void initState() {
    super.initState();
    manager.viewModel.compositeSubscription.add(
      manager.viewModel.isLoading_PostsList$()
          .listen(_updateUI),
    );
  }

  @override
  void dispose() {
    manager.viewModel.dispose();
    super.dispose();
  }

  void _updateUI(Tuple2<bool, PostsList> model) {
    setState(() {
      _isLoading = model.item1;
      _postsList = model.item2;
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: Column(
              children: <Widget>[
                Slider(
                  min: 0,
                  max: 9,
                  value: _sliderValue,
                  onChanged: (page) {
                    manager.sink.setPage(page.toInt());
                    setState(() => _sliderValue = page);
                  },
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: _postsList().length,
                      padding: EdgeInsets.all(8),
                      itemBuilder: (context, index) => Card(
                            elevation: 4,
                            child: ListTile(
                              title: Text(
                                "${_postsList()[index].id}: ${_postsList()[index].title}",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(_postsList()[index].body),
                              onTap: () => print(_postsList()[index].id),
                            ),
                          )),
                )
              ],
            ),
          ),
          if (_isLoading)
            Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      );
}
