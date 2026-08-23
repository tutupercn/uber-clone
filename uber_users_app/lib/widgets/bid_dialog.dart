import 'package:flutter/material.dart';

class BidDialogWidget extends StatefulWidget {
  final double? initialFareAmount;
  final ValueChanged<double?> onBidAmountChanged;

  const BidDialogWidget({
    super.key,
    required this.initialFareAmount,
    required this.onBidAmountChanged,
  });

  @override
  _BidDialogWidgetState createState() => _BidDialogWidgetState();
}

class _BidDialogWidgetState extends State<BidDialogWidget> {
  final TextEditingController bidController = TextEditingController();
  String? _enteredBidAmount;

  @override
  void initState() {
    super.initState();
    bidController.text = widget.initialFareAmount.toString();
    _enteredBidAmount = widget.initialFareAmount?.toString();
  }

  void _showBidDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Fiyat teklifinizi belirleyin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: bidController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.white),
                  filled: true,
                  fillColor: Colors.grey[800],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorText: _validateBidAmount(),
                  helperText:
                      'Teklif ₺${_calculateLowerLimit().toStringAsFixed(2)} ile\n₺${_calculateUpperLimit().toStringAsFixed(2)} arasında olmalıdır.',
                  helperStyle: const TextStyle(color: Colors.black),
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  setState(() {
                    _enteredBidAmount = value; // Update the entered bid amount
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Vazgeç',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              onPressed: () {
                if (_validateBidAmount() == null) {
                  double? bidAmount = double.tryParse(bidController.text);
                  widget.onBidAmountChanged(bidAmount);
                  Navigator.of(context).pop(); // Close the dialog
                }
              },
              child: const Text(
                "Onayla",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  String? _validateBidAmount() {
    final double? fare = widget.initialFareAmount;
    if (fare == null || fare <= 0) {
      return 'Önce araç ve güzergâh seçin.';
    }
    double bid = double.tryParse(bidController.text) ?? 0.0;

    double lowerLimit = _calculateLowerLimit();
    double upperLimit = _calculateUpperLimit();

    if (bid < lowerLimit || bid > upperLimit) {
      return 'Teklif ₺${lowerLimit.toStringAsFixed(2)} ile\n₺${upperLimit.toStringAsFixed(2)} arasında olmalıdır.';
    }
    return null;
  }

  double _calculateLowerLimit() {
    return (widget.initialFareAmount ?? 0) * 0.90;
  }

  double _calculateUpperLimit() {
    return (widget.initialFareAmount ?? 0) * 1.20;
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      onPressed: () => _showBidDialog(context),
      child: Text(
        _enteredBidAmount == null || _validateBidAmount() != null
            ? "Fiyat teklif et"
            : 'Teklif: ₺$_enteredBidAmount',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
