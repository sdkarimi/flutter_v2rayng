class AppException{
  final String message;
  final ErrorType typeError;
  AppException({this.typeError=ErrorType.NOT_FOUND, this.message='خطای نامشخص'});

}

enum ErrorType{
  NO_INTERNET , NOT_FOUND , AOUTRIZATION
}
