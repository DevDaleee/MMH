import 'package:flutter/material.dart';
import 'package:mmh/components/cmp_deco_auth_camp.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool login = true;
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _nick = TextEditingController();
  final _senha = TextEditingController();

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
                    TextFormField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: getAutenticationInputDecoration('E-mail'),
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'Digite seu e-mail';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: _senha,
                      obscureText: true,
                      decoration: getAutenticationInputDecoration('Senha'),
                      validator: (senha) {
                        if (senha == null || senha.isEmpty) {
                          return 'Digite sua senha';
                        }
                        return null;
                      },
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
                            obscureText: true,
                            decoration: getAutenticationInputDecoration('Nick'),
                            validator: (nick) {
                              if (nick == null || nick.isEmpty) {
                                return 'Digite seu Nick';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.black),
                            ),
                            onPressed: () {},
                            child: Text(
                              (login) ? 'Entrar' : 'Cadastrar',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          const Divider(),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  login = !login;
                                });
                              },
                              child: Text((login)
                                  ? "Ainda não tem uma conta?  Cadastre-se!"
                                  : "Já tem uma conta? Entre!")),
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
