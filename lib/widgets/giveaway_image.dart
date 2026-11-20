import 'package:flutter/material.dart';

/// Network image with a themed gradient placeholder while loading or on error.
class GiveawayImage extends StatelessWidget {
  const GiveawayImage({super.key, required this.url, this.iconSize = 40});

  final String url;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _Placeholder(iconSize: iconSize);
    return Image.network(
      url,
      fit: BoxFit.cover,
      // Lets the web build show images from sites that don't send CORS headers.
      webHtmlElementStrategy: WebHtmlElementStrategy.fallback,
      loadingBuilder: (context, child, progress) =>
          progress == null ? child : _Placeholder(iconSize: iconSize),
      errorBuilder: (context, error, stackTrace) =>
          _Placeholder(iconSize: iconSize),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.iconSize});

  final double iconSize;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [scheme.primary, scheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.sports_esports,
          size: iconSize,
          color: Colors.white.withValues(alpha: 0.4),
        ),
      ),
    );
  }
}
