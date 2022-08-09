// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:great_places_app/providers/great_places.dart';
import 'package:great_places_app/screens/map_screen.dart';
import 'package:provider/provider.dart';

class PlaceDetailsScreen extends StatelessWidget {
  static const routeName = '/place-detail';
  const PlaceDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final selectedplace =
        Provider.of<GreatPlaces>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedplace.title),
      ),
      body: Column(
        children: [
          Container(
            height: 250,
            width: double.infinity,
            child: Image.file(
              selectedplace.image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          SizedBox(height: 10),
          Text(
            selectedplace.location.address!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 10),
          FlatButton(
            textColor: Theme.of(context).primaryColor,
            child: Text('View on Map'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (ctx) => MapScreen(
                    initialLocation: selectedplace.location,
                    isSelecting: false,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
