import 'package:supabase_flutter/supabase_flutter.dart';

class OrderRepository {
  final SupabaseClient supabase;

  OrderRepository({
    required this.supabase,
  });

  createOrder({
    required String id,
    required String quantity,
    required price,
    required name,
    required imageUrl,
    required userId,
  }) async {
    return await supabase
        .from('orders')
        .insert({
          'id': id,
          'quantity': quantity,
          'price': price,
          'name': name,
          'image_url': imageUrl,
          'user_id': userId,
        })
        .select()
        .single();
  }

  //userId
  getOrders({required String userId}) async {
    return await supabase
        .from('orders')
        .select('id, quantity, price, name,image_url,user_id, created_at')
        .eq('user_id', userId)
        .eq('payment_status', true);
  }

  changePaymentStatus({required String orderId}) async {
    return await supabase
        .from('orders')
        .update({'payment_status': true})
        .eq('id', orderId)
        .select();
  }
}
