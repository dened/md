import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_md/flutter_md.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Платформа, на которой запускается тест.
  // Используется для создания специфичных для платформы golden-файлов,
  // так как рендеринг может незначительно отличаться.
  final platform = Platform.operatingSystem;

  // Golden-тест для MarkdownRenderObject
  testWidgets('MarkdownWidget golden test', (WidgetTester tester) async {
    const markdownSource = r'''
# Markdown Render Object Test

This is a paragraph with **bold** and *italic* text.

---

## Lists

### Unordered List
- First item
- Second item
  - Sub-item

### Ordered List
1. Step 1
2. Step 2
   1. Sub-step 1

> This is a blockquote.

```dart
void main() {
  print('Hello, Golden Test!');
}
```
''';

    // Важно обернуть виджет в MaterialApp и Scaffold,
    // чтобы обеспечить консистентную тему и окружение для рендеринга.
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        // Теперь можно просто использовать ThemeData.light() или любую другую тему.
        // Шрифт 'GoldenBrics' будет применен автоматически благодаря
        // настройкам в flutter_test_config.dart.
        theme: ThemeData.light(),
        home: Scaffold(
          body: Center(
            child: MarkdownWidget(
              markdown: Markdown.fromString(markdownSource),
            ),
          ),
        ),
      ),
    );

    // expectLater с matchesGoldenFile сравнивает отрендеренный виджет
    // с эталонным изображением (golden file).
    await expectLater(
      find.byType(MarkdownWidget),
      matchesGoldenFile('goldens/$platform/markdown_render_object.png'),
    );
  });
}
