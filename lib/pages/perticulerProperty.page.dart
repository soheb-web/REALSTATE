import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realstate/Controller/getMyPropertyController.dart';
import 'package:realstate/Model/saveContactInPropertyBodyModel.dart';
import 'package:realstate/core/network/api.state.dart';
import 'package:realstate/core/utils/preety.dio.dart';
import 'package:realstate/pages/details.page.dart';
import 'package:realstate/Model/getPropertyResponsemodel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PerticulerPropertyPage extends StatefulWidget {
  final ListElement data;
  const PerticulerPropertyPage({super.key, required this.data});

  @override
  State<PerticulerPropertyPage> createState() => _PerticulerPropertyPageState();
}

class _PerticulerPropertyPageState extends State<PerticulerPropertyPage> {
  // Category data
  final List<Map<String, String>> categories = const [
    {
      'label': 'ELECTRICIAN',
      'url':
          'https://img.freepik.com/free-photo/electrician-working-house-repair-installation_1303-25038.jpg',
    },
    {
      'label': 'CARPENTER',
      'url':
          'https://img.freepik.com/free-photo/carpenter-working-wooden-furniture_1150-100.jpg',
    },
    {
      'label': 'PAINTER',
      'url':
          'https://img.freepik.com/free-photo/painter-painting-wall_23-2149371488.jpg',
    },
    {
      'label': 'PLUMBER',
      'url':
          'https://img.freepik.com/free-photo/plumber-fixing-pipe_23-2149371490.jpg',
    },
    {
      'label': 'INTERIOR CLEANING',
      'url':
          'https://img.freepik.com/free-photo/cleaning-service-concept-with-supplies_23-2149371500.jpg',
    },
    {
      'label': 'DRILL & HANG',
      'url':
          'https://img.freepik.com/free-photo/man-hanging-picture-wall_23-2149371510.jpg',
    },
    {
      'label': 'SECURITY GUARD',
      'url':
          'https://img.freepik.com/free-photo/security-guard-standing-front-building_23-2149371520.jpg',
    },
    {
      'label': 'FABRICATION',
      'url':
          'https://img.freepik.com/free-photo/welder-working-metal_23-2149371530.jpg',
    },
    {
      'label': 'FABRICATION',
      'url':
          'https://img.freepik.com/free-photo/construction-worker-site_23-2149371540.jpg',
    },
  ];
  late List<bool> selected, searchSelect;
  @override
  void initState() {
    super.initState();
    selected = List<bool>.filled(items.length, false);
    searchSelect = List<bool>.filled(searchItem.length, false);
  }

  double isValue = 0.0;

  List<String> items = [
    "1 BHK",
    "2 BHK",
    "3 BHK",
    "4 BHK",
    "5 BHK",
    "6 BHK",
    "7 BHK",
    "8 BHK",
  ];

  List<String> searchItem = [
    "Gwalior",
    "ajmer",
    "Jaipur",
    "Delhi",
    "6 BHK",
    "Delhi",
  ];
  final PageController _pageController = PageController();

  void showContactDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    // Dialog ke state ko manage karne ke liye variables
    bool agreeToContact = false;
    bool interestedHomeLoan = false;
    bool isLoading = false; // Isse yaha initialize karein

