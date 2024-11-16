import 'package:flutter/material.dart';
import 'package:submission_story_app/utils/date_formatter.dart';
import '../../provider/list_story_provider.dart';
import '../../shared/widgets/gap.dart';
import '../../shared/widgets/loading.dart';

Widget cardListWidget(BuildContext context, ListStoryProvider data, int index) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    width: MediaQuery.of(context).size.width,
    decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RichText(
                text: TextSpan(
                    text: "by ",
                    style: Theme.of(context).textTheme.titleSmall,
                    children: [
                  TextSpan(
                      text: data.list?[index].name,
                      style: Theme.of(context).textTheme.titleMedium)
                ])),
            const Spacer(),
            Text(DateFormatter().formatDate(data.list![index].createdAt),
                style: Theme.of(context).textTheme.titleSmall),
          ],
        ),
        const Gap.v(h: 8),
        ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Hero(
              tag: "imageStory",
              child: Image.network(
                data.list![index].photoUrl,
                width: MediaQuery.of(context).size.width,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Loading().imageLoading(context);
                },
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return Loading().imageError(context);
                },
              ),
            )),
        const Gap.v(h: 4),
        Row(
          children: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.favorite_border)),
            const Gap.h(w: 4),
            IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble_outline_rounded)),
            const Gap.h(w: 4),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
          ],
        ),
        Text(
          data.list![index].description,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
