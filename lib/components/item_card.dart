import 'package:flutter/material.dart';

//Creating a  stateful widget...

class ItemCard extends StatefulWidget {
  final post;
  final VoidCallback press;

  const ItemCard({Key? key, this.post, required this.press}) : super(key: key);

  @override
  _ItemCardState createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: widget.press,
        child: Container(
            margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            padding: const EdgeInsets.all(10.0),
            height: 180,
            width: 160,
            decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // First container..
                Container(
                    // padding: const EdgeInsets.all(0.0),
                    height: 150,
                    width: 140,
                    decoration: BoxDecoration(
                        // color: Colors.blue,
                        image: DecorationImage(
                            image: NetworkImage(widget.post['imageUrl']),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(10)),
                ),

                // Second container..
                Container(
                  padding: const EdgeInsets.all(5.0),
                  height: 150,
                  width: 130,
                  decoration: BoxDecoration(
                      // color: Colors.blue,
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          widget.post['title'].toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          widget.post['description'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          softWrap: true,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 2.0),
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          widget.post['ownerName'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}
