import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import 'menu_event.dart';
import 'menu_state.dart';

import '../../presentation/screens/Home/audit_document_screen.dart';
import '../../presentation/screens/Home/auditor_screen.dart';
import '../../presentation/screens/Home/bills_screen.dart';
import '../../presentation/screens/Home/compare_screen.dart';
import '../../presentation/screens/Home/inventory_screen.dart';
import '../../presentation/screens/Home/plan_screen.dart';
import '../../presentation/screens/Home/segregation_screen.dart';
import '../../presentation/screens/Home/staffing_screen.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuInitial()) {
    on<MenuItemTapped>((event, emit) {
      Widget screen;

      switch (event.title) {
        case 'Auditor':
          screen = const AuditorScreen();
          break;
        case 'Inventory':
          screen = const InventoryScreen();
          break;
        case 'Plan':
          screen = const PlanScreen();
          break;
        case 'Audit & Document':
          screen = const AuditDocumentScreen();
          break;
        case 'Staffing':
          screen = const StaffingScreen();
          break;
        case 'Compare':
          screen = const CompareScreen();
          break;
        case 'Bills':
          screen = const BillsScreen();
          break;
        case 'Segregation':
          screen = const SegregationScreen();
          break;
        default:
          screen = const SizedBox.shrink(); // fallback empty screen
          break;
      }

      emit(MenuNavigateTo(screen));
    });
  }
}
