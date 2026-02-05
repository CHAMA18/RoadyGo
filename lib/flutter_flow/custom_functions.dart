import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';

int calculatePrice(
  LatLng pickup,
  LatLng destination,
  double costPerRide,
  double costPerKilometer,
  double costPerMinute,
) {
  // how do I calculate the distance between two points using longitude and latitudes
  final double earthRadius = 6371.0; // in kilometers

  final double lat1 = pickup.latitude * 3.141592653589793 / 180.0;
  final double lon1 = pickup.longitude * 3.141592653589793 / 180.0;
  final double lat2 = destination.latitude * 3.141592653589793 / 180.0;
  final double lon2 = destination.longitude * 3.141592653589793 / 180.0;

  final double dLat = lat2 - lat1;
  final double dLon = lon2 - lon1;

  final double a = math.pow(math.sin(dLat / 2), 2) +
      math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
  final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  final double distance = earthRadius * c;

  double time = distance / 60;

  // Convert time to minutes
  double duration = time * 60;

  double calculatedPrice =
      costPerRide + (costPerKilometer * distance) + (costPerMinute * duration);

  int price = calculatedPrice.toInt();
  if (calculatedPrice > price) {
    price += 1;
  }

  return price;
}

double? calculateDistance(
  LatLng pickup,
  LatLng destination,
) {
  final double earthRadius = 6371.0; // in kilometers

  final double lat1 = pickup.latitude * 3.141592653589793 / 180.0;
  final double lon1 = pickup.longitude * 3.141592653589793 / 180.0;
  final double lat2 = destination.latitude * 3.141592653589793 / 180.0;
  final double lon2 = destination.longitude * 3.141592653589793 / 180.0;

  final double dLat = lat2 - lat1;
  final double dLon = lon2 - lon1;

  final double a = math.pow(math.sin(dLat / 2), 2) +
      math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
  final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  final double distance = earthRadius * c;

  return (distance * 10).roundToDouble() / 10;
}

double? calculateDuration(
  LatLng pickup,
  LatLng destination,
) {
  // how do I calculate the distance between two points using longitude and latitudes
  final double earthRadius = 6371.0; // in kilometers

  final double lat1 = pickup.latitude * 3.141592653589793 / 180.0;
  final double lon1 = pickup.longitude * 3.141592653589793 / 180.0;
  final double lat2 = destination.latitude * 3.141592653589793 / 180.0;
  final double lon2 = destination.longitude * 3.141592653589793 / 180.0;

  final double dLat = lat2 - lat1;
  final double dLon = lon2 - lon1;

  // co

  final double a = math.pow(math.sin(dLat / 2), 2) +
      math.cos(lat1) * math.cos(lat2) * math.pow(math.sin(dLon / 2), 2);
  final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  final double distance = earthRadius * c;

  double time = distance / 60;

  // Convert time to minutes
  double duration = time * 60;

  return duration;
}

double percent(
  double percentt,
  double amount,
) {
  // returns the percent of the amount
  return (percentt / 100) * amount;
}
