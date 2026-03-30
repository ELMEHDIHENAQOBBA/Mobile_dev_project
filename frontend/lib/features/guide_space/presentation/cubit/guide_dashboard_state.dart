part of 'guide_dashboard_cubit.dart';

abstract class GuideDashboardState {}
class GuideDashboardInitial extends GuideDashboardState {}
class GuideDashboardLoading extends GuideDashboardState {}
class GuideDashboardLoaded extends GuideDashboardState {
  final Map<String, dynamic> data;
  GuideDashboardLoaded(this.data);
}
class GuideBookingsLoaded extends GuideDashboardState {
  final List bookings;
  GuideBookingsLoaded(this.bookings);
}
class GuideDashboardError extends GuideDashboardState {
  final String message;
  GuideDashboardError(this.message);
}
