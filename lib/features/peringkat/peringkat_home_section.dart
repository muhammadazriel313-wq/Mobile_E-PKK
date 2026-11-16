import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'peringkat_controller.dart';
import 'peringkat_model.dart';
import 'peringkat_widgets.dart';

/// Taruh di home_screen.dart, tepat di bawah bagian "Kelompok Kerja".
class PeringkatHomeSection extends StatelessWidget {
  const PeringkatHomeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PeringkatController()..limit = 3, tag: 'beranda');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Expanded(
            child: Text('Peringkat Anggota PKK',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
          TextButton(
              onPressed: () => Get.toNamed('/peringkat'),
              child: const Text('Lihat Semua')),
        ]),
        Obx(() => SegmentedButton<PeringkatJenis>(
              segments: const [
                ButtonSegment(value: PeringkatJenis.desa, label: Text('Desa')),
                ButtonSegment(
                    value: PeringkatJenis.kecamatan, label: Text('Kecamatan')),
              ],
              selected: {c.jenis.value},
              onSelectionChanged: (s) => c.ganti(j: s.first),
            )),
        const SizedBox(height: 8),
        Obx(() {
          if (c.loading.value) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (c.error.value != null) return Text(c.error.value!);
          if (c.items.isEmpty) return const Text('Belum ada data.');
          return Column(
              children: c.items.map((e) => PeringkatTile(item: e)).toList());
        }),
      ]),
    );
  }
}
