import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import 'draft_model.dart';

class DraftService {
  static final DraftService _instance = DraftService._internal();
  factory DraftService() => _instance;
  DraftService._internal();

  Database? _database;
  Future<Database>? _databaseFuture;
  Future<void> _webOperation = Future<void>.value();
  bool _webRecoveryComplete = false;
  static const String _tableName = 'drafts';
  static const String _webStorageKey = 'epkk_drafts_web';

  Future<T> _withWebDrafts<T>(
    Future<T> Function(List<DraftModel> drafts) operation,
  ) {
    final result = _webOperation.then((_) async {
      final prefs = await SharedPreferences.getInstance();
      final stored = prefs.getString(_webStorageKey);
      final drafts = <DraftModel>[];
      if (stored != null) {
        final decoded = jsonDecode(stored);
        if (decoded is List) {
          drafts.addAll(
            decoded.whereType<Map>().map(
              (row) => DraftModel.fromMap(Map<String, dynamic>.from(row)),
            ),
          );
        }
      }

      if (!_webRecoveryComplete) {
        for (var i = 0; i < drafts.length; i++) {
          if (drafts[i].status == 'mengirim') {
            drafts[i] = drafts[i].copyWith(
              status: 'gagal_kirim',
              pesanError: 'Pengiriman terputus saat aplikasi ditutup.',
            );
          }
        }
        _webRecoveryComplete = true;
      }

      final value = await operation(drafts);
      await prefs.setString(
        _webStorageKey,
        jsonEncode(drafts.map((draft) => draft.toMap()).toList()),
      );
      return value;
    });
    _webOperation = result.then<void>(
      (_) {},
      onError: (Object error, StackTrace stack) {},
    );
    return result;
  }

  Future<Database> get database {
    if (_database != null) return Future.value(_database);
    return _databaseFuture ??= _openDatabase();
  }

  Future<Database> _openDatabase() async {
    try {
      final db = await _initDb();
      _database = db;
      return db;
    } catch (_) {
      _databaseFuture = null;
      rethrow;
    }
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'epkk_drafts.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id TEXT PRIMARY KEY,
            id_akun TEXT NOT NULL,
            jenis TEXT NOT NULL,
            data_form TEXT NOT NULL,
            daftar_foto TEXT NOT NULL,
            tanggal_dibuat TEXT NOT NULL,
            status TEXT NOT NULL,
            pesan_error TEXT
          )
        ''');
      },
      onOpen: (db) async {
        // Jika aplikasi tertutup saat status "mengirim", saat dibuka lagi kembalikan status ke "gagal_kirim"
        try {
          await db.update(
            _tableName,
            {
              'status': 'gagal_kirim',
              'pesan_error': 'Pengiriman terputus saat aplikasi ditutup.',
            },
            where: 'status = ?',
            whereArgs: ['mengirim'],
          );
        } catch (e) {
          debugPrint('Error recovering interrupted drafts: $e');
        }
      },
    );
  }

  /// Folder khusus draf di application documents directory
  Future<Directory> getDraftFilesDirectory() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final draftDir = Directory(p.join(docsDir.path, 'draft_photos'));
    if (!await draftDir.exists()) {
      await draftDir.create(recursive: true);
    }
    return draftDir;
  }

  /// Salin foto ke folder khusus draf dan kompres hingga <= 1 MB
  Future<String?> processAndSavePhoto(String originalPath) async {
    try {
      final originalFile = File(originalPath);
      if (!await originalFile.exists()) return null;

      final draftDir = await getDraftFilesDirectory();
      final extension = p.extension(originalPath).toLowerCase();
      final targetExt = (extension == '.png') ? '.png' : '.jpg';
      final fileName = 'draft_img_${const Uuid().v4()}$targetExt';
      final targetPath = p.join(draftDir.path, fileName);

      final originalSize = await originalFile.length();
      // 1 MB = 1024 * 1024 = 1,048,576 bytes
      if (originalSize > 1024 * 1024) {
        // Perlu kompresi
        final result = await FlutterImageCompress.compressAndGetFile(
          originalFile.absolute.path,
          targetPath,
          quality: 80,
          minWidth: 1280,
          minHeight: 1280,
        );
        if (result != null) {
          return result.path;
        }
      }

      // Jika di bawah 1 MB atau kompresi fallback, salin langsung
      final copied = await originalFile.copy(targetPath);
      return copied.path;
    } catch (e) {
      debugPrint('Error processAndSavePhoto: $e');
      // Fallback: kembalikan path asli jika tidak bisa disalin
      return originalPath;
    }
  }

  /// Hapus file foto dari disk
  Future<void> deletePhotoFiles(List<String> photoPaths) async {
    for (final path in photoPaths) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
        }
      } catch (e) {
        debugPrint('Error deleting photo $path: $e');
      }
    }
  }

  /// Simpan draf baru
  Future<DraftModel> simpanDraft({
    required String idAkun,
    required String jenis,
    required Map<String, dynamic> dataForm,
    required List<String> originalPhotoPaths,
  }) async {
    if (kIsWeb) {
      return _withWebDrafts((drafts) async {
        final draft = DraftModel(
          id: const Uuid().v4(),
          idAkun: idAkun,
          jenis: jenis,
          dataForm: dataForm,
          daftarFoto: const [],
          tanggalDibuat: DateTime.now().toIso8601String(),
          status: 'draf',
        );
        drafts.add(draft);
        return draft;
      });
    }
    final db = await database;
    final id = const Uuid().v4();
    final tanggalDibuat = DateTime.now().toIso8601String();

    // Proses foto
    List<String> savedPhotoPaths = [];
    for (final pth in originalPhotoPaths) {
      final processed = await processAndSavePhoto(pth);
      if (processed != null) {
        savedPhotoPaths.add(processed);
      }
    }

    final draft = DraftModel(
      id: id,
      idAkun: idAkun,
      jenis: jenis,
      dataForm: dataForm,
      daftarFoto: savedPhotoPaths,
      tanggalDibuat: tanggalDibuat,
      status: 'draf',
    );

    await db.insert(
      _tableName,
      draft.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return draft;
  }

  /// Ambil semua draf milik akun tertentu, opsional difilter per jenis atau daftar jenis
  Future<List<DraftModel>> getDraftsByAkun({
    required String idAkun,
    String? jenis,
    List<String>? daftarJenis,
  }) async {
    if (kIsWeb) {
      return _withWebDrafts((drafts) async {
        final filtered = drafts.where((draft) {
          if (draft.idAkun != idAkun) return false;
          if (jenis != null && jenis.isNotEmpty) return draft.jenis == jenis;
          if (daftarJenis != null && daftarJenis.isNotEmpty) {
            return daftarJenis.contains(draft.jenis);
          }
          return true;
        }).toList()..sort((a, b) => b.tanggalDibuat.compareTo(a.tanggalDibuat));
        return filtered;
      });
    }
    final db = await database;

    String whereClause = 'id_akun = ?';
    List<dynamic> whereArgs = [idAkun];

    if (jenis != null && jenis.isNotEmpty) {
      whereClause += ' AND jenis = ?';
      whereArgs.add(jenis);
    } else if (daftarJenis != null && daftarJenis.isNotEmpty) {
      final placeholders = List.filled(daftarJenis.length, '?').join(',');
      whereClause += ' AND jenis IN ($placeholders)';
      whereArgs.addAll(daftarJenis);
    }

    final maps = await db.query(
      _tableName,
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'tanggal_dibuat DESC',
    );

    return maps.map((e) => DraftModel.fromMap(e)).toList();
  }

  /// Ambil satu draf berdasarkan ID
  Future<DraftModel?> getDraftById(String id) async {
    if (kIsWeb) {
      return _withWebDrafts((drafts) async {
        for (final draft in drafts) {
          if (draft.id == id) return draft;
        }
        return null;
      });
    }
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return DraftModel.fromMap(maps.first);
  }

  /// Update draf (misal perubahan data form atau foto)
  Future<void> updateDraft(DraftModel draft) async {
    if (kIsWeb) {
      await _withWebDrafts((drafts) async {
        final index = drafts.indexWhere((item) => item.id == draft.id);
        if (index >= 0) drafts[index] = draft;
      });
      return;
    }
    final db = await database;
    await db.update(
      _tableName,
      draft.toMap(),
      where: 'id = ?',
      whereArgs: [draft.id],
    );
  }

  /// Ubah status draf ('draf', 'mengirim', 'gagal_kirim')
  Future<void> ubahStatus({
    required String id,
    required String status,
    String? pesanError,
  }) async {
    if (kIsWeb) {
      await _withWebDrafts((drafts) async {
        final index = drafts.indexWhere((draft) => draft.id == id);
        if (index >= 0) {
          drafts[index] = drafts[index].copyWith(
            status: status,
            pesanError: pesanError,
          );
        }
      });
      return;
    }
    final db = await database;
    await db.update(
      _tableName,
      {'status': status, 'pesan_error': pesanError},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Hapus draf beserta file fotonya
  Future<void> hapusDraft(String id) async {
    if (kIsWeb) {
      await _withWebDrafts((drafts) async {
        drafts.removeWhere((draft) => draft.id == id);
      });
      return;
    }
    final draft = await getDraftById(id);
    if (draft != null) {
      await deletePhotoFiles(draft.daftarFoto);
    }
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  /// Hitung jumlah draf milik akun dengan status 'draf' atau 'gagal_kirim'
  Future<int> hitungJumlahDraft({
    required String idAkun,
    List<String>? daftarJenis,
  }) async {
    if (kIsWeb) {
      return _withWebDrafts((drafts) async {
        return drafts.where((draft) {
          if (draft.idAkun != idAkun ||
              (draft.status != 'draf' && draft.status != 'gagal_kirim')) {
            return false;
          }
          return daftarJenis == null ||
              daftarJenis.isEmpty ||
              daftarJenis.contains(draft.jenis);
        }).length;
      });
    }
    final db = await database;
    String whereClause = 'id_akun = ? AND status IN (?, ?)';
    List<dynamic> whereArgs = [idAkun, 'draf', 'gagal_kirim'];

    if (daftarJenis != null && daftarJenis.isNotEmpty) {
      final placeholders = List.filled(daftarJenis.length, '?').join(',');
      whereClause += ' AND jenis IN ($placeholders)';
      whereArgs.addAll(daftarJenis);
    }

    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM $_tableName WHERE $whereClause',
      whereArgs,
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }
}
