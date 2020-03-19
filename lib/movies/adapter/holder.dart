import 'package:android_lab/movies/adapter/api.dart';
import 'package:android_lab/movies/adapter/database.dart';
import 'package:android_lab/movies/adapter/service.dart';

class Holder {
  static final AbstractDatabaseHelper databaseHelper = DatabaseHelper();
  static final MovieService service = MovieService(databaseHelper);
  static final Api api = Api();
}
