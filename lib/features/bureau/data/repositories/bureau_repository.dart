import '../../domain/bureau.dart';
import '../datasources/bureau_remote_datasource.dart';

abstract class BureauRepository {
  Future<List<Bureau>> getAllBureaux();
  Future<Bureau?> getBureauById(int id);
  Future<Bureau> createBureau(Bureau bureau);
  Future<Bureau> updateBureau(int id, Bureau bureau);
  Future<void> deleteBureau(int id);
  Future<List<Bureau>> getBureauxByDepartement(int departementId);
}

class BureauRepositoryImpl implements BureauRepository {
  @override
  Future<List<Bureau>> getBureauxByDepartement(int departementId) async {
    return await _remoteDataSource.getBureauxByDepartement(departementId);
  }
  final BureauRemoteDataSource _remoteDataSource;

  BureauRepositoryImpl({BureauRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? BureauRemoteDataSourceImpl();

  @override
  Future<List<Bureau>> getAllBureaux() async {
    return await _remoteDataSource.getAllBureaux();
  }

  @override
  Future<Bureau?> getBureauById(int id) async {
    return await _remoteDataSource.getBureauById(id);
  }

  @override
  Future<Bureau> createBureau(Bureau bureau) async {
    return await _remoteDataSource.createBureau(bureau);
  }

  @override
  Future<Bureau> updateBureau(int id, Bureau bureau) async {
    return await _remoteDataSource.updateBureau(id, bureau);
  }

  @override
  Future<void> deleteBureau(int id) async {
    await _remoteDataSource.deleteBureau(id);
  }
}
