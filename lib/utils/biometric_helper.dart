import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricHelper {
  static final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if device supports biometric authentication
  static Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      
      print('DEBUG: BiometricHelper - canCheckBiometrics: $isAvailable');
      print('DEBUG: BiometricHelper - isDeviceSupported: $isDeviceSupported');
      
      // For testing in emulator, return true if device is supported
      if (isDeviceSupported) {
        print('DEBUG: BiometricHelper - Device supports biometrics');
        return true;
      }
      
      return isAvailable && isDeviceSupported;
    } on PlatformException catch (e) {
      print('Error checking biometric availability: $e');
      return false;
    }
  }

  /// Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      final biometrics = await _localAuth.getAvailableBiometrics();
      print('DEBUG: BiometricHelper - Available biometrics: $biometrics');
      return biometrics;
    } on PlatformException catch (e) {
      print('Error getting available biometrics: $e');
      return [];
    }
  }

  /// Authenticate using biometrics
  static Future<bool> authenticate() async {
    try {
      print('DEBUG: BiometricHelper - Starting authentication...');
      
      // Check if biometrics are available first
      final isAvailable = await isBiometricAvailable();
      print('DEBUG: BiometricHelper - Biometrics available: $isAvailable');
      
      if (!isAvailable) {
        print('DEBUG: BiometricHelper - Biometrics not available, returning false');
        return false;
      }
      
      final result = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your workout data',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      print('DEBUG: BiometricHelper - Authentication result: $result');
      return result;
    } on PlatformException catch (e) {
      print('DEBUG: BiometricHelper - PlatformException during authentication: $e');
      print('DEBUG: BiometricHelper - Error code: ${e.code}');
      print('DEBUG: BiometricHelper - Error message: ${e.message}');
      return false;
    } catch (e) {
      print('DEBUG: BiometricHelper - General error during authentication: $e');
      return false;
    }
  }

  /// Check if fingerprint is available
  static Future<bool> isFingerprintAvailable() async {
    try {
      final availableBiometrics = await getAvailableBiometrics();
      final hasFingerprint = availableBiometrics.contains(BiometricType.fingerprint);
      print('DEBUG: BiometricHelper - Has fingerprint: $hasFingerprint');
      return hasFingerprint;
    } on PlatformException catch (e) {
      print('Error checking fingerprint availability: $e');
      return false;
    }
  }

  /// Get biometric type name for display
  static String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.iris:
        return 'Iris';
      default:
        return 'Biometric';
    }
  }
} 