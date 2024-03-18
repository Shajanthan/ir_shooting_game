import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ir_shooting_game/Score.dart';
import 'package:ir_shooting_game/playerHome.dart';
import 'package:ir_shooting_game/wrapper.dart';

const List<String> list = <String>['player1','player2'];


class Score extends StatefulWidget {
  //const Score({super.key});
  final String selectedValue;

  Score(this.selectedValue);

  @override
  State<Score> createState() => _ScoreState();

}

class _ScoreState extends State<Score> {
  int _secondsRemaining = 60;
  late Timer _timer;
  var finalscore;
  String winner_="";

  final user = FirebaseAuth.instance.currentUser;
  final databaseref=FirebaseDatabase.instance.ref();

  @override
  void initState() {
    super.initState();

    // Start a timer that ticks every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          // Timer completed, do something here
          _timer.cancel(); // Cancel the timer when it's no longer needed
        }
      });
    });
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
    playerout();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Wrapper()),
    );

  }

  play(){
    playerout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => PlayerHome()),
    );

  }

  store(var b,var c){
    databaseref.child("${c}/finalcore").set({
      "score":b,
    });
  }

  Future<int> getScore(var pl)async{

    final snapshot = await databaseref.child('${pl}/score').get();
    int a=0;
    if (snapshot.exists) {
      a=int.parse(snapshot.value.toString());
    } else {
      print('No data available.');
    }
    return a;
  }

  Future<String> winner()async{
    String win="";
    final snapshot = await databaseref.child('player1/finalcore/score').get();
    final snapshot2 = await databaseref.child('player2/finalcore/score').get();
    int a=0,b=0;
    if (snapshot.exists && snapshot2.exists) {
      a=int.parse(snapshot.value.toString());
      b=int.parse(snapshot2.value.toString());
      if(a>b){
        winner_="player1 (${a})";
      }
      else if(a<b){
        winner_="player2 (${b})";
      }
      else{
        winner_="Match Tied";
      }
    } else {
      print('No data available.');
    }
    return win;
  }


  Future<int> finalScore(var s)async{
    int finalscore=0;
    final snapshot = await databaseref.child('player1/finalcore/score').get();
    final snapshot2 = await databaseref.child('player2/finalcore/score').get();
    int a=0,b=0;
    if (snapshot.exists && snapshot2.exists) {
      a=int.parse(snapshot.value.toString());
      b=int.parse(snapshot2.value.toString());
      if(s=='player1'){
        finalscore=a;
      }
      else{
        finalscore=b;
      }
    } else {
      print('No data available.');
    }
    return finalscore;
  }





  playerout()async{
    final ref=await FirebaseDatabase.instance.ref();
    ref.child('start').set(false);
    ref.child('p1').set(false);
    ref.child('p2').set(false);
  }


  @override
  Widget build(BuildContext context) {
    String player=widget.selectedValue;
    int final_score=0;
    String won="";
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${getUserEmail()} ($player)'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if(_secondsRemaining!=0)
                Text(
                  'remaining Seconds : $_secondsRemaining'.toUpperCase(),
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                if(_secondsRemaining!=0)
                FutureBuilder<int>(future: getScore('player1'),builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    finalscore=snapshot.data;
                    if(_secondsRemaining==1){
                      winner();
                      playerout();
                    }
                    else if(_secondsRemaining!=0){
                      store(finalscore,'player1');
                    }
                    return Text(
                      'player1 Score : ${finalscore}'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
                ),
                const SizedBox(height: 10),

                if(_secondsRemaining!=0)
                FutureBuilder<int>(future: getScore('player2'),builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    finalscore=snapshot.data;
                    if(_secondsRemaining==1){
                      winner();
                      playerout();
                    }
                    else if(_secondsRemaining!=0){
                      store(finalscore,'player2');
                    }
                    return Text(
                      'player2 Score : ${finalscore}'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
                ),

                const SizedBox(height: 10),

                if(_secondsRemaining==0)
                Text('Winner : ${winner_} '.toUpperCase(),style: TextStyle(
                  color: Colors.red,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                ),
                const SizedBox(height: 10),

                if(_secondsRemaining==0)
                FutureBuilder<int>(future: finalScore(player),builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    finalscore=snapshot.data;
                    if(_secondsRemaining==1){
                      winner();
                      playerout();
                    }
                    else if(_secondsRemaining!=0){
                      store(finalscore,player);
                    }
                    return Text(
                      'Your Score : ${finalscore}'.toUpperCase(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }
                },
                ),

                const SizedBox(height: 30),
                /*
                ElevatedButton(
                  onPressed: () => play(),
                  child: Tooltip(
                    message: 'play',
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Play Again'),
                      ],
                    ),
                  ),
                ),
*/
                if(_secondsRemaining==0)
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
                        "Play Again",
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
                    message: 'Logout',
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

  @override
  void dispose() {
    // Make sure to cancel the timer when the widget is disposed
    _timer.cancel();
    super.dispose();
  }
}