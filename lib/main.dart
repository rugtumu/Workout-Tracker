import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workout_tracker/providers/workout_provider.dart';
import 'package:workout_tracker/providers/medical_provider.dart';
import 'package:workout_tracker/screens/welcome_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:workout_tracker/utils/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storage = FlutterSecureStorage();
  String? pin = await storage.read(key: 'db_password');

  runApp(FitnessTrackerApp(pinSet: pin != null));
}

class FitnessTrackerApp extends StatelessWidget {
  final bool pinSet;
  const FitnessTrackerApp({super.key, required this.pinSet});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WorkoutProvider()),
        ChangeNotifierProvider(create: (_) => MedicalProvider()),
      ],
      child: MaterialApp(
        title: 'Workout Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primarySwatch: Colors.green,
          scaffoldBackgroundColor: const Color(0xFF0A3D2A), // Phthalo Green
          cardColor: const Color(0xFF1E1E1E),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E1E1E),
            elevation: 0,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(color: Colors.white),
            bodyMedium: TextStyle(color: Colors.white70),
            titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: const Color(0xFF2A2A2A),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            hintStyle: const TextStyle(color: Colors.white54),
          ),
        ),
        home: pinSet ? PinEntryScreen() : PinSetupScreen(),
      ),
    );
  }
}

class PinSetupScreen extends StatefulWidget {
  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Set a PIN for your data', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: const Text(
                    '⚠️ IMPORTANT: If you forget your PIN, your data cannot be recovered!\nPlease write down your PIN in a safe place. There is NO way to reset or recover your PIN.',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'PIN',
                    hintText: 'Enter a 4-6 digit PIN',
                  ),
                  validator: (value) {
                    if (value == null || value.length < 4) {
                      return 'PIN must be at least 4 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final storage = FlutterSecureStorage();
                      await storage.write(key: 'db_password', value: _pinController.text);
                      // Restart app with PIN set
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => FitnessTrackerApp(pinSet: true)),
                      );
                    }
                  },
                  child: const Text('Set PIN'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PinEntryScreen extends StatefulWidget {
  @override
  State<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends State<PinEntryScreen> {
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Enter your PIN', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.red.withOpacity(0.3)),
                  ),
                  child: const Text(
                    '⚠️ If you forget your PIN, your data cannot be recovered!\nThere is NO way to reset or recover your PIN.',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    labelText: 'PIN',
                    hintText: 'Enter your PIN',
                  ),
                  validator: (value) {
                    if (value == null || value.length < 4) {
                      return 'PIN must be at least 4 digits';
                    }
                    return null;
                  },
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final storage = FlutterSecureStorage();
                      String? realPin = await storage.read(key: 'db_password');
                      if (_pinController.text == realPin) {
                        // Initialize database with PIN
                        await DatabaseHelper.getInstance();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
                        );
                      } else {
                        setState(() {
                          _error = 'Incorrect PIN';
                        });
                      }
                    }
                  },
                  child: const Text('Unlock'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 