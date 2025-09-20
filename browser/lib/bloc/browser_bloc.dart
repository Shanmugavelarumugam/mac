import 'package:bloc/bloc.dart';
import 'browser_event.dart';
import 'browser_state.dart';

class BrowserBloc extends Bloc<BrowserEvent, BrowserState> {
  BrowserBloc() : super(const BrowserState(url: 'https://www.google.com')) {
    on<LoadUrlEvent>((event, emit) {
      emit(BrowserState(url: event.url));
    });
  }
}
