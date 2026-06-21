import 'package:flutter_sslcommerz/sslcommerz.dart';
import 'package:flutter_sslcommerz/model/SSLCommerzInitialization.dart';
import 'package:flutter_sslcommerz/model/SSLCSdkType.dart';
import 'package:flutter_sslcommerz/model/SSLCurrencyType.dart';
import 'package:flutter_sslcommerz/model/SSLCTransactionInfoModel.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SslPaymentService {
  Future<SSLCTransactionInfoModel> initiatePayment({
    required double amount,
    required String transactionId,
    required String productCategory,
  }) async {
    Sslcommerz sslcommerz = Sslcommerz(
      initializer: SSLCommerzInitialization(
        sdkType: SSLCSdkType.TESTBOX,
        store_id: "testbox",
        store_passwd: "testpassword",
        total_amount: amount,
        currency: SSLCurrencyType.BDT,
        tran_id: transactionId,
        product_category: productCategory,
      ),
    );

    return await sslcommerz.payNow();
  }
}
