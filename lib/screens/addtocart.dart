import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounce/flutter_bounce.dart';
import 'package:fooddelievery/screens/bottomnavigation.dart';
import 'package:fooddelievery/sqflite/database.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddToCart extends StatefulWidget {
  AddToCart({super.key});

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  List<CartDetail> cartData = [
    CartDetail(
        itemName: "Manchurian",
        desp: 'Too Spicy and hard',
        imageLink:
            'https://myfoodstory.com/wp-content/uploads/2021/10/Veg-Manchurian-FI-1.jpg',
        price: '200',
        quantity: 4),
    CartDetail(
        itemName: "Margherita Pizza",
        desp: 'Margherita Pizza is made up of tomato sauce',
        imageLink:
            'https://www.vegrecipesofindia.com/wp-content/uploads/2020/12/margherita-pizza-4.jpg',
        price: '220',
        quantity: 2),
    CartDetail(
        itemName: "Sandwich",
        desp: 'Make of bread and vegetables',
        imageLink:
            'https://www.foodandwine.com/thmb/gv06VNqj1uUJHGlw5e7IULwUmr8=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/2012-r-xl-vegetable-sandwich-with-dill-sauce-2000-0984c1b513ae4af396aee039afa5e38c.jpg',
        price: '80',
        quantity: 4)
  ];
  // FirebaseFirestore db = FirebaseFirestore.instance;
  DatabaseHelper databaseHelper = DatabaseHelper();
  double totalPrice = 1250;

  late Razorpay _razorpay;

  final dbquery = FirebaseFirestore.instance;

  @override
  void initState() {
    // addPrice();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Done ${response.orderId}');
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavigation()),
        (route) => false);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print('error');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
    print('other');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Orders',
          style: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w600,
              fontSize: 16),
        ),
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
        child: Container(
          child: StreamBuilder<QuerySnapshot>(
              stream: dbquery.collection('AddtoCart').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data?.docs.length,
                  shrinkWrap: true,
                  itemBuilder: (_, i) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 15),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                        elevation: 3,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(360),
                                child: Image.network(
                                  snapshot.data!.docs[i]['dishImage'],
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text(
                                            snapshot.data!.docs[i]['dishName'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xFFD96704)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text(
                                            snapshot.data!.docs[i]['dishDesp'],
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w400,
                                                color: Color.fromARGB(
                                                    255, 94, 92, 91)),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.3,
                                          child: Text(
                                            '\u20B9 ' +
                                                snapshot
                                                    .data!.docs[i]['dishPrice']
                                                    .toString(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Color(0xFFD96704)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Bounce(
                                            child: Icon(
                                              Icons.close,
                                              size: 15,
                                              color: Colors.grey[700],
                                            ),
                                            duration: const Duration(
                                                milliseconds: 110),
                                            onPressed: () {}),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.02,
                                        ),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Color(0xFFD96704),
                                          ),
                                          child: Center(
                                            child: Text(
                                              snapshot
                                                  .data!.docs[i]['dishCount']
                                                  .toString(),
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                          ),
                                        )
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
                  },
                );
              }),
        ),
      ),
      bottomSheet: Material(
        elevation: 30,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30), topLeft: Radius.circular(30)),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.2,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30))),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[700]),
                  ),
                  Text(
                    '\u20B9 $totalPrice',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFD96704)),
                  ),
                ],
              ),
              Divider(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Bounce(
                  duration: const Duration(milliseconds: 110),
                  onPressed: () async {
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();

                    String? userName = sharedPreferences.getString('userName');
                    String? userEmail =
                        sharedPreferences.getString('userEmail');
                    var options = {
                      'key': 'rzp_test_Dgn4RgE96NUqzR',
                      'amount': totalPrice * 100,
                      'name': '$userName',
                      'description': 'Fine T-Shirt',
                      'prefill': {
                        'contact': '6353673302',
                        'email': '$userEmail'
                      }
                    };

                    try {
                      _razorpay.open(options);
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: const Color(0xFFD96704),
                    ),
                    child: Center(
                        child: Text(
                      'Pay   \u20B9$totalPrice',
                      style: TextStyle(
                        color: Colors.grey[200],
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }
}

class CartDetail {
  String itemName, desp, price, imageLink;
  int quantity;

  CartDetail(
      {required this.itemName,
      required this.desp,
      required this.imageLink,
      required this.price,
      required this.quantity});
}
