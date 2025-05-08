// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:mobile/common/widgets/outlined_button/outlined_button.dart';
// import 'package:mobile/common/widgets/status_dialog/status_dialog.dart';
// import 'package:mobile/cores/constants/colors.dart';
// import 'package:mobile/cores/constants/enums/status_enum.dart';
// import 'package:mobile/features/auth/services/keycloak_service.dart';
// import 'package:mobile/features/auth/viewmodels/auth_viewmodel.dart';
// import 'package:provider/provider.dart';
//
// class UserLogin extends StatefulWidget {
//   const UserLogin({super.key});
//
//   @override
//   _UserLoginState createState() => _UserLoginState();
// }
//
// class _UserLoginState extends State<UserLogin> {
//   final _formKey = GlobalKey<FormState>();
//   final _emailController = TextEditingController();
//   final _passwordController = TextEditingController();
//   bool _isPasswordVisible = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Lấy arguments từ ModalRoute
//       final arguments = ModalRoute.of(context)?.settings.arguments;
//
//       // Kiểm tra kiểu của arguments và xử lý
//       bool shouldShowMessage = false;
//       if (arguments is bool) {
//         shouldShowMessage = arguments;
//       } else if (arguments is Map) {
//         // Nếu arguments là Map, kiểm tra xem có key 'showMessage' hay không
//         final map = arguments;
//         shouldShowMessage = map['showMessage'] == true || map['message'] == 'Session expired';
//       }
//
//       if (shouldShowMessage) {
//         ScaffoldMessenger.of(context).clearSnackBars();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text("Session expired, please log in again."),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     });
//   }
//
//   // Validation cho email
//   String? _validateEmail(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your email';
//     }
//     final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//     if (!emailRegex.hasMatch(value)) {
//       return 'Please enter a valid email';
//     }
//     return null;
//   }
//
//   // Validation cho password
//   String? _validatePassword(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please enter your password';
//     }
//     if (value.length < 6) {
//       return 'Password must be at least 6 characters';
//     }
//     return null;
//   }
//
//   // Logic đăng nhập bằng email và mật khẩu
//   void _login() async {
//     if (_formKey.currentState!.validate()) {
//       final success =
//       await Provider.of<AuthViewModel>(context, listen: false).login(
//         email: _emailController.text,
//         password: _passwordController.text,
//       );
//
//       if (success && mounted) {
//         showStatusDialog(
//           context,
//           status: StatusType.success,
//           title: 'Login Successful',
//           message: 'Welcome back!',
//           onOkPressed: () {
//             Navigator.of(context).pop(); // Đóng dialog
//             GoRouter.of(context).go('/dashboard'); // Chuyển hướng
//           },
//         );
//         //GoRouter.of(context).go('/dashboard');
//       } else if (mounted) {
//         showStatusDialog(
//           context,
//           status: StatusType.error,
//           title: 'Login Failed',
//           message: Provider.of<AuthViewModel>(context, listen: false).error ??
//               'Please check your credentials.',
//         );
//       }
//     }
//   }
//
//   // Hàm trống cho Google Sign-In
//   void _logInGoogle() {
//     // Để trống theo yêu cầu
//   }
//
//   // Hàm trống cho Facebook Sign-In
//   void _logInFacebook() {
//     // Để trống theo yêu cầu
//   }
//
//   Future<void> _loginWithKeycloak(BuildContext context) async {
//     final authService = KeycloakService();
//     print(">>>>> A");
//     final success = await authService.login();
//     print(">>>>> B");
//     if (success) {
//       // Gọi API sau khi đăng nhập thành công
//       try {
//         print(">>>>> C");
//         // final data = await authService.callApi('http://your-backend/api/protected-resource');
//         // print('API Response: $data');
//         // Điều hướng đến màn hình chính
//         GoRouter.of(context).go('/dashboard');
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error: $e')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Login failed')),
//       );
//     }  }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Log In',
//           style: Theme.of(context).textTheme.titleSmall,
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             GoRouter.of(context).pop();
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: [
//                 const SizedBox(height: 50),
//                 // Trường Email Address
//                 TextFormField(
//                   controller: _emailController,
//                   validator: _validateEmail,
//                   decoration: InputDecoration(
//                     labelText: 'Email Address',
//                     hintText: 'debra.holt@example.com',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     prefixIcon: const Icon(Icons.person_outline_outlined),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//
//                 // Trường Password
//                 TextFormField(
//                   controller: _passwordController,
//                   validator: _validatePassword,
//                   obscureText: !_isPasswordVisible,
//                   decoration: InputDecoration(
//                     labelText: 'Password',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     prefixIcon: const Icon(Icons.fingerprint),
//                     suffixIcon: IconButton(
//                       onPressed: () {
//                         setState(() {
//                           _isPasswordVisible = !_isPasswordVisible;
//                         });
//                       },
//                       icon: Icon(
//                         _isPasswordVisible
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 40),
//
//                 // Nút Log In
//                 SizedBox(
//                   width: 280,
//                   child: ElevatedButton(
//                     // onPressed: context.watch<AuthViewModel>().isLoading
//                     //     ? null
//                     //     : _login,
//                     onPressed: () {
//                       // Gọi hàm đăng nhập với Keycloak
//                       _loginWithKeycloak(context);
//                     },
//                     child: context.watch<AuthViewModel>().isLoading
//                         ? const CircularProgressIndicator()
//                         : const Text('Log In'),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Text "Forget password?"
//                 Align(
//                   alignment: Alignment.center,
//                   child: GestureDetector(
//                     onTap: () {
//                       print('Forget password pressed');
//                       // Điều hướng tới màn hình quên mật khẩu (nếu có)
//                       GoRouter.of(context).go('/forget-password');
//                     },
//                     child: Text(
//                       'Forget password?',
//                       style: Theme.of(context).textTheme.bodyMedium?.copyWith(
//                         color: HighlightColors.highlight500,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//
//                 // Text "OR"
//                 Align(
//                   alignment: Alignment.center,
//                   child: Text(
//                     'OR',
//                     style: Theme.of(context).textTheme.titleMedium,
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//
//                 // Nút Continue With Google
//                 OutlinedButtonCustom(
//                   icon: const Image(
//                     image: AssetImage('assets/logo/google.png'),
//                     width: 28,
//                   ),
//                   onPressed: _logInGoogle,
//                   label: "Continue With Google",
//                 ),
//                 const SizedBox(height: 16),
//
//                 // Nút Continue With Facebook
//                 OutlinedButtonCustom(
//                   icon: const Image(
//                     image: AssetImage('assets/logo/facebook.png'),
//                     width: 30,
//                   ),
//                   onPressed: _logInFacebook,
//                   label: "Continue with Facebook",
//                 ),
//                 const SizedBox(height: 24),
//
//                 // Text "Don't have an account? Register"
//                 Align(
//                   alignment: Alignment.center,
//                   child: TextButton(
//                     onPressed: () {
//                       GoRouter.of(context).go('/auth/register');
//                     },
//                     child: Text.rich(
//                       TextSpan(
//                         text: "Don't have an account? ",
//                         style: Theme.of(context).textTheme.bodyMedium,
//                         children: const [
//                           TextSpan(
//                             text: "Register",
//                             style: TextStyle(
//                               color: HighlightColors.highlight500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 24),
//
//                 // Text "We will never post anything without your permission."
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                   child: Text(
//                     'We will never post anything without your permission.',
//                     style: Theme.of(context).textTheme.bodyMedium,
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
// }