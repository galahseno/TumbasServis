import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/invoice_view_model.dart';
import 'package:tumbas_servis/invoice/presentation/invoice/state/invoice_state.dart';

final invoiceViewModelProvider = NotifierProvider.autoDispose
    .family<InvoiceViewModel, InvoiceState, String>(InvoiceViewModel.new);
