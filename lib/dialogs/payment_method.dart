import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/models/user_model/user_model.dart';
import 'package:destiny_capsules/provider/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class PaymentDialog extends StatefulWidget {
  final Function(String) onPaymentTypeChanged; // Callback function
  const PaymentDialog({Key? key, required this.onPaymentTypeChanged})
      : super(key: key);

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  late User user;
  String? _selectedPaymentType;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    user = Provider.of<AppProvider>(context, listen: false).user;
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<AppProvider>(context, listen: false).user;
    return Theme(
      data: ThemeData(
        dialogTheme: const DialogTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero, 
          ),
        ),
      ),
      child: Dialog(
        backgroundColor: Colors.white,
        child: SizedBox(
          width: 200,
          height: 150,
          child: Center(
            child: _isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xff3249CA),
                    ),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: DropdownButton<String>(
                        value: _selectedPaymentType,
                        onChanged: (newValue) async {
                          setState(() {
                            _isLoading = true;
                          });
                          // Update the user's payment type
                          user.setPaymentType(newValue!);
                          // Call the updateUserData function
                          await updateUserData(user);
                          // Call the callback function to notify the parent widget
                          widget.onPaymentTypeChanged(newValue);
                          setState(() {
                            _isLoading = false;
                            _selectedPaymentType = newValue;
                          });
                        },
                        items: <String>['mpesa', 'paypal']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        hint: Text(
                          user.paymenttype ?? 'payment',
                          style: appstyle(14, AppColors.black, FontWeight.w400),
                        ),
                        isExpanded: true,
                        iconSize: 30,
                        elevation: 16,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
