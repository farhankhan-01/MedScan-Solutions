import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    Key key,
    @required this.avatarImage,
    @required this.backgroundColor,
    @required this.title,
    this.content,
  }) : super(key: key);

  final ImageProvider avatarImage;
  final String title;
  final Color backgroundColor;
  final List<String> content;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
      color: backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: <Widget>[
            Center(
              child: CircleAvatar(
                backgroundImage: avatarImage,
                backgroundColor: Colors.transparent,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    for (String item in content)
                      Text(
                        item,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
