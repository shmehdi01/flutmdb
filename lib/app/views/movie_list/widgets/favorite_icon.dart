import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget favoriteIcon(bool isFavorite) {
  return Icon(
    isFavorite ? Icons.favorite : Icons.favorite_outline,
    color: isFavorite ? Colors.red : Colors.grey,
  );
}
