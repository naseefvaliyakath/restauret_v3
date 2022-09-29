class MyResponse{

  final int statusCode;
  final String status;
  final String message;
  final dynamic data;

  MyResponse( {required this.statusCode, required this.status,required this.message, this.data});
}
