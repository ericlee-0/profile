import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

enum DataSource {
  none,
  firestore,
  realtimeDB,
  cache,
}

DataSource _source(dynamic snapshot) => snapshot is DataSnapshot
    ? DataSource.realtimeDB
    : snapshot is DocumentSnapshot
        ? DataSource.firestore
        : DataSource.none;

// base data model class
class ContentModel {
  ContentModel({
    this.menuList,
    this.projectList,
    this.images,
    this.description,
  });
  final List<String>? menuList;
  final List<String>? projectList;
  final Map<String, List>? images;
  final Map<String, Map>? description;

//constructor from map data
  ContentModel.fromMap(Map<String, dynamic> data)
      : menuList = List<String>.from(data['menuList'] as List),
        projectList = List<String>.from(data['projectList'] as List),
        images = Map<String, List>.from(data['images'] as Map),
        description = Map<String, Map>.from(data['description'] as Map);

//constructor from snapshot data
  ContentModel.fromDataSnapshot(AsyncSnapshot<DocumentSnapshot> snapshot)
      : this.fromMap((snapshot.data!.data() as Map<String, dynamic>));

//in case of using different database type
  factory ContentModel.fromSnapshot(dynamic data) {
    switch (_source(data)) {
      case DataSource.realtimeDB:
        return ContentModel.fromDataSnapshot(data);
      case DataSource.firestore:
        return ContentModel.fromDataSnapshot(data);
      default:
        return ContentModel.fromDataSnapshot(data);
    }
  }
}
