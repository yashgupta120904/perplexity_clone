

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:perplexity_clon/widgets/answer_section.dart';
import 'package:perplexity_clon/widgets/side_bar.dart';
import 'package:perplexity_clon/widgets/sources_section.dart';

class ChatPage extends StatelessWidget {
  final String question;
  const ChatPage({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: kIsWeb
          ? Row(
              children: [
                /// Sidebar only for web
                const SideBar(),

                /// Space between sidebar and content
                const SizedBox(width: 24),

                /// Main Chat Content - Expand le lund
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        const SourcesSection(),
                        const SizedBox(height: 24),
                        const AnswerSection(),
                      ],
                    ),
                  ),
                ),

                /// Right Placeholder - optional, just make sure it doesn’t cause overflow
                Expanded(
                  flex: 2,
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ],
            )
          : SafeArea(
              /// For mobile - no sidebar bsdk!
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SourcesSection(),
                    const SizedBox(height: 16),
                    const AnswerSection(),
                  ],
                ),
              ),
            ),
    );
  }
}
