import 'package:flutter/material.dart';
import 'package:payments_management/common/widgets/color_rounded_item.dart';
import 'package:payments_management/constants/global_variables.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/home/utils/pay_option.dart';

class PayOptionBtn extends StatelessWidget {
  // final bool amountTotal;
  //final Function(String value) updateAmount;
  // final VoidCallback updateAmount;
  // final Function(String value) updateAmount;
  final Function(PayOption value) updateAmount;
  final PayOption payOption;
  // final String label;
  const PayOptionBtn(
      {super.key,
      //  required this.amountTotal,
      required this.payOption,
      // required this.label,
      required this.updateAmount});

  @override
  Widget build(BuildContext context) {
    return ColorRoundedItem(
        colorBackCard: payOption.state
            ? GlobalVariables.blueActionColor
            : GlobalVariables.greyBackgroundColor,
        colorBorderCard: GlobalVariables.blueActionColor,
        text: capitalizeFirstLetter(payOption.label),
        colorText: Colors.black,
        sizeText: 13,
        //onTap: () => _updateAmount(element),
        onTap: () => updateAmount(payOption));
  }
}
