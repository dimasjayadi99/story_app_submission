import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission_story_app/common/enum_state.dart';
import 'package:submission_story_app/provider/detail_story_provider.dart';
import 'package:submission_story_app/shared/widgets/gap.dart';
import 'package:submission_story_app/utils/date_formatter.dart';

class DetailStoryPage extends StatefulWidget {
  final String id;
  const DetailStoryPage({super.key, required this.id});

  @override
  State<DetailStoryPage> createState() => _DetailStoryPageState();
}

class _DetailStoryPageState extends State<DetailStoryPage> {
  @override
  void initState() {
    final detailProvider =
        Provider.of<DetailStoryProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      detailProvider.fetchDetail(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final widthScreen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Page"),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Consumer<DetailStoryProvider>(
            builder: (context, detailProvider, _) {
              final responseState = detailProvider.responseState;
              switch (responseState) {
                case ResponseState.loading:
                  return const Center(child: CircularProgressIndicator());
                case ResponseState.failed:
                  return Center(child: Text(detailProvider.message));
                case ResponseState.success:
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                  text: TextSpan(
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                      text: "by ",
                                      children: [
                                    TextSpan(
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                        text: detailProvider
                                            .detailStoryModel!.name)
                                  ])),
                              Text(
                                  DateFormatter().formatDate(detailProvider
                                      .detailStoryModel!.createdAt),
                                  style:
                                      Theme.of(context).textTheme.labelSmall),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.location_on_outlined),
                          const Gap.h(w: 8),
                          const Icon(Icons.bookmark_border)
                        ],
                      ),
                      const Gap.v(h: 16),
                      Container(
                          width: widthScreen,
                          constraints: const BoxConstraints(maxHeight: 400),
                          child: Hero(
                              tag: "imageStory",
                              child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  child: Image.network(
                                    detailProvider.detailStoryModel!.photoUrl,
                                    fit: BoxFit.cover,
                                  )))),
                      const Gap.v(h: 16),
                      Text("Description",
                          style: Theme.of(context).textTheme.headlineSmall),
                      const Gap.v(h: 8),
                      Text(detailProvider.detailStoryModel!.description)
                    ],
                  );
                default:
                  return Container();
              }
            },
          ),
        ),
      )),
    );
  }
}
