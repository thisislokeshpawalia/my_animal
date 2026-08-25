import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'address_model.dart';

class AddressNotifier extends Notifier<List<AddressModel>> {
  static const String _storageKey = "saved_addresses";

  @override
  List<AddressModel> build() {
    _loadAddresses();
    return [];
  }

  Future<void> _loadAddresses() async {
    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString(_storageKey);

    if (jsonString == null || jsonString.isEmpty) {
      return;
    }

    final List decoded = jsonDecode(jsonString);

    state = decoded
        .map((e) => AddressModel.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<void> _saveAddresses() async {
    final prefs = await SharedPreferences.getInstance();

    final json = jsonEncode(
      state.map((e) => e.toMap()).toList(),
    );

    await prefs.setString(_storageKey, json);
  }

  Future<void> addAddress(AddressModel address) async {
    if (address.isDefault) {
      state = state
          .map(
            (e) => e.copyWith(isDefault: false),
      )
          .toList();
    }

    state = [...state, address];

    await _saveAddresses();
  }

  Future<void> updateAddress(AddressModel address) async {
    if (address.isDefault) {
      state = state
          .map(
            (e) => e.copyWith(isDefault: false),
      )
          .toList();
    }

    state = [
      for (final item in state)
        if (item.id == address.id) address else item
    ];

    await _saveAddresses();
  }

  Future<void> deleteAddress(String id) async {
    state = state.where((e) => e.id != id).toList();

    if (state.isNotEmpty &&
        !state.any((element) => element.isDefault)) {
      state = [
        state.first.copyWith(isDefault: true),
        ...state.skip(1),
      ];
    }

    await _saveAddresses();
  }

  Future<void> makeDefault(String id) async {
    state = state
        .map(
          (e) => e.copyWith(
        isDefault: e.id == id,
      ),
    )
        .toList();

    await _saveAddresses();
  }

  AddressModel? get defaultAddress {
    try {
      return state.firstWhere(
            (e) => e.isDefault,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clearAll() async {
    state = [];

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}

final addressProvider =
NotifierProvider<AddressNotifier, List<AddressModel>>(
  AddressNotifier.new,
);