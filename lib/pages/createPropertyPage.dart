import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:realstate/Model/Body/CreatePropertyBodyModel.dart';
import 'package:flutter/cupertino.dart';
import '../Controller/getCityListController.dart';
import '../Model/CityResponseModel.dart';
import '../core/network/api.state.dart';
import '../core/utils/preety.dio.dart';

class CreatePropertyScreen extends ConsumerStatefulWidget {
  const CreatePropertyScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CreatePropertyScreen> createState() =>
      _CreatePropertyScreenState();
}

class _CreatePropertyScreenState extends ConsumerState<CreatePropertyScreen> {
  // Dropdown Values
  String? selectedPropertyType;
  String? selectedListingCategory;
  String? selectedFurnishing;
  // String? selectedPropertyType;        // residential / commercial
  String? selectedPropertySubType; // ← नया: apartment, villa, office आदि
  // City & Locality (Dynamic from API)
  String? selectedCity;
  String? selectedLocality;

  // Amenities
  final List<String> allAmenities = [
    "Swimming Pool",
    "Gym",
    "Fitness Center",
    "Yoga Studio",
    "Sauna",
    "Spa",
    "Parking",
    "Covered Parking",
    "EV Charging Station",
    "Lift/Elevator",
    "Power Backup",
    "Security",
    "24/7 Security",
    "Controlled Access/Gated",
    "CCTV Surveillance",
    "Garden",
    "Landscaped Gardens",
    "BBQ/Picnic Area",
    "Playground",
    "Children's Play Area",
    "Clubhouse",
    "Community Hall",
    "Business Center",
    "Conference Room",
    "Library",
    "Theater Room",
    "Game Room",
    "Tennis Court",
    "Basketball Court",
    "Jogging Track",
    "Laundry Room",
    "In-Unit Laundry",
    "High-Speed Internet",
    "Wi-Fi Included",
    "On-Site Maintenance",
    "Package Lockers",
    "Bike Storage",
    "Storage Units",
    "Roof Deck/Terrace",
    "Concierge Service",
    "Pet-Friendly (Dog Park)",
    "Non-Smoking Building",
    "Wheelchair Accessible",
    "Air Conditioning",
    "Central Heating",
    "Balcony/Patio",
    "Walk-in Closet",
    "Dishwasher",
    "Microwave",
    "Stainless Steel Appliances",
    "Garbage Disposal",
  ];
  List<String> selectedAmenities = [];
  // Around Project Dynamic Rows
  List<Map<String, TextEditingController>> aroundProjectList = [];
  // Property Images
  List<File> propertyImages = [];
  final ImagePicker _picker = ImagePicker();
  // Text Controllers
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _bedroomsController = TextEditingController();
  final TextEditingController _bathroomsController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _permitNoController = TextEditingController();
  final TextEditingController _reraController = TextEditingController();
  final TextEditingController _dedController = TextEditingController();
  final TextEditingController _brnController = TextEditingController();
  final TextEditingController _projectAreaController = TextEditingController();
  final TextEditingController _unitSizesController = TextEditingController();
  final TextEditingController _projectSizeController = TextEditingController();
  final TextEditingController _launchDateController = TextEditingController();
  final TextEditingController _avgPriceController = TextEditingController();

