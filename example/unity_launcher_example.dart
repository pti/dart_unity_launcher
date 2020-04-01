import 'dart:async';

import 'package:unity_launcher/unity_launcher.dart';

void main() {
  final entry = UnityLauncher.getLauncherEntry('firefox.desktop');
  entry.setUrgent(false);

  final n = 3;
  final loop = UnityLauncher.newMainLoop();

  for (var i = 1; i <= n; i++) {
    final v = i;

    Future.delayed(Duration(seconds: i)).then((_) {
      entry.setProgress(v / n.toDouble());
      entry.setCount(v);
    });
  }

  Future.delayed(Duration(seconds: n + 1)).then((_) async {
    entry.setCountVisible(false);
    await Future.delayed(Duration(seconds: 1));

    entry.setCount(11, setVisible: false);
    entry.setCountVisible(true);
    await Future.delayed(Duration(seconds: 1));

    await loop.quit();
    print('quit loop');

    loop.dispose();
    entry.dispose();
  });

  print('start loop');
  loop.run().then((_) {
    print('loop done');
  });
}
