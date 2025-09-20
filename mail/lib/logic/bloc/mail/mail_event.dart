abstract class MailEvent {}

class ChangeTab extends MailEvent {
  final int index;
  ChangeTab(this.index);
}
