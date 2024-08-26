import 'package:supabase_flutter/supabase_flutter.dart';

class ProductRepository {
  final SupabaseClient supabase;

  ProductRepository({
    required this.supabase,
  });

  getProducts() async {
    return await supabase
        .from('products')
        .select('id, name, price, image_url, created_at')
        .order(
          'created_at',
          ascending: false,
        );
  }
}
