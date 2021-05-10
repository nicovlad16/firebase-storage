part of app;

enum FirebaseAppLifecycleState { created, deleted }

class FirebaseAppLifecycleEvent {
  const FirebaseAppLifecycleEvent(this.state, this.app);

  final FirebaseAppLifecycleState state;
  final FirebaseApp app;

  @override
  String toString() {
    return 'FirebaseAppLifecycleEvent(state: $state, app: $app)';
  }
}
