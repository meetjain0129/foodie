import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:fooddelievery/screens/restaurantdetail.dart';
import 'package:sqflite/sqflite.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  // GoogleSignIn googleSignIn = GoogleSignIn();

  final db = FirebaseFirestore.instance;

  String searchRestaurant = '';
  List cartData = [];
  Database? database;

  @override
  void initState() {
    // getData();
    // DatabaseHelper.instance.getTasks();
    super.initState();
  }

  getData() async {
    cartData.clear();
    cartData = await database!.rawQuery('SELECT * FROM CartData');
    print(cartData);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        searchRestaurant = value;
                      });
                    },
                    keyboardType: TextInputType.emailAddress,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                        hintText: 'Restaurant name',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Color(0xFFF28705),
                        ),
                        border: InputBorder.none,
                        filled: true,
                        fillColor: Colors.grey[200]),
                  ),
                ),
              ),
            ),
            preferredSize: Size.fromHeight(55)),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Foodie',
          style: TextStyle(
              color: Color(0xFFD96704),
              fontSize: 22,
              fontWeight: FontWeight.w700),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: StreamBuilder<QuerySnapshot>(
            stream: db.collection('Restaurants').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFD96704),
                    ),
                  ),
                );
              }
              return Container(
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final DocumentSnapshot data = snapshot.data!.docs[index];
                      if (data['restaurant_name']
                          .toString()
                          .toLowerCase()
                          .startsWith(searchRestaurant.toLowerCase())) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: Bounce(
                            duration: const Duration(milliseconds: 110),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RestaurantDetail(
                                        data['restaurant_name'],
                                        data['address'],
                                        data['imgURL'],
                                        data['desp'])),
                              );
                            },
                            child: Material(
                              elevation: 4,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        data['imgURL'],
                                        height: 150,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                data['restaurant_name'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[900]),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.green[900]),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      data['ratings'],
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 18,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                          ),
                                          Text(
                                            data['address'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey[600]),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.002,
                                          ),
                                          Text(
                                            'Opens at ' + data['opens_at'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      if (searchRestaurant == '') {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: Bounce(
                            duration: const Duration(milliseconds: 110),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RestaurantDetail(
                                        data['restaurant_name'],
                                        data['address'],
                                        data['imgURL'],
                                        data['desp'])),
                              );
                            },
                            child: Material(
                              elevation: 4,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white,
                                ),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image.network(
                                        data['imgURL'],
                                        height: 150,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                data['restaurant_name'],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.grey[900]),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5,
                                                        vertical: 2),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Colors.green[900]),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      data['ratings'],
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    const Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                      size: 18,
                                                    )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                          ),
                                          Text(
                                            data['address'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey[600]),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.002,
                                          ),
                                          Text(
                                            'Opens at ' + data['opens_at'],
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    }),
              );
            }),
      ),
    );
  }
}

class RestaurantList {
  String imageLink, restaurantName, address;
  int openingTime;
  double ratings;

  RestaurantList(
      {required this.imageLink,
      required this.restaurantName,
      required this.address,
      required this.openingTime,
      required this.ratings});
}
