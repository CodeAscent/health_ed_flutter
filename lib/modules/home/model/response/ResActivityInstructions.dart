class ResActivityInstructions {
  bool? success;
  String? message;
  Data? data;

  ResActivityInstructions({this.success, this.message, this.data});

  ResActivityInstructions.fromJson(Map<String, dynamic> json) {
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
  Instructions? instructions;

  Data({this.instructions});

  Data.fromJson(Map<String, dynamic> json) {
    instructions = json['instructions'] != null
        ? new Instructions.fromJson(json['instructions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.instructions != null) {
      data['instructions'] = this.instructions!.toJson();
    }
    return data;
  }
}

class Instructions {
  String? en;
  String? hi;
  String? or;

  Instructions({this.en, this.hi, this.or});

  Instructions.fromJson(Map<String, dynamic> json) {
    en = json['en'];
    hi = json['hi'];
    or = json['or'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en'] = this.en;
    data['hi'] = this.hi;
    data['or'] = this.or;
    return data;
  }
}