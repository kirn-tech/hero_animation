import 'package:example/core/app_text_styles.dart';
import 'package:flutter/widgets.dart';

extension AppStylingContext on BuildContext {
  AppTextStyles get textStyling => AppThemeProvider.of(this).textStyles;

  AppTheme get theme => AppThemeProvider.of(this);
}

class AppTheme {
  static final _fallback = AppTheme(
    textStyles: AppTextStyles.mobile(),
  );

  final AppTextStyles textStyles;

  const AppTheme({
    required this.textStyles,
  });

  factory AppTheme.mobile() => AppTheme(textStyles: AppTextStyles.mobile());

  factory AppTheme.desktop() => AppTheme(textStyles: AppTextStyles.desktop());
}

class AppThemeProvider extends InheritedWidget {
  final AppTheme theme;

  const AppThemeProvider({
    super.key,
    required this.theme,
    required Widget child,
  }) : super(child: child);

  static AppTheme of(BuildContext context) {
    final inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<AppThemeProvider>()?.theme;

    return inheritedTheme ?? AppTheme._fallback;
  }

  static AppTheme? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<AppThemeProvider>()
        ?.theme;
  }

  @override
  bool updateShouldNotify(AppThemeProvider oldWidget) =>
      theme != oldWidget.theme;
}
