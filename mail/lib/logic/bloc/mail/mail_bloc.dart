import 'package:flutter_bloc/flutter_bloc.dart';
import 'mail_event.dart';
import 'mail_state.dart';

class MailBloc extends Bloc<MailEvent, MailState> {
  MailBloc() : super(MailState(0)) {
    on<ChangeTab>((event, emit) => emit(MailState(event.index)));
  }
}
