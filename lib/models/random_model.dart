import 'package:json_annotation/json_annotation.dart';
part 'random_model.g.dart';

@JsonSerializable()
class RandomModel {
  String? message;
  Word? word;

  RandomModel({
    this.message,
    this.word,
  });

  factory RandomModel.fromJson(Map<String, dynamic> json) =>
      _$RandomModelFromJson(json);

  Map<String, dynamic> toJson() => _$RandomModelToJson(this);
}

@JsonSerializable()
class Word {
  String? id;
  String? word;
  String? meaning;
  String? pronunciation;
  String? example;
  String? level;

  Word({
    this.id,
    this.word,
    this.meaning,
    this.pronunciation,
    this.example,
    this.level,
  });

  factory Word.fromJson(Map<String, dynamic> json) => _$WordFromJson(json);

  Map<String, dynamic> toJson() => _$WordToJson(this);
}