    const primaryColor = Color(0xffFF6A2A);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            // setState ka naam badal diya taki confusion na ho
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text(
                "Contact Details",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: "Name",
                        prefixIcon: Icon(Icons.person, color: primaryColor),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email, color: primaryColor),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: const InputDecoration(
                        labelText: "Phone",
                        prefixIcon: Icon(Icons.phone, color: primaryColor),
                        border: OutlineInputBorder(),
                        counterText: "",
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Required Checkbox
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        "I agree to be contacted",
                        style: TextStyle(fontSize: 13),
                      ),
                      value: agreeToContact,
                      activeColor: primaryColor,
                      // Sahi parameter name niche hai:
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (val) =>
                          setDialogState(() => agreeToContact = val ?? false),
                    ),

                    // Optional Checkbox
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        "Interested in Home Loan",
                        style: TextStyle(fontSize: 13),
                      ),
                      value: interestedHomeLoan,
                      activeColor: primaryColor,
                      // Sahi parameter name niche hai:
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (val) => setDialogState(
                        () => interestedHomeLoan = val ?? false,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        fixedSize: const Size(
                          120,
                          45,
                        ), // Fixed size taaki loader ke time button shrank na ho
                      ),
                      onPressed: isLoading
                          ? null
                          : () async {
                              if (nameController.text.isEmpty ||
                                  emailController.text.isEmpty ||
                                  phoneController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please fill all fields"),
                                  ),
                                );
                                return;
                              }
                              if (!agreeToContact) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Please agree to be contacted",
                                    ),
                                  ),
                                );
                                return;
                              }

                              setDialogState(() => isLoading = true);

                              try {
                                // Body model aur API call
                                final body = SaveContactInPropertyBodyModel(
                                  email: emailController.text,
                                  name: nameController.text,
                                  phone: phoneController.text,
                                  propertyId: widget.data.id.toString(),
                                );

                                final service = APIStateNetwork(createDio());
                                final response = await service
                                    .saveContactInProperty(body);

                                if (response.code == 0 ||
                                    response.error == false) {
                                  Fluttertoast.showToast(
                                    msg: response.message ?? "Success",
                                  );
                                  ref.invalidate(
                                    getMyPropertyContantListController,
                                  );

                                  Navigator.pop(context);
                                } else {
                                  Fluttertoast.showToast(
                                    msg: response.message ?? "Error",
                                  );
                                }
                              } catch (e) {
                                debugPrint("Error: $e");
                              } finally {
                                // Check if mounted to avoid errors if dialog closed
                                setDialogState(() => isLoading = false);
                              }
                            },
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final property = widget.data;
    final data = widget.data;

    final List<String> photos = property.uploadedPhotos ?? [];
    final List amenities = property.amenities ?? [];
    final List aroundProjects = property.aroundProject ?? [];
    final overview = property.aveneuOverView;

    return Scaffold(
      backgroundColor: Color(0xFFF9FBFF),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Particular Property',
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
            fontSize: 22.sp,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     SizedBox(width: 25.w),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           'Let’s Find your',
            //           style: GoogleFonts.inter(
            //             fontSize: 16.sp,
            //             color: Color(0xFF8997A9),
            //             fontWeight: FontWeight.w400,
            //           ),
            //         ),
            //         Text(
            //           'Favorite Home',
            //           style: GoogleFonts.inter(
            //             fontSize: 18.sp,
            //             color: Color(0xFF122D4D),
            //             fontWeight: FontWeight.bold,
            //           ),
            //         ),
            //       ],
            //     ),
            //     Spacer(),
            //     Container(
            //       width: 50.w,
            //       height: 50.h,
            //       decoration: BoxDecoration(
            //         shape: BoxShape.circle,
            //         color: Color(0xFFC4C4C4),
            //       ),
            //       child: ClipOval(
            //         child: Image.network(
            //           "https://img.freepik.com/free-photo/plumber-fixing-pipe_23-2149371490.jpg",
            //           width: 50.w,
            //           height: 50.h,
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: 25.w),
            //   ],
            // ),
            // Container(
            //   height: 50.h,
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(30.r),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.10),
            //         blurRadius: 16,
            //         offset: const Offset(0, 8),
            //       ),
            //     ],
            //   ),
            //   margin: EdgeInsets.only(left: 25.w, right: 25.w, top: 20.h),
            //   child: TextField(
            //     decoration: InputDecoration(
            //       enabledBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(30.r),
            //         borderSide: BorderSide.none,
            //       ),
            //       focusedBorder: OutlineInputBorder(
            //         borderRadius: BorderRadius.circular(30.r),
            //         borderSide: BorderSide.none,
            //       ),
            //       hintText: "Search",
            //     ),
            //   ),
            // ),
            // Center(
            //   child: Container(
            //     margin: EdgeInsets.only(top: 20.h, left: 25.w, right: 25.w),
            //     child: Stack(
            //       alignment: Alignment.center,
            //       children: [
            //         ClipRRect(
            //           borderRadius: BorderRadius.circular(16.r),
            //           child: Image.asset(
            //             "assets/particular (2).png",
            //             width: double.infinity,
            //             height: 140.h,
            //             fit: BoxFit.cover,
            //           ),
            //         ),
            //         // 🔹 Optional overlay (text readability)
            //         Container(
            //           width: double.infinity,
            //           height: 140.h,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(16.r),
            //             color: Colors.black.withOpacity(0.35),
            //           ),
            //         ),
            //         // 🔹 Center Text
            //         Padding(
            //           padding: EdgeInsets.symmetric(horizontal: 12.w),
            //           child: Column(
            //             mainAxisSize: MainAxisSize.min,
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             crossAxisAlignment: CrossAxisAlignment.center,
            //             children: [
            //               Text(
            //                 'Best Property Consultants in India',
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(
            //                   fontSize: 12.sp,
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //               Text(
            //                 'Home Buying, Selling, Renting & Loan Support',
            //                 textAlign: TextAlign.center,
            //                 style: TextStyle(
            //                   fontSize: 16.sp,
            //                   fontWeight: FontWeight.w500,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // // 🔹 HEADER
            // Container(
            //   height: 45.h,
            //   margin: EdgeInsets.only(top: 20.h, left: 25.w, right: 25.w),
            //   width: double.infinity,
            //   padding: const EdgeInsets.all(8),
            //   decoration: BoxDecoration(
            //     color: Color(0xffFF6A2A),
            //     borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(20.r),
            //       topRight: Radius.circular(20.r),
            //     ),
            //   ),
            //   child: Text(
            //     "Filter",
            //     style: GoogleFonts.inter(
            //       color: Colors.white,
            //       fontSize: 16.sp,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 16.h),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // PRICE SLIDER
            //       Text(
            //         "Price Range",
            //         style: GoogleFonts.inter(
            //           color: Colors.black,
            //           fontWeight: FontWeight.w500,
            //           fontSize: 16.sp,
            //         ),
            //       ),
            //       SliderTheme(
            //         data: SliderTheme.of(context).copyWith(
            //           tickMarkShape: const RoundSliderTickMarkShape(
            //             tickMarkRadius: 3.0,
            //           ), // छोटे dots
            //           thumbShape: const RoundSliderThumbShape(
            //             enabledThumbRadius: 12,
            //           ), // thumb size
            //           overlayShape: const RoundSliderOverlayShape(
            //             overlayRadius: 24,
            //           ),
            //           trackHeight: 6, // track की मोटाई
            //         ),
            //         child: Slider(
            //           value: isValue,
            //           min: 0,
            //           max: 100,
            //           divisions: 10,
            //           activeColor: const Color(0xffFF6A2A),
            //           inactiveColor: Colors.grey.shade300,
            //           label: '${isValue.round()}',
            //           onChanged: (value) {
            //             setState(() {
            //               isValue = value;
            //             });
            //           },
            //         ),
            //       ),
            //       SizedBox(height: 20.h),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           ElevatedButton(
            //             onPressed: () {
            //               // TODO: action
            //             },
            //             style: ElevatedButton.styleFrom(
            //               elevation: 0,
            //               backgroundColor: Colors.white,
            //               foregroundColor: const Color(0xffFF6A2A),
            //               fixedSize: Size.fromHeight(
            //                 45.h,
            //               ), // <-- यहीं height set करो
            //               padding: EdgeInsets.symmetric(
            //                 horizontal: 20.w,
            //               ), // vertical padding की जरूरत नहीं अब
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(30.r),
            //                 side: const BorderSide(
            //                   color: Color(0xffFF6A2A),
            //                   width: 1.2,
            //                 ),
            //               ),
            //             ),
            //             child: Text(
            //               "₹ 1,50,000",
            //               style: GoogleFonts.inter(
            //                 fontSize: 15.sp,
            //                 fontWeight: FontWeight.w600,
            //               ),
            //             ),
            //           ),
            //           SizedBox(width: 25.w),
            //           ElevatedButton(
            //             onPressed: () {
            //               // TODO: action
            //             },
            //             style: ElevatedButton.styleFrom(
            //               elevation: 0,
            //               backgroundColor: Colors.white,
            //               foregroundColor: const Color(0xffFF6A2A),
            //               fixedSize: Size.fromHeight(45.h), // <-- height 45.h
            //               padding: EdgeInsets.symmetric(horizontal: 20.w),
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(30.r),
            //                 side: const BorderSide(
            //                   color: Color(0xffFF6A2A),
            //                   width: 1.2,
            //                 ),
            //               ),
            //             ),
            //             child: Text(
            //               "₹ 5,00,000",
            //               style: GoogleFonts.inter(
            //                 fontSize: 15.sp,
            //                 fontWeight: FontWeight.w600,
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //       SizedBox(height: 15.w),
            //       Divider(color: Colors.grey, thickness: 3),
            //       SizedBox(height: 15.w),
            //       Text(
            //         "Bedroom",
            //         style: GoogleFonts.inter(
            //           fontSize: 16.sp,
            //           fontWeight: FontWeight.w500,
            //           color: Color(0xFF000000),
            //         ),
            //       ),
            //       GridView.builder(
            //         shrinkWrap: true,
            //         physics: const NeverScrollableScrollPhysics(),
            //         padding: const EdgeInsets.all(16),
            //         itemCount: items.length,
            //         gridDelegate:
            //             const SliverGridDelegateWithFixedCrossAxisCount(
            //               crossAxisCount: 2,
            //               mainAxisSpacing: 10,
            //               crossAxisSpacing: 20,
            //               childAspectRatio: 6,
            //             ),
            //         itemBuilder: (context, index) {
            //           return InkWell(
            //             onTap: () {
            //               setState(() {
            //                 selected[index] = !selected[index];
            //               });
            //             },
            //             child: Row(
            //               children: [
            //                 Checkbox(
            //                   value: selected[index],
            //                   activeColor: const Color(0xffFF6A2A),
            //                   onChanged: (value) {
            //                     setState(() {
            //                       selected[index] = value!;
            //                     });
            //                   },
            //                 ),
            //                 SizedBox(width: 10.w),
            //                 Text(
            //                   items[index],
            //                   style: GoogleFonts.inter(
            //                     fontSize: 14.sp,
            //                     fontWeight: FontWeight.w500,
            //                     color: Colors.black,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           );
            //         },
            //       ),
            //       SizedBox(height: 10.w),
            //       Divider(color: Colors.grey, thickness: 3),
            //       SizedBox(height: 15.w),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             "Locality",
            //             style: GoogleFonts.inter(
            //               fontSize: 16.sp,
            //               fontWeight: FontWeight.w500,
            //               color: Color(0xFF000000),
            //             ),
            //           ),
            //           /* Text(
            //             "Locality",
            //             style: GoogleFonts.inter(
            //               fontSize: 18.sp,
            //               fontWeight: FontWeight.w500,
            //               color: Colors.grey,
            //             ),
            //           ),*/
            //         ],
            //       ),
            //       SizedBox(height: 15.h),
            //       Container(
            //         height: 50.h,
            //         decoration: BoxDecoration(
            //           color: Colors.white,
            //           borderRadius: BorderRadius.circular(30.r),
            //           boxShadow: [
            //             BoxShadow(
            //               color: Colors.black.withOpacity(0.10),
            //               blurRadius: 16,
            //               offset: const Offset(0, 8),
            //             ),
            //           ],
            //         ),
            //         child: TextField(
            //           decoration: InputDecoration(
            //             enabledBorder: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(30.r),
            //               borderSide: BorderSide.none,
            //             ),
            //             focusedBorder: OutlineInputBorder(
            //               borderRadius: BorderRadius.circular(30.r),
            //               borderSide: BorderSide.none,
            //             ),
            //             hintText: "Search",
            //           ),
            //         ),
            //       ),
            //       SizedBox(height: 15.h),
            //       ListView.builder(
            //         shrinkWrap: true,
            //         itemCount: searchItem.length,
            //         physics: NeverScrollableScrollPhysics(),
            //         itemBuilder: (context, index) {
            //           return InkWell(
            //             onTap: () {
            //               setState(() {
            //                 searchSelect[index] = !searchSelect[index];
            //               });
            //             },
            //             child: Row(
            //               children: [
            //                 Checkbox(
            //                   value: selected[index],
            //                   activeColor: const Color(0xffFF6A2A),
            //                   onChanged: (value) {
            //                     setState(() {
            //                       selected[index] = value!;
            //                     });
            //                   },
            //                 ),
            //                 SizedBox(width: 10.w),
            //                 Text(
            //                   searchItem[index],
            //                   style: GoogleFonts.inter(
            //                     fontSize: 14.sp,
            //                     fontWeight: FontWeight.w500,
            //                     color: Colors.black,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           );
            //         },
            //       ),
            //       Center(
            //         child: GestureDetector(
            //           onTap: () {},
            //           child: Container(
            //             height: 50.h,
            //             width: double.infinity,
            //             decoration: BoxDecoration(
            //               color: const Color(0xffFF6A2A),
            //               borderRadius: BorderRadius.circular(40.r),
            //             ),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Icon(Icons.search, color: Colors.white),
            //                 SizedBox(width: 10.w),
            //                 Text(
            //                   "Search",
            //                   style: TextStyle(
            //                     color: Colors.white,
            //                     fontSize: 14,
            //                     fontWeight: FontWeight.w600,
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Stack(
              children: [
                SizedBox(
                  height: 220.h,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: photos.isEmpty ? 1 : photos.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        photos.isEmpty
                            ? 'https://via.placeholder.com/600x400'
                            : photos[index],
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => Container(
                          color: Colors.grey.shade300,
                          child: const Center(
                            child: Icon(Icons.image, size: 60),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Align(
                  alignment: AlignmentGeometry.topRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10.h, right: 10.w),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.r),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.share, color: Colors.black, size: 16.sp),
                            SizedBox(width: 6.w),
                            Text(
                              "Share",
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.h, right: 10.w),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.r),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                              size: 16.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Save",
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: photos.isEmpty ? 1 : photos.length,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.deepOrange,
                  dotColor: Colors.white.withOpacity(.7),
                  dotHeight: 8,
                  dotWidth: 8,
                  expansionFactor: 3,
                  spacing: 6,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, top: 16.h, right: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 🔹 Title
                  Row(
                    children: [
                      Text(
                        // "NRI Avenue",
                        "${widget.data.bedRoom} BHK ${widget.data.propertyType}",
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10.w),
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                          color: Color(0xFFECECEC),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.done, color: Colors.green, size: 15.sp),
                            SizedBox(width: 3.w),
                            Text(
                              "RERA",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),
                  Text(
                    // "Jagatpura, NH - 8 Jaipur",
                    "${property.localityArea}, ${property.city}",
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  /// 🔹 Price
                  Text(
                    // "₹40.95 L - 43.7 L",
                    "₹ ${property.price}",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),

                  SizedBox(height: 6.h),
                  Text(
                    "EMI starts at ₹21.68 K",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFFF6725),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  /// 🔹 EMI Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF6725),
                      minimumSize: Size(150.w, 45.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                    ),
                    onPressed: () {
                      showContactDialog(context);
                    },
                    icon: const Icon(Icons.call_outlined, color: Colors.white),
                    label: Text(
                      "Contact",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.h),
                    width: double.infinity,
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 🔹 Title
                        Text(
                          "Around This Project",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 12.h),
                        Column(
                          children: List.generate(aroundProjects.length, (
                            index,
                          ) {
                            final item = aroundProjects[index];
                            return Container(
                              width: 220.w,
                              margin: EdgeInsets.only(right: 12.w),
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset("assets/Group 25.png"),
                                  SizedBox(width: 10.w),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name ?? "",
                                        style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),

                                      Text(
                                        item.details ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  /// 🔹 Overview
                  Text(
                    "Avenue Overview",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 12.h),
                  Wrap(
                    spacing: 16.w,
                    runSpacing: 20.h,
                    children: [
                      _info("${property.bedRoom} Bed", "assets/bed.png", ""),
                      _info(
                        "${property.bathrooms} Baths",
                        "assets/bath.png",
                        "",
                      ),
                      _info(
                        "Project Area",
                        "assets/Group 30.png",
                        overview?.projectArea ?? "-",
                      ),
                      _info(
                        "Sizes",
                        "assets/turf-size.png",
                        overview?.size ?? "-",
                      ),
                      _info(
                        "Launch Date",
                        "assets/Group 33.png",
                        overview?.launchDate ?? "-",
                      ),
                      _info(
                        "Project Size",
                        "assets/Vector.png",
                        overview?.projectSize ?? "-",
                      ),
                      _info(
                        "Possession",
                        "assets/Vector (1).png",
                        overview?.possessionStart ?? "-",
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 90.w,
                        height: 42.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.r),
                          color: Color.fromARGB(52, 255, 103, 137),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.share, color: Colors.black, size: 16.sp),
                            SizedBox(width: 6.w),
                            Text(
                              "Share",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 90.w,
                        height: 42.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.r),
                          color: Color.fromARGB(52, 255, 103, 137),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite_border,
                              color: Colors.black,
                              size: 16.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              "Save",
                              style: GoogleFonts.inter(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100.w,
                        height: 42.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.r),
                          color: Color(0xFFFF6725),
                        ),
                        child: Center(
                          child: Text(
                            "Ask For Details",
                            style: GoogleFonts.inter(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Photos & Videos: Tour this project virtually",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15.h),

                  Text(
                    "Project Tour & Photos",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Stack(
                    alignment: AlignmentGeometry.center,
                    children: [
                      Image.asset("assets/Rectangle 92.png"),
                      Align(
                        alignment: AlignmentGeometry.center,
                        child: Icon(
                          Icons.play_circle_fill_outlined,
                          color: Colors.white,
                          size: 30.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        "assets/Rectangle 91.png",
                        width: 103.w,
                        height: 95.h,
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        "assets/Rectangle 91.png",
                        width: 103.w,
                        height: 95.h,
                        fit: BoxFit.cover,
                      ),
                      Image.asset(
                        "assets/Rectangle 91.png",
                        width: 103.w,
                        height: 95.h,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  /// 🔹 Amenities
                  Text(
                    "Project Amenities",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: amenities.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12.h,
                      crossAxisSpacing: 12.w,
                      childAspectRatio: 1.14,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Center(
                          child: Text(
                            // item.title,
                            amenities[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24.h),
                  // Row(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Expanded(
                  //       child: Text(
                  //         textAlign: TextAlign.center,
                  //         "Studio Apartment Configuration",
                  //         style: TextStyle(
                  //           fontSize: 16.sp,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Column(
                  //         children: [
                  //           Text(
                  //             "431 - 460 sq.ft",
                  //             style: TextStyle(
                  //               fontSize: 16.sp,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //           Text(
                  //             "convert unit",
                  //             style: TextStyle(
                  //               fontSize: 14.sp,
                  //               fontWeight: FontWeight.w500,
                  //               color: Color(0xFFFF6725),
                  //             ),
                  //           ),
                  //           Text(
                  //             textAlign: TextAlign.center,
                  //             "(Super Builtup Area) \n Size",
                  //             style: TextStyle(
                  //               fontSize: 13.sp,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 Configuration
                      Expanded(
                        child: Text(
                          "${data.propertyType ?? ""} Configuration",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      /// 🔹 Size Info
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              overview?.size != null
                                  ? "${overview!.size} sq.ft"
                                  : data.area != null
                                  ? "${data.area} sq.ft"
                                  : "-",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            /// Convert Unit
                            Text(
                              "convert unit",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFFF6725),
                              ),
                            ),

                            /// Area Type (not in API → static)
                            Text(
                              "(Super Builtup Area)\nSize",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),

                  /// 🔹 Description
                  Text(
                    "Property Description",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    // "Luxury 2-Bedroom Apartment | Off-Plan Resale | Damac Casa – Al Sufouh Second. "
                    // "Property introduces a remarkable 2-bedroom apartment...",
                    property.description ?? "No des",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 20.h),
                ],
              ),
            ),
            // Categories Grid (3x3 + 1 extra)
            SizedBox(height: 15.h),
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.all(12),
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12.h,
                crossAxisSpacing: 12.w,
                childAspectRatio: 0.55,
              ),
              itemBuilder: (context, index) {
                return const PropertyCard();
              },
            ),
            paginationBar(),

            Padding(
              padding: EdgeInsets.only(left: 15.w, right: 15.w, top: 15.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Buy ",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFFFF6725),
                          ),
                        ),
                        TextSpan(
                          text: "Property Online in India",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Majestic Living brings you a seamless experience to buy properties online across India. Whether you are a first-time homebuyer, ',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(204, 0, 0, 0),
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    "Find the Right Residential Property for Sale in India",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'A home is more than a living space—it’s where life grows. That’s why we bring you a curated selection of top-quality residential properties across India, including affordable flats in Mumbai,',
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(204, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _info(String text, String image, String sub) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(image, width: 25.w, height: 25.h),
        SizedBox(width: 4.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Color(0xFFFF6725),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              sub,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget paginationBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // PREV
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          onPressed: () {},
          child: Text(
            "PREV",
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),

        const SizedBox(width: 10),

        // PAGE NUMBERS
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            onPressed: () {},
            child: Text(
              "0",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // NEXT
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF6725),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
          ),
          onPressed: () {},
          child: Text(
            "NEXT",
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 20.w),
      ],
    );
  }
}

class PropertyCard extends StatelessWidget {
  const PropertyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(14.r)),
                child: Image.network(
                  "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2",
                  height: 100.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "3 BHK Apartment in Vaishali Nagar",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Vaishali Nagar, Jaipur • 1200 sqft",
                      style: GoogleFonts.inter(
                        fontSize: 10.sp,
                        color: Color.fromARGB(204, 0, 0, 0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 6),

                    // TAGS
                    Row(children: [_tag("3 BHK"), _tag("Apartment")]),

                    const SizedBox(height: 6),

                    // PRICE
                    Text(
                      "₹45L",
                      style: GoogleFonts.inter(
                        color: Color(0xFFFF6725),
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => DetailsPage(),
                                ),
                              );
                            },
                            child: Text(
                              "View",
                              style: GoogleFonts.inter(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFFFF6725),
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                            ),
                            onPressed: () {},
                            child: Text(
                              "Contact",
                              style: GoogleFonts.inter(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _tag(String text) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Color.fromARGB(127, 138, 56, 245),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: const TextStyle(fontSize: 11)),
    );
  }
}
