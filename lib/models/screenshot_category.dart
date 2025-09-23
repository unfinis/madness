enum ScreenshotCategory {
  web('web', 'Web'),
  network('network', 'Network'),
  system('system', 'System'),
  mobile('mobile', 'Mobile'),
  other('other', 'Other');

  const ScreenshotCategory(this.value, this.displayName);

  final String value;
  final String displayName;

  static ScreenshotCategory fromValue(String value) {
    return ScreenshotCategory.values.firstWhere(
      (category) => category.value == value,
      orElse: () => ScreenshotCategory.other,
    );
  }
}