import 'package:youthspot/db/models/service_model.dart';
import 'package:youthspot/main.dart';

class ServiceService {
  Future<List<Service>> fetchServices() async {
    final response = await supabase.from('services').select();
    final List<dynamic> data = response;
    return data.map((e) => Service.fromMap(e)).toList();
  }
}
