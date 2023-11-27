import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<dynamic> professores;
  TextEditingController nomeController = TextEditingController();
  TextEditingController formacaoController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text('Cadastro de Professores'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro: ${snapshot.error}');
                } else {
                  professores = snapshot.data as List<dynamic>;

                  return Container(
                    width: 300.0,
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Professores:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10.0),

                        for (var professor in professores)
                          Card(
                            elevation: 5.0,
                            margin: EdgeInsets.symmetric(vertical: 10.0),
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text.rich(
                                    TextSpan(
                                      text: 'Nome: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: professor['nome'],
                                          style: TextStyle(
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: 'Formação: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: professor['formacao'],
                                          style: TextStyle(
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text.rich(
                                    TextSpan(
                                      text: 'Email: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: professor['email'],
                                          style: TextStyle(
                                            color: Colors.pink,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10.0),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _mostrarFormularioEdicao(
                                              context, professor);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.pink,
                                        ),
                                        child: Text('Editar'),
                                      ),
                                      SizedBox(width: 10.0),
                                      ElevatedButton(
                                        onPressed: () async {
                                          await excluirProfessor(professor['id']);
                                          setState(() {});
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.pink,
                                        ),
                                        child: Text('Excluir'),
                                      ),
                                    ],
                                  ),
                                ],
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _mostrarFormulario(context);
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.pink,
        ),
      ),
    );
  }

  _mostrarFormulario(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Novo Professor',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextFormField(
                controller: formacaoController,
                decoration: InputDecoration(labelText: 'Formação'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  String nome = nomeController.text;
                  String formacao = formacaoController.text;
                  String email = emailController.text;

                  // Verificar se os campos obrigatórios estão preenchidos
                  if (nome.isEmpty || formacao.isEmpty || email.isEmpty) {
                    print('Por favor, preencha todos os campos obrigatórios.');
                    return;
                  }

                  await salvarNovoProfessor(nome, formacao, email);
                  Navigator.of(context).pop();
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
                ),
                child: Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  _mostrarFormularioEdicao(BuildContext context, Map<String, dynamic> professor) {
    nomeController.text = professor['nome'];
    formacaoController.text = professor['formacao'];
    emailController.text = professor['email'];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Editar Professor',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                controller: nomeController,
                decoration: InputDecoration(labelText: 'Nome'),
              ),
              TextFormField(
                controller: formacaoController,
                decoration: InputDecoration(labelText: 'Formação'),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'E-mail'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () async {
                  String nome = nomeController.text;
                  String formacao = formacaoController.text;
                  String email = emailController.text;

                  // Verificar se os campos obrigatórios estão preenchidos
                  if (nome.isEmpty || formacao.isEmpty || email.isEmpty) {
                    print('Por favor, preencha todos os campos obrigatórios.');
                    return;
                  }

                  await editarProfessor(professor['id'], nome, formacao, email);
                  Navigator.of(context).pop();
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.pink,
                ),
                child: Text('Salvar'),
              ),
            ],
          ),
        );
      },
    );
  }

  Future fetchData() async {
    final response =
    await http.get(Uri.parse('http://localhost:3002/professores'));

    if (response.statusCode == 200) {
      final dynamic decodedData = json.decode(response.body);

      if (decodedData is List) {
        return decodedData;
      } else if (decodedData is Map<String, dynamic> &&
          decodedData.containsKey('rows')) {
        return decodedData['rows'];
      } else {
        throw Exception('Formato inesperado dos dados da API');
      }
    } else {
      throw Exception('Falha ao carregar dados da API: ${response.statusCode}');
    }
  }

  Future excluirProfessor(int id) async {
    final response = await http.delete(
      Uri.parse('http://localhost:3002/professor/deletar/$id'),
    );

    if (response.statusCode == 200) {
      print('Professor excluído com sucesso');
    } else {
      print('Falha ao excluir professor - Status ${response.statusCode}');
    }
  }

  Future salvarNovoProfessor(String nome, String formacao, String email) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3002/professor/inserir'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nomeProfessor': nome,
          'formacaoProfessor': formacao,
          'emailProfessor': email,
        }),
      );

      if (response.statusCode == 200) {
        print('Novo Professor adicionado com sucesso');
      } else {
        print('Falha ao adicionar novo professor - Status ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao realizar a solicitação HTTP: $error');
    }
  }

  Future editarProfessor(int id, String nome, String formacao, String email) async {
    try {
      final response = await http.put(
        Uri.parse('http://localhost:3002/professor/alterar/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nomeProfessor': nome,
          'formacaoProfessor': formacao,
          'emailProfessor': email,
        }),
      );

      if (response.statusCode == 200) {
        print('Professor editado com sucesso');
      } else {
        print('Falha ao editar professor - Status ${response.statusCode}');
      }
    } catch (error) {
      print('Erro ao realizar a solicitação HTTP: $error');
    }
  }
}
