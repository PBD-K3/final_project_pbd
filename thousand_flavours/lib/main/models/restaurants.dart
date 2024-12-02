import 'dart:convert';

Restaurants restaurantsFromJson(String str) => Restaurants.fromJson(json.decode(str));

String restaurantsToJson(Restaurants data) => json.encode(data.toJson());

class Restaurants {
    String model;
    String pk;
    Fields fields;

    Restaurants({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Restaurants.fromJson(Map<String, dynamic> json) => Restaurants(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String name;
    String island;
    String cuisine;
    String contacts;
    String gmaps;
    String image;

    Fields({
        required this.name,
        required this.island,
        required this.cuisine,
        required this.contacts,
        required this.gmaps,
        required this.image,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        name: json["name"],
        island: json["island"],
        cuisine: json["cuisine"],
        contacts: json["contacts"],
        gmaps: json["gmaps"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "island": island,
        "cuisine": cuisine,
        "contacts": contacts,
        "gmaps": gmaps,
        "image": image,
    };
}
