import 'package:flutter/material.dart';

class BuildStarsRating {
  static List<Widget> buildStarRating(double rating, double size) {
    List<Widget> stars = [];
    const int maxStars = 5;

    double roundedRating = double.parse(rating.toStringAsFixed(1));
    int fullStars = roundedRating.floor();
    bool hasHalfStar = (roundedRating - fullStars) >= 0.5;

    for (int i = 0; i < fullStars; i++) {
      stars.add(Icon(Icons.star, color: Colors.amber, size: size));
    }

    if (hasHalfStar && fullStars < maxStars) {
      stars.add(Icon(Icons.star_half, color: Colors.amber, size: size));
    }

    while (stars.length < maxStars) {
      stars.add(Icon(Icons.star_border, color: Colors.amber, size: size));
    }
    return stars;
  }
}
