import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:fooddelievery/screens/addtocart.dart';
import 'package:fooddelievery/screens/itemdetail.dart';

class RestaurantMenu extends StatefulWidget {
  String restaurantName = '';
  RestaurantMenu({required this.restaurantName, super.key});

  @override
  State<RestaurantMenu> createState() => _RestaurantMenuState();
}

class _RestaurantMenuState extends State<RestaurantMenu> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  String restaurantName = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Menu',
          style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              splashRadius: 20,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AddToCart()));
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.grey[700],
              )),
          SizedBox(
            width: 10,
          )
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            splashRadius: 20,
            icon: Icon(
              Icons.arrow_back,
              color: Colors.grey[700],
            )),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Delicious Food',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Discover and get great food',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                        color: Colors.grey[600]),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
                StreamBuilder(
                    stream: db
                        .collection('Restaurants')
                        .doc(widget.restaurantName)
                        .collection('categories')
                        .doc('Delicious')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        if (!snapshot.hasData) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFFD96704),
                              ),
                            ),
                          );
                        }
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFD96704),
                            ),
                          ),
                        );
                      }
                      List foods = snapshot.data!.data()!.values.toList();
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.27,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: foods.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 7),
                                child: Bounce(
                                  duration: Duration(milliseconds: 110),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => ItemDetail(
                                                  dishName: foods[index]
                                                      ['dishName'],
                                                  dishDesp: foods[index]
                                                      ['dishDesp'],
                                                  dishIMG: foods[index]
                                                      ['dishIMG'],
                                                  dishPrice: foods[index]
                                                      ['price'],
                                                )));
                                  },
                                  child: Material(
                                    elevation: 10,
                                    borderRadius: BorderRadius.circular(10),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.1,
                                              ),
                                              Text(
                                                foods[index]['dishName'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFFD96704)),
                                              ),
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.015,
                                              ),
                                              Text(
                                                foods[index]['dishDesp'],
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color.fromARGB(
                                                        255, 94, 92, 91)),
                                              ),
                                              Text(
                                                '\u20B9 ' +
                                                    foods[index]['price']
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFFD96704)),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          top: -30,
                                          left: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.085,
                                          child: Material(
                                            elevation: 10,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                child: Image.network(
                                                  foods[index]['dishIMG'],
                                                  fit: BoxFit.fill,
                                                  width: 90,
                                                  height: 90,
                                                )),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    }),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Also Explore',
                    style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700]),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                StreamBuilder(
                    stream: db
                        .collection('Restaurants')
                        .doc(widget.restaurantName)
                        .collection('categories')
                        .doc('AlsoExplore')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text('Data is not available'),
                        );
                      }
                      List foods = snapshot.data!.data()!.values.toList();

                      return Container(
                        width: MediaQuery.of(context).size.width,
                        child: MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: foods.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 7),
                                  child: Bounce(
                                    duration: const Duration(milliseconds: 110),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ItemDetail(
                                                    dishName: foods[index]
                                                        ['dishName'],
                                                    dishDesp: foods[index]
                                                        ['dishDesp'],
                                                    dishIMG: foods[index]
                                                        ['dishIMG'],
                                                    dishPrice: foods[index]
                                                        ['price'],
                                                  )));
                                    },
                                    child: Material(
                                      elevation: 10,
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 15),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Material(
                                              elevation: 10,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  child: Image.network(
                                                    foods[index]['dishIMG'],
                                                    fit: BoxFit.fill,
                                                    width: 80,
                                                    height: 80,
                                                  )),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.02,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.45,
                                                  child: Text(
                                                    foods[index]['dishName'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFFD96704)),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.02,
                                                ),
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5,
                                                  child: Text(
                                                    foods[index]['dishDesp'],
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: Color.fromARGB(
                                                            255, 94, 92, 91)),
                                                  ),
                                                ),
                                                Text(
                                                  '\u20B9 ' +
                                                      foods[index]['price']
                                                          .toString(),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xFFD96704)),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      );
                    })
              ],
            ),
          )),
    );
  }

  // getRestaurantName() async {
  //   QuerySnapshot snapshot =
  //       await FirebaseFirestore.instance.collection('Restaurants').get();

  //   for (int i = 0; i < snapshot.docs.length; i++) {
  //     restaurantName = snapshot.docs[i].id;
  //   }

  //   print(restaurantName);
  // }
}

class RestaurantMenuDataClass {
  String dishName, dishDesp, dishIMG;
  int dishPrice;

  RestaurantMenuDataClass(
      {required this.dishName,
      required this.dishDesp,
      required this.dishIMG,
      required this.dishPrice});
}
