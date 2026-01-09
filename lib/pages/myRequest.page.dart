import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; // Date formatting ke liye (Optional)
import 'package:realstate/Controller/myRequestBookingSerivceController.dart';

class MyRequestPage extends ConsumerWidget {
  const MyRequestPage({super.key});

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'in_progress':
        return Colors.blue;
      case 'complete':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const primaryColor = Color(0xFFFF5722);
    final myRequestProvider = ref.watch(myRequestBookingServiceContorller);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
          "My Service Requests",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
          ),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: myRequestProvider.when(
        data: (data) {
          final list = data.data?.list ?? [];

          // --- EMPTY DATA DESIGN ---
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.assignment_late_outlined,
                    size: 80.sp,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    "No Requests Found",
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "You haven't booked any services yet.",
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            );
          }

          // --- DYNAMIC LIST ---
          return ListView.builder(
            padding: EdgeInsets.all(15.w),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];
              final status = item.status ?? "pending";

              return Container(
                margin: EdgeInsets.only(bottom: 15.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // 1. Header: Dynamic Image & Status
                    Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Image.network(
                              item.serviceType?.image ?? "",
                              width: 40.w,
                              height: 40.w,
                              errorBuilder: (c, e, s) => Icon(
                                Icons.build,
                                color: primaryColor,
                                size: 30.sp,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  // item.serviceType?.name ?? "Service",
                                  item.serviceType!.name ?? "",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                Text(
                                  "ID: #${item.id?.substring(item.id!.length - 8)}", // Chota ID dikhane ke liye
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor(status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              status.toUpperCase().replaceAll('_', ' '),
                              style: TextStyle(
                                color: getStatusColor(status),
                                fontWeight: FontWeight.bold,
                                fontSize: 9.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1),

                    // 2. Details: Dynamic Address & Message
                    Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        children: [
                          _infoRow(
                            Icons.location_on_outlined,
                            "Address",
                            item.address ?? "No Address Provided",
                          ),
                          if (item.message != null &&
                              item.message!.isNotEmpty) ...[
                            SizedBox(height: 8.h),
                            _infoRow(
                              Icons.message_outlined,
                              "Message",
                              item.message!,
                            ),
                          ],
                          if (status == "rejected") ...[
                            SizedBox(height: 8.h),
                            _infoRow(
                              Icons.error_outline,
                              "Reason",
                              item.rejectedReason ?? "Contact Support",
                              color: Colors.red,
                            ),
                          ],
                        ],
                      ),
                    ),

                    // 3. Footer: Dynamic Service Boy & Date
                    Container(
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.05),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.person_outline,
                                size: 16.sp,
                                color: primaryColor,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                item.serviceBoy != null
                                    ? "Assign: ${item.serviceBoy!.name}"
                                    : "Assigning Soon...",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            item.createdAt != null
                                ? DateFormat('dd MMM, hh:mm a').format(
                                    DateTime.fromMillisecondsSinceEpoch(
                                      item.createdAt!,
                                    ),
                                  )
                                : "",
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        error: (error, stackTrace) {
          log(stackTrace.toString());
          return Center(child: Text("Error: $error"));
        },
        loading: () =>
            const Center(child: CircularProgressIndicator(color: primaryColor)),
      ),
    );
  }

  Widget _infoRow(IconData icon, String title, String value, {Color? color}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14.sp, color: color ?? Colors.grey),
        SizedBox(width: 8.w),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                color: color ?? Colors.black87,
                fontSize: 12.5.sp,
              ),
              children: [
                TextSpan(
                  text: "$title: ",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
