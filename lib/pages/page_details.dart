import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: FutureBuilder(
          future: DefaultAssetBundle.of(context).loadString('assets/markdown/test.md'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Markdown(data: snapshot.data.toString());
            }
            return Center(child: CircularProgressIndicator()); // 显示加载指示器
          },
        ),
      ),
    );
  }
}
