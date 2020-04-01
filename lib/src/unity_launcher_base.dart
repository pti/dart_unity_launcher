import 'dart:async';
import 'dart:ffi' as ffi;
import 'dart:isolate';
import 'package:ffi/ffi.dart';
import 'package:unity_launcher/src/libunity.dart';

class UnityLauncher {

  static UnityLauncherEntry getLauncherEntry(String desktopId) {
    return UnityLauncherEntry._internal(desktopId);
  }

  static GMainLoop newMainLoop() {
    return GMainLoop._internal();
  }
}

class UnityLauncherEntry {

  ffi.Pointer<ffi.Void> _entryPtr;
  ffi.Pointer<Utf8> _idPtr;

  UnityLauncherEntry._internal(String desktopId) {
    _idPtr = Utf8.toUtf8(desktopId);
    _entryPtr = LibUnity().getEntryPtr(_idPtr);
  }

  void dispose() {
    LibUnity().gObjectUnrefPtr(_entryPtr);
    _entryPtr = ffi.nullptr;

    free(_idPtr);
    _idPtr = ffi.nullptr;
  }

  void setCount(int count, {bool setVisible = true}) {
    LibUnity().setCountPtr(_entryPtr, count);
    // By default set the count visible too -> nicer to use. No extra signals seem to get emitted because of this
    // as the library seems to bundle changes from (immediate) subsequent calls to one signal.
    if (setVisible) setCountVisible(true);
  }

  void setCountVisible(bool visible) => LibUnity().setCountVisiblePtr(_entryPtr, visible.toInt());

  void setProgress(double progress, {bool setVisible = true}) {
    LibUnity().setProgressPtr(_entryPtr, progress);
    if (setVisible) setProgressVisible(true);
  }

  void setProgressVisible(bool visible) => LibUnity().setProgressVisiblePtr(_entryPtr, visible.toInt());

  void setUrgent(bool urgent) => LibUnity().setUrgentPtr(_entryPtr, urgent.toInt());
}

class GMainLoop {

  ffi.Pointer<ffi.Void> _loopPtr;
  Completer _runCompleter;

  GMainLoop._internal() {
    _loopPtr = LibUnity().gMainLoopNewPtr(ffi.nullptr, 0);
  }

  void dispose() {
    LibUnity().gMainLoopUnrefPtr(_loopPtr);
  }

  Future<void> quit() async {
    LibUnity().gMainLoopQuitPtr(_loopPtr);
    await _runCompleter.future;
  }

  bool get isRunning => _runCompleter?.isCompleted == false;

  /// Starts the loop in a new isolate (so that it doesn't block the current isolate).
  /// Returns once the isolate exits (e.g. because [quit] was called).
  Future<void> run() async {
    if (isRunning) return;

    _runCompleter = Completer();
    final exitPort = ReceivePort();
    await Isolate.spawn(_gLoopRunner, _loopPtr.address, onExit: exitPort.sendPort);

    try {
      await exitPort.first;
    } finally {
      _runCompleter.complete();
    }
  }
}

void _gLoopRunner(int address) {
  final loopPtr = ffi.Pointer<ffi.Void>.fromAddress(address);
  LibUnity().gMainLoopRunPtr(loopPtr);
}

extension on bool {
  int toInt() => this ? 1 : 0;
}
