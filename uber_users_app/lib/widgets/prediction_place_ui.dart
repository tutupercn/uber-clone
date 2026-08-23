import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uber_users_app/appInfo/app_info.dart';
import 'package:uber_users_app/models/address_models.dart';
import 'package:uber_users_app/models/prediction_model.dart';

class PredictionPlaceUI extends StatefulWidget {
  PredictionModel? predictedPlaceData;

  PredictionPlaceUI({super.key, this.predictedPlaceData});

  @override
  State<PredictionPlaceUI> createState() => _PredictionPlaceUIState();
}

class _PredictionPlaceUIState extends State<PredictionPlaceUI> {
  selectPlace(PredictionModel place) {
    if (place.latitude == null || place.longitude == null) return;
    final dropOffLocation = AddressModel(
      placeID: place.place_id,
      placeName: place.main_text,
      humanReadableAddress: [place.main_text, place.secondary_text]
          .where((part) => part != null && part.isNotEmpty)
          .join(', '),
      latitudePosition: place.latitude,
      longitudePosition: place.longitude,
    );
    Provider.of<AppInfoClass>(context, listen: false)
        .updateDropOffLocation(dropOffLocation);
    Navigator.pop(context, "placeSelected");
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        selectPlace(widget.predictedPlaceData!);
      },
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0))),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.share_location,
                color: Colors.grey,
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.predictedPlaceData!.main_text.toString(),
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      widget.predictedPlaceData!.secondary_text.toString(),
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
