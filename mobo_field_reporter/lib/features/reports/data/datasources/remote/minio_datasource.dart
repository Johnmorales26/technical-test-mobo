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
      final String uploadUrl = '/evidence-bucket/$fileName';

      final List<int> fileBytes = await file.readAsBytes();

      await _dio.put(
        uploadUrl,
        data: Stream.fromIterable([fileBytes]),
        options: Options(
          headers: {
            Headers.contentLengthHeader: fileBytes.length,
            'Content-Type': 'application/octet-stream',
          },
        ),
      );

      return '${_dio.options.baseUrl}/evidence-bucket/$fileName';
    } on DioException catch (e) {
      throw ServerFailure('Error subiendo a MinIO: ${e.message}');
    }
  }
}