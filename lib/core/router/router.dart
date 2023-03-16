import 'package:atm_simulator/app/atm/presentation/page/atm_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AtmPage(),
    ),
  ],
);
