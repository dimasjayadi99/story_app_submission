import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_story_app/common/enum_state.dart';
import 'package:submission_story_app/provider/list_story_provider.dart';
import 'package:submission_story_app/shared/widgets/gap.dart';
import 'package:submission_story_app/shared/widgets/loading.dart';
import 'package:submission_story_app/ui/widgets/card_list_story.dart';

class HomePage extends StatefulWidget {
  final VoidCallback toSettingPage;
  final VoidCallback toAddPost;
  final Function(String?) toDetail;
  const HomePage(
      {super.key,
      required this.toSettingPage,
      required this.toAddPost,
      required this.toDetail});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<ListStoryProvider>(context, listen: false)
          .fetchListStory();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffE0E5E5),
        appBar: AppBar(
          title: Text("StoryApp",
              style: Theme.of(context).textTheme.headlineMedium),
          actions: [
            IconButton(
                onPressed: () {
                  widget.toSettingPage();
                },
                icon: const Icon(Icons.settings))
          ],
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.indigo,
            onPressed: () {
              widget.toAddPost();
            },
            child: const Icon(
              Icons.post_add,
              color: Colors.white,
            )),
        body: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<ListStoryProvider>(context, listen: false)
                .fetchListStory();
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                  child: Consumer<ListStoryProvider>(
                    builder: (context, data, _) {
                      final state = data.responseState;
                      switch (state) {
                        case ResponseState.loading:
                          return Loading().listVerticalShimmer();
                        case ResponseState.empty:
                          return Center(child: Text(data.message));
                        case ResponseState.failed:
                          return Center(child: Text(data.message));
                        case ResponseState.success:
                          return ListView.separated(
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () =>
                                        widget.toDetail(data.list![index].id),
                                    child:
                                        cardListWidget(context, data, index));
                              },
                              separatorBuilder: (context, index) =>
                                  const Gap.v(h: 16),
                              itemCount: 10);
                        default:
                          return Container();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
