import 'package:flutter/material.dart';
import 'package:mmh/components/cmp_deco_auth_camp.dart';
import 'package:mmh/components/snackbar.dart';
import 'package:mmh/components/validations_mixin.dart';
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
                    TextFormField(
                      controller: _email,
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
      if (login) {
        _autenticacaoservico
            .fazerLogin(email: email, senha: senha)
            .then((String? erro) {
          if (erro != null) {
            showSnackBar(context: context, texto: erro);
          }
        });
      } else {
        _autenticacaoservico
            .cadastrarUsuario(nick: nick, email: email, senha: senha)
            .then(
          (String? erro) {
            if (erro != null) {
              showSnackBar(context: context, texto: erro);
            }
          },
        );
      }
    }
  }
}
