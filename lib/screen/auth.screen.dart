import 'package:commerce_app/bloc/auth.bloc.dart';
import 'package:commerce_app/comp/custom_button.comp.dart';
import 'package:commerce_app/comp/custom_textfield.comp.dart';
import 'package:commerce_app/event/auth.event.dart';
import 'package:commerce_app/layout/default.layout.dart';
import 'package:commerce_app/screen/products.screen.dart';
import 'package:commerce_app/state/auth.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  final bool isLogin;

  const AuthScreen({
    this.isLogin = false,
    Key? key,
  }) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    if (widget.isLogin != null) {
      isLogin = widget.isLogin;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state != null) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => ProductsScreen()));
        }
      },
      child: DefaultLayout(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 40,
            horizontal: 18,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Image.asset(
                'asset/img/green_logo.png',
                height: 50,
              ),
              Text(
                isLogin ? '로그인을 하세요' : '회원가입을 하세요',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  CustomTextField(
                    controller: emailController,
                    hintText: '이메일',
                    prefixIcon: Icons.email,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomTextField(
                    controller: passwordController,
                    hintText: '비밀번호',
                    prefixIcon: Icons.lock,
                    obscureText: true,
                  ),
                ],
              ),
              CustomButton(
                text: isLogin ? '로그인' : '회원가입',
                onPressed: () {
                  isLogin
                      ? context.read<AuthBloc>().add(Login(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ))
                      : context.read<AuthBloc>().add(SignUp(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          ));
                },
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
                child: Text(
                  isLogin ? '계정이 아직 없나요? 회원가입' : '계정이 이미 있나요? 로그인',
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
