import 'package:blca_project_app/model/error.dart';

class Result<T> {
  final T? _data;
  final GeneralError? error;

  const Result({
    T? data,
    this.error,
  }) : _data = data;

  bool get hasError => error != null;
  T get data => _data!;
}
