import '../database/database_helper.dart';
import '../models/report_model.dart';

class ReportRepository {
  final DatabaseHelper _databaseHelper;

  ReportRepository(this._databaseHelper);

  Future<List<Report>> getReports() async {
    return await _databaseHelper.fetchAllReports();
  }

  Future<int> addReport(Report report) async {
    return await _databaseHelper.insertReport(report);
  }

  Future<int> updateReport(Report report) async {
    return await _databaseHelper.updateReport(report);
  }

  Future<int> deleteReport(int id) async {
    return await _databaseHelper.deleteReport(id);
  }
}
