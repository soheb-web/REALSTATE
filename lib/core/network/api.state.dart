import 'dart:io';
import 'package:dio/dio.dart';
import 'package:realstate/Model/Body/CreatePropertyBodyModel.dart';
import 'package:realstate/Model/Body/userResister.dart';
import 'package:realstate/Model/contactUsBodyModel.dart';
import 'package:realstate/Model/contactUsResModel.dart';
import 'package:realstate/Model/editProfileBodyModel.dart';
import 'package:realstate/Model/editProfileResModel.dart';
import 'package:realstate/Model/getMyPropertyBodyModel.dart';
import 'package:realstate/Model/getMyPropertyDetailsResModel.dart';
import 'package:realstate/Model/getMyPropertyResModel.dart';
import 'package:realstate/Model/homeGetServiceCateogryModel.dart';
import 'package:realstate/Model/loanQueryBodyModel.dart';
import 'package:realstate/Model/loanQueryResModel.dart';
import 'package:realstate/Model/loanServiceResModel.dart';
import 'package:realstate/Model/loginWithPhoneBodyModel.dart';
import 'package:realstate/Model/registerResModel.dart';
import 'package:realstate/Model/uploadImageBodyModel.dart';
import 'package:realstate/Model/uploadImageResModel.dart';
import 'package:realstate/Model/userProfileResModel.dart';
import 'package:realstate/Model/verifyBodyModel.dart';
import 'package:realstate/Model/verifyResModel.dart';
import 'package:retrofit/retrofit.dart';

import '../../Model/Body/PropertyListBodyModel.dart';
import '../../Model/CityResponseModel.dart';
import '../../Model/CreatePropertyResponseModel.dart';
import '../../Model/MultipleImgaeResponseModel.dart';
import '../../Model/getPropertyResponsemodel.dart';

part 'api.state.g.dart'; // File name ke hisab se .g.dart

@RestApi(baseUrl: 'https://api.propertyleinnovation.com/api/v1')
// @RestApi(baseUrl: 'http://192.168.1.22:9999/api/v1')
abstract class APIStateNetwork {

  factory APIStateNetwork(Dio dio, {String baseUrl}) = _APIStateNetwork;

  @POST('/user/userRegister')
  Future<RegisterResModel> userRegister(@Body() UserResisterBodyModel body);

  @POST("/user/verifyOtp")
  Future<VerifyResModel> verifyUser(@Body() VerifyBodyModel body);

  @POST("/user/userLogin")
  Future<VerifyResModel> loginUser(@Body() LoginWithPhoneBodyModel body);

  @POST("/user/userProfile")
  Future<UserProfileResModel> userProfile();

  @MultiPart()
  @POST("/uploadImage")
  Future<UploadImageResModel> uploadImage(@Part(name: "file") File file);

  @MultiPart()
  @POST("/uploadMultipleImages")
  Future<MultipleImageUploadResponse> uploadImageMultiple(
    @Part(name: "file") List<File> file,
  );

  @POST("/user/userUpdate")
  Future<EditProfileResModel> editProfile(@Body() EditProfileBodyModel body);

  @POST("/user/getServiceCategory")
  Future<HomeGetServiceCategoryModel> homeServiceCategory();

  @POST("/user/getCityList")
  Future<CityResponseModel> getCityList();

  @POST('/user/sell-property')
  Future<CreatePropertyResponseModel> createProperty(
    @Body() CreatePropertyBodyModel body,
  );

  @POST("/user/getLoanList")
  Future<LoanServiceResModel> fetchAllLoanService(
    @Body() LoanServiceBodyModel body,
  );

  @POST("/user/get-list")
  Future<PropertyGetReponseModel> getListProperty(@Body() PropertyListBodyModel body);


  @POST("/user/loanQuery")
  Future<LoanQueryResModel> loanQuery(@Body() LoanQueryBodyModel body);

  @POST("/user/contact-us")
  Future<ContactUsResModel> contactUs(@Body() ContactUsBodyModel body);

  @POST("/user/getMyProperty")
  Future<GetMyPropertyResModel> getMyProperty();

  @POST("/user/get-property-by-id")
  Future<GetMyPropertyDetailsResModel> getMyPropertyDetails(
    @Body() GetMyPropertyDetailsBodyModel body,
  );
}
