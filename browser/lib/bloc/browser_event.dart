abstract class BrowserEvent {}

class LoadUrlEvent extends BrowserEvent {
  final String url;

  LoadUrlEvent(this.url);
}
