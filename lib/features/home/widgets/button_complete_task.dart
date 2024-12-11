// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_randomcolor/flutter_randomcolor.dart';
import 'package:payments_management/constants/utils.dart';
import 'package:payments_management/features/home/widgets/modal_complete_task.dart';
import 'package:payments_management/models/payment/payment.dart';
import 'package:payments_management/models/task/task.dart';

class ButtonCompleteTask extends StatefulWidget {
  final Task task;
  // final String idPayment;
  final double amount;
  final Payment payment;
  const ButtonCompleteTask(
      {Key? key,
      required this.task,
      // required this.idPayment,
      required this.amount,
      required this.payment})
      : super(key: key);

  @override
  State<ButtonCompleteTask> createState() => _ButtonCompleteTaskState();
}

class _ButtonCompleteTaskState extends State<ButtonCompleteTask> {
  Color generateRandomColor() {
    var options = Options(
        format: Format.rgba,
        count: 1,
        //colorType: ColorType.blue,
        luminosity: Luminosity.light);
    var newColorRGBA = RandomColor.getColor(options);
    String colorString = newColorRGBA.toString();
    String stringWithoutExtrems =
        colorString.substring(5, colorString.length - 1);
    List arrayNumbers = stringWithoutExtrems.split(',');

    return Color.fromRGBO(
        int.parse(arrayNumbers[0]),
        int.parse(arrayNumbers[1]),
        int.parse(arrayNumbers[2]),
        double.parse(arrayNumbers[3]));
  }

  Icon defineIconTask(bool isCompleted) {
    if (isCompleted) {
      return const Icon(Icons.check_circle_sharp,
          color: Colors.green, size: 30);
    } else {
      return const Icon(Icons.error_sharp, color: Colors.red, size: 30);
    }
  }

  void openCompleteModal() async {
    showDialog<String>(
        barrierDismissible: false,
        context: context,
        builder: (context) => ModalCompleteTask(
            task: widget.task,
            //idPayment: widget.idPayment,
            payment: widget.payment,
            amount: widget.amount));
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: generateRandomColor(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        fixedSize: const Size(150, 60),
      ),
      onPressed: widget.task.isCompleted ? null : openCompleteModal,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SizedBox(
              width: 120,
              child: Row(children: [
                defineIconTask(widget.task.isCompleted),
                const SizedBox(width: 5),
                Expanded(
                    child: Text(
                  capitalizeFirstLetter(widget.task.code.abbr),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 15),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  softWrap: false,
                )),
              ]))),
    );
  }
}
