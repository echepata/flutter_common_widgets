import 'package:flutter/material.dart';

/// @author    Diego
/// @since     2022-06-30
/// @copyright 2022 Carshare Australia Pty Ltd.

@Deprecated('Use HeadingLarge, HeadingMedium, and HeadingSmall instead')
class Heading1 extends StatelessWidget {
  final String text;

  final Color? color;

  final TextAlign? textAlign;

  final Shadow? shadow;

  const Heading1(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: textStyle(context).copyWith(
        color: color,
        shadows: shadow is Shadow ? [shadow!] : null,
      ),
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.headline1!;
  }
}

@Deprecated('Use HeadingLarge, HeadingMedium, and HeadingSmall instead')
class Heading2 extends StatelessWidget {
  final String text;

  final Color? color;

  final TextAlign? textAlign;

  final Shadow? shadow;

  const Heading2(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: textStyle(context).copyWith(
        color: color,
        shadows: shadow is Shadow ? [shadow!] : null,
      ),
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.headline2!;
  }
}

@Deprecated('Use HeadingLarge, HeadingMedium, and HeadingSmall instead')
class Heading3 extends StatelessWidget {
  final String text;

  final Color? color;

  final TextAlign? textAlign;

  final Shadow? shadow;

  const Heading3(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: textStyle(context).copyWith(
        color: color,
        shadows: shadow is Shadow ? [shadow!] : null,
      ),
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.headline3!;
  }
}

@Deprecated('Use HeadingLarge, HeadingMedium, and HeadingSmall instead')
class Heading4 extends StatelessWidget {
  final String text;

  final Color? color;

  final TextAlign? textAlign;

  final Shadow? shadow;

  const Heading4(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: textStyle(context).copyWith(
        color: color,
        shadows: shadow is Shadow ? [shadow!] : null,
      ),
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.headline4!;
  }
}

@Deprecated('Use HeadingLarge, HeadingMedium, and HeadingSmall instead')
class Heading5 extends StatelessWidget {
  final String text;

  final Color? color;

  final TextAlign? textAlign;

  final Shadow? shadow;

  const Heading5(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: textStyle(context).copyWith(
        color: color,
        shadows: shadow is Shadow ? [shadow!] : null,
      ),
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.headline5!;
  }
}

class HeadingLarge extends StatelessWidget {
  final String text;

  final Color? color;

  final TextAlign? textAlign;

  final Shadow? shadow;

  final TextOverflow? overflow;

  final int? maxLines;

  const HeadingLarge(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadow,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: textStyle(context).copyWith(
        color: color,
        shadows: shadow is Shadow ? [shadow!] : null,
      ),
      maxLines: maxLines,
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineLarge!;
  }
}

class HeadingMedium extends StatelessWidget {
  final String text;

  final Color? color;

  final TextAlign? textAlign;

  final Shadow? shadow;

  final TextOverflow? overflow;

  final int? maxLines;

  const HeadingMedium(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadow,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: textStyle(context).copyWith(
        color: color,
        shadows: shadow is Shadow ? [shadow!] : null,
      ),
      maxLines: maxLines,
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!;
  }
}

class HeadingSmall extends StatelessWidget {
  final String text;

  final Color? color;

  final TextAlign? textAlign;

  final Shadow? shadow;

  final TextOverflow? overflow;

  final int? maxLines;

  const HeadingSmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadow,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: textStyle(context).copyWith(
        color: color,
        shadows: shadow is Shadow ? [shadow!] : null,
      ),
      maxLines: maxLines,
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.headlineSmall!;
  }
}

class BodyMedium extends StatelessWidget {
  final String text;

  final Color? color;

  final TextAlign? textAlign;

  final Shadow? shadow;

  final TextOverflow? overflow;

  final int? maxLines;

  const BodyMedium(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadow,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: textStyle(context).copyWith(
        color: color,
        shadows: shadow is Shadow ? [shadow!] : null,
      ),
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!;
  }
}

class BodySmall extends StatelessWidget {
  final String text;

  final Color? color;

  final TextAlign? textAlign;

  final Shadow? shadow;

  final TextOverflow? overflow;

  final int? maxLines;

  const BodySmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadow,
    this.overflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: textStyle(context).copyWith(
        color: color,
        shadows: shadow is Shadow ? [shadow!] : null,
      ),
      maxLines: maxLines,
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!;
  }
}

class BodyXSmall extends StatelessWidget {
  final String text;

  final Color? color;

  final TextAlign? textAlign;

  final Shadow? shadow;

  final TextOverflow? overflow;

  final int? maxLines;

  final bool? softWrap;

  const BodyXSmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadow,
    this.overflow,
    this.maxLines,
    this.softWrap,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      softWrap: softWrap,
      style: textStyle(context).copyWith(
        color: color,
        shadows: shadow is Shadow ? [shadow!] : null,
      ),
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!;
  }
}

class DisplayLarge extends StatelessWidget {
  final String text;

  final Color? color;

  final TextAlign? textAlign;

  final Shadow? shadow;

  final TextOverflow? overflow;

  const DisplayLarge(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadow,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: textStyle(context).copyWith(
        color: color,
        shadows: shadow is Shadow ? [shadow!] : null,
      ),
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.displayLarge!;
  }
}

class DisplayMedium extends StatelessWidget {
  final String text;

  final Color? color;

  final TextAlign? textAlign;

  final Shadow? shadow;

  final TextOverflow? overflow;

  const DisplayMedium(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadow,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: textStyle(context).copyWith(
        color: color,
        shadows: shadow is Shadow ? [shadow!] : null,
      ),
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.displayMedium!;
  }
}

class DisplaySmall extends StatelessWidget {
  final String text;

  final Color? color;

  final TextAlign? textAlign;

  final Shadow? shadow;

  final TextOverflow? overflow;

  const DisplaySmall(
    this.text, {
    super.key,
    this.color,
    this.textAlign = TextAlign.left,
    this.shadow,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      style: textStyle(context).copyWith(
        color: color,
        shadows: shadow is Shadow ? [shadow!] : null,
      ),
    );
  }

  static TextStyle textStyle(BuildContext context) {
    return Theme.of(context).textTheme.displaySmall!;
  }
}
