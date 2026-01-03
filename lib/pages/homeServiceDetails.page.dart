import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:realstate/pages/add.service.page.dart';

class HomeServiceDetailsPage extends StatelessWidget {
  const HomeServiceDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFFF5722);
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      /// ================= BOTTOM BUTTON =================
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: SizedBox(
          height: 50.h,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            onPressed: () {},
            child: Text(
              "Book Service",
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),

      body: CustomScrollView(
        slivers: [
          /// ================= IMAGE HEADER =================
          SliverAppBar(
            expandedHeight: 280.h,
            pinned: true,
            backgroundColor: primaryColor,
            leading: _icon(Icons.arrow_back, () {
              Navigator.pop(context);
            }),
            actions: [
              _icon(Icons.favorite_border, () {}),
              SizedBox(width: 10.w),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "https://images.unsplash.com/photo-1581578731548-c64695cc6952",
                fit: BoxFit.cover,
              ),
            ),
          ),

          /// ================= CONTENT =================
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE + PRICE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Toilet Repair Service",
                          style: GoogleFonts.inter(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        "₹499",
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  /// RATING
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 18.sp),
                      SizedBox(width: 4.w),
                      Text(
                        "4.8 (120 reviews)",
                        style: GoogleFonts.inter(fontSize: 13.sp),
                      ),
                    ],
                  ),

                  SizedBox(height: 20.h),

                  /// DESCRIPTION
                  _sectionTitle("Service Description"),
                  Text(
                    "Fast, reliable toilet fixes that restore proper function. Our professionals use modern tools to diagnose and repair efficiently.",
                    style: GoogleFonts.inter(
                      fontSize: 13.sp,
                      color: Colors.grey.shade700,
                      height: 1.6,
                    ),
                  ),

                  SizedBox(height: 24.h),

                  /// WHY CHOOSE US
                  _sectionTitle("Why Choose Us"),
                  Wrap(
                    spacing: 10.w,
                    children: const [
                      _ChipItem("Tech Expertise"),
                      _ChipItem("Advanced Tools"),
                      _ChipItem("Smart Solutions"),
                    ],
                  ),

                  SizedBox(height: 24.h),

                  /// GALLERY (REUSED FEATURED PROJECT)
                  _sectionTitle("Service Gallery"),
                  SizedBox(
                    height: 180.h,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: const [
                        FeaturedProject(
                          imageUrl:
                              'https://images.finehomebuilding.com/app/uploads/2016/04/09114955/021181bs116-01_xlg.jpg',
                          title: 'Drain Repair',
                          subtitle: 'Complete overhaul',
                        ),
                        FeaturedProject(
                          imageUrl:
                              'https://www.thespruce.com/thmb/e-MxaOBy4AKp4JW1XFZGbrkDaIw=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/how-to-install-a-sink-drain-2718789_hero_5078-64538f6f90d545c7af0728e4bf8f894e.jpg',
                          title: 'Sink Setup',
                          subtitle: 'Kitchen installation',
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  /// PRICING
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.price_check,
                          size: 40.sp,
                          color: primaryColor,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "Affordable Pricing",
                          style: GoogleFonts.inter(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "Transparent pricing with no hidden charges.",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(fontSize: 13.sp),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _icon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8.w),
        padding: EdgeInsets.all(8.w),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Text(
        text,
        style: GoogleFonts.inter(fontSize: 16.sp, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ChipItem extends StatelessWidget {
  final String label;
  const _ChipItem(this.label);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.orange.shade50,
      labelStyle: GoogleFonts.inter(fontSize: 12.sp),
    );
  }
}
