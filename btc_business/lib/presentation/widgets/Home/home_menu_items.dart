import 'package:btc_business/blocs/segregated_wallet/segregated_wallet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:btc_business/presentation/screens/Home/audit_document_screen.dart';
import 'package:btc_business/presentation/screens/Home/auditor_screen.dart';
import 'package:btc_business/presentation/screens/Home/bills_screen.dart';
import 'package:btc_business/presentation/screens/Home/compare_screen.dart';
import 'package:btc_business/presentation/screens/Home/inventory_screen.dart';
import 'package:btc_business/presentation/screens/Home/plan_screen.dart';
import 'package:btc_business/presentation/screens/Home/segregation_screen.dart';
import 'package:btc_business/presentation/screens/Home/staffing_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final List<Map<String, dynamic>> menuItems = [
  {
    "title": "Auditor",
    "icon": Icons.person_search,
    "widget": const AuditorScreen(),
  },
  {
    "title": "Inventory",
    "icon": Icons.inventory_2,
    "widget": const InventoryScreen(),
  },
  {"title": "Plan", "icon": Icons.event_note, "widget": const PlanScreen()},
  {
    "title": "Audit & Document",
    "icon": Icons.insert_drive_file,
    "widget": const AuditDocumentScreen(),
  },
  {
    "title": "Staffing",
    "icon": Icons.people_alt,
    "widget": const StaffingScreen(),
  },
  {
    "title": "Compare",
    "icon": Icons.compare_arrows,
    "widget": const CompareScreen(),
  },
  {"title": "Bills", "icon": Icons.receipt_long, "widget": const BillsScreen()},
  {
    "title": "Segregation",
    "icon": Icons.layers,
    "widget":  const SegregationScreen(),
  },

];
