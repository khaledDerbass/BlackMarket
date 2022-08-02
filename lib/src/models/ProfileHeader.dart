import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class profileHeader extends StatelessWidget {
  const profileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SliverToBoxAdapter(
      child: Padding(

        padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * .0,
          left: MediaQuery.of(context).size.height * .01,
          right: MediaQuery.of(context).size.height * .01,
          bottom: MediaQuery.of(context).size.height * .0,

        ),        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Color(0xff74EDED),
                  backgroundImage:
                  NetworkImage("https://placeimg.com/640/480/people"),
                ),
                Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          "23",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            letterSpacing: 1,
                           fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Offers",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 12,
                           letterSpacing: .5,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.height * .05,
                    ),
                    Column(
                      children: [
                        Text(
                          "2,896",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            letterSpacing: 1,
                          fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Followers",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            letterSpacing: .5,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width:MediaQuery.of(context).size.height * .05,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            Text(
              "Username",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
                fontSize: 13,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .005,
            ),
            Text(
              "About us",
              style: TextStyle(
                letterSpacing: 0.2,
                fontSize: 13,
                decoration: TextDecoration.none,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .005,
            ),
            Text(
              "Location",
              style: TextStyle(
                letterSpacing: 0.2,
                fontSize: 13,
                decoration: TextDecoration.none,
              ),
            ),

          ],
        ),
      ),
    );
  }

}