import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctors_prescription/components/detail_row.dart';
import 'package:flutter/material.dart';

class MedicineDetailCard extends StatelessWidget {
  final String name;
  final String id;
  final String image;
  final String category;
  final String weight;
  final bool hasAddedReminder;
  final Function showBottomSheet;

  const MedicineDetailCard({
    Key key,
    this.name,
    this.id,
    this.image,
    this.category,
    this.weight,
    this.hasAddedReminder,
    this.showBottomSheet,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                // Padding(
                //   padding: const EdgeInsets.only(right: 30.0),
                //   child: CachedNetworkImage(
                //     imageUrl: image,
                //     placeholder: (context, url) => const Padding(
                //       padding: EdgeInsets.all(8.0),
                //       child: CircularProgressIndicator(),
                //     ),
                //     errorWidget: (context, url, error) =>
                //         const Icon(Icons.error),
                //   ),
                // ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DetailRow(
                        title: 'Suggestion',
                        data: name,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      DetailRow(
                        title: 'Scanned Text',
                        data: category,
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      DetailRow(
                        title: 'Accuracy',
                        data: id,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
