import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/vendor_registration_model.dart';
import '../data/vendor_repository.dart';

enum VendorStatus { unverified, pending, verified }

class VendorState {
  final VendorStatus status;
  final VendorRegistrationModel? model;
  final bool isInitializing;

  const VendorState({
    this.status = VendorStatus.unverified, 
    this.model,
    this.isInitializing = true,
  });

  VendorState copyWith({
    VendorStatus? status, 
    VendorRegistrationModel? model,
    bool? isInitializing,
  }) {
    return VendorState(
      status: status ?? this.status,
      model: model ?? this.model,
      isInitializing: isInitializing ?? this.isInitializing,
    );
  }
}

final vendorRegistrationControllerProvider =
    StateNotifierProvider<VendorRegistrationController, VendorState>((ref) {
  final repo = ref.watch(vendorRepositoryProvider);
  final controller = VendorRegistrationController(repo);
  controller._loadSavedStatus();
  return controller;
});

class VendorRegistrationController extends StateNotifier<VendorState> {
  final VendorRepository _repository;
  static const String _vendorStatusKey = 'is_verified_vendor';

  VendorRegistrationController(this._repository) : super(const VendorState());

  Future<void> _loadSavedStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isVerified = prefs.getBool(_vendorStatusKey) ?? false;
    if (mounted) {
      if (isVerified) {
        state = state.copyWith(status: VendorStatus.verified, isInitializing: false);
      } else {
        state = state.copyWith(isInitializing: false);
      }
    }
  }

  Future<void> _saveStatus(bool isVerified) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vendorStatusKey, isVerified);
  }

  Future<void> submitRegistration(VendorRegistrationModel model) async {
    // 1. Immediately change to pending to show loader
    state = state.copyWith(status: VendorStatus.pending, model: model);

    try {
      // 2. Await the actual repository call
      await _repository.registerVendor(model);
      
      // 3. Simulate a backend 10-second wait time for verification logic
      await Future.delayed(const Duration(seconds: 10));

      // 4. Update state to verified
      state = state.copyWith(status: VendorStatus.verified);
      await _saveStatus(true);
    } on DioException catch (e) {
      throw Exception('Network error during registration: ${e.message}');
    } catch (e) {
      // If error, revert to unverified
      state = state.copyWith(status: VendorStatus.unverified);
      rethrow;
    }
  }

  Future<void> resetVendor() async {
    state = const VendorState(status: VendorStatus.unverified, model: null);
    await _saveStatus(false);
  }
}
