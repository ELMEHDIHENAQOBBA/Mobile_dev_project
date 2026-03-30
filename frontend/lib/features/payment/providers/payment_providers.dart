import 'package:guideme/features/auth/providers/auth_providers.dart';
import 'package:guideme/features/payment/data/datasources/payment_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final paymentDataSourceProvider = Provider<PaymentRemoteDataSource>(
  (ref) => PaymentRemoteDataSource(ref.watch(dioProvider)),
);
