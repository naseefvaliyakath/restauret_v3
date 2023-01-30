class PrinterConfig{
  //TODO allowedPrinter,allowedAddress from server
  static const List allowedBtPrinter = ['BTprinterd130','M581','MPT-II'];
  static const List allowedUsbPrinter = ['POS-58'];
  static bool isThreeInchPrinter = false;
}

enum POSPrinterType{
  kotPrinter,
  billingPrinter,
}

//Common methods
// getDevices()
// getSelectedDevice()
// selectDevice

