
import 'package:flutter/material.dart';

class DateTimeSelectionWidget extends StatelessWidget {
  const DateTimeSelectionWidget({
    super.key,
    required this.onTap,
    required this.title,
    required this.time,
     this.isTime=false,
  });
  final VoidCallback onTap;
  final String title;
  final String time;
  final bool isTime;
  @override
  Widget build(BuildContext context) {
    var textTheme=Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(20,20,20,0),
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300,),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(title,style: textTheme.headlineSmall,),
            ),
            Container(
              margin: EdgeInsets.only(right: 10),
              width:isTime ? 150: 80,
              height: 35,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade100
              ),
              child:Center(
                child: Text(time,style: textTheme.titleSmall,),
              ) ,
            ),
          ],
        ),
      ),
    );
  }
}