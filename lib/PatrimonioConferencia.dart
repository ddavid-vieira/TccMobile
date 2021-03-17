import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import 'UniqueConference.dart';

// ignore: must_be_immutable
class PatrimonioConferencia extends StatefulWidget {
  dynamic tombamento;
  String sala;
  int idConferencia;

  PatrimonioConferencia(this.tombamento, this.sala, this.idConferencia);

  @override
  _PatrimonioConferenciaState createState() => _PatrimonioConferenciaState();
}

class _PatrimonioConferenciaState extends State<PatrimonioConferencia> {
  Future myfunction;
  String selected = '';
  List _states = [
    'Em uso',
    'Não encontrado/Fora do setor',
    'Antieconômico/Irrecuperável'
  ];
  List<DropdownMenuItem<String>> _items = [];

  @override
  void initState() {
    _items = getDropDownMenuItems();
    selected = _items[0].value;
    myfunction = getUniquePatrimonio();
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    for (String state in _states) {
      items.add(DropdownMenuItem(value: state, child: Text(state)));
    }
    return items;
  }

  Future getUniquePatrimonio() async {
    http.Response response;
    response = await http.get(
        "https://apiconfpat.herokuapp.com/api/selectPatrimonio/${widget.tombamento}");
    return json.decode(response.body);
  }

  Future alterEstado(
    dynamic estado,
    dynamic codPatrimonio,
    BuildContext context,
  ) async {
    var url = 'http://apiconfpat.herokuapp.com/api/alterEstado/$codPatrimonio';
    var response = await http.put(url, body: {"Estado": "$estado"});
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UniqueConference(widget.idConferencia)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(219, 209, 209, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(84, 204, 11, 1),
        title: Text(
          'Patrimônio - ${widget.sala} ',
          style: GoogleFonts.kanit(
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(10.0),
          child: Card(
            elevation: 4,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(7),
                child: FutureBuilder(
                  future: myfunction,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Center(
                            child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Color.fromRGBO(84, 204, 11, 1)),
                        ));
                      default:
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              column('Número de Tombamento: ',
                                  '${snapshot.data[0]["CodPatrimonio"]}'),
                              column('Data de tombamento: ',
                                  '${snapshot.data[0]["DataTombamento"]}'),
                              column('Data de garantia: ',
                                  '${snapshot.data[0]["DataGarantia"]}'),
                              column('Denominação: ',
                                  '${snapshot.data[0]["Denominacao"]}'),
                              column('Marca: ', '${snapshot.data[0]["Marca"]}'),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Estado:',
                                        style: GoogleFonts.kanit(
                                          fontSize: 17,
                                          color: Color.fromRGBO(84, 204, 11, 1),
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      Text(
                                        '${snapshot.data[0]["Estado"]}',
                                        textAlign: TextAlign.start,
                                        textDirection: TextDirection.ltr,
                                        style: GoogleFonts.kanit(
                                          fontSize: 17,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Alterar estado ',
                                        style: GoogleFonts.kanit(
                                          fontSize: 17,
                                          color: Color.fromRGBO(84, 204, 11, 1),
                                          fontWeight: FontWeight.w300,
                                        ),
                                      ),
                                      DropdownButton(
                                          value: selected,
                                          items: _items,
                                          hint: Text('Alterar estado'),
                                          onChanged: (value) {
                                            selected = value;
                                            setState(() {
                                              selected = value;
                                            });
                                          }),
                                    ],
                                  )
                                ],
                              ),
                              column('Finalidade: ',
                                  '${snapshot.data[0]["Finalidade"]}'),
                              column('Depreciável: ',
                                  '${snapshot.data[0]["Depreciavel"]}'),
                              column('Valor: ', '${snapshot.data[0]["Valor"]}'),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: MediaQuery.of(context).size.width *
                                        0.2),
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: RaisedButton(
                                    elevation: 4.0,
                                    splashColor: Colors.green,
                                    color: Color.fromRGBO(84, 204, 11, 1),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(7.0)),
                                    child: Text(
                                      'Salvar',
                                      style: GoogleFonts.kanit(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w300,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () {
                                      {
                                        alterEstado(
                                            selected,
                                            snapshot.data[0]["CodPatrimonio"],
                                            context);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                    }
                  },
                ),
              ),
            ),
          )),
    );
  }
}

Widget column(String campo, String data) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        campo,
        style: GoogleFonts.kanit(
          fontSize: 17,
          color: Color.fromRGBO(84, 204, 11, 1),
          fontWeight: FontWeight.w300,
        ),
      ),
      Text(
        data,
        style: GoogleFonts.kanit(
          fontSize: 17,
          color: Colors.black,
          fontWeight: FontWeight.w300,
        ),
      ),
    ],
  );
}