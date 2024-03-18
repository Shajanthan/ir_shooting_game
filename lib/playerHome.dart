import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ir_shooting_game/Score.dart';
import 'package:ir_shooting_game/wrapper.dart';

class PlayerHome extends StatefulWidget {
  const PlayerHome({super.key});

  @override
  State<PlayerHome> createState() => _PlayerHomeState();

}

class _PlayerHomeState extends State<PlayerHome> {

  final user = FirebaseAuth.instance.currentUser;
  final databaseref=FirebaseDatabase.instance.ref("player");
  bool p1=false;
  bool p2=false;
  bool start=false;

  Future<int> getScore()async{
    final snapshot = await databaseref.child('${getUserEmail()}/score').get();
    int a=0;
    if (snapshot.exists) {
      print(snapshot.value);
      a=int.parse(snapshot.value.toString());
    } else {
      print('No data available.');
    }
    return a;
  }


  Future<int> score() async {
    return await getScore();
  }

  String getUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String k;
       k = user.email!;
       k= k.substring(0,k.length - 10);
       return k;
    }
    return " ";
  }

    signout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Wrapper()),
      );
    }

    play()async{
      final ref=await FirebaseDatabase.instance.ref();

      final snapshot = await ref.child('p1').get();
      final snapshot2 = await ref.child('p2').get();

      p1= snapshot.value as bool;
      p2= snapshot2.value as bool;

      if(p1==true && p2==true){
        showDialog(
            context: context, builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        );
        ref.child('start').set(true);
      }
      else if(selectedValue=='player1' && p2!=false){
        ref.child('p1').set(true);
        ref.child('start').set(true);
      }
      else if(selectedValue=='player2' && p1!=false){
        ref.child('p2').set(true);
        ref.child('start').set(true);
      }
      else if(selectedValue=='player1' && p2!=true){
        showDialog(
            context: context, builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        );
        ref.child('p1').set(true);
      }
      else if(selectedValue=='player2' && p1!=true){
        showDialog(
            context: context, builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        );
        ref.child('p2').set(true);
      }

      while(start!=true){
        final snapshot = await ref.child('p1').get();
        final snapshot2 = await ref.child('p2').get();

        p1= snapshot.value as bool;
        p2= snapshot2.value as bool;

        final snapshot3 = await ref.child('start').get();
        start=snapshot3.value as bool;

        showDialog(
            context: context, builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        );

      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Score(selectedValue)),
      );

    }


    String selectedValue = 'player1';
    List<String> dropdownItems = ['player1','player2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(50.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black,width: 1)
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text('${getUserEmail()}'.toUpperCase(),
                    style: TextStyle(color: Colors.black,
                        fontSize: 30,

                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                Text('Select player',
                    style: TextStyle(color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                DropdownButton<String>(
                  value: selectedValue,
                  isExpanded: true,
                  onChanged: (newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: dropdownItems.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(item),
                    );
                  }).toList(),
                ),


                const SizedBox(height: 40),
                GestureDetector(
                onTap: ()=> play(),
                child:Container(
                  padding:const EdgeInsets.all(25),
                  margin:const EdgeInsets.symmetric(horizontal: 25),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Play",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),

                /*ElevatedButton(
                  onPressed: ()=> play(),
                  child: Tooltip(
                    message: 'play',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Play'),
                      ],
                    ),
                  ),
                ),*/
                const SizedBox(height: 10),

                GestureDetector(
                  onTap: ()=> signout(),
                  child:Container(
                    padding:const EdgeInsets.all(25),
                    margin:const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        "Log out",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                /*ElevatedButton(
                  onPressed: () => signout(),
                  child: Tooltip(
                    message: 'Exit',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Logout'),
                      ],
                    ),
                  ),
                ),*/

              ],
            ),
          ),
        ),

      ),
    );
  }

}