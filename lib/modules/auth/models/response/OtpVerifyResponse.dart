class OtpVerifyResponse {
  bool? success;
  String? message;
  Data? data;

  OtpVerifyResponse({this.success, this.message, this.data});

  OtpVerifyResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  User? user;
  int? currentStep;
  String? token;

  Data({this.user, this.currentStep, this.token});

  Data.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    currentStep = json['currentStep'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['currentStep'] = this.currentStep;
    data['token'] = this.token;
    return data;
  }
}

class User {
  String? sId;
  String? mobile;
  String? currentLevel;
  bool? isActive;
  String? preferredLanguage;
  int? step;
  Null otp;
  Null otpExpired;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? currentCityDistrict;
  String? currentState;
  String? dateOfBirth;
  String? email;
  String? familyType;
  String? fatherOccupation;
  String? fullName;
  String? gender;
  bool? isChildTakingSpeechTherapy;
  String? languageSpokenAtHome;
  String? languageSpokenByChild;
  String? medium;
  int? noOfSiblings;
  String? userName;
  int? onboardingScore;

  User(
      {this.sId,
      this.mobile,
      this.currentLevel,
      this.isActive,
      this.preferredLanguage,
      this.step,
      this.otp,
      this.otpExpired,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.currentCityDistrict,
      this.currentState,
      this.dateOfBirth,
      this.email,
      this.familyType,
      this.fatherOccupation,
      this.fullName,
      this.gender,
      this.isChildTakingSpeechTherapy,
      this.languageSpokenAtHome,
      this.languageSpokenByChild,
      this.medium,
      this.noOfSiblings,
      this.userName,
      this.onboardingScore});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    mobile = json['mobile'];
    currentLevel = json['currentLevel'];
    isActive = json['isActive'];
    preferredLanguage = json['preferredLanguage'];
    step = json['step'];
    otp = json['otp'];
    otpExpired = json['otpExpired'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    currentCityDistrict = json['currentCityDistrict'];
    currentState = json['currentState'];
    dateOfBirth = json['dateOfBirth'];
    email = json['email'];
    familyType = json['familyType'];
    fatherOccupation = json['fatherOccupation'];
    fullName = json['fullName'];
    gender = json['gender'];
    isChildTakingSpeechTherapy = json['isChildTakingSpeechTherapy'];
    languageSpokenAtHome = json['languageSpokenAtHome'];
    languageSpokenByChild = json['languageSpokenByChild'];
    medium = json['medium'];
    noOfSiblings = json['noOfSiblings'];
    userName = json['userName'];
    onboardingScore = json['onboardingScore'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['mobile'] = this.mobile;
    data['currentLevel'] = this.currentLevel;
    data['isActive'] = this.isActive;
    data['preferredLanguage'] = this.preferredLanguage;
    data['step'] = this.step;
    data['otp'] = this.otp;
    data['otpExpired'] = this.otpExpired;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['currentCityDistrict'] = this.currentCityDistrict;
    data['currentState'] = this.currentState;
    data['dateOfBirth'] = this.dateOfBirth;
    data['email'] = this.email;
    data['familyType'] = this.familyType;
    data['fatherOccupation'] = this.fatherOccupation;
    data['fullName'] = this.fullName;
    data['gender'] = this.gender;
    data['isChildTakingSpeechTherapy'] = this.isChildTakingSpeechTherapy;
    data['languageSpokenAtHome'] = this.languageSpokenAtHome;
    data['languageSpokenByChild'] = this.languageSpokenByChild;
    data['medium'] = this.medium;
    data['noOfSiblings'] = this.noOfSiblings;
    data['userName'] = this.userName;
    data['onboardingScore'] = this.onboardingScore;
    return data;
  }
}
