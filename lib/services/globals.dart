import 'services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';


/// Static global state. Immutable services that do not care about build context. 
class Global {
  // App Data
  static final String title = 'Magicards';

  // Services
  static final FirebaseAnalytics analytics = FirebaseAnalytics();

    // Data Models
  static final Map models = {
    Topic: (data) => Topic.fromMap(data),
    Subtopic: (data) => Subtopic.fromMap(data),
  };
  
}






