import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
        backgroundColor: Color.fromRGBO(38, 38, 38, 1),
        body: Column(
            children: <Widget>[
              Expanded(

                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        alignment: FractionalOffset(0.5, 0.9),
                        image: AssetImage("images/logo.png"),
                      )
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  alignment: FractionalOffset(0.5, 0.05),
                  child: Text('Расписание МИРЭА',
                      textDirection: TextDirection.ltr,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontSize:24,
                      )
                  ),
                ),),
              Container(
                margin: EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                    onPressed: (){Navigator.pushNamed(context, '/second');},
                    child: Text('Далее'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 75, vertical: 20),
                        textStyle: GoogleFonts.ubuntu(
                          fontSize: 18,
                          color: Colors.white,
                        )
                    )
                ),
              )
            ]
        )
    );
  }
}