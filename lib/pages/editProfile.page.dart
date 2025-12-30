import 'dart:developer';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realstate/Controller/userProfileController.dart';
import 'package:realstate/Model/editProfileBodyModel.dart';
import 'package:realstate/Model/uploadImageBodyModel.dart';
import 'package:realstate/core/network/api.state.dart';
import 'package:realstate/core/utils/preety.dio.dart';
import 'package:realstate/pages/OTPVerify.page.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final nameController = TextEditingController();
  final emailControler = TextEditingController();
  final phoneController = TextEditingController();
  bool isLoading = false;
  File? profileImage;
  String existingImage = "";

  final ImagePicker _picker = ImagePicker();

  /// Pick image (Camera / Gallery)
  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  /// Bottom sheet for image picker
  void showImagePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                pickImage(ImageSource.camera);
              },
              child: const Text("Camera"),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                pickImage(ImageSource.gallery);
              },
              child: const Text("Gallery"),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadProfileData();
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  Future<void> loadProfileData() async {
    final profile = ref.read(userProfileController);
    profile.whenData((userdata) {
      nameController.text = userdata.data!.name ?? "";
      emailControler.text = userdata.data!.email ?? "";
      phoneController.text = userdata.data!.phone ?? "";
      existingImage = userdata.data!.image ?? "";
    });
  }

  Future<void> updateProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final service = APIStateNetwork(createDio());
      String uploadImagePath = existingImage;

      if (profileImage != null) {
        final uploadResponse = await service.uploadImage(
          File(profileImage!.path),
        );

        log("UPLOAD RESPONSE: ${uploadResponse.data}");
        if (uploadResponse.error == false) {
          uploadImagePath = uploadResponse.data!.imageUrl ?? "";
        } else {
          log("Image upload failed");
        }
      }

      final body = EditProfileBodyModel(
        name: nameController.text,
        image: uploadImagePath,
      );

      final response = await service.editProfile(body);
      if (response.code == 0 || response.error == false) {
        Navigator.pop(context);
        ref.invalidate(userProfileController);
        Fluttertoast.showToast(msg: response.message ?? "");
      } else {
        Fluttertoast.showToast(msg: response.message ?? "Error");
      }
    } catch (e) {
      log(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CommonLoader(
      isLoading: isLoading,
      child: Scaffold(
        backgroundColor: const Color(0xffF6F7FB),
        appBar: AppBar(
          title: const Text("Edit Profile"),
          backgroundColor: const Color(0xffF6F7FB),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Profile Image
                Center(
                  child: GestureDetector(
                    onTap: showImagePicker,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          radius: 60.r,
                          backgroundColor: Colors.grey.shade300,
                          // backgroundImage: existingImage.isEmpty
                          //     ? NetworkImage("https://i.pravatar.cc/150")
                          //     : NetworkImage(existingImage),
                          backgroundImage: profileImage != null
                              ? FileImage(profileImage!)
                              : (existingImage.isNotEmpty
                                        ? NetworkImage(existingImage)
                                        : const NetworkImage(
                                            "https://i.pravatar.cc/150",
                                          ))
                                    as ImageProvider,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.blue,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Name",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff0E1A35),
                  ),
                ),
                SizedBox(height: 15.h),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Name",
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    suffixIcon: Icon(Icons.edit, color: Colors.grey),
                    hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Color(0xffE86A34)),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Email",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff0E1A35),
                  ),
                ),
                SizedBox(height: 15.h),
                TextField(
                  onTap: () {
                    Fluttertoast.showToast(
                      msg: "Registered email cannot be updated",
                    );
                  },
                  controller: emailControler,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Email",
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Color(0xffE86A34)),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Mobile Number",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff0E1A35),
                  ),
                ),
                SizedBox(height: 15.h),
                TextField(
                  onTap: () {
                    Fluttertoast.showToast(
                      msg: "Registered phone number cannot be updated",
                    );
                  },
                  readOnly: true,
                  controller: phoneController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Mobile Number",
                    labelStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    hintStyle: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14.r),
                      borderSide: BorderSide(color: Color(0xffE86A34)),
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                /// Save Button
                InkWell(
                  onTap: isLoading ? null : updateProfile,
                  child: Container(
                    height: 60.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isLoading ? Colors.grey : Color(0xffE86A34),
                      borderRadius: BorderRadius.circular(40.r),
                    ),
                    child: Center(
                      child: Text(
                        "Update",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
