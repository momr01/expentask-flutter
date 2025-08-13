import 'package:flutter/material.dart';
import 'package:payments_management/constants/global_variables.dart';

class FloatBtn extends StatelessWidget {
  final bool loadFloatBtn;
  final VoidCallback? onTapFloatBtn;
  const FloatBtn({
    super.key,
    this.loadFloatBtn = false,
    this.onTapFloatBtn,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      width: 80,
      child: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: GlobalVariables.historicalPending,
        foregroundColor: Colors.white,
        onPressed: onTapFloatBtn ?? () {},
        child: loadFloatBtn
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : const Icon(
                Icons.add,
                size: 40,
              ),
      ),
    );
  }
}
