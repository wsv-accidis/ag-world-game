import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/*
 * The worst Markdown parser implementation known to mankind since I refuse to pull in the
 * massive flutter_markdown dependency, nor will I format longer texts by creating each 
 * TextSpan instance manually like a madman. Pretty sure this runs in O(text.length) at least.
 * 
 * Supported:
 * - Emphasis (bold, italic or both)
 * - Links (with onLinkTapped event)
 * - Headings (up to three levels, only one-line syntax)
 * - Paragraphs and line breaks (free from Text.rich)
 * 
 * Not supported:
 * - Everything else
 * - Error handling, this falls over on the tiniest of syntax errors
 * - Nested tags, because I don't need them
 * - Lots of other special cases, because I don't need them
 */
class TerribleMarkdown extends StatelessWidget {
  const TerribleMarkdown({super.key, required this.text, this.onLinkTapped});

  final String text;
  final Future<void> Function(String link)? onLinkTapped;

  @override
  Widget build(BuildContext context) {
    final children = _parseText(Theme.of(context));
    return SingleChildScrollView(child: SelectionArea(child: Text.rich(TextSpan(children: children))));
  }

  List<InlineSpan> _parseText(ThemeData theme) {
    final children = List<InlineSpan>.empty(growable: true);
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      switch (text[i]) {
        case '#':
          _createPlainSpanIfNotEmpty(buffer, children, theme);
          i = _createHeadingSpan(i, children, theme);
          break;
        case '*':
        case '_':
          _createPlainSpanIfNotEmpty(buffer, children, theme);
          i = _createEmphasisSpan(i, children, theme);
          break;
        case '[':
          _createPlainSpanIfNotEmpty(buffer, children, theme);
          i = _createLinkSpan(i, children, theme);
        default:
          buffer.write(text[i]);
      }
    }

    _createPlainSpanIfNotEmpty(buffer, children, theme);
    return children;
  }

  int _createEmphasisSpan(int i, List<InlineSpan> children, ThemeData theme) {
    // Count the number of markers and advance the index to where they end
    var c = 1;
    var m = text[i++];
    for (; text[i] == m; i++, c++) {}

    // Create the appropriate inner span depending on the number of markers
    switch (c) {
      case 1:
        final italic = _defaultTextStyle(theme).copyWith(fontStyle: FontStyle.italic);
        i = _createEmphasisSpanInner(italic, m, i, children);
        break;
      case 2:
        final bold = _defaultTextStyle(theme).copyWith(fontWeight: FontWeight.bold);
        i = _createEmphasisSpanInner(bold, m, i, children);
        break;
      case >= 3:
        final boldItalic = _defaultTextStyle(theme).copyWith(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold);
        i = _createEmphasisSpanInner(boldItalic, m, i, children);
        break;
    }

    return i;
  }

  int _createEmphasisSpanInner(TextStyle style, String m, int i, List<InlineSpan> children) {
    // Count the number of characters until the first end marker
    final buffer = StringBuffer();
    for (; text[i] != m; i++) {
      buffer.write(text[i]);
    }

    // Create the span from the buffer we collected
    children.add(TextSpan(style: style, text: buffer.toString()));

    // Advance the pointer to past the end marker (tolerates unbalanced markers)
    for (; text[i] == m; i++) {}
    return i - 1;
  }

  int _createLinkSpan(int i, List<InlineSpan> children, ThemeData theme) {
    // Skip initial marker
    i++;

    // Read the link until the end marker
    final linkBuffer = StringBuffer();
    for (; text[i] != ']'; i++) {
      linkBuffer.write(text[i]);
    }

    if (text[i + 1] == '(') {
      // Skip markers
      i += 2;

      // Read the label until the end marker
      final labelBuffer = StringBuffer();
      for (; text[i] != ')'; i++) {
        labelBuffer.write(text[i]);
      }

      _createLinkSpanInner(linkBuffer.toString(), labelBuffer.toString(), children, theme);
    } else {
      // This is a link with no label
      _createLinkSpanInner(linkBuffer.toString(), linkBuffer.toString(), children, theme);
    }

    return i;
  }

  void _createLinkSpanInner(String link, String label, List<InlineSpan> children, ThemeData theme) {    
    final linkStyle = _defaultTextStyle(theme).copyWith(color: theme.colorScheme.secondary);
    children.add(TextSpan(
        style: linkStyle,
        text: label,
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            onLinkTapped?.call(link);
          }));
  }

  int _createHeadingSpan(int i, List<InlineSpan> children, ThemeData theme) {
    // Count the number of markers and advance the index to where they end
    var c = 1;
    for (; text[i] == '#'; i++, c++) {}

    // Skip empty space after marker(s), if there is any
    for (; text[i] == ' '; i++) {}

    // Read until endline
    final buffer = StringBuffer();
    for (; text[i] != '\n'; i++) {
      buffer.write(text[i]);
    }

    // Ensure heading ends with newline
    buffer.write('\n');

    // Create the span from the buffer we collected
    final style = switch (c) {
      1 => theme.textTheme.headlineLarge,
      2 => theme.textTheme.headlineMedium,
      _ => theme.textTheme.headlineSmall
    };
    children.add(TextSpan(style: style, text: buffer.toString()));

    // Return the pointer
    return i;
  }

  void _createPlainSpanIfNotEmpty(StringBuffer buffer, List<InlineSpan> children, ThemeData theme) {
    // Just create a plain text span from whatever's in the buffer
    if (buffer.isEmpty) return;
    children.add(TextSpan(style: _defaultTextStyle(theme), text: buffer.toString()));
    buffer.clear();
  }

  TextStyle _defaultTextStyle(ThemeData theme) {
    return theme.textTheme.bodyMedium!;
  }
}
