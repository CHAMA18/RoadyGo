import 'package:flutter/material.dart';
import 'flutter_flow/flutter_flow_theme.dart';

class ErrorHandlingWidget extends StatefulWidget {
  final Widget child;
  final String? fallbackErrorMessage;
  final bool Function()? errorCondition;
  final VoidCallback? onRetry;

  const ErrorHandlingWidget({
    super.key,
    required this.child,
    this.fallbackErrorMessage,
    this.errorCondition,
    this.onRetry,
  });

  @override
  State<ErrorHandlingWidget> createState() => _ErrorHandlingWidgetState();
}

class _ErrorHandlingWidgetState extends State<ErrorHandlingWidget> {
  bool _hasError = false;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _checkErrorCondition();
  }

  void _checkErrorCondition() {
    // Check if we should simulate an error for testing
    if (widget.errorCondition?.call() ?? false) {
      setState(() {
        _hasError = true;
        _errorMessage = widget.fallbackErrorMessage ?? 'An error occurred';
        _isLoading = false;
      });
      return;
    }

    // Simulate loading
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _isLoading = true;
      _errorMessage = null;
    });

    if (widget.onRetry != null) {
      widget.onRetry!();
    } else {
      _checkErrorCondition();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 20),
              Text(
                'Loading RoadyGo...',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: FlutterFlowTheme.of(context).error,
              ),
              const SizedBox(height: 20),
              Text(
                _errorMessage ?? 'Something went wrong',
                style: TextStyle(
                  color: FlutterFlowTheme.of(context).primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _retry,
                child: const Text('Try Again'),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  // Navigate to a simple fallback screen
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/',
                    (route) => false,
                  );
                },
                child: Text(
                  'Go to Home',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return widget.child;
  }
}

class CircuitBreaker {
  static const int _maxFailures = 3;
  static const Duration _timeoutDuration = Duration(seconds: 30);

  int _failureCount = 0;
  DateTime? _lastFailureTime;
  bool _isCircuitOpen = false;

  bool shouldAttemptRequest() {
    if (_isCircuitOpen) {
      if (_lastFailureTime != null &&
          DateTime.now().difference(_lastFailureTime!) > _timeoutDuration) {
        // Timeout expired, try again
        _isCircuitOpen = false;
        _failureCount = 0;
        return true;
      }
      return false;
    }
    return true;
  }

  void recordFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();

    if (_failureCount >= _maxFailures) {
      _isCircuitOpen = true;
    }
  }

  void recordSuccess() {
    _failureCount = 0;
    _isCircuitOpen = false;
    _lastFailureTime = null;
  }
}

class LoadingOverlay extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final String? loadingText;
  final Color? backgroundColor;

  const LoadingOverlay({
    super.key,
    required this.child,
    this.isLoading = false,
    this.loadingText,
    this.backgroundColor,
  });

  @override
  State<LoadingOverlay> createState() => _LoadingOverlayState();
}

class _LoadingOverlayState extends State<LoadingOverlay> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isLoading)
          Positioned.fill(
            child: Container(
              color:
                  widget.backgroundColor ?? Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.loadingText ?? 'Loading...',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
