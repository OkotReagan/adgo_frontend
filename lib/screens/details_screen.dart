import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DetailsScreen extends StatelessWidget {
  final post;

  const DetailsScreen({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: post.color,
      appBar: buildAppBarWidget(context),
      body: buildDetailsBody(context, post),
    );
  }

// AppBar of the Scaffold Widget...
  PreferredSizeWidget buildAppBarWidget(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 21, 76, 121),
      leading: IconButton(
          icon: SvgPicture.asset(
            "assets/icons/back.svg",
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context)),
      title: const Text('Item Details', style: TextStyle(fontSize: 20)),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            print("application is being refreshed.");
          },
        ),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            print("more verting in the application.");
          },
        ),
      ],
    );
  }

  Widget buildDetailsBody(BuildContext context, post) {
    return SingleChildScrollView(
        child: Column(
      children: <Widget>[
        Container(
          height: 800.0,
          color: Colors.black,
          padding: const EdgeInsets.only(
            top: 5.0,
          ),
          child: Stack(
            children: <Widget>[
              //first child of the stack
              Container(
                width: double.infinity,
                height: 350,
                margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: post['imageUrl'] != null
                    ? Image.network(post['imageUrl'],
                        fit: BoxFit.cover, height: 250)
                    : const Text("image not uploaded",
                        style: TextStyle(color: Colors.black)),
              ),

              //Second child of the stack

              Positioned(
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 200.0 * 0.12, left: 20.0, right: 20.0, bottom: 20.0),
                  height: 500,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      )),
                  child: Container(
                    padding: const EdgeInsets.all(5.0),
                    height: 150,
                    width: 130,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          child: Text(
                            post['title'].toUpperCase(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),

                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(post['avatar']),
                              radius: 30,
                            ),
                            SizedBox(width: 30),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      post['ownerName'],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      "Ugx " + post['price'].toString(),
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                  Text(
                                    post['contact'],
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                          Container(
                          margin: const EdgeInsets.all(5.0),
                          child: Text(
                            'DESCRIPTION',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                
                        Container(
                          margin: const EdgeInsets.only(top: 5.0),
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            post['description'],
                            overflow: TextOverflow.ellipsis,
                            maxLines: 8,
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                right: 0,
                left: 0,
                top: 360.0,
              )
            ],
          ),
        ),
      ],
    ));
  }
}
