enum AppFlavor {
  dev,
  prod,
}

class AppFlavorConfig {
  static const String _flavor = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'dev',
  );

  static AppFlavor get current {
    switch (_flavor) {
      case 'prod':
        return AppFlavor.prod;
      case 'dev':
      default:
        return AppFlavor.dev;
    }
  }
}
