import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:pile/screens/home_screen.dart';
import 'package:pile/screens/login_screen.dart';
import 'package:pile/services/firebase_auth_methods.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pile/screens/signup_email_password_screen.dart';
import 'package:pile/screens/login_email_password_screen.dart';
import 'package:pile/screens/phone_screen.dart';
import 'firebase_options.dart';
import 'package:flutter/foundation.dart';
// import 'package:responsive_framework/responsive_framework.dart';
import 'package:animations/animations.dart';
import 'package:pile/screens/profile/profile_page.dart';
import 'package:pile/screens/profile/models/content_model.dart';
import '.env.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        title: 'Pile',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        scrollBehavior: WebMouseScrollBehavior(),

        home: kIsWeb ? const ProfilePage() : const AuthWrapper(),
        // builder: (context, widget) => ResponsiveWrapper.builder(
        //   BouncingScrollWrapper.builder(context, widget!),

        //   defaultScale: false,
        //   breakpoints: [
        //     const ResponsiveBreakpoint.resize(480, name: MOBILE),
        //     const ResponsiveBreakpoint.autoScale(800, name: TABLET),
        //     const ResponsiveBreakpoint.autoScale(1000, name: DESKTOP),
        //   ],
        //   // background: Container(
        //   //     color: Color(0xFFF5F5F5))
        // ),
        routes: {
          EmailPasswordSignup.routeName: (context) =>
              const EmailPasswordSignup(),
          EmailPasswordLogin.routeName: (context) => const EmailPasswordLogin(),
          PhoneScreen.routeName: (context) => const PhoneScreen(),
        },
        onGenerateRoute: (RouteSettings settings) {
          return Routes.fadeThrough(settings, (context) {
            switch (settings.name) {
              case Routes.home:
                return const ProfilePage();
              case Routes.profile:
                return const ProfilePage();

              default:
                return const SizedBox.shrink();
            }
          });
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();

    if (firebaseUser != null) {
      return const HomeScreen();
    }
    return const LoginScreen();
  }
}

// profile page only for web version
// responsive screen with future snapshot
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.doc(profileDocReference).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          List<Widget> children;

          if (snapshot.hasData) {
            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 800) {
                  return Desktop(
                    contents: ContentModel.fromDataSnapshot(snapshot),
                  );
                } else {
                  return Mobile(
                    contents: ContentModel.fromDataSnapshot(snapshot),
                  );
                }
              },
            );
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              ),
            ];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              ),
            ];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              ),
            );
          }
        },
      ),
    );
  }
}

class Routes {
  static const String home = "/";
  static const String profile = "profile";
  // static const String style = "style";

  static Route<T> fadeThrough<T>(RouteSettings settings, WidgetBuilder page,
      {int duration = 300}) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: Duration(milliseconds: duration),
      pageBuilder: (context, animation, secondaryAnimation) => page(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeScaleTransition(animation: animation, child: child);
      },
    );
  }
}

//enable web mnouse dragging
class WebMouseScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
