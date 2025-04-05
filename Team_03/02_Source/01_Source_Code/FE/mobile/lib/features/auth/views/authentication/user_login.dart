import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/elevated_button/elevated_button.dart';
import 'package:mobile/common/widgets/outlined_button/outlined_button.dart';
import 'package:mobile/cores/constants/colors.dart';

class UserLogin extends StatelessWidget {
  const UserLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Log In',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop(); // Quay lại màn hình trước
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 50),
            // Trường Email Address
            TextField(
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'debra.holt@example.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Trường Password
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Nút Log In
            SizedBox(
              width: 280,
              child: ElevatedButton(
                onPressed: () {
                  // Logic xử lý đăng nhập (gọi API, kiểm tra, v.v.)
                  print('Log In pressed');
                  // Ví dụ: Điều hướng tới Dashboard sau khi đăng nhập thành công
                  GoRouter.of(context).go('/dashboard');
                },
                child: Text('Log In'),
                // text: 'Log In',
                // textStyle: Theme.of(context).textTheme.labelLarge,
              ),
            ),
            const SizedBox(height: 20),

            // Text "Forget password?"
            Align(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  print('Forget password pressed');
                  // Điều hướng tới màn hình quên mật khẩu (nếu có)
                },
                child: Text(
                  'Forget password?',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: HighlightColors.highlight500, // Màu xanh dư
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Text "OR"
            Align(
              alignment: Alignment.center,
              child: Text(
                'OR',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 24),

            // Nút Continue With Google
            OutlinedButtonCustom(
              icon: Image(
                image: AssetImage('assets/logo/google.png'),
                width: 28,
              ),
              onPressed: () => {},
              label: "Continue With Google",
            ),
            const SizedBox(height: 16),

            OutlinedButtonCustom(
              icon: Image(
                image: AssetImage('assets/logo/facebook.png'),
                width: 30,
              ),
              onPressed: () => {},
              label: "Continue with Facebook",
            ),
            // Nút Continue With Facebook

            const SizedBox(height: 24),

            // Text "We will never post anything without your permission."
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'We will never post anything without your permission.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}