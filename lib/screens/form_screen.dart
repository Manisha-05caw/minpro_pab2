import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/health_record.dart';
import '../services/supabase_service.dart';
import '../theme/app_theme.dart';

const List<String> _dokterSuggestions = [
  'Dr. Umum - Puskesmas',
  'Dr. Spesialis Jantung',
  'Dr. Spesialis Penyakit Dalam',
  'Dr. Spesialis Anak',
  'Dr. Spesialis Ortopedi',
  'Dr. Spesialis THT',
  'Dr. Spesialis Kulit',
  'Dr. Spesialis Mata',
  'Dr. Spesialis Saraf',
  'Dr. Spesialis Kandungan',
  'RS Umum Daerah',
  'Klinik Pratama',
  'Puskesmas',
];

class FormScreen extends StatefulWidget {
  final HealthRecord? record;
  const FormScreen({super.key, this.record});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _tanggalCtrl;
  late TextEditingController _namaDokterCtrl;
  late TextEditingController _diagnosisCtrl;
  late TextEditingController _obatCtrl;
  late TextEditingController _sistolikCtrl;
  late TextEditingController _diastolikCtrl;
  late TextEditingController _beratCtrl;
  late TextEditingController _tinggiCtrl;
  late TextEditingController _catatanCtrl;

  bool _loading = false;
  bool get isEdit => widget.record != null;

  @override
  void initState() {
    super.initState();
    final r = widget.record;

    // Parse tekanan darah jika edit
    String sistolik = '', diastolik = '';
    if (r != null && r.tekananDarah.contains('/')) {
      final parts = r.tekananDarah.split('/');
      sistolik = parts[0].trim();
      diastolik = parts[1].trim();
    }

    // Parse berat/tinggi jika edit
    String berat = '', tinggi = '';
    if (r != null && r.beratTinggi.contains('/')) {
      final parts = r.beratTinggi.split('/');
      berat = parts[0].replaceAll(RegExp(r'[^0-9.]'), '').trim();
      tinggi = parts[1].replaceAll(RegExp(r'[^0-9.]'), '').trim();
    }

    _tanggalCtrl = TextEditingController(text: r?.tanggal ?? '');
    _namaDokterCtrl = TextEditingController(text: r?.namaDokter ?? '');
    _diagnosisCtrl = TextEditingController(text: r?.diagnosis ?? '');
    _obatCtrl = TextEditingController(text: r?.obat ?? '');
    _sistolikCtrl = TextEditingController(text: sistolik);
    _diastolikCtrl = TextEditingController(text: diastolik);
    _beratCtrl = TextEditingController(text: berat);
    _tinggiCtrl = TextEditingController(text: tinggi);
    _catatanCtrl = TextEditingController(text: r?.catatan ?? '');
  }

  @override
  void dispose() {
    _tanggalCtrl.dispose();
    _namaDokterCtrl.dispose();
    _diagnosisCtrl.dispose();
    _obatCtrl.dispose();
    _sistolikCtrl.dispose();
    _diastolikCtrl.dispose();
    _beratCtrl.dispose();
    _tinggiCtrl.dispose();
    _catatanCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      const bulan = [
        '',
        'Januari',
        'Februari',
        'Maret',
        'April',
        'Mei',
        'Juni',
        'Juli',
        'Agustus',
        'September',
        'Oktober',
        'November',
        'Desember'
      ];
      _tanggalCtrl.text = '${picked.day} ${bulan[picked.month]} ${picked.year}';
    }
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final tekananDarah =
        '${_sistolikCtrl.text.trim()}/${_diastolikCtrl.text.trim()}';
    final beratTinggi =
        '${_beratCtrl.text.trim()}kg / ${_tinggiCtrl.text.trim()}cm';
    final userId = SupabaseService.currentUser?.id ?? '';

