import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'peringkat_controller.dart';
import 'peringkat_model.dart';
import 'peringkat_widgets.dart';

class PeringkatScreen extends StatelessWidget {
  const PeringkatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(PeringkatController(), tag: 'penuh');
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Peringkat Anggota PKK'),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month),
              onPressed: () async {
                final p = await pilihPeriode(context, c.periode.value);
                if (p != null) c.ganti(p: p);
              },
            ),
          ],
          bottom: TabBar(
            onTap: (i) => c.ganti(
                j: i == 0 ? PeringkatJenis.desa : PeringkatJenis.kecamatan),
            tabs: const [Tab(text: 'Desa'), Tab(text: 'Kecamatan')],
          ),
        ),
        body: Column(children: [
          Obx(() => Padding(
                padding: const EdgeInsets.all(12),
                child: Text('Periode: ${c.periode.value.label}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              )),
          Expanded(
            child: Obx(() {
              if (c.loading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (c.error.value != null) {
                return Center(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(c.error.value!),
                    TextButton(onPressed: c.muat, child: const Text('Coba lagi')),
                  ]),
                );
              }
              if (c.items.isEmpty) {
                return const Center(child: Text('Belum ada data peringkat.'));
              }
              return RefreshIndicator(
                onRefresh: c.muat,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: c.items.length,
                  itemBuilder: (_, i) => PeringkatTile(item: c.items[i]),
                ),
              );
            }),
          ),
        ]),
      ),
    );
  }
}
