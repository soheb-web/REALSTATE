import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:realstate/Controller/homeServiceCategoryController.dart';
import 'package:realstate/pages/propertyCat.page.dart';
import 'package:shimmer/shimmer.dart';
import 'createPropertyPage.dart';
import 'drawer.dart';

class RealEstateHomePage extends StatefulWidget {
  const RealEstateHomePage({super.key});

  @override
  State<RealEstateHomePage> createState() => _RealEstateHomePageState();
}

class _RealEstateHomePageState extends State<RealEstateHomePage> {
  int bottomIndex = 0;
  int selectIndex = 0;
  final GlobalKey<_RealEstateHomePageState> _scaffoldKey = GlobalKey();
  List<Property> properties = [];

  @override
  void initState() {
    super.initState();
    _addDummyProperties();
  }

  void _addDummyProperties() {
    properties = [
      Property(
        propertyType: 'Apartment/Flat',
        propertyCategory: 'Residential',
        listingCategory: 'Sale',
        city: 'Mumbai',
        locality: 'Andheri West',
        price: '2.5 Cr',
        bedrooms: '3',
        bathrooms: '3',
        area: '1200',
        furnishing: 'Semi-Furnished',
        amenities: [
          'Gymnasium',
          'Swimming Pool',
          'Lift',
          'Security',
          'Parking',
        ],
        aroundProject: [
          {'place': 'Metro Station', 'details': '2 mins walk'},
          {'place': 'School', 'details': 'International School - 1 km'},
        ],
        fullName: 'Rahul Sharma',
        email: 'rahul@example.com',
        phone: '+91 9876543210',
        address: 'Palm Grove Apartments, Andheri West, Mumbai',
        description: 'Luxurious 3 BHK with sea view...',
      ),
      Property(
        propertyType: 'Independent House/Villa',
        propertyCategory: 'Residential',
        listingCategory: 'Rent/Lease',
        city: 'Delhi',
        locality: 'Greater Kailash',
        price: '1.2 Lac/month',
        bedrooms: '4',
        bathrooms: '4',
        area: '2500',
        furnishing: 'Furnished',
        amenities: ['Garden', 'Parking', 'Power Backup', 'Security'],
        aroundProject: [
          {'place': 'Market', 'details': 'GK Market - 500m'},
          {'place': 'Hospital', 'details': 'Max Hospital - 3km'},
        ],
        fullName: 'Priya Singh',
        email: 'priya@example.com',
        phone: '+91 8765432109',
        address: 'E-Block, Greater Kailash, New Delhi',
        description: 'Beautiful independent villa with lawn...',
      ),
      Property(
        propertyType: 'Shop/Showroom',
        propertyCategory: 'Commercial',
        listingCategory: 'Sale',
        city: 'Bangalore',
        locality: 'Koramangala',
        price: '3.8 Cr',
        bedrooms: '0',
        bathrooms: '2',
        area: '800',
        furnishing: 'Unfurnished',
        amenities: ['Parking', 'Lift', 'Security'],
        aroundProject: [
          {'place': 'Forum Mall', 'details': 'Walking distance'},
        ],
        fullName: 'Amit Patel',
        email: 'amit@example.com',
        phone: '+91 7654321098',
        address: 'Main Road, Koramangala, Bangalore',
        description: 'Prime location showroom...',
      ),
      Property(
        propertyType: 'Plot/Land',
        propertyCategory: 'Residential',
        listingCategory: 'Sale',
        city: 'Pune',
        locality: 'Hinjewadi',
        price: '85 Lac',
        bedrooms: '0',
        bathrooms: '0',
        area: '2000',
        furnishing: 'Unfurnished',
        amenities: [],
        aroundProject: [
          {'place': 'IT Park', 'details': 'Phase 1 - 2km'},
          {'place': 'School', 'details': 'Vibgyor - 1.5km'},
        ],
        fullName: 'Neha Gupta',
        email: 'neha@example.com',
        phone: '+91 6543210987',
        address: 'Rajiv Gandhi Infotech Park, Hinjewadi, Pune',
        description: 'Ready to construct residential plot...',
      ),
      Property(
        propertyType: 'Office Space',
        propertyCategory: 'Commercial',
        listingCategory: 'Rent/Lease',
        city: 'Gurgaon',
        locality: 'Cyber City',
        price: '2.5 Lac/month',
        bedrooms: '0',
        bathrooms: '4',
        area: '3000',
        furnishing: 'Furnished',
        amenities: ['Lift', 'Parking', 'Power Backup', 'Security', 'Gymnasium'],
        aroundProject: [
          {'place': 'Metro', 'details': 'Cyber City Metro - 100m'},
          {'place': 'Cafe', 'details': 'Starbucks - Ground floor'},
        ],
        fullName: 'Vikram Singh',
        email: 'vikram@example.com',
        phone: '+91 5432109876',
        address: 'DLF Cyber Hub, Gurgaon',
        description: 'Fully furnished premium office space...',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: AppDrawer(),
      backgroundColor: const Color(0xffF5F7FA),
      body: <Widget>[
        HomeScreen(),
        MyListingsScreen(),
        CallUsScreen(),
        SavedScreen(),
      ][bottomIndex],

      floatingActionButton: SizedBox(
        height: 55,
        width: 55,
        child: FloatingActionButton(
          elevation: 10,
          backgroundColor: const Color(0xffFF6A2A),
          shape: const CircleBorder(),
          onPressed: () async {
            final newProperty = await Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => const CreatePropertyScreen(),
              ),
            );

            if (newProperty != null && newProperty is Property) {
              setState(() {
                properties.add(newProperty);
              });
            }
          },
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomAppBar(
          padding: EdgeInsets.zero,
          color: Colors.white,
          elevation: 10,
          height: 90.h,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                buildNavItem(Icons.home_outlined, 'Home', 0),
                buildNavItem(Icons.description_outlined, 'My Listings', 1),
                SizedBox(width: 48.w),
                buildNavItem(Icons.call_outlined, 'Call us', 2),
                buildNavItem(Icons.bookmark_border, 'Saved', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ==================== HOME SCREEN ====================
  Widget HomeScreen() {
    return SafeArea(
      top: false,
      child: Builder(
        // <-- यहीं Builder add करो
        builder: (BuildContext context) {
          // नया context जो Scaffold के अंदर है
          return SingleChildScrollView(
            child: Column(
              children: [
                // APP BAR
                Container(
                  height: 120.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  color: const Color(0xffFF6A2A),
                  child: Padding(
                    padding: EdgeInsets.only(top: 25.h),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          child: Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: TextField(
                            style: GoogleFonts.inter(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.25),
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.h,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.r),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.r),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                              prefixIconConstraints: BoxConstraints(
                                minHeight: 32.h,
                                minWidth: 36.w,
                              ),
                              hintText: "Search",
                              hintStyle: GoogleFonts.inter(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        const Icon(Icons.mic, color: Colors.white),
                        SizedBox(width: 10.w),
                        const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.w),
                        SvgPicture.asset("assets/Svg/whatsapp.svg"),
                        SizedBox(width: 10.w),
                        const Icon(Icons.logout, color: Colors.white),
                      ],
                    ),
                  ),
                ),

                // BANNER
                Stack(
                  children: [
                    Image.asset(
                      "assets/home (3).png",
                      height: 260.h,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      height: 260.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16.w,
                      bottom: 20.h,
                      right: 16.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Chip(
                            label: const Text("Top rated"),
                            backgroundColor: const Color.fromARGB(
                              178,
                              255,
                              255,
                              255,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.r),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            "Sea Facing Villa, Miami\nBeach Property",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "24 XYZ, Miami Beach, Florida",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // MARQUEE
                Container(
                  width: double.infinity,
                  height: 40.h,
                  color: const Color(0xffFF6A2A),
                  child: Marquee(
                    text:
                        "CALL US TODAY AT +91-8899556644 FOR PROPERTY INQUERY",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                    scrollAxis: Axis.horizontal,
                    velocity: 40,
                    blankSpace: 50,
                    startPadding: 10,
                  ),
                ),

                SizedBox(height: 15.h),

                // TABS
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Row(
                    children: [
                      _tab("Buy & Rent Property", 0),
                      _tab("Home Services", 1),
                      _tab("Loan Service", 2),
                    ],
                  ),
                ),

                SizedBox(height: 16.h),

                // TAB CONTENT
                if (selectIndex == 0)
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: GridView.count(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        _gridItem("assets/png/home.png", "Buy House"),
                        _gridItem("assets/png/apartment.png", "Rent Studio"),
                        _gridItem("assets/png/buyFlat.png", "Buy Flats"),
                        _gridItem("assets/png/buyPlot.png", "Buy Plots"),
                        _gridItem("assets/png/commercial.png", "Commercial"),
                        _gridItem("assets/png/buyHotel.png", "Buy Hotels"),
                        _gridItem("assets/png/rentCondos.png", "Rent Condos"),
                        _gridItem("assets/png/buyDuplex.png", "Buy Duplex"),
                        _gridItem("assets/png/rentHouse.png", "Rent House"),
                      ],
                    ),
                  )
                else if (selectIndex == 1)
                  const HomeService()
                else if (selectIndex == 2)
                  const LoanService(),
                SizedBox(height: 80.h),
              ],
            ),
          );
        },
      ),
    );
  }

  // ==================== MY LISTINGS SCREEN ====================
  Widget MyListingsScreen() {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          Container(
            height: 120.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            color: const Color(0xffFF6A2A),
            child: Padding(
              padding: EdgeInsets.only(top: 25.h),
              child: Row(
                children: [
                  Text(
                    "My Listings",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: properties.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_work_outlined,
                          size: 100,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No properties listed yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Tap + to add your first property',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      return PropertyCard(property: properties[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
  /*
  Widget CallUsScreen() {
    return SafeArea(
      top: false,
      child: Column(
        children: [


          Container(
            height: 120.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            color: const Color(0xffFF6A2A),
            child: Padding(
              padding: EdgeInsets.only(top: 25.h),
              child: Row(
                children: [
                  // Icon(Icons.menu, color: Colors.white, size: 24.sp),
                  // SizedBox(width: 12.w),
                  Text(
                    "Call Us Page",
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Text("Call Us Page", style: TextStyle(fontSize: 20.sp)),
          ),
        ],
      ),
    );
  }*/

  Widget CallUsScreen() {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          // Orange App Bar (same as others)
          Container(
            height: 120.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            color: const Color(0xffFF6A2A),
            child: Padding(
              padding: EdgeInsets.only(top: 25.h),
              child: Row(
                children: [
                  // Menu icon (अगर drawer चाहो तो uncomment)
                  // InkWell(
                  //   onTap: () => Scaffold.of(context).openDrawer(),
                  //   child: Icon(Icons.menu, color: Colors.white, size: 24.sp),
                  // ),
                  // SizedBox(width: 12.w),
                  Text(
                    "Call Us",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24.w),
              child: Column(
                children: [
                  // Big Phone Icon
                  Icon(
                    Icons.phone_in_talk,
                    size: 100.sp,
                    color: const Color(0xffFF6A2A),
                  ),
                  SizedBox(height: 20.h),

                  // Title
                  Text(
                    "We're Here to Help!",
                    style: GoogleFonts.inter(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),

                  Text(
                    "For any property inquiry, feel free to call us anytime.",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: Colors.grey.shade600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40.h),

                  // Main Inquiry Number
                  Text(
                    "+91-8899556644",
                    style: GoogleFonts.inter(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xffFF6A2A),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  Text(
                    "Available 24/7",
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SizedBox(height: 40.h),

                  // Big Call Button
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Direct call launch करने के लिए url_launcher package add करो
                        // launchUrl(Uri.parse('tel:+918899556644'));
                      },
                      icon: const Icon(
                        Icons.call,
                        size: 28,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Call Now",
                        style: GoogleFonts.inter(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFF6A2A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // WhatsApp Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        "assets/Svg/whatsapp.svg",
                        height: 40.h,
                        color: Colors.green,
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        "Chat on WhatsApp",
                        style: GoogleFonts.inter(fontSize: 16.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  // Extra Info Cards
                  Container(
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: const Color(0xffFF6A2A),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "Support Hours: 24 Hours / 7 Days",
                              style: GoogleFonts.inter(fontSize: 14.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              color: const Color(0xffFF6A2A),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              "Email: support@yourrealestate.com",
                              style: GoogleFonts.inter(fontSize: 14.sp),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget SavedScreen() {
    return SafeArea(
      top: false,
      child: Column(
        children: [
          Container(
            height: 120.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            color: const Color(0xffFF6A2A),
            child: Padding(
              padding: EdgeInsets.only(top: 25.h),
              child: Row(
                children: [
                  // Icon(Icons.menu, color: Colors.white, size: 24.sp),
                  // SizedBox(width: 12.w),
                  Text(
                    "Saved Property",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: properties.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_work_outlined,
                          size: 100,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'No properties listed yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Tap + to add your first property',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: properties.length,
                    itemBuilder: (context, index) {
                      return PropertyCard(property: properties[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // NAV ITEM
  Widget buildNavItem(IconData icon, String label, int index) {
    final isSelected = bottomIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() => bottomIndex = index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xffFF6A2A)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : const Color(0xFF838299),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: isSelected ? Colors.black : const Color(0xFF838299),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TAB
  Widget _tab(String title, int index) {
    final select = selectIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          selectIndex = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: select ? const Color(0xffFF6A2A) : Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xffFF6A2A)),
        ),
        child: Text(
          title,
          style: GoogleFonts.inter(
            color: select ? Colors.white : const Color(0xffFF6A2A),
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  // GRID ITEM
  Widget _gridItem(String icon, String title) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PropertyPageCat()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: 50.h),
            SizedBox(height: 8.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== PROPERTY MODEL ====================
class Property {
  final String propertyType;
  final String propertyCategory;
  final String listingCategory;
  final String city;
  final String locality;
  final String price;
  final String bedrooms;
  final String bathrooms;
  final String area;
  final String furnishing;
  final List<String> amenities;
  final List<Map<String, String>> aroundProject;
  final String fullName;
  final String email;
  final String phone;
  final String address;
  final String description;

  Property({
    required this.propertyType,
    required this.propertyCategory,
    required this.listingCategory,
    required this.city,
    required this.locality,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.area,
    required this.furnishing,
    required this.amenities,
    required this.aroundProject,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.address,
    required this.description,
  });
}

// ==================== PROPERTY CARD ====================
class PropertyCard extends StatelessWidget {
  final Property property;

  const PropertyCard({Key? key, required this.property}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    property.propertyType,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF5722),
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    property.listingCategory,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: const Color(0xFFFF5722),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Colors.grey, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${property.locality}, ${property.city}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '₹ ${property.price}',
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSpecItem(Icons.king_bed, '${property.bedrooms} Beds'),
                _buildSpecItem(Icons.bathtub, '${property.bathrooms} Baths'),
                _buildSpecItem(Icons.square_foot, '${property.area} sqft'),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(
                    property.furnishing,
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.grey.shade200,
                ),
                if (property.amenities.isNotEmpty)
                  Chip(
                    label: Text(
                      '${property.amenities.length} Amenities',
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.grey.shade200,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  'Listed by: ${property.fullName}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFFFF5722)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}

// ==================== MAIN STATE CLASS ====================

class HomeService extends ConsumerStatefulWidget {
  const HomeService({super.key});

  @override
  ConsumerState<HomeService> createState() => _HomeServiceState();
}

class _HomeServiceState extends ConsumerState<HomeService> {
  final List<Map<String, String>> categories = const [
    {
      'label': 'ELECTRICIAN',
      'url':
          'https://media.istockphoto.com/id/1049775258/photo/smiling-handsome-electrician-repairing-electrical-box-with-pliers-in-corridor-and-looking-at.jpg?s=612x612&w=0&k=20&c=stdWozouV2XsrHk2xXD3C31nT90BG7ydZvcpAn1Fx7I=',
    }, // Replace with actual
    {
      'label': 'CARPENTER',
      'url':
          'https://s3-media0.fl.yelpcdn.com/bphoto/y2N9GweV0RhaXx9dYbXHTA/l.jpg',
    },
    {
      'label': 'PAINTER',
      'url':
          'https://www.shutterstock.com/image-vector/worker-repair-service-plumber-handyman-260nw-2234725577.jpg',
    },
    {
      'label': 'PLUMBER',
      'url':
          'https://cdn.prod.website-files.com/5e593fb060cf877cf875dd1f/679085ac60c170e5ebba4b34_recBrwtY2JtNJji6k_image_1.webp',
    },
    {
      'label': 'CLEANING',
      'url':
          'https://www.shutterstock.com/shutterstock/videos/3684051321/thumb/4.jpg?ip=x480',
    },
    {
      'label': 'INTERIOR',
      'url':
          'https://s3-media0.fl.yelpcdn.com/bphoto/tuGs0mGEDRuE8omqeINuKQ/l.jpg',
    },
    {
      'label': 'RENOVATION',
      'url':
          'https://cdn.prod.website-files.com/5e593fb060cf877cf875dd1f/677c007c62c5db1e8a3b1317_handyman-webflow-template.png',
    },
    {
      'label': 'PEST CONTROL',
      'url':
          'https://img.freepik.com/free-photo/people-disinfecting-together-dangerous-area_23-2148848569.jpg?semt=ais_hybrid&w=740&q=80',
    },
  ];

  final List<Map<String, String>> services = const [
    {
      'icon': 'Toilet Repair',
      'title': 'Toilet Repair',
      'desc':
          'Fast, reliable toilet fixes that restore comfort and functionality.',
    },
    {
      'icon': 'Faucet Installation',
      'title': 'Faucet Installation',
      'desc': 'Expert faucet installation and repair for every style.',
    },
    {
      'icon': 'Sewer Inspection',
      'title': 'Sewer Inspection',
      'desc': 'Advanced camera inspections to prevent damage.',
    },
    {
      'icon': 'Sewer Inspection',
      'title': 'Sewer Inspection',
      'desc': 'Advanced camera inspections to prevent damage.',
    }, // Duplicate in screenshot, adjust if needed
  ];

  @override
  Widget build(BuildContext context) {
    final homeServiceProvider = ref.watch(homeServiceCategoryController);
    return homeServiceProvider.when(
      data: (service) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Categories Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.75,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              //itemCount: categories.length,
              itemCount: service.data!.list!.length,
              itemBuilder: (context, index) {
                final item = service.data!.list![index];
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        // categories[index]['url']!,
                        item.image ??
                            "https://s3-media0.fl.yelpcdn.com/bphoto/y2N9GweV0RhaXx9dYbXHTA/l.jpg",
                        width: 80.w,
                        height: 80.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      //  categories[index]['label']!,
                      item.name ?? "N/A",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                );
              },
            ),

            // We Provide Quality Services
            Center(
              child: Text(
                'What We Offer',
                style: GoogleFonts.inter(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Center(
              child: Text(
                'We Provide Quality Services',
                style: GoogleFonts.inter(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // Services Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: const [
                ServiceCard(
                  title: 'Toilet Repair',
                  desc:
                      'Fast, reliable toilet fixes that restore proper function.',
                  imageUrl:
                      'https://media.gettyimages.com/id/2192255408/vector/plumbing-line-icon-set-group-of-object-pipe-bathtub-boiler-faucet-repair.jpg?s=612x612&w=gi&k=20&c=IgKlfAmPPCWSHJy7L_KlG4bjVyB_If33cqFTI8X51Ng=',
                ),
                ServiceCard(
                  title: 'Faucet Installation',
                  desc: 'Expert faucet fitting that ensures smooth water flow.',
                  imageUrl:
                      'https://media.istockphoto.com/id/1140334314/vector/plumber-master-with-wrench-fixing-kitchen-faucet.jpg?s=612x612&w=0&k=20&c=5XTiydIT32QfXU-x8WVM6rSeWpy6TopGU66RNfPunw4=',
                ),
                ServiceCard(
                  title: 'Sewer Inspection',
                  desc: 'Advanced sewer checks to detect issues early.',
                  imageUrl:
                      'https://media.istockphoto.com/id/2194903933/vector/plumbers-and-plumbing-thin-line-icons-editable-stroke-icons-include-plumbing-pipes-leaky.jpg?s=612x612&w=0&k=20&c=V2EAWro2g_Xk72Bl9c0LJ78ylpTxzZaZcyct56nqwCc=',
                ),
                ServiceCard(
                  title: 'Drain Cleaning',
                  desc: 'Prevent damage with professional drain cleaning.',
                  imageUrl:
                      'https://media.istockphoto.com/id/1363041172/vector/water-tank-pipe-pipeline-and-sewerage-cleaning-service-by-cleaner.jpg?s=612x612&w=0&k=20&c=OPh5837hpAV13c5fsr3daJrrzFK1E4HjSEhiDdgZwN0=',
                ),
              ],
            ),

            // Why We Are / Easy Solutions
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Who We Are',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Easy Solutions For Plumbing and Home Repair Needs',
                    style: GoogleFonts.inter(fontSize: 16.sp),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Chip(
                        padding: EdgeInsets.zero,
                        label: Text(
                          'Tech Expertise',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                      Chip(
                        padding: EdgeInsets.zero,
                        label: Text(
                          'Advanced Tools',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                      Chip(
                        padding: EdgeInsets.zero,
                        label: Text(
                          'Smart Solutions',
                          style: GoogleFonts.inter(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                    ),
                    child: const Text('Hire Experts'),
                  ),
                ],
              ),
            ),

            // Plumber Image
            Image.network(
              'https://as1.ftcdn.net/jpg/05/94/89/64/1000_F_594896473_PmXb07nS8Odld7O3op4E5Vi2USzODYYc.jpg',
              fit: BoxFit.cover,
              width: double.infinity,
            ),

            // Affordable Pricing
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  Icon(Icons.price_check, size: 40, color: Colors.orange),
                  Text(
                    'Affordable Pricing',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Quality service doesn\'t have to be costly. We offer transparent, fair pricing on every job.',
                  ),
                ],
              ),
            ),

            // Featured Projects
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Featured Projects',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See Full Gallery >',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  FeaturedProject(
                    imageUrl:
                        'https://images.finehomebuilding.com/app/uploads/2016/04/09114955/021181bs116-01_xlg.jpg',
                    title: 'Drain Overhaul',
                    subtitle: 'Complete drain system upgrade',
                  ),
                  FeaturedProject(
                    imageUrl:
                        'https://www.thespruce.com/thmb/e-MxaOBy4AKp4JW1XFZGbrkDaIw=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/how-to-install-a-sink-drain-2718789_hero_5078-64538f6f90d545c7af0728e4bf8f894e.jpg',
                    title: 'Sink Installation',
                    subtitle: 'New kitchen sink setup',
                  ),
                  FeaturedProject(
                    imageUrl:
                        'https://gharpedia.com/_next/image/?url=https%3A%2F%2Fcloudfrontgharpediabucket.gharpedia.com%2Fuploads%2F2021%2F12%2FBest-Way-to-Install-a-Bathroom-Sink-Drain-01-0504130013.jpg&w=3840&q=75',
                    title: 'Drain Overhaul',
                    subtitle: 'Complete drain system upgrade',
                  ),
                ],
              ),
            ),

            // Latest Insights
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Our Latest Insights',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Image.network(
                    'https://wg.scene7.com/is/image/wrenchgroup/insulate-pipes-info-ps22wi001wg?&wid=362',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'How to Protect Your Pipes During Cold Weather',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Read More >',
                          style: TextStyle(color: Colors.orange),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        );
      },
      error: (error, stackTrace) {
        log(stackTrace.toString());
        return Center(child: Text(error.toString()));
      },
      loading: () {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: 6, // shimmer items
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.80,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Image placeholder
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    /// Text placeholder
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 75.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20.h),
            Center(
              child: Column(
                children: [
                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 100.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ),

                  SizedBox(height: 10.h),

                  Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Container(
                      width: 200.w,
                      height: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: 4, // shimmer items
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.80,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Image placeholder
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 200.w,
                        height: 100.h,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),

                    SizedBox(height: 8.h),

                    /// Text placeholder
                    Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 75.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String desc;
  final String imageUrl;

  const ServiceCard({
    super.key,
    required this.title,
    required this.desc,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ICON / IMAGE
          SizedBox(
            height: 60,
            child: Image.network(imageUrl, fit: BoxFit.contain),
          ),
          const SizedBox(height: 14),

          // TITLE
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),

          const SizedBox(height: 6),

          // DESCRIPTION
          Text(
            desc,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

class FeaturedProject extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const FeaturedProject({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(color: Colors.black54),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  child: Text(title),
                ),
                Text(subtitle, style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LoanService extends StatelessWidget {
  const LoanService({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              image: const DecorationImage(
                image: AssetImage("assets/image 15.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(height: 20.h),

          /// 🔹 Title
          Text(
            "Top Home Loan Bank Partners",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 16.h),

          /// 🔹 Loan Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: loanList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12.w,
              mainAxisSpacing: 12.h,
              childAspectRatio: 0.80,
            ),
            itemBuilder: (context, index) {
              return Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(loanList[index].icon, size: 36.sp, color: Colors.blue),
                    SizedBox(height: 6.h),
                    Text(
                      loanList[index].title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Spacer(),
                    Container(
                      height: 28.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF6725),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Center(
                        child: Text(
                          "Call Now",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          SizedBox(height: 24.h),

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
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
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
          _bankOfferCard(),
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
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
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
                      DropdownMenuItem(value: "value", child: Text("30 yrs")),
                    ],
                    onChanged: (v) {},
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
  Widget _bankOfferCard() {
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
                "Bank of Baroda",
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
              _offerText("8.4%", "Interest"),
              _offerText("₹50L", "Loan Amount"),
              _offerText("30 Yr", "Tenure"),
              _offerText("₹38.4K", "Monthly EMI"),
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
                "₹14,000 Cash Reward",
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

/// 🔹 Model
class LoanModel {
  final String title;
  final IconData icon;

  LoanModel({required this.title, required this.icon});
}

/// 🔹 Data
final List<LoanModel> loanList = [
  LoanModel(title: "Home Loan", icon: Icons.home),
  LoanModel(title: "Car Loan", icon: Icons.directions_car),
  LoanModel(title: "Two-Wheeler Loan", icon: Icons.motorcycle),
  LoanModel(title: "Indian Bank", icon: Icons.account_balance),
  LoanModel(title: "Education Loan", icon: Icons.school),
  LoanModel(title: "Gold Loan", icon: Icons.currency_exchange),
  LoanModel(title: "Property Loan", icon: Icons.apartment),
  LoanModel(title: "Personal Loan", icon: Icons.person),
];

/// 🔹 Models
class WorkModel {
  final String title;
  final String desc;
  final IconData icon;

  WorkModel({required this.title, required this.desc, required this.icon});
}

/// 🔹 Data
final List<WorkModel> workSteps = [
  WorkModel(
    title: "Fill Online Form",
    desc: "Fill an online form to view the best offers.",
    icon: Icons.edit_document,
  ),
  WorkModel(
    title: "Expert Assistance",
    desc: "Our executive helps you choose best offer.",
    icon: Icons.support_agent,
  ),
  WorkModel(
    title: "Submit Documents",
    desc: "Pick up documents at your doorstep.",
    icon: Icons.file_copy,
  ),
  WorkModel(
    title: "Bank Approval",
    desc: "Bank reviews your application & confirms.",
    icon: Icons.verified,
  ),
];

/// 🔹 Models & Data
class InfoModel {
  final String title;
  final String desc;
  final String image;

  InfoModel(this.title, this.desc, this.image);
}

final List<InfoModel> topCards = [
  InfoModel(
    "Personalized Deals",
    "Discover home loan offers for your needs",
    "assets/Rectangle 113 (1).png",
  ),
  InfoModel(
    "Government Employees",
    "Special schemes for government staff",
    "assets/Rectangle 113 (2).png",
  ),

  InfoModel(
    "Self Employed",
    "Quick approval for self employed",
    "assets/Rectangle 113.png",
  ),

  InfoModel(
    "Cash Income",
    "Low documentation for cash income",
    "assets/Rectangle 113 (3).png",
  ),
];
