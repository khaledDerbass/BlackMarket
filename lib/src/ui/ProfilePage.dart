import 'package:flutter/material.dart';
import 'package:souq/src/models/CustomProfileAppBar.dart';
import '../models/ProfileHeader.dart';

class profilepage extends StatelessWidget{
  const profilepage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return DefaultTabController(
      length: 2,
      child: NestedScrollView(
          headerSliverBuilder: (context,index) {
            return [
              CustomProfileAppBar(),
              profileHeader(),
            ];
          }, body: Text(" "),
    ),);
  }
  }
        /*
        const Divider(height: 1),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children:[
              ClipOval(
                child: images.asset('assets/images/Me.jpg',
                height: 100, width: 100, fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                  child: Column(
                    children: [
                      Text(
                        '13',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                        fontSize: 18),),
                        Text(
                          'Posts',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),

                    ],
                  ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '1,370',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),),
                    Text(
                      'Followers',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),

                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '830',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),),
                    Text(
                      'Following',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
        /////////////////// bio

        const SizedBox(height: 12),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Khaled Derbass',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),

        SliverToBoxAdapter( )
      ];
        }, body: Text("Hello"),
    ),);


  }

}
*/
