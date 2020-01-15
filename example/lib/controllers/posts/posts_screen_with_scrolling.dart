import 'package:example/base/view.dart';
import 'package:example/controllers/posts/posts_manager.dart';
import 'package:example/controllers/posts/posts_view_model.dart';
import 'package:example/model/post.dart';
import 'package:flutter/material.dart';
import 'package:routex/routex.dart';

// ignore: must_be_immutable
class PostsScreenWithScrolling extends BaseView<PostsViewModel> {
  PostsManager manager;

  @override
  get model => manager.viewModel;
  get sink => manager.sink;

  PostsScreenWithScrolling(this.manager);

  @override
  void handleManagedFields() {
    manager = managedField(() => manager);
  }

  @override
  Widget buildWidget(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text("Posts with scrolling")),
        body: Stack(
          children: <Widget>[
            Container(
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Observer<List<Post>>(
                    stream: model.posts,
                    onSuccess: (ctx, posts) => Expanded(
                      child: ListView.builder(
                          itemCount: posts.length,
                          padding: EdgeInsets.all(8),
                          itemBuilder: (context, index) =>
                              buildItem(posts[index], index)),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );

  Widget buildItem(Post model, int index) {
    sink.addRowIndex(index);
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          "${model.id}: ${model.title}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(model.body),
        onTap: () => print(model.id),
      ),
    );
  }
}
