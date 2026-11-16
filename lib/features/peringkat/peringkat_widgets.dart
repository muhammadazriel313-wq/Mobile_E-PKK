import 'package:flutter/material.dart';
import 'peringkat_model.dart';

class PeringkatTile extends StatelessWidget {
  final PeringkatItem item;
  const PeringkatTile({super.key, required this.item});

  Color get _warna {
    switch (item.rank) {
      case 1:
        return const Color(0xFFFFC107);
      case 2:
        return const Color(0xFF9E9E9E);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return Colors.pink.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Row(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: _warna,
            child: Text('${item.rank}',
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          const SizedBox(width: 10),
          CircleAvatar(
            radius: 20,
            backgroundImage: item.foto != null ? NetworkImage(item.foto!) : null,
            child: item.foto == null ? const Icon(Icons.person) : null,
          ),
        ]),
        title: Text(item.nama, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: Text('${item.poin} poin',
            style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
    );
  }
}

Future<PeringkatPeriode?> pilihPeriode(
    BuildContext context, PeringkatPeriode aktif) {
  return showModalBottomSheet<PeringkatPeriode>(
    context: context,
    builder: (_) => SafeArea(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Pilih periode',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        for (final p in PeringkatPeriode.values)
          ListTile(
            title: Text(p.label),
            trailing: p == aktif ? const Icon(Icons.check) : null,
            onTap: () => Navigator.pop(context, p),
          ),
      ]),
    ),
  );
}
