import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import '../data/models/report_model.dart';
import '../data/repositories/report_repository.dart';
import '../services/location_service.dart';

class ReportProvider extends ChangeNotifier {
  final ReportRepository _repository;

  ReportProvider(this._repository);

  List<Report> _reports = [];
  List<Report> get reports => _reports;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  List<Report> get filteredReports {
    if (_searchQuery.isEmpty) {
      return _reports;
    }
    return _reports.where((report) {
      return report.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             report.description.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  String? _currentImagePath;
  String? get currentImagePath => _currentImagePath;

  Position? _currentPosition;
  Position? get currentPosition => _currentPosition;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSubmitting = false;
  bool get isSubmitting => _isSubmitting;

  Future<void> fetchReports() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _reports = await _repository.getReports();
    } catch (e) {
      _errorMessage = 'Gagal memuat laporan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      _currentImagePath = image.path;
      notifyListeners();
    }
  }

  Future<void> pickLocation() async {
    try {
      _currentPosition = await LocationService.getCurrentPosition();
      notifyListeners();
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  Future<void> pickImageAndLocation() async {
    await pickImage();
    if (_currentImagePath != null) {
      await pickLocation();
    }
  }

  void setImagePath(String path) {
    _currentImagePath = path;
    notifyListeners();
  }

  void setPosition(double lat, double lng) {
    _currentPosition = Position(
      longitude: lng,
      latitude: lat,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      altitudeAccuracy: 0.0,
      headingAccuracy: 0.0,
    );
    notifyListeners();
  }

  Future<bool> addReport(String title, String description) async {
    if (title.isEmpty || description.isEmpty || _currentImagePath == null || _currentPosition == null) {
      return false;
    }

    _isSubmitting = true;
    notifyListeners();

    final now = DateTime.now().toIso8601String();
    final report = Report(
      title: title,
      description: description,
      imagePath: _currentImagePath!,
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
      createdAt: now,
      updatedAt: now,
    );

    await _repository.addReport(report);
    
    _currentImagePath = null;
    _currentPosition = null;
    _isSubmitting = false;
    notifyListeners();
    
    await fetchReports();
    return true;
  }

  Future<bool> updateReportData(int id, String title, String description, String createdAt) async {
    if (title.isEmpty || description.isEmpty || _currentImagePath == null || _currentPosition == null) {
      return false;
    }

    _isSubmitting = true;
    notifyListeners();

    final report = Report(
      id: id,
      title: title,
      description: description,
      imagePath: _currentImagePath!,
      latitude: _currentPosition!.latitude,
      longitude: _currentPosition!.longitude,
      createdAt: createdAt,
      updatedAt: DateTime.now().toIso8601String(),
    );

    await _repository.updateReport(report);
    
    _currentImagePath = null;
    _currentPosition = null;
    _isSubmitting = false;
    notifyListeners();
    
    await fetchReports();
    return true;
  }

  Future<void> deleteReport(int id) async {
    await _repository.deleteReport(id);
    await fetchReports();
  }

  void resetForm() {
    _currentImagePath = null;
    _currentPosition = null;
    notifyListeners();
  }
}
