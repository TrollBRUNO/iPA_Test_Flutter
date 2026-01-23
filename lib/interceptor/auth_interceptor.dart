import 'package:dio/dio.dart';
import 'package:first_app_flutter/services/auth_service.dart';
import 'package:first_app_flutter/services/token_service.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (TokenService.accessToken == null) {
      await TokenService.loadAccessToken();
    }

    if (TokenService.accessToken != null) {
      options.headers['Authorization'] = 'Bearer ${TokenService.accessToken}';
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    // Если ошибка 401 — пробуем обновить токен
    if (err.response?.statusCode == 401) {
      final success = await AuthService.refreshToken();
      if (success) {
        final options = err.requestOptions;
        options.headers['Authorization'] = 'Bearer ${TokenService.accessToken}';
        final cloneReq = await AuthService.dio.fetch(options);
        return handler.resolve(cloneReq);
      } else {
        // Токен не обновился — нужно перелогиниться
        await TokenService.clearTokens();
      }
    }
    super.onError(err, handler);
  }
}

// Пример добавления interceptor
/* Dio dio = Dio();
dio.interceptors.add(AuthInterceptor()); */

void configureInterceptors() {
  // Используем общий экземпляр Dio из AuthService
  AuthService.dio.interceptors.add(AuthInterceptor());
}
