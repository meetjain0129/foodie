import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:fooddelievery/screens/addtocart.dart';
import 'package:fooddelievery/sqflite/database.dart';

class ItemDetail extends StatefulWidget {
  String dishName, dishDesp, dishIMG;
  int dishPrice;
  ItemDetail(
      {super.key,
      required this.dishName,
      required this.dishDesp,
      required this.dishIMG,
      required this.dishPrice});

  @override
  State<ItemDetail> createState() => _ItemDetailState();
}

class _ItemDetailState extends State<ItemDetail> {
  List<Map> cartData = [];
  int dishCount = 1, finalPrice = 0, price = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  bool isDataUploading = false;

  @override
  void initState() {
    price = widget.dishPrice;
    finalPrice = price;
    databaseHelper.initializeDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.dishName,
          style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
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
        child: Center(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.67,
                height: MediaQuery.of(context).size.height * 0.4,
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(360),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(360),
                      child: Image.network(
                        widget.dishIMG,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.dishName,
                      style: TextStyle(
                          fontSize: 19,
                          color: Color(0xFFD96704),
                          fontWeight: FontWeight.w500),
                    ),
                    Row(
                      children: [
                        Bounce(
                          onPressed: () {
                            setState(() {
                              if (dishCount > 1) {
                                subCount();
                              }
                            });
                          },
                          duration: Duration(milliseconds: 110),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xFFD96704)),
                            child: Icon(Icons.remove,
                                color: Colors.white, size: 20),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          '$dishCount',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700]),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Bounce(
                          onPressed: () {
                            addCount();
                          },
                          duration: Duration(milliseconds: 110),
                          child: Container(
                            width: 25,
                            height: 25,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Color(0xFFD96704)),
                            child:
                                Icon(Icons.add, color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.3,
                      padding: EdgeInsets.symmetric(
                          vertical: MediaQuery.of(context).size.height * 0.04),
                      child: Text(
                        widget.dishDesp +
                            ' Lorem In publishing and graphic design, Lorem ipsum is a placeholder text commonly used to demonstrate the visual form of a document or a typeface without relying on meaningful content. Lorem ipsum, or lipsum as it is sometimes known, is dummy text used in laying out print, graphic or web designs. The passage is attributed to an unknown',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 7,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Delievery Time',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Icon(
                          Icons.history,
                          color: Color(0xFFD96704),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          '30 min',
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFFD96704),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.025,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Total Price',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w400,
                                  color: Color(0xFFD96704)),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.005,
                            ),
                            Text(
                              '\u20B9 $finalPrice',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFFD96704)),
                            ),
                          ],
                        ),
                        Bounce(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFD96704),
                              ),
                              child: Center(
                                child: isDataUploading == true
                                    ? SizedBox(
                                        width: 25,
                                        height: 25,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        'Add To Cart',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                              ),
                            ),
                            duration: Duration(milliseconds: 110),
                            onPressed: () {
                              addtoCart();
                            })
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  addtoCart() async {
    isDataUploading = true;
    CollectionReference reference =
        FirebaseFirestore.instance.collection('AddtoCart');

    reference.add({
      'dishImage': widget.dishIMG,
      'dishName': widget.dishName,
      'dishDesp': widget.dishDesp,
      'dishCount': dishCount,
      'dishPrice': finalPrice
    }).whenComplete(() => {
          isDataUploading = false,
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddToCart()))
        });
  }

  addCount() {
    setState(() {
      int tempCount = 1, priceCalculate = price;
      dishCount++;
      tempCount = dishCount;
      priceCalculate = price * tempCount;
      finalPrice = priceCalculate;
    });
  }

  subCount() {
    setState(() {
      dishCount--;
      int temp = price * dishCount;
      finalPrice = temp;
    });
  }

  // //Sqflite Database
  // createDB() async {
  //   var dbName = await openDatabase('cartData.db');
  //   String defaultPath = await getDatabasesPath();
  //   String dbPath = defaultPath + 'cartData.db';

  //   database =
  //       await openDatabase(dbPath, version: 1, onCreate: ((db, version) async {
  //     await db
  //         .execute(
  //             'CREATE TABLE CartData (id INTEGER PRIMARY KEY AUTOINCREMENT, itemName TEXT, itemIMG TEXT, itemCount INTEGER, price INTEGER, itemDesp TEXT)')
  //         .whenComplete(() => {
  //               print('Successfull'),
  //             });
  //   }));
  // }

  // insertData(
  //     {required String dishName,
  //     required String dishIMG,
  //     required int dishCount,
  //     required int dishPrice,
  //     required String dishDesp}) async {
  //   print(dishPrice.toString());
  //   await database?.transaction((txn) async {
  //     int id = await txn
  //         .rawInsert(
  //             'INSERT INTO CartData(itemName, itemIMG, itemCount, price, itemDesp) VALUES ("$dishName", "$dishIMG", $dishCount, $dishPrice, "$dishDesp")')
  //         .whenComplete(() => {
  //               print('Data Entered'),
  //             });

  //     print(id);
  //   });

  //   getData();
  // }

  // getData() async {
  //   cartData = await database!.rawQuery('SELECT * FROM CartData');
  //   setState(() {});
  // }
}
