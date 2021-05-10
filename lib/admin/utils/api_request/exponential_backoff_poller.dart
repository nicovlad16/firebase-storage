part of api_request;

/// Class used for polling an endpoint with exponential backoff.
///
/// Example usage:
/// ```
///  final String responseData = await ExponentialBackoffPoller<String>(
///    callFactory: myRequestToPoll,
///    pollWhenFactory: (String responseData) {
///      if (!isValid(responseData)) {
///        // Continue polling.
///        return null;
///      }
///
///      // Polling complete. Resolve promise with final response data.
///      return responseData;
///    },
///  );
///
///  print('Final response: $responseData');
/// ```

class ExponentialBackoffPoller<T> extends DelegatingFuture<T> {
  factory ExponentialBackoffPoller({
    required Future<T> Function() callFactory,
    required T? Function(T value) pollWhenFactory,
    Duration initialPollingDelay = const Duration(seconds: 1),
    Duration maxPollingDelay = const Duration(seconds: 10),
    Duration masterTimeout = const Duration(seconds: 60),
  }) {
    final Completer<T> completer = Completer<T>();

    return ExponentialBackoffPoller<T>._(
      completer: completer,
      callFactory: callFactory,
      pollWhenFactory: pollWhenFactory,
      initialPollingDelay: initialPollingDelay,
      maxPollingDelay: maxPollingDelay,
      masterTimeout: masterTimeout,
    );
  }

  ExponentialBackoffPoller._({
    required this.completer,
    required this.callFactory,
    required this.pollWhenFactory,
    required this.initialPollingDelay,
    required this.maxPollingDelay,
    required this.masterTimeout,
  }) : super(completer.future) {
    masterTimer = Timer(masterTimeout, () {
      repollTimer?.cancel();
      _markCompleted();
      completer.completeError(
          TimeoutException('ExponentialBackoffPoller deadline exceeded - Master timeout reached', masterTimeout));
    });
    _poll();
  }

  final Future<T> Function() callFactory;
  final T? Function(T value) pollWhenFactory;
  final Duration initialPollingDelay;
  final Duration maxPollingDelay;
  final Duration masterTimeout;
  final Completer<T> completer;

  int numTries = 0;
  late Timer masterTimer;
  Timer? repollTimer;

  Duration _getPollingDelayMillis() {
    final Duration increasedPollingDelay =
        Duration(milliseconds: initialPollingDelay.inMilliseconds * pow(2, numTries).toInt());

    if (min(increasedPollingDelay.inMilliseconds, maxPollingDelay.inMilliseconds) ==
        increasedPollingDelay.inMilliseconds) {
      return increasedPollingDelay;
    } else {
      return maxPollingDelay;
    }
  }

  Future<void> _poll() async {
    try {
      final T result = await callFactory();
      final T? finalResult = pollWhenFactory(result);
      if (finalResult != null) {
        _markCompleted();
        completer.complete(finalResult);
      } else {
        numTries++;
        repollTimer = Timer(_getPollingDelayMillis(), _poll);
      }
    } catch (error, stacktrace) {
      _markCompleted();
      completer.completeError(error, stacktrace);
    }
  }

  void _markCompleted() {
    masterTimer.cancel();
    repollTimer?.cancel();
  }
}
