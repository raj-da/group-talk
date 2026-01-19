import 'package:flutter/material.dart';

Widget searchBar() {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: const TextField(
      decoration: InputDecoration(
        icon: Icon(Icons.search, color: Colors.grey),
        hintText: "Search rooms...",
        border: InputBorder.none, // Removes the default underline
      ),
    ),
  );
}
