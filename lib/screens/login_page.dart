import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mmh/components/cmp_deco_auth_camp.dart';
import 'package:mmh/components/loading.dart';
import 'package:mmh/components/snackbar.dart';
import 'package:mmh/components/validations_mixin.dart';
import 'package:mmh/named_routes.dart';
import 'package:mmh/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with ValidationsMixin {
  bool login = true;
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _nick = TextEditingController();
  final _senha = TextEditingController();

  final ServiceAuth _autenticacaoservico = ServiceAuth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: Image.asset("assets/images/MMH_Logo.png"),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: _email,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      decoration: getAutenticationInputDecoration('E-mail'),
                      validator: (email) => combine(
                        [
                          () => isNotEmpty(email),
                          () => hasFiveChars(email),
                          () => validacaoEmail(email!),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _senha,
                      style: const TextStyle(color: Colors.white),
                      obscureText: true,
                      onTapOutside: (event) => FocusScope.of(context).unfocus(),
                      decoration: getAutenticationInputDecoration('Senha'),
                      validator: (senha) => combine(
                        [
                          () => isNotEmpty(senha),
                          () => hasFiveChars(senha),
                          () => validarSenha(senha!)
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Visibility(
                      visible: !login,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _nick,
                            style: const TextStyle(color: Colors.white),
                            onTapOutside: (event) =>
                                FocusScope.of(context).unfocus(),
                            decoration: getAutenticationInputDecoration('Nick'),
                            validator: (nick) => combine(
                              [
                                () => isNotEmpty(nick),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffA6BD94),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                            ),
                            onPressed: () {
                              botaoPrincipalClicado();
                            },
                            child: Text(
                              (login) ? 'Entrar' : 'Cadastrar',
                              style: const TextStyle(color: Color(0xFF38453E)),
                            ),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          const Divider(),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                login = !login;
                              });
                            },
                            child: Text(
                              (login)
                                  ? "Ainda não tem uma conta?  Cadastre-se!"
                                  : "Já tem uma conta? Entre!",
                              style: const TextStyle(
                                color: Color(0xffA6BD94),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  botaoPrincipalClicado() {
    String nick = _nick.text;
    String email = _email.text;
    String senha = _senha.text;

    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const Loading();
        },
      );

      if (login) {
        _autenticacaoservico
            .fazerLogin(email: email, senha: senha)
            .then((String? erro) {
          if (erro != null) {
            showSnackBar(context: context, texto: erro);
          }
          Navigator.pop(context);
        });
      } else {
        _autenticacaoservico.cadastrarUsuario(email: email, senha: senha).then(
          (String? erroCadastro) {
            if (erroCadastro != null) {
              showSnackBar(context: context, texto: erroCadastro);
              Navigator.pop(context);
            } else {
              String uid = _autenticacaoservico.currentUserUid()!;

              FirebaseFirestore.instance.collection('users').doc(uid).set(
                {
                  'nick': nick,
                  'email': email,
                  "gamesPlayed": 0,
                  "gamesWon": 0,
                  "maxStreak": 0,
                  "points": 0,
                  "streak": 0,
                  "winPercentage": 0,
                },
              ).then(
                (_) {
                  Navigator.pushNamed(context, InitialViewRoute).then((_) {
                    Navigator.pop(
                        context); 
                  });
                },
              ).catchError(
                (error) {
                  showSnackBar(context: context, texto: error.toString());
                  Navigator.pop(context);
                },
              );
            }
          },
        );
      }
    }
  }
}
