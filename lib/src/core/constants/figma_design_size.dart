import 'package:flutter/material.dart';

/// Figma design size used by ScreenUtilInit
const Size figmaDesignSize = Size(390, 844);

/// Backward compatibility for existing usages
class FigmaDesignSize {
  static double get hSize => figmaDesignSize.height;
  static double get wSize => figmaDesignSize.width;
}
