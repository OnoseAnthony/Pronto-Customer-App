class CardDetails {
  String cardNumber;
  String cvv;
  String expMonth;
  String expYear;

  CardDetails({this.cardNumber, this.cvv, this.expMonth, this.expYear});

  CardDetails.fromMap(Map map)
      : this.cardNumber = map['cardNumber'],
        this.cvv = map['cvv'],
        this.expMonth = map['expMonth'],
        this.expYear = map['expYear'];

  Map toMap() {
    return {
      'cardNumber': this.cardNumber,
      'cvv': this.cvv,
      'expMonth': this.expMonth,
      'expYear': this.expYear
    };
  }
}
