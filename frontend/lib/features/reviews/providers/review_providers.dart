import 'package:guideme/features/auth/providers/auth_providers.dart';
import 'package:guideme/features/reviews/data/datasources/review_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final reviewDataSourceProvider = Provider<ReviewRemoteDataSource>(
  (ref) => ReviewRemoteDataSource(ref.watch(dioProvider)),
);
