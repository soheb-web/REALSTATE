import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:realstate/Controller/loanServiceController.dart';
import 'package:realstate/Model/loanQueryBodyModel.dart';
import 'package:realstate/Model/loanServiceResModel.dart';
import 'package:realstate/core/network/api.state.dart';
import 'package:realstate/core/utils/preety.dio.dart';
import 'package:realstate/pages/home.page.dart';

class LoanServiceDetailsPage extends StatefulWidget {
  final ListElement item;
  const LoanServiceDetailsPage({super.key, required this.item});

  @override
  State<LoanServiceDetailsPage> createState() => _LoanServiceDetailsPageState();
}

class _LoanServiceDetailsPageState extends State<LoanServiceDetailsPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool? isBuying;
  bool isLoading = false;
  String? selectLoanType;
  List loanList = [
    "Home Loan",
    "Personal Loan",
    "Business Loan",
    "Vehicle Loan",
    "Education Loan",
    "Gold Loan",
    "Loan Against Property",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Loan Details")),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Top Image
              Container(
                height: 200.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  // image: const DecorationImage(
                  //   image: AssetImage("assets/image 15.png"),
                  //   fit: BoxFit.cover,
                  // ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: Image.network(
                    widget.item.bankLogo ?? "",
                    width: double.infinity,
                    height: 200.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              /// 🔹 Offer Section
              Text(
                "PROPERTYLOAN",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF6725),
                ),
              ),

              SizedBox(height: 10.h),

              _bulletText("Apply Home Loan Online at Magicbricks"),
              _bulletText("Loan Offers from 34+ Banks"),
              _bulletText("Dedicated RM for Property Search"),
              _bulletText("Highest Loan Value & Lowest ROI"),
              SizedBox(height: 12.h),
              Text(
                "Check Your Credit Score →",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF6725),
                ),
              ),
              SizedBox(height: 12.h),

              /// 🔹 Heading
              Row(
                children: [
                  Text(
                    "Home Loan Offers",
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 5.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      "New Schemes",
                      style: TextStyle(color: Colors.white, fontSize: 10.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              Text(
                "Get personalised home loan offers from top banks in just 2 mins.",
                style: TextStyle(fontSize: 12.sp, color: Colors.black),
              ),
              SizedBox(height: 14.h),

              /// 🔹 Info Chips
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  _chip("Loan req. - ₹50,00,000"),
                  _chip("Credit Score - 820"),
                  _chip("Ongoing EMI - ₹10,000"),
                  _chip("Monthly income - ₹1,00,000"),
                ],
              ),
              SizedBox(height: 16.h),

              /// 🔹 Bank Card
              _bankOfferCard(
                widget.item.name ?? "N/A",
                widget.item.interest ?? "",
                "₹${widget.item.loandAmount.toString()}",
                "${widget.item.tenure.toString()}Years",
                "₹${widget.item.monthlyEmi.toString()}",
                "₹${widget.item.reward ?? ""} Cash Reward",
              ),
              SizedBox(height: 16.h),

              /// 🔹 Explore Button
              Center(
                child: Container(
                  height: 45.h,
                  width: 220.w,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: Text(
                      "Explore More Offer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6),
                  ],
                ),
                child: Consumer(
                  builder: (context, ref, child) {
                    return Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Get your Best Home Loan offer!",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFFFF6725),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),

                          SizedBox(height: 8.h),
                          TextFormField(
                            controller: nameController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.h,
                                horizontal: 10.w,
                              ),
                              hintText: "Enter Name",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Name is required";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Mobile Number",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TextFormField(
                            maxLength: 10,
                            controller: phoneController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              counterText: "",
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.h,
                                horizontal: 10.w,
                              ),
                              hintText: "Enter Mobile Number",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Mobile Number is required";
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "Loan Type",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          FormField<String>(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Loan Type is required";
                              }
                              return null;
                            },
                            builder: (FormFieldState<String> field) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DropdownButtonFormField(
                                    value: selectLoanType,
                                    items: loanList.map((e) {
                                      return DropdownMenuItem(
                                        value: e,
                                        child: Text(e),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectLoanType = value.toString();
                                      });
                                    },
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 10.h,
                                        horizontal: 10.w,
                                      ),
                                      hintText: "LoanType",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          30.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (field.hasError)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 10.w,
                                        top: 5.h,
                                      ),
                                      child: Text(
                                        field.errorText!,
                                        style: TextStyle(
                                          color: const Color.fromARGB(
                                            255,
                                            145,
                                            36,
                                            36,
                                          ),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            "City",
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          TextFormField(
                            controller: cityController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.h,
                                horizontal: 10.w,
                              ),
                              hintText: "Enter City",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.r),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "City is required";
                              }
                              return null;
                            },
                          ),

                          SizedBox(height: 12.h),
                          SizedBox(
                            width: double.infinity,
                            height: 44.h,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      if (!_formKey.currentState!.validate())
                                        return;

                                      if (isBuying == null) {
                                        Fluttertoast.showToast(
                                          msg: "Please select Yes or No",
                                        );
                                        return;
                                      }
                                      setState(() => isLoading = true);
                                      try {
                                        final body = LoanQueryBodyModel(
                                          phone: phoneController.text,
                                          city: cityController.text,
                                          loanType: selectLoanType.toString(),
                                          name: nameController.text,
                                        );

                                        /// 🔥 FutureProvider ko direct call
                                        final response = await ref.read(
                                          loanQueryProvider(body).future,
                                        );
                                        if (response.code == 0 ||
                                            response.error == false) {
                                          /// ✅ API message show
                                          Fluttertoast.showToast(
                                            msg: response.message ?? "Success",
                                          );
                                          _formKey.currentState!.reset();
                                          phoneController.clear();
                                          cityController.clear();
                                          selectLoanType = null;
                                          setState(() => isBuying = null);
                                        } else {
                                          Fluttertoast.showToast(
                                            msg: response.message ?? "",
                                          );
                                        }
                                      } catch (e) {
                                        Fluttertoast.showToast(
                                          msg: "Something went wrong",
                                        );
                                      } finally {
                                        setState(() => isLoading = false);
                                      }
                                    },
                              child: isLoading
                                  ? Center(
                                      child: SizedBox(
                                        width: 20.w,
                                        height: 20.h,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 1.5.w,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      "Check Offers",
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 24.h),

              /// 🔹 How it works
              Text(
                "How it works?",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: workSteps.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12.h,
                  crossAxisSpacing: 12.w,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 6),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          workSteps[index].icon,
                          size: 28.sp,
                          color: Colors.orange,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          workSteps[index].title,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          workSteps[index].desc,
                          style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 25.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/Rectangle 559.png",
                    width: 158.w,
                    height: 159.h,
                    fit: BoxFit.cover,
                  ),
                  Image.asset(
                    "assets/Rectangle 560.png",
                    width: 158.w,
                    height: 159.h,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              Image.asset("assets/Frame (1).png"),
              SizedBox(height: 25.h),
              Text(
                "Property not finalized yet?",
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              Text(
                "Unlock the power of a Pre-approved Loan. Apply now and make your property search more focused and easy.",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(178, 0, 0, 0),
                ),
              ),
              SizedBox(height: 10.h),

              /// 🔹 Offer Section
              Text(
                "Benefits of Pre-approved loans",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              _bulletText("Plan your budget smartly"),
              _bulletText("Negotiate a better deal with the seller"),
              _bulletText("Dedicated RM for Property Search"),
              _bulletText("Get the loan processed quickly"),
              SizedBox(height: 20.h),

              /// 🔹 Explore Button
              Center(
                child: Container(
                  height: 45.h,
                  width: 220.w,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(30.r),
                  ),
                  child: Center(
                    child: Text(
                      "Explore More Offer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              /// 🔹 Offer Section
              Text(
                "Personalized deals for everyone",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                "Explore the home loan options that best match your requirements",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: Color.fromARGB(178, 0, 0, 0),
                ),
              ),
              SizedBox(height: 20.h),

              /// 🔹 Top Cards
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: topCards.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (_, index) => Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.r),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 6),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Image.asset(
                          topCards[index].image.toString(),
                          width: 160.w,
                          height: 93.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        topCards[index].title,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        topCards[index].desc,
                        style: TextStyle(fontSize: 11.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 20.h),

              /// 🔹 EMI Calculator
              Text(
                "EMI Calculator",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10.h),

              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Propertyle Loan",
                      style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFF6725),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 10.w,
                          ),
                          labelText: "Enter Loan Amount",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
                      child: DropdownButtonFormField(
                        value: "value",
                        items: [
                          DropdownMenuItem(
                            value: "value",
                            child: Text("30 yrs"),
                          ),
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 10.w,
                          ),
                          labelText: "Loan Tenure",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                          hintText: "₹ 60,00,000",
                        ),
                        onChanged: (v) {},
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
                      child: DropdownButtonFormField(
                        value: "7.35",
                        items: [
                          DropdownMenuItem(value: "7.35", child: Text("7.35")),
                        ],
                        onChanged: (v) {},
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h,
                            horizontal: 10.w,
                          ),
                          labelText: "Interest Rate % (P.a.)",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    SizedBox(
                      width: double.infinity,
                      height: 44.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        onPressed: () {},
                        child: Text(
                          "Calculate Your EMI",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 18.h),

              /// 🔹 EMI Result
              Text(
                "You are Eligible for EMI Amount ₹39,388",
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 12.h),

              Row(
                children: [
                  _emiInfo("Principal Amount", "₹80,00,000"),
                  SizedBox(width: 12.w),
                  _emiInfo("Interest Amount", "₹29,53,299"),
                ],
              ),

              SizedBox(height: 20.h),

              /// 🔹 Benefits
              Text(
                "Why Magicbricks?",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10.h),
              _bulletText("Offers from 34+ Banks"),
              _bulletText("Lowest Interest Rate"),
              _bulletText("Highest Loan Value"),

              SizedBox(height: 14.h),

              SizedBox(
                width: double.infinity,
                height: 45.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  onPressed: () {},
                  child: Text("Check Bank Offers"),
                ),
              ),

              SizedBox(height: 20.h),

              /// 🔹 FAQs
              Text(
                "Home Loan FAQs",
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: const [
                    BoxShadow(color: Colors.black12, blurRadius: 6),
                  ],
                ),
                child: Column(
                  children: [
                    _faq("What are the key features?", context),
                    _faq("What are the different types?", context),
                    _faq("What are the factors you should consider?", context),
                    _faq(
                      "How does Credit score impact your interest rate?",
                      context,
                    ),
                    _faq(
                      "What's the benefit of having a female co-applicant?",
                      context,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bulletText(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        children: [
          const Icon(Icons.check, color: Color(0xFFFF6725), size: 16),
          SizedBox(width: 6.w),
          Expanded(
            child: Text(text, style: TextStyle(fontSize: 13.sp)),
          ),
        ],
      ),
    );
  }

  /// 🔹 Chip Widget
  Widget _chip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(text, style: TextStyle(fontSize: 11.sp)),
    );
  }

  /// 🔹 Bank Offer Card
  Widget _bankOfferCard(
    String backName,
    String interest,
    String loanAmount,
    String tensure,
    String emi,
    String reward,
  ) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.account_balance, color: Colors.blue),
              SizedBox(width: 6.w),
              Text(
                //  "Bank of Baroda",
                backName,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "Recommended",
                  style: TextStyle(color: Colors.white, fontSize: 10.sp),
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _offerText(interest, "Interest"),
              _offerText(
                //"₹50L"
                loanAmount,
                "Loan Amount",
              ),
              _offerText(tensure, "Tenure"),
              _offerText(emi, "Monthly EMI"),
            ],
          ),

          SizedBox(height: 10.h),

          Text(
            "Get Loan disbursed under 8 Days",
            style: TextStyle(fontSize: 15.sp, color: Colors.black),
          ),

          SizedBox(height: 8.h),

          Row(
            children: [
              Text(
                // "₹14,000 Cash Reward",
                reward,
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  "Claim Now",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _offerText(String title, String sub) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
        Text(
          sub,
          style: TextStyle(
            fontSize: 11.sp,
            color: Color.fromARGB(178, 0, 0, 0),
          ),
        ),
      ],
    );
  }

  Widget _emiInfo(String title, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 11.sp,
                color: Color.fromARGB(178, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _faq(String text, BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent, // 👈 border remove
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        title: Text(text, style: TextStyle(fontSize: 13.sp)),
        children: [
          Align(
            alignment: Alignment.centerLeft, // 👈 LEFT align
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Detailed explanation will appear here.",
                  textAlign: TextAlign.start, // 👈 safe side
                  style: TextStyle(fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
