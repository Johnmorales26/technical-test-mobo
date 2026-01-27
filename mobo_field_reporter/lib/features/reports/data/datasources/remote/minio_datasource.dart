import 'dart:io';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

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
    Logger logger = Logger();

    try {
      final String uploadUrl = '/evidence-bucket/$fileName';

      logger.d(
        'Starting file upload',
        error: {
          'fileName': fileName,
          'filePath': file.path,
          'url': '${_dio.options.baseUrl}$uploadUrl',
        },
      );

      final List<int> fileBytes = await file.readAsBytes();

      logger.d(
        'File read successfully',
        error: {
          'sizeInBytes': fileBytes.length,
        },
      );

      final response = await _dio.put(
        uploadUrl,
        data: Stream.fromIterable([fileBytes]),
        options: Options(
          headers: {
            Headers.contentLengthHeader: fileBytes.length,
            'Content-Type': 'application/octet-stream',
          },
        ),
      );

      logger.d(
        'Upload finished',
        error: {
          'statusCode': response.statusCode,
          'statusMessage': response.statusMessage,
        },
      );

      final fileUrl =
          '${_dio.options.baseUrl}/evidence-bucket/$fileName';

      logger.d(
        'File available at',
        error: fileUrl,
      );

      return fileUrl;
    } on DioException catch (e, stackTrace) {
      logger.e(
        'Error uploading file to MinIO',
        error: {
          'message': e.message,
          'type': e.type.toString(),
          'statusCode': e.response?.statusCode,
          'response': e.response?.data,
        },
        stackTrace: stackTrace,
      );

      throw ServerFailure('Error subiendo a MinIO: ${e.message}');
    } catch (e, stackTrace) {
      logger.e(
        'Unexpected error uploading file',
        error: e,
        stackTrace: stackTrace,
      );

      rethrow;
    }
  }
}