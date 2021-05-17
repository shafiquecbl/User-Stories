import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:user_stories/components/navigator.dart';

class DashboardCard extends StatelessWidget {
  final Widget icon;
  final String title;
  final Widget screen;
  DashboardCard(
      {@required this.icon, @required this.title, @required this.screen});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor == Colors.white
                ? Colors.grey[100]
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10)),
        child: TextButton(
          onPressed: () {
            navigatorPush(context, screen);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon,
              SizedBox(
                height: 14,
              ),
              Text(
                title,
                style: GoogleFonts.teko(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor == Colors.blue
                        ? Colors.black54
                        : Colors.grey[50]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
