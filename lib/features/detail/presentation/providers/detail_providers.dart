import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/machine_detail_model.dart';
import '../../data/mock_machine_details.dart';

// ─── Active Detail Tab ────────────────────────────────────────────────────────

enum DetailTab { overview, specifications, features, shipping, condition }

final detailTabProvider = StateProvider.autoDispose<DetailTab>(
  (ref) => DetailTab.overview,
);

// ─── Active Gallery Index ─────────────────────────────────────────────────────

final galleryIndexProvider = StateProvider.autoDispose<int>((ref) => 0);

// ─── Machine Detail Data ──────────────────────────────────────────────────────

/// FutureProvider.family — swap the body for a real Dio call later.
/// autoDispose ensures memory is freed when the detail screen is popped.
final machineDetailProvider =
    FutureProvider.autoDispose.family<MachineDetailModel, String>(
  (ref, id) async {
    // Simulate a network round-trip so the loading state renders correctly.
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return kMockMachineDetails[id] ?? fallbackDetail(id);
  },
);