    try {
      if (isEdit) {
        final updated = HealthRecord(
          id: widget.record!.id,
          userId: userId,
          tanggal: _tanggalCtrl.text.trim(),
          namaDokter: _namaDokterCtrl.text.trim(),
          diagnosis: _diagnosisCtrl.text.trim(),
          obat: _obatCtrl.text.trim(),
          tekananDarah: tekananDarah,
          beratTinggi: beratTinggi,
          catatan: _catatanCtrl.text.trim(),
        );
        await SupabaseService.updateRecord(updated);
      } else {
        final newRecord = HealthRecord(
          id: '',
          userId: userId,
          tanggal: _tanggalCtrl.text.trim(),
          namaDokter: _namaDokterCtrl.text.trim(),
          diagnosis: _diagnosisCtrl.text.trim(),
          obat: _obatCtrl.text.trim(),
          tekananDarah: tekananDarah,
          beratTinggi: beratTinggi,
          catatan: _catatanCtrl.text.trim(),
        );
        await SupabaseService.addRecord(newRecord);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(isEdit
            ? 'Data berhasil diperbarui!'
            : 'Data berhasil ditambahkan!'),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Gagal menyimpan data. Coba lagi.'),
        backgroundColor: AppTheme.danger,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Riwayat' : 'Tambah Riwayat'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionLabel('Informasi Pemeriksaan'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _tanggalCtrl,
                readOnly: true,
                onTap: _pickDate,
                decoration: const InputDecoration(
                  labelText: 'Tanggal Pemeriksaan *',
                  prefixIcon: Icon(Icons.calendar_today_outlined,
                      color: AppTheme.primary),
                  suffixIcon:
                      Icon(Icons.arrow_drop_down, color: AppTheme.primary),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Tanggal tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 14),
              Autocomplete<String>(
                optionsBuilder: (textEditingValue) {
                  if (textEditingValue.text.isEmpty) return _dokterSuggestions;
                  return _dokterSuggestions.where((s) => s
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase()));
                },
                onSelected: (val) => _namaDokterCtrl.text = val,
                fieldViewBuilder:
                    (context, controller, focusNode, onSubmitted) {
                  if (_namaDokterCtrl.text.isNotEmpty &&
                      controller.text.isEmpty) {
                    controller.text = _namaDokterCtrl.text;
                  }
                  controller.addListener(
                      () => _namaDokterCtrl.text = controller.text);
                  return TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    decoration: const InputDecoration(
                      labelText: 'Nama Dokter / Faskes *',
                      prefixIcon:
                          Icon(Icons.person_outline, color: AppTheme.primary),
                      hintText: 'Ketik atau pilih dari saran',
                    ),
                    validator: (_) => (_namaDokterCtrl.text.trim().isEmpty)
                        ? 'Nama dokter tidak boleh kosong'
                        : null,
                  );
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4,
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            final option = options.elementAt(index);
                            return ListTile(
                              dense: true,
                              leading: const Icon(Icons.local_hospital_outlined,
                                  color: AppTheme.primary, size: 18),
                              title: Text(option,
                                  style: const TextStyle(fontSize: 14)),
                              onTap: () => onSelected(option),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 22),
              _sectionLabel('Hasil Pemeriksaan'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _diagnosisCtrl,
                decoration: const InputDecoration(
                  labelText: 'Diagnosis *',
                  prefixIcon: Icon(Icons.medical_information_outlined,
                      color: AppTheme.primary),
                  hintText: 'Contoh: Hipertensi Ringan',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Diagnosis tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _obatCtrl,
                decoration: const InputDecoration(
                  labelText: 'Obat yang Diresepkan *',
                  prefixIcon:
                      Icon(Icons.medication_outlined, color: AppTheme.primary),
                  hintText: 'Contoh: Amlodipine 5mg',
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? 'Obat tidak boleh kosong'
                    : null,
              ),
              const SizedBox(height: 22),
              _sectionLabel('Data Vital'),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _sistolikCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Sistolik *',
                        prefixIcon: Icon(Icons.monitor_heart_outlined,
                            color: AppTheme.primary),
                        hintText: '120',
                        suffixText: 'mmHg',
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Wajib diisi';
                        final val = int.tryParse(v);
                        if (val == null || val < 60 || val > 250) {
                          return 'Nilai 60–250';
                        }
                        return null;
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 18, left: 8, right: 8),
                    child: Text('/',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _diastolikCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Diastolik *',
                        hintText: '80',
                        suffixText: 'mmHg',
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Wajib diisi';
                        final val = int.tryParse(v);
                        if (val == null || val < 40 || val > 150) {
                          return 'Nilai 40–150';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _beratCtrl,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d{0,3}(\.\d{0,1})?')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Berat Badan *',
                        prefixIcon: Icon(Icons.monitor_weight_outlined,
                            color: AppTheme.primary),
                        hintText: '65',
                        suffixText: 'kg',
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Wajib diisi';
                        final val = double.tryParse(v);
                        if (val == null || val < 1 || val > 300) {
                          return 'Nilai 1–300 kg';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _tinggiCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(3),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Tinggi Badan *',
                        hintText: '170',
                        suffixText: 'cm',
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Wajib diisi';
                        final val = int.tryParse(v);
                        if (val == null || val < 50 || val > 250) {
                          return 'Nilai 50–250 cm';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _sectionLabel('Catatan Tambahan'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _catatanCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Catatan',
                  prefixIcon:
                      Icon(Icons.notes_outlined, color: AppTheme.primary),
                  hintText: 'Catatan dari dokter atau kondisi lainnya...',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _loading ? null : _simpan,
                  icon: _loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : Icon(isEdit
                          ? Icons.save_outlined
                          : Icons.add_circle_outline),
                  label: Text(isEdit ? 'Simpan Perubahan' : 'Tambah Riwayat'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child:
                      const Text('Batal', style: TextStyle(color: Colors.grey)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ],
    );
  }
}
