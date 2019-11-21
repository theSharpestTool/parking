import 'package:flutter/widgets.dart';

class UIProvider with ChangeNotifier {
  bool _searchPageShown = false;
  bool _optionsShown = false;
  bool _paymentStarted = false;

  bool get searchPageShown => _searchPageShown;
  bool get optionsShown => _optionsShown;
  bool get paymentStarted => _paymentStarted;

  void showSearchPage(bool show) {
    _searchPageShown = show;
    notifyListeners();
  }

  void showOptions() {
    _optionsShown = !_optionsShown;
    notifyListeners();
  }

  void startPayment(bool start) {
    _paymentStarted = start;
    notifyListeners();
  }
}
