import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/errors/failures.dart';

abstract class MinioRemoteDataSource {
  Future<String> uploadFile(File file, String fileName);
}

@LazySingleton(as: MinioRemoteDataSource)
class MinioRemoteDataSourceImpl implements MinioRemoteDataSource {
  final Dio _dio;

  MinioRemoteDataSourceImpl(this._dio);

  @override
  Future<String> uploadFile(File file, String fileName) async {
    try {
      final bucket = 'evidence-bucket';
      final String uploadUrl = '/$bucket/$fileName';

      final List<int> fileBytes = await file.readAsBytes();

      await _dio.put(
        uploadUrl,
        data: fileBytes,
        options: Options(
          headers: {
            Headers.contentTypeHeader: 'application/octet-stream',
            Headers.contentLengthHeader: fileBytes.length,
          },
          responseType: ResponseType.plain,
        ),
      );

      final fileUrl = '${_dio.options.baseUrl}/$bucket/$fileName';

      return fileUrl;
    } on DioException catch (e, _) {
      throw ServerFailure('Error subiendo a MinIO: ${e.message}');
    } catch (e, _) {
      rethrow;
    }
  }
}