  final TextEditingController _possessionDateController =
      TextEditingController();
  // final TextEditingController _fullNameController = TextEditingController();
  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _propertyAddressController =
      TextEditingController();

  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();
    addAroundProjectRow();
  }

  void addAroundProjectRow() {
    setState(() {
      aroundProjectList.add({
        'place': TextEditingController(),
        'details': TextEditingController(),
      });
    });
  }

  void removeAroundProjectRow(int index) {
    if (aroundProjectList.length > 1) {
      setState(() {
        aroundProjectList[index]['place']?.dispose();
        aroundProjectList[index]['details']?.dispose();
        aroundProjectList.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('At least 1 nearby place is required!'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    _areaController.dispose();
    _permitNoController.dispose();
    _reraController.dispose();
    _dedController.dispose();
    _brnController.dispose();
    _projectAreaController.dispose();
    _unitSizesController.dispose();
    _projectSizeController.dispose();
    _launchDateController.dispose();
    _avgPriceController.dispose();
    _possessionDateController.dispose();
    // _fullNameController.dispose();
    // _emailController.dispose();
    // _phoneController.dispose();
    _propertyAddressController.dispose();
    _descriptionController.dispose();
    for (var ctrl in aroundProjectList) {
      ctrl['place']?.dispose();
      ctrl['details']?.dispose();
    }
    super.dispose();
  }

  // Image Picker
  Future<void> pickImages() async {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CupertinoActionSheet(
        title: const Text('Add Property Photos'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              final picked = await _picker.pickMultiImage(imageQuality: 70);
              if (picked != null && picked.isNotEmpty) {
                setState(() {
                  propertyImages.addAll(picked.map((x) => File(x.path)));
                });
              }
            },
            child: const Text('Gallery (Multiple)'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context);
              final file = await _picker.pickImage(
                source: ImageSource.camera,
                imageQuality: 70,
              );
              if (file != null) {
                setState(() {
                  propertyImages.add(File(file.path));
                });
              }
            },
            child: const Text('Camera'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  void removeImage(int index) {
    setState(() {
      propertyImages.removeAt(index);
    });
  }
  // Create Property API Call

  // Future<void> createPropertyApi() async {
  //   if (_isLoading) return;
  //
  //   setState(() => _isLoading = true);
  //
  //   List<String> uploadedImageUrls = [];
  //
  //   try {
  //     final service = APIStateNetwork(createDio());
  //     // Upload Multiple Images
  //     if (propertyImages.isNotEmpty) {
  //       final uploadResponse = await service.uploadImageMultiple(propertyImages);
  //       if (uploadResponse.error == false && uploadResponse.data != null && uploadResponse.data!.isNotEmpty) {
  //         uploadedImageUrls = uploadResponse.data!
  //             .map((item) => item.imageUrl ?? "")
  //             .where((url) => url.isNotEmpty)
  //             .toList();
  //
  //         Fluttertoast.showToast(msg: "${uploadedImageUrls.length} photos uploaded!");
  //       } else {
  //         Fluttertoast.showToast(msg: "Image upload failed.");
  //         setState(() => _isLoading = false);
  //         return;
  //       }
  //     }
  //
  //     // Around Project Data
  //     List<AroundProject> aroundProjectData = aroundProjectList.map((e) {
  //       return AroundProject(
  //         name: e['place']!.text.trim(),
  //         details: e['details']!.text.trim(),
  //       );
  //     }).where((item) => item.name?.isNotEmpty == true).toList();
  //
  //     // Final Body
  //     final body = CreatePropertyBodyModel(
  //       localityArea: selectedLocality,
  //
  //       property: selectedPropertyType,
  //       propertyType: selectedPropertySubType,
  //       listingCategory: selectedListingCategory,
  //       // location: selectedLocality ?? "",        // ← Selected Locality
  //       city: selectedCity ?? "",                // ← Selected City
  //       price: _priceController.text.trim(),
  //       area: _areaController.text.trim(),
  //       bedRoom: _bedroomsController.text.trim(),
  //       amenities: selectedAmenities,
  //       aroundProject: aroundProjectData,
  //       permitNo: _permitNoController.text.trim(),
  //       rera: _reraController.text.trim(),
  //       ded: _dedController.text.trim(),
  //       brn: _brnController.text.trim(),
  //       bathrooms: _bathroomsController.text.trim(),
  //       furnishing: selectedFurnishing,
  //       description: _descriptionController.text.trim(),
  //       aveneuOverView: AveneuOverView(
  //         projectArea: _projectAreaController.text.trim(),
  //         size: _unitSizesController.text.trim(),
  //         projectSize: _projectSizeController.text.trim(),
  //         launchDate: _launchDateController.text.trim(),
  //         // avgPrice: _avgPriceController.text.trim(),
  //         possessionStart: _possessionDateController.text.trim(),
  //       ),
  //       fullName: _fullNameController.text.trim(),
  //       email: _emailController.text.trim(),
  //       phone: _phoneController.text.trim(),
  //       propertyAddress: _propertyAddressController.text.trim(),
  //       // language: "en",
  //       uploadedPhotos: uploadedImageUrls,
  //     );
  //
  //     final response = await service.createProperty(body);
  //
  //     if (response.code == 0 && response.error == false) {
  //       Fluttertoast.showToast(msg: response.message ?? "Property created successfully!");
  //       if (mounted) Navigator.pop(context);
  //     } else {
  //       Fluttertoast.showToast(msg: response.message ?? "Failed to create property.");
  //     }
  //   } catch (e, s) {
  //     log("Error: $e\n$s");
  //     Fluttertoast.showToast(msg: "Something went wrong.");
  //   } finally {
  //     if (mounted) setState(() => _isLoading = false);
  //   }
  // }

  // Create Property API Call - Updated Part
  Future<void> createPropertyApi() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    List<String> uploadedImageUrls = [];

    try {
      final service = APIStateNetwork(createDio());

      // Upload Images
      if (propertyImages.isNotEmpty) {
        final uploadResponse = await service.uploadImageMultiple(
          propertyImages,
        );
        if (uploadResponse.error == false &&
            uploadResponse.data != null &&
            uploadResponse.data!.isNotEmpty) {
          uploadedImageUrls = uploadResponse.data!
              .map((item) => item.imageUrl ?? "")
              .where((url) => url.isNotEmpty)
              .toList();

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${uploadedImageUrls.length} photos uploaded successfully!",
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Image upload failed."),
              backgroundColor: Colors.red,
            ),
          );
          setState(() => _isLoading = false);
          return;
        }
      }

      // Around Project
      List<AroundProject> aroundProjectData = aroundProjectList
          .map((e) {
            return AroundProject(
              name: e['place']!.text.trim(),
              details: e['details']!.text.trim(),
            );
          })
          .where((item) => item.name?.isNotEmpty == true)
          .toList();

      // Final Body
      final body = CreatePropertyBodyModel(
        localityArea: selectedLocality,
        property: selectedPropertyType, // residential / commercial
        propertyType: selectedPropertySubType, // apartment, villa, office etc.
        listingCategory: selectedListingCategory,
        city: selectedCity ?? "",
        price: _priceController.text.trim(),
        area: _areaController.text.trim(),
        bedRoom: _bedroomsController.text.trim(),
        bathrooms: _bathroomsController.text.trim(),
        furnishing: selectedFurnishing,
        amenities: selectedAmenities,
        aroundProject: aroundProjectData,
        permitNo: _permitNoController.text.trim(),
        rera: _reraController.text.trim(),
        ded: _dedController.text.trim(),
        brn: _brnController.text.trim(),
        description: _descriptionController.text.trim(),
        aveneuOverView: AveneuOverView(
          projectArea: _projectAreaController.text.trim(),
          size: _unitSizesController.text.trim(),
          projectSize: _projectSizeController.text.trim(),
          launchDate: _launchDateController.text.trim(),
          // avgPrice: _avgPriceController.text.trim(),        // ← वापस add किया
          possessionStart: _possessionDateController.text.trim(),
        ),
        // fullName: _fullNameController.text.trim(),
        // email: _emailController.text.trim(),
        // phone: _phoneController.text.trim(),
        propertyAddress: _propertyAddressController.text.trim(),
        uploadedPhotos: uploadedImageUrls,
      );

      final response = await service.createProperty(body);

      // Success / Error Message from API
      if (response.code == 0 && response.error == false) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Property created successfully!"),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );
        if (mounted) Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message ?? "Failed to create property."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e, s) {
      log("Create Property Error: $e\n$s");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cityAsync = ref.watch(getCityController);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Create Property Listing',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // BASIC INFO के बाद...
            const Text(
              'BASIC INFO',
              style: TextStyle(
                color: Color(0xFFFF5722),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // BASIC INFO के बाद...
            _buildDropdown(
              label: 'Property',
              value: selectedPropertyType,
              items: ["residential", "commercial"],
              onChanged: (v) => setState(() => selectedPropertyType = v),
            ),

            SizedBox(height: 16),

            _buildDropdown(
              label: 'Property Type',
              value: selectedPropertySubType, // नया variable add करना पड़ेगा
              items: selectedPropertyType == "residential"
                  ? [
                      "apartment",
                      "townhouse",
                      "villa-compound",
                      "land",
                      "building",
                      "villa",
                      "penthouse",
                      "hotel-apartment",
                      "floor",
                      "studio",
                    ]
                  : [
                      "office",
                      "warehouse",
                      "industrial-land",
                      "showroom",
                      "shop",
                      "labour-camp",
                      "bulk-unit",
                      "factory",
                      "mixed-use-land",
                      "other-commercial",
                      "floor",
                      "building",
                      "villa",
                    ],
              onChanged: (v) => setState(() => selectedPropertySubType = v),
            ),

            const SizedBox(height: 16),

            _buildDropdown(
              label: 'Listing Category',
              value: selectedListingCategory,
              items: ['rent', 'sell'],
              onChanged: (v) => setState(() => selectedListingCategory = v),
            ),

            const SizedBox(height: 16),

            // City Dropdown - From API
            cityAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Text(
                'Failed to load cities',
                style: TextStyle(color: Colors.red),
              ),
              data: (cityResponse) {
                final cities = cityResponse.data ?? [];
                final cityNames = cities.map((e) => e.cityName ?? "").toList();

                return _buildDropdown(
                  label: 'City',
                  value: selectedCity,
                  items: cityNames,
                  onChanged: (value) {
                    setState(() {
                      selectedCity = value;
                      selectedLocality = null; // Reset locality on city change
                    });
                  },
                );
              },
            ),

            const SizedBox(height: 16),

            // Locality Dropdown - Based on selected city
            if (selectedCity != null)
              cityAsync.when(
                data: (cityResponse) {
                  final selectedCityObj = cityResponse.data?.firstWhere(
                    (city) => city.cityName == selectedCity,
                    orElse: () => Datum(),
                  );
                  final areas = selectedCityObj?.areas ?? [];

                  return _buildDropdown(
                    label: 'Locality / Area',
                    value: selectedLocality,
                    items: areas,
                    onChanged: (v) => setState(() => selectedLocality = v),
                  );
                },
                loading: () => const SizedBox(),
                error: (_, __) => const SizedBox(),
              ),

            const SizedBox(height: 16),
            _buildTextField('Price', controller: _priceController),
            const SizedBox(height: 16),
            _buildTextField('Bedrooms', controller: _bedroomsController),
            const SizedBox(height: 16),
            _buildTextField('Bathrooms', controller: _bathroomsController),
            const SizedBox(height: 16),
            _buildTextField('Area (sqft)', controller: _areaController),
            const SizedBox(height: 16),
            _buildDropdown(
              label: 'Furnishing',
              value: selectedFurnishing,
              items: ["furnished", "semi-furnished", "unfurnished"],
              onChanged: (v) => setState(() => selectedFurnishing = v),
            ),

            const SizedBox(height: 32),
            const Text(
              'Legal Information',
              style: TextStyle(
                color: Color(0xFFFF5722),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('Permit No', controller: _permitNoController),
            const SizedBox(height: 16),
            _buildTextField(
              'RERA Registration No',
              controller: _reraController,
            ),
            const SizedBox(height: 16),
            _buildTextField('DED', controller: _dedController),
            const SizedBox(height: 16),
            _buildTextField('BRN', controller: _brnController),
            const SizedBox(height: 32),
            const Text(
              'Project Overview',
              style: TextStyle(
                color: Color(0xFFFF5722),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Project Area (Acre)',
              controller: _projectAreaController,
              hint: 'e.g. 0.89 Acres',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Unit Sizes (sq.ft)',
              controller: _unitSizesController,
              hint: 'e.g. 431 - 460 sq.ft.',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Project Size',
              controller: _projectSizeController,
              hint: 'e.g. 1 Building - 258 Units',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Project launch month & year',
              controller: _launchDateController,
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Avg Price',
              controller: _avgPriceController,
              suffix: '₹ / sq.ft',
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Expected possession start date',
              controller: _possessionDateController,
            ),
            const SizedBox(height: 32),
            const Text(
              'Amenities',
              style: TextStyle(
                color: Color(0xFFFF5722),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildMultiSelectAmenities(),
            const SizedBox(height: 32),
            const Text(
              'Around Project',
              style: TextStyle(
                color: Color(0xFFFF5722),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ...aroundProjectList.asMap().entries.map((entry) {
              int idx = entry.key;
              var ctrl = entry.value;
              bool isOnly = aroundProjectList.length == 1;
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        _buildTextField(
                          'Place Name',
                          controller: ctrl['place'],
                        ),
                        const SizedBox(height: 16),
                        _buildTextField('Details', controller: ctrl['details']),
                      ],
                    ),
                    if (!isOnly)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(
                            Icons.remove_circle,
                            color: Colors.red,
                            size: 30,
                          ),
                          onPressed: () => removeAroundProjectRow(idx),
                        ),
                      ),
                  ],
                ),
              );
            }).toList(),

            ElevatedButton.icon(
              onPressed: addAroundProjectRow,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text('Add More'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5722),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
            ),

            const SizedBox(height: 32),
            const Text(
              'Property Photos',
              style: TextStyle(
                color: Color(0xFFFF5722),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: pickImages,
              icon: const Icon(Icons.add_photo_alternate, color: Colors.white),
              label: const Text('Add Photos'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5722),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
              ),
            ),

            const SizedBox(height: 16),
            propertyImages.isEmpty
                ? const Text(
                    'No photos selected',
                    style: TextStyle(color: Colors.grey),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1,
                        ),
                    itemCount: propertyImages.length,
                    itemBuilder: (_, i) => Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            propertyImages[i],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: () => removeImage(i),
                            child: const CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

            SizedBox(height: 25.h),

            // const SizedBox(height: 16),
            // _buildTextField('Full Name', controller: _fullNameController),
            // const SizedBox(height: 16),
            // _buildTextField('Email', controller: _emailController),
            // const SizedBox(height: 16),
            // _buildTextField('Phone', controller: _phoneController),
            const Text(
              'Contact Information',
              style: TextStyle(
                color: Color(0xFFFF5722),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField('Full Name', controller: _fullNameController),
            const SizedBox(height: 16),
            _buildTextField('Email', controller: _emailController),
            const SizedBox(height: 16),
            _buildTextField('Phone', controller: _phoneController),

            const SizedBox(height: 32),
            const Text(
              'Property Address',
              style: TextStyle(
                color: Color(0xFFFF5722),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Property Address',
              controller: _propertyAddressController,
              maxLines: 4,
            ),

            const SizedBox(height: 32),
            const Text(
              'Description',
              style: TextStyle(
                color: Color(0xFFFF5722),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              'Description',
              controller: _descriptionController,
              maxLines: 6,
            ),

            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isLoading ? null : createPropertyApi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF5722),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Submit Property',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // Helper Widgets
  Widget _buildTextField(
    String label, {
    String? hint,
    String? suffix,
    int maxLines = 1,
    TextEditingController? controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            suffixText: suffix,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFFF5722), width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              hint: Text(
                'Select $label',
                style: const TextStyle(color: Colors.grey),
              ),
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelectAmenities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Amenities',
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allAmenities.map((amenity) {
            final selected = selectedAmenities.contains(amenity);
            return FilterChip(
              label: Text(amenity),
              selected: selected,
              selectedColor: const Color(0xFFFF5722).withOpacity(0.2),
              checkmarkColor: const Color(0xFFFF5722),
              onSelected: (bool sel) {
                setState(() {
                  if (sel) {
                    selectedAmenities.add(amenity);
                  } else {
                    selectedAmenities.remove(amenity);
                  }
                });
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
