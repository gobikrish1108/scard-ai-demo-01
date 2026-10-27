import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/card_management/presentation/screens/manage_card_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/ai_agents/presentation/screens/ai_agents_screen.dart';
import '../../features/voice_assistant/presentation/screens/voice_assistant_screen.dart';
import '../../features/calendar_tasks/presentation/screens/calendar_tasks_screen.dart';
import '../../features/smart_inbox/presentation/screens/smart_inbox_screen.dart';
import '../../features/document_vault/presentation/screens/document_vault_screen.dart';
import '../../features/invoices_finance/presentation/screens/invoices_finance_screen.dart';
import '../../features/pomodoro_habits/presentation/screens/pomodoro_habits_screen.dart';
import '../../features/workflow_marketplace/presentation/screens/workflow_marketplace_screen.dart';
import '../../features/team_collab/presentation/screens/team_collab_screen.dart';
import '../../features/telephony/presentation/screens/telephony_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/card',
      builder: (context, state) => const ManageCardScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/agents',
      builder: (context, state) => const AiAgentsScreen(),
    ),
    GoRoute(
      path: '/voice',
      builder: (context, state) => const VoiceAssistantScreen(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarTasksScreen(),
    ),
    GoRoute(
      path: '/emails',
      builder: (context, state) => const SmartInboxScreen(),
    ),
    GoRoute(
      path: '/vault',
      builder: (context, state) => const DocumentVaultScreen(),
    ),
    GoRoute(
      path: '/invoices',
      builder: (context, state) => const InvoicesFinanceScreen(),
    ),
    GoRoute(
      path: '/focus',
      builder: (context, state) => const PomodoroHabitsScreen(),
    ),
    GoRoute(
      path: '/marketplace',
      builder: (context, state) => const WorkflowMarketplaceScreen(),
    ),
    GoRoute(
      path: '/team',
      builder: (context, state) => const TeamCollabScreen(),
    ),
    GoRoute(
      path: '/phonecall',
      builder: (context, state) => const TelephonyScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);
