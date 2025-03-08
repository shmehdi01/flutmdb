part of 'network_cubit.dart';

@immutable
abstract class NetworkState {}

class NetworkInitial extends NetworkState {}
class NoNetwork extends NetworkState {}
class NetworkAvailable extends NetworkState {}
