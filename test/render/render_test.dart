import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_md/flutter_md.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final platform = Platform.operatingSystem;

  final markdownSources = <String, String>{
    'unordered_list': r'''
### Unordered List
- First item
- Second item
  - Sub-item
''',
    'ordered_list': r'''
### Ordered List
1. Step 1
2. Step 2
   1. Sub-step 1
''',
    'blockquote': r'''
### Blockquote
> This is a blockquote.
''',
    'table': r'''
### Table
| Header 1 | Header 2 |
|----------|----------|
| Cell 1   | Cell 2   |
| Cell 3   | Cell 4   |
''',
    'horizontal_rule': r'''
### Horizontal Rule
---
''',
    'headings': r'''
#Header
# This is a Heading h1
## This is a Heading h2
### This is a Heading h3
#### This is a Heading h4
##### This is a Heading h5
###### This is a Heading h6
''',
    'emphasis': r'''
## Emphasis

*This text will be italic*
_This will also be italic_

**This text will be bold**

__This will be underline__

`This is inline code`

~~This text will be strikethrough~~

==This text will be highlighted==

_`You` **can** __combine__ ~~them~~_
''',
    'links': r'''
## Links

You may be using [Markdown Live Preview](https://markdownlivepreview.com/).
'''
  };

  final themes = <String, ThemeData>{
    'light': ThemeData.light(),
    'dark': ThemeData.dark(),
  };

  group('MarkdownWidget golden tests', () {
    void runGoldenTest(String name, String markdown) {
      themes.forEach((themeName, themeData) {
        testWidgets('$name - $themeName', (WidgetTester tester) async {
          await tester.pumpWidget(
            MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: themeData,
              home: Scaffold(
                body: Center(
                  child: MarkdownWidget(
                    markdown: Markdown.fromString(markdown),
                  ),
                ),
              ),
            ),
          );

          await expectLater(
            find.byType(MarkdownWidget),
            matchesGoldenFile('goldens/$platform/${name}_$themeName.png'),
          );
        });
      });
    }

    markdownSources.forEach((name, markdown) {
      runGoldenTest(name, markdown);
    });
  });
}
