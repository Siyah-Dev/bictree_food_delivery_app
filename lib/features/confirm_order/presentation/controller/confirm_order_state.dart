class ConfirmOrderState {
  const ConfirmOrderState({
    this.shippingAddress = '778 Locust View Drive Oakland, CA',
  });

  final String shippingAddress;

  ConfirmOrderState copyWith({String? shippingAddress}) {
    return ConfirmOrderState(
      shippingAddress: shippingAddress ?? this.shippingAddress,
    );
  }
}
