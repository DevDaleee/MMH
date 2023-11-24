// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mmh/classes/rest_client.dart';
import 'package:mmh/components/cmp_deco_auth_camp.dart';
import 'package:mmh/components/loading.dart';
import 'package:mmh/components/validations_mixin.dart';
import 'package:mmh/named_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with ValidationsMixin {
  bool login = true;
  String token = '';
  final httpClient = GetIt.I.get<RestClient>();

  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _nick = TextEditingController();
  final _senha = TextEditingController();

  Future loginUser(String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    try {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          context = context;
          return const Loading();
        },
      );
      var response = await httpClient.post(
        '/login',
        {
          "email": email,
          "password": password,
        },
      );
      token = response['access_token'];
      await sharedPreferences.setString('access_token', token);

      Navigator.pushNamed(context, RootViewRoute);
    } catch (error) {
      print(error);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Invalido'),
            content: const Text('Seu E-mail e/ou senha inválidos'),
            actions: [
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }

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
                      height: 50,
                    ),
                    TextFormField(
                      controller: _email,
                      style: const TextStyle(color: Colors.white),
                      keyboardType: TextInputType.emailAddress,
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
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await loginUser(_email.text, _senha.text);
                              }
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
}
