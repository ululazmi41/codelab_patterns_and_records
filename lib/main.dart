import 'package:flutter/material.dart';
import 'package:patterns_codelab/data.dart';

void main() {
  runApp(const DocumentApp());
}

class DocumentApp extends StatelessWidget {
  const DocumentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: DocumentScreen(
        document: Document(),
      ),
    );
  }
}

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({
    required this.document,
    super.key,
  });

  final Document document;

  @override
  Widget build(BuildContext context) {
    final (title, :modified) = document.metadata;
    final formattedModifiedDate = formatDate(modified);
    final blocks = document.getBlocks();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Last modified $formattedModifiedDate"),
          Expanded(
            child: ListView.builder(
              itemCount: blocks.length,
              itemBuilder: (context, index) {
                return BlockWidget(block: blocks[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BlockWidget extends StatefulWidget {
  const BlockWidget({
    required this.block,
    super.key,
  });

  final Block block;

  @override
  State<BlockWidget> createState() => _BlockWidgetState();
}

class _BlockWidgetState extends State<BlockWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: switch (widget.block) {
        HeaderBlock(:final text) => Text(
            text,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ParagraphBlock(:final text) => Text(text),
        CheckboxBlock(:final text, :final isChecked) =>
          ExhaustiveCheckbox(text, isChecked),
      },
    );
  }
}

class ExhaustiveCheckbox extends StatefulWidget {
  const ExhaustiveCheckbox(this.text, this.defaultValue, {super.key});

  final String text;
  final bool defaultValue;

  @override
  State<ExhaustiveCheckbox> createState() => _ExhaustiveCheckboxState();
}

class _ExhaustiveCheckboxState extends State<ExhaustiveCheckbox> {
  late bool value;

  @override
  void initState() {
    value = widget.defaultValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (newValue) {
            setState(() {
              value = newValue!;
            });
          },
        ),
        Text(widget.text),
      ],
    );
  }
}

String formatDate(DateTime dateTime) {
  final today = DateTime.now();
  final difference = dateTime.difference(today);

  return switch (difference) {
    Duration(inDays: 0) => 'today',
    Duration(inDays: 1) => 'tomorrow',
    Duration(inDays: -1) => 'yesterday',
    Duration(inDays: final days) when days > 7 => '${days ~/ 7} weeks from now',
    Duration(inDays: final days) when days < -7 =>
      '${days.abs() ~/ 7} weeks ago',
    Duration(inDays: final days, isNegative: true) => '${days.abs()} days ago',
    Duration(inDays: final days) => '$days days from now',
  };
}
