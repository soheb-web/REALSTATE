import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:realstate/Model/verifyBodyModel.dart';
import 'package:realstate/core/network/api.state.dart';
import 'package:realstate/core/utils/preety.dio.dart';
import 'package:realstate/pages/home.page.dart';

class OtpVerifyPage extends StatefulWidget {
  final String token;
  const OtpVerifyPage({super.key, required this.token});

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  bool isVerify = false;
  final otpController = TextEditingController();

  Future<void> verifyUser() async {
    if (otpController.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Please Enter OTP");
      return;
    }
    setState(() {
      isVerify = true;
    });
    final body = VerifyBodyModel(token: widget.token, otp: otpController.text);
    try {
      final service = APIStateNetwork(createDio());
      final response = await service.verifyUser(body);
      if (response.code == 0 || response.error == false) {
        var box = Hive.box("userdata");
        await box.put("token", response.data!.token.toString());
        await box.put("name", response.data!.user!.name.toString());
        await box.put("email", response.data!.user!.email.toString());
        await box.put("phone", response.data!.user!.phone.toString());
        Fluttertoast.showToast(msg: response.message ?? "");
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => RealEstateHomePage()),
          (route) => false,
        );
      } else {
        Fluttertoast.showToast(msg: response.message ?? "Error");
      }
    } catch (e, st) {
      log(e.toString());
    } finally {
      setState(() {
        isVerify = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonLoader(
      isLoading: isVerify,
      child: Scaffold(
        backgroundColor: const Color(0xffF6F7FB),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  /// ==== LOGO ====
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        "assets/logo.png", // replace with your logo
                        width: 220,
                      ),
                    ),
                  ),

                  const SizedBox(height: 50),

                  /// ==== SIGN IN TITLE ====
                  const Text(
                    "OTP Verify",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff0E1A35),
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// ==== USERNAME ====
                  const Text(
                    "Enter Your Code",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0E1A35),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    height: 58,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.person_outline, color: Colors.grey),
                        SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: otpController,
                            maxLength: 6,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              counterText: "",
                              hintText: "OTP",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  /// ==== SIGNt IN BUTTON ====
                  Center(
                    child: GestureDetector(
                      onTap: isVerify ? null : verifyUser,
                      child: Container(
                        height: 60,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isVerify
                              ? Colors.grey
                              : const Color(0xffE86A34),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: Text(
                            "Verify",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CommonLoader extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const CommonLoader({super.key, required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,

        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
