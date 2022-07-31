import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class profileHeader extends StatelessWidget {
  const profileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SliverToBoxAdapter(
      child: Padding(

        padding: const EdgeInsets.only(left: 15.0, right: 15.0, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 15,
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
                          "Posts",
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            fontSize: 12,
                           letterSpacing: .5,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 20,
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
                      width: 20,
                    ),
                    Column(
                      children: [
                        Text(
                          "234",
                          style: TextStyle(
                            letterSpacing: 1,
                            decoration: TextDecoration.none,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Following",
                          style: TextStyle(
                            letterSpacing: .5,
                            decoration: TextDecoration.none,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width:20,
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Khaled Derbass",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
                fontSize: 13,
                letterSpacing: 0.2,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              "Developer",
              style: TextStyle(
                letterSpacing: 0.2,
                fontSize: 13,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.none,
              ),
            ),

          ],
        ),
      ),
    );
  }

}