import 'package:flutter/material.dart';

class LoadMoreView extends StatelessWidget {
  final Widget icon;
  final String msg;

  LoadMoreView({
    required this.icon,
    required this.msg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Colors.yellowAccent, Colors.orangeAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orangeAccent.withOpacity(0.7),
                  blurRadius: 20,
                  offset: Offset(5, 5),
                ),
              ],
              border: Border.all(
                color: Colors.redAccent,
                width: 5,
              ),
            ),
            child: Row(
              children: [
                icon,
                Container(
                  child: Text(
                    msg,
                    style: const TextStyle(
                      fontFamily: 'KuaiKan',
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
