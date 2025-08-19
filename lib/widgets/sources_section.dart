
import 'package:flutter/material.dart';
import 'package:perplexity_clon/services/chat_web_service.dart';
import 'package:perplexity_clon/services/theme/colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SourcesSection extends StatefulWidget {
  const SourcesSection({super.key});

  @override
  State<SourcesSection> createState() => _SourcesSectionState();
}

class _SourcesSectionState extends State<SourcesSection> {
  bool isLoading = true;

  List searchResults = [
    {
      'title': 'Ind vs Aus Live Score 4th Test',
      'url':
          'https://www.moneycontrol.com/sports/cricket/ind-vs-aus-live-score-4th-test-shubman-gill-dropped-australia-win-toss-opt-to-bat-liveblog-12897631.html',
    },
  ];

  @override
  void initState() {
    super.initState();
    ChatWebService().searchResultStream.listen((data) {
      setState(() {
        searchResults = data['data'];
        isLoading = false;
      });
    });
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_blank',
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.source_outlined,
              color: Colors.white70,
            ),
            const SizedBox(width: 8),
            Text(
              "Sources",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textColor,
              ),
            )
          ],
        ),
        const SizedBox(height: 16),
        Skeletonizer(
          enabled: isLoading,
          child: LayoutBuilder(
            builder: (context, constraints) {
              double boxWidth = constraints.maxWidth < 500
                  ? constraints.maxWidth
                  : 200;

              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: searchResults
                    .map((res) => SizedBox(
                          width: boxWidth,
                          height: 120,
                          child: InkWell(
                            onTap: () => _launchURL(res['url']),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.cardColor,
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.grey.shade800),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _formatTitle(res['title']),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textColor,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    _formatUrl(res['url']),
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 12,
                                      decoration: TextDecoration.underline,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              );
            },
          ),
        )
      ],
    );
  }

  // Helper function to format titles
  String _formatTitle(String title) {
    return title
        .replaceAll('|', '-')
        .replaceAll('Problem', '')
        .trim();
  }

  // Helper function to format URLs
  String _formatUrl(String url) {
    return url
        .replaceAll('https://', '')
        .replaceAll('http://', '')
        .split('/')
        .first;
  }
}
