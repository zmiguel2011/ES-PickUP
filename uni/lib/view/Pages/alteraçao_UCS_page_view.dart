import 'package:flutter/cupertino.dart';
import 'package:uni/controller/mock_get_info.dart';
import 'package:uni/model/entities/course_unit.dart';
import 'package:flutter/material.dart';
import 'package:uni/view/Pages/incricao_UCS_page_view.dart';
import 'package:uni/view/Pages/unnamed_pickup_page_view.dart';

class alteracao_UCS extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => alteracao_UCSViewState();
}


/// Tracks the state of `Enrollment`.
class alteracao_UCSViewState extends UnnamedPickUPPageView {
  List<CourseUnit> ucs = get_enrolled_ucs();

  bool check_isfirst = true;

  Widget Build_Course_card(CourseUnit uc) {
    Key key_isfirst, key_desincrever_turma_first;
    if(check_isfirst){
      key_desincrever_turma_first = Key("desinscrever_1st_turma");
      key_isfirst = Key("1st_uc");
      check_isfirst = false;
    }
    return Container(      width: 350,
      height: 300,
      padding: new EdgeInsets.all(10.0),
      child: Card(
        //possible improvement: dinamically change cards height acording to its contents
          margin: EdgeInsets.zero,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.0),
            borderSide: BorderSide.none,
          ),
          color: Colors.grey,
          elevation: 10,
          child: Center(
            child: Column(
              key:key_isfirst,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                //leading: Icon(Icons.album, size: 60),
                Text(uc.name,
                    style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                Text(uc.curricularYear.toString(),
                    style: TextStyle(fontSize: 18.0, color: Colors.black45),
                    textAlign: TextAlign.left),
                Text(uc.ects.toString() + " ECTS",
                    style: TextStyle(fontSize: 18.0, color: Colors.deepPurple,fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left),
                Text("Turma: " + get_turma_uc(uc),
                    key: Key("turma_uc"),
                    style: TextStyle(fontSize: 20.0, color: Colors.blue, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      key: key_desincrever_turma_first,
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                        child: const Text('Desincrever Turma'),
                        //Solução temporária
                        onPressed: () {
                        if(get_turma_uc(uc) != "-") {
                          desincrever_turma_uc(uc);
                          Navigator.pushAndRemoveUntil(context,
                            MaterialPageRoute(builder: (context) => alteracao_UCS()), // this mymainpage is your page to refresh
                                (Route<dynamic> route) => false,
                          );
                        }
                        }
                    )),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.red)),
                        child: const Text('Desinscrever'),
                        //Solução temporária
                        onPressed: () {
                            desinscrever_uc(uc);
                            Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (context) => alteracao_UCS()),
                              // this mymainpage is your page to refresh
                                  (Route<dynamic> route) => false,

                            );
                            ScaffoldMessenger.of(context)
                              ..removeCurrentSnackBar()
                              ..showSnackBar(SnackBar(backgroundColor: Colors
                                  .green,
                                  content: Text(
                                      'Desincreveste-te à unidade Curricular ${uc
                                          .name}',
                                      textAlign: TextAlign.center)));
                        }
                    ))
                //Build_Course_card_button(uc, context)
              ],
            ),
          )),
    );
  }


  @override
  Widget getBody(BuildContext context) {
    List<Widget> c = <Widget>[];
    c.add(Text("Unidades Curriculares atuais:",
        style: TextStyle(
            color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)));
    c.add(Text("Créditos atuais: " + creditos_totais.toString(),
        textAlign: TextAlign.left,
        style: TextStyle(
            color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)));
    for (CourseUnit uc in ucs){
        //c.add(new alteracao_UC(uc: uc).build(context));
        c.add(Build_Course_card(uc));
      }

    return ListView(children: <Widget>[
      Container(key:Key("uc_cards"), child: Column(mainAxisSize: MainAxisSize.max, children: c))
    ]);
  }
}