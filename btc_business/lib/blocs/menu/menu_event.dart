import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class MenuItemTapped extends MenuEvent {
  final String title;
  const MenuItemTapped(this.title);

  @override
  List<Object> get props => [title];
}
