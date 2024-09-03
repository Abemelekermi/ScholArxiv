// ignore_for_file: file_names
import 'package:arxiv/components/each_paper_card.dart';
import 'package:arxiv/components/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({
    super.key,
    required this.downloadPaper,
    required this.parseAndLaunchURL,
  });

  final Function downloadPaper;
  final Function parseAndLaunchURL;

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  var bookmarks = [];
  bool isLoading = true;

  Future<void> getBookmarks() async {
    Box bookmarksBox = await Hive.openBox("bookmarks");
    bookmarks = await bookmarksBox.get("bookmarks") ?? [];
    await Hive.close();
    isLoading = false;
    setState(() {});
  }

  void clearBookmarks() async {
    isLoading = true;
    setState(() {});
    Box bookmarksBox = await Hive.openBox("bookmarks");
    await bookmarksBox.clear();
    await Hive.close();
    bookmarks = [];
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Bookmarks",
        ),
        actions: [
          IconButton(
            onPressed: () {
              clearBookmarks();
            },
            icon: const Icon(
              Icons.delete_forever_outlined,
            ),
          ),
        ],
      ),
      body: isLoading == true
          ? const LoadingIndicator(
              topPadding: 50.0,
            )
          : bookmarks.isNotEmpty
              ? LiquidPullToRefresh(
                  onRefresh: getBookmarks,
                  backgroundColor: Colors.white,
                  color: const Color(0xff121212),
                  animSpeedFactor: 2.0,
                  child: ListView(
                    children: bookmarks
                        .map(
                          (eachPaper) => EachPaperCard(
                            eachPaper: eachPaper,
                            downloadPaper: widget.downloadPaper,
                            parseAndLaunchURL: widget.parseAndLaunchURL,
                            isBookmarked: true,
                          ),
                        )
                        .toList(),
                  ),
                )
              : Center(
                  child: Text(
                    "No Bookmarks Yet!",
                    style: TextStyle(
                      color: Colors.grey[600]!,
                      fontSize: 16.0,
                    ),
                  ),
                ),
    );
  }
}
