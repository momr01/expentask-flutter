import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/bottom_bar.dart';
import 'package:payments_management/features/404_not_found/screens/not_found_screen.dart';
import 'package:payments_management/features/alerts/screens/alerts_screen.dart';
import 'package:payments_management/features/auth/screens/login_screen.dart';
import 'package:payments_management/features/auth/screens/register_screen.dart';
import 'package:payments_management/features/categories/screens/categories_screen.dart';
import 'package:payments_management/features/form_manage_name/screens/form_manage_name_screen.dart';
import 'package:payments_management/features/generate/screens/generate_%C3%AFnstallments_form_screen.dart';
import 'package:payments_management/features/generate/screens/generate_details_groups_screen.dart';
import 'package:payments_management/features/generate/screens/generate_details_individual_screen.dart';
import 'package:payments_management/features/generate/screens/generate_main_screen.dart';
import 'package:payments_management/features/groups/screens/manage_group_screen.dart';
import 'package:payments_management/features/groups/screens/group_details_screen.dart';
import 'package:payments_management/features/groups/screens/groups_screen.dart';
import 'package:payments_management/features/historical/screens/historical_details_screen.dart';
import 'package:payments_management/features/historical/screens/historical_filter_screen.dart';
import 'package:payments_management/features/historical/screens/historical_screen.dart';
import 'package:payments_management/features/home/screens/home_screen.dart';
import 'package:payments_management/features/names/screens/names_screen.dart';
import 'package:payments_management/features/form_edit_payment/screens/form_edit_payment_screen.dart';
import 'package:payments_management/features/payment_details/screens/payment_details_screen.dart';
import 'package:payments_management/features/profile/screens/profile_screen.dart';
import 'package:payments_management/features/tasks/screens/tasks_screen.dart';
import 'package:payments_management/models/form_edit_payment_arguments.dart';
import 'package:payments_management/models/form_manage_name_arguments.dart';
import 'package:payments_management/models/group/group.dart';
import 'package:payments_management/models/payment/payment.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const LoginScreen());
    case RegisterScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const RegisterScreen());
    case HomeScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const HomeScreen());
    case BottomBar.routeName:
      int page = routeSettings.arguments as int;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => BottomBar(
                page: page,
              ));
    case PaymentDetailsScreen.routeName:
      String paymentId = routeSettings.arguments as String;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => PaymentDetailsScreen(
                paymentId: paymentId,
              ));
    case FormEditPayment.routeName:
      FormEditPaymentArguments args =
          routeSettings.arguments as FormEditPaymentArguments;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => FormEditPayment(
                // payment: payment,
                payment: args.payment,
                names: args.names,
                taskCodes: args.taskCodes,
              ));
    case NamesScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const NamesScreen());
    case FormManageNameScreen.routeName:
      FormManageNameArguments args =
          routeSettings.arguments as FormManageNameArguments;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => FormManageNameScreen(
                name: args.name,
                categories: args.categories,
                taskCodes: args.taskCodes,
              ));
    case GenerateMainScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const GenerateMainScreen());
    case GenerateDetailsIndividualScreen.routeName:
      List<dynamic> args = routeSettings.arguments as List<dynamic>;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => GenerateDetailsIndividualScreen(
                payments: args[0],
                title: args[1],
                // type: args[2] ?? null,
                type: args.length > 2
                    ? args[2]
                    : "individual", // Solo pasa `type` si existe.
              ));
    case GenerateDetailsGroupsScreen.routeName:
      List<dynamic> args = routeSettings.arguments as List<dynamic>;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => GenerateDetailsGroupsScreen(
                payments: args[0],
                title: args[1],
              ));

    case GenerateInstallmentsFormScreen.routeName:
      List<dynamic> args = routeSettings.arguments as List<dynamic>;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => GenerateInstallmentsFormScreen(
                totalSelected: args[0],
                payments: args[1],
              ));
    case AlertsScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const AlertsScreen());
    case HistoricalScreen.routeName:
      List<HistoricalFilter> args =
          routeSettings.arguments as List<HistoricalFilter>;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => HistoricalScreen(
                finalFilter: args,
              ));
    case HistoricalDetailsScreen.routeName:
      var payment = routeSettings.arguments as Payment;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => HistoricalDetailsScreen(
                payment: payment,
              ));
    case HistoricalFilterScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => const HistoricalFilterScreen());
    case TasksScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const TasksScreen());
    case CategoriesScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const CategoriesScreen());
    case GroupsScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const GroupsScreen());
    case GroupDetailsScreen.routeName:
      var group = routeSettings.arguments as Group;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => GroupDetailsScreen(
                group: group,
              ));
    case ManageGroupScreen.routeName:
      // var group = routeSettings.arguments as Group;
      List<dynamic> args = routeSettings.arguments as List<dynamic>;
      return MaterialPageRoute(
          settings: routeSettings,
          builder: (_) => ManageGroupScreen(
                // group: group,
                group: args[0],
                namesList: args[1],
              ));
    case ProfileScreen.routeName:
      return MaterialPageRoute(
          settings: routeSettings, builder: (_) => const ProfileScreen());
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const NotFoundScreen(),
      );
  }
}
