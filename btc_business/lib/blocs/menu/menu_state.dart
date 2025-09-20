import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {}

class MenuNavigateTo extends MenuState {
  final Widget screen;
  const MenuNavigateTo(this.screen);

  @override
  List<Object?> get props => [screen];
}
