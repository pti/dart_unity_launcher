import 'dart:ffi' as ffi;
import 'package:ffi/ffi.dart';

typedef entry_get_for_desktop_id = ffi.Pointer<ffi.Void> Function(ffi.Pointer<Utf8> id);
typedef EntryForDesktopId = ffi.Pointer<ffi.Void> Function(ffi.Pointer<Utf8> id);

typedef entry_set_count = ffi.Void Function(ffi.Pointer<ffi.Void> entry, ffi.Int64 count);
typedef EntrySetCount = void Function(ffi.Pointer<ffi.Void> entry, int count);

typedef entry_set_count_visible = ffi.Void Function(ffi.Pointer<ffi.Void> entry, ffi.Int32 visible);
typedef EntrySetCountVisible = void Function(ffi.Pointer<ffi.Void> entry, int visible);

typedef entry_set_progress = ffi.Void Function(ffi.Pointer<ffi.Void> entry, ffi.Double progress);
typedef EntrySetProgress = void Function(ffi.Pointer<ffi.Void> entry, double progress);

typedef entry_set_progress_visible = ffi.Void Function(ffi.Pointer<ffi.Void> entry, ffi.Int32 visible);
typedef EntrySetProgressVisible = void Function(ffi.Pointer<ffi.Void> entry, int visible);

typedef entry_set_urgent = ffi.Void Function(ffi.Pointer<ffi.Void> entry, ffi.Int32 urgent);
typedef EntrySetUrgent = void Function(ffi.Pointer<ffi.Void> entry, int urgent);

typedef g_main_loop_new = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void> context, ffi.Int32 is_running);
typedef GMainLoopNew = ffi.Pointer<ffi.Void> Function(ffi.Pointer<ffi.Void> context, int is_running);

typedef g_main_loop_run = ffi.Void Function(ffi.Pointer<ffi.Void> loop);
typedef GMainLoopRun = void Function(ffi.Pointer<ffi.Void> loop);

typedef g_main_loop_quit = ffi.Void Function(ffi.Pointer<ffi.Void> loop);
typedef GMainLoopQuit = void Function(ffi.Pointer<ffi.Void> loop);

typedef g_main_loop_unref = ffi.Void Function(ffi.Pointer<ffi.Void> loop);
typedef GMainLoopUnref = void Function(ffi.Pointer<ffi.Void> loop);

typedef g_object_unref = ffi.Void Function(ffi.Pointer<ffi.Void> obj);
typedef GObjectUnref = void Function(ffi.Pointer<ffi.Void> obj);

class LibUnity {

  EntryForDesktopId getEntryPtr;
  EntrySetCount setCountPtr;
  EntrySetCountVisible setCountVisiblePtr;
  EntrySetProgress setProgressPtr;
  EntrySetProgressVisible setProgressVisiblePtr;
  EntrySetUrgent setUrgentPtr;
  GMainLoopNew gMainLoopNewPtr;
  GMainLoopRun gMainLoopRunPtr;
  GMainLoopQuit gMainLoopQuitPtr;
  GMainLoopUnref gMainLoopUnrefPtr;
  GObjectUnref gObjectUnrefPtr;

  static LibUnity _instance;

  LibUnity._internal() {
    final dylib = ffi.DynamicLibrary.open('libunity.so');

    getEntryPtr = dylib
        .lookup<ffi.NativeFunction<entry_get_for_desktop_id>>('unity_launcher_entry_get_for_desktop_id')
        .asFunction<EntryForDesktopId>();

    setCountPtr = dylib
        .lookup<ffi.NativeFunction<entry_set_count>>('unity_launcher_entry_set_count')
        .asFunction<EntrySetCount>();

    setCountVisiblePtr = dylib
        .lookup<ffi.NativeFunction<entry_set_count_visible>>('unity_launcher_entry_set_count_visible')
        .asFunction<EntrySetCountVisible>();

    setProgressPtr = dylib
        .lookup<ffi.NativeFunction<entry_set_progress>>('unity_launcher_entry_set_progress')
        .asFunction<EntrySetProgress>();

    setProgressVisiblePtr = dylib
        .lookup<ffi.NativeFunction<entry_set_progress_visible>>('unity_launcher_entry_set_progress_visible')
        .asFunction<EntrySetProgressVisible>();

    setUrgentPtr = dylib
        .lookup<ffi.NativeFunction<entry_set_urgent>>('unity_launcher_entry_set_urgent')
        .asFunction<EntrySetUrgent>();

    gMainLoopNewPtr = dylib
        .lookup<ffi.NativeFunction<g_main_loop_new>>('g_main_loop_new')
        .asFunction<GMainLoopNew>();

    gMainLoopRunPtr = dylib
        .lookup<ffi.NativeFunction<g_main_loop_run>>('g_main_loop_run')
        .asFunction<GMainLoopRun>();

    gMainLoopQuitPtr = dylib
        .lookup<ffi.NativeFunction<g_main_loop_quit>>('g_main_loop_quit')
        .asFunction<GMainLoopQuit>();

    gMainLoopUnrefPtr = dylib
        .lookup<ffi.NativeFunction<g_main_loop_unref>>('g_main_loop_unref')
        .asFunction<GMainLoopUnref>();

    gObjectUnrefPtr = dylib
        .lookup<ffi.NativeFunction<g_object_unref>>('g_object_unref')
        .asFunction<GObjectUnref>();
  }

  factory LibUnity() => _instance ??= LibUnity._internal();
}
