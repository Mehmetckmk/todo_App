import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/extensions/space_exs.dart';
import 'package:to_do_app/utils/app_colors.dart';

class CustomDrawer extends StatelessWidget {
   CustomDrawer({super.key});

  final List<IconData> icons=[
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];
  final List<String> texts=[
    "Home",
    "Profile",
    "Settings",
    "Details"
  ];


  @override
  Widget build(BuildContext context) {
    var textTheme=Theme.of(context).textTheme;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: AppColors.primaryGradientColor,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://static.vecteezy.com/system/resources/previews/007/698/902/original/geek-gamer-avatar-profile-icon-free-vector.jpg"),
          ),
          10.h,
          Text("Mehmet Çakmak",style: textTheme.displayMedium,),
          Text("Banü Student Software Engineer",style: textTheme.displaySmall,),

          Container(
            margin: EdgeInsets.symmetric(vertical: 30,horizontal: 10,),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
              itemCount: icons.length,
                itemBuilder:(BuildContext context,int index){
                return InkWell(
                  onTap: (){
                    print("${texts[index]} Basıldı");
                  },
                  child: Container(
                    margin:const EdgeInsets.all(3),
                    child: ListTile(
                      leading: Icon(icons[index],color: Colors.white,size: 30,),
                      title: Text(texts[index],style: TextStyle(color: Colors.white,fontSize: 20),),
                    ),
                  ),
                );
                },
            ),
          ),
        ],
      ),
    );
  }
}
