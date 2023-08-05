import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/colors.dart';

class WhetherContainer extends StatelessWidget {
  const WhetherContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(Icons.wb_sunny_outlined),
            SizedBox(
              width: 5,
            ),
            Text(
              '20-28 C',
              style:
                  TextStyle(color: darkGreenColor, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Row(
          children: [
            Icon(Icons.cloud_outlined),
            SizedBox(
              width: 5,
            ),
            Text(
              'Outdoor',
              style:
                  TextStyle(color: darkGreenColor, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Row(
          children: [
            Icon(Icons.location_on_outlined),
            SizedBox(
              width: 5,
            ),
            Text(
              'Lucknow',
              style:
                  TextStyle(color: darkGreenColor, fontWeight: FontWeight.bold),
            )
          ],
        )
      ],
    );
  }
}
