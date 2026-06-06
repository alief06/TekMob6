import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/report_provider.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ReportProvider>(context, listen: false).resetForm();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final provider = Provider.of<ReportProvider>(context, listen: false);
      
      if (provider.currentImagePath == null || provider.currentPosition == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Harap ambil foto dan lokasi terlebih dahulu'),
            backgroundColor: AppColors.danger,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        return;
      }

      final success = await provider.addReport(
        _titleController.text,
        _descriptionController.text,
      );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Laporan berhasil ditambahkan!'),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        _titleController.clear();
        _descriptionController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Laporan Baru'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0).copyWith(bottom: 120),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildCardSection(
                title: 'Judul Laporan',
                child: TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan judul laporan',
                    prefixIcon: Icon(Icons.title),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty ? 'Judul wajib diisi' : null,
                ),
              ),
              const SizedBox(height: 20),
              _buildCardSection(
                title: 'Deskripsi Kejadian',
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Jelaskan detail kejadian...',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 4,
                  validator: (value) => value == null || value.trim().isEmpty ? 'Deskripsi wajib diisi' : null,
                ),
              ),
              const SizedBox(height: 20),
              _buildPhotoLocationSection(context),
              const SizedBox(height: 32),
              Consumer<ReportProvider>(
                builder: (context, provider, child) {
                  return ElevatedButton(
                    onPressed: provider.isSubmitting ? null : _submit,
                    child: provider.isSubmitting
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Simpan Laporan'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCardSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: child,
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoLocationSection(BuildContext context) {
    return Consumer<ReportProvider>(
      builder: (context, provider, child) {
        final hasImage = provider.currentImagePath != null;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Foto & Lokasi GPS', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (hasImage) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(provider.currentImagePath!),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          provider.pickImageAndLocation();
                        },
                        icon: const Icon(Icons.camera_alt),
                        label: Text(hasImage ? 'Ganti Foto & Lokasi' : 'Ambil Foto & Lokasi'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          side: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                    ),
                    if (provider.currentPosition != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.success.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.success),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Lat: ${provider.currentPosition!.latitude.toStringAsFixed(4)}\nLng: ${provider.currentPosition!.longitude.toStringAsFixed(4)}',
                                style: const TextStyle(color: AppColors.success, fontSize: 13),
                              ),
                            ),
                            const Icon(Icons.check_circle, color: AppColors.success),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
