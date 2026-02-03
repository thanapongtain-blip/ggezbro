import 'package:flutter/material.dart';
import '../widgets/food_item.dart';
import 'cart_page.dart';

class FoodListPage extends StatefulWidget {
  const FoodListPage({super.key});

  @override
  State<FoodListPage> createState() => _FoodListPageState();
}

class _FoodListPageState extends State<FoodListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รายการอาหาร"),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
              setState(() {});
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: const [
            SizedBox(height: 10),
            Text("อาหารคาว", style: TextStyle(fontSize: 18)),

            FoodItem(
              name: "ข้าวไก่ทอด",
              imagePath: "assets/images/3465_1376 Delivery 510x510 Px.jpg",
            ),
            FoodItem(name: "ข้าวไข่ดาว", imagePath: "assets/images/images (1).jpg"),
            FoodItem(name: "ข้าวมันไก่", imagePath: "assets/images/images.jpg"),
            FoodItem(name: "ข้าวไข่เจียว", imagePath: "assets/images/เครื่องจักรแปรรูปผัก-ผลไม้.jpg"),

            SizedBox(height: 20),
            Text("ของหวาน", style: TextStyle(fontSize: 18)),

            FoodItem(
              name: "ช็อกโกแลต",
              imagePath: "assets/images/th-11134207-7ras9-m9mg38or20dc64.jpg",
            ),
            FoodItem(
              name: "โดนัด",
              imagePath: "assets/images/b99eb34d-4c7c-47d5-a8f4-41c22f0d10fe.jpg",
            ),
            FoodItem(name: "เยลลี่", imagePath: "assets/images/sz4vnp2g9i27JSPRJxTAG-o.jpg"),
          ],
        ),
      ),
    );
  }
}
