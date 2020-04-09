abstract class BaseDto{
  BaseDto fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
}
