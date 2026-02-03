import 'package:flutter/material.dart';
import '../service/cart_service.dart';
import '../service/sale_service.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final items = CartService.items;

    return Scaffold(
      appBar: AppBar(title: const Text("ตะกร้าสินค้า")),
      body: items.isEmpty
          ? const Center(child: Text("ตะกร้าว่าง"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (c, i) {
                      final item = items[i];

                      return ListTile(
                        title: Text(item.name),
                        subtitle: Text("฿${item.price} x ${item.qty}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  CartService.decrease(item.name);
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  CartService.increase(item.name);
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  CartService.removeItem(item.name);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "รวมทั้งหมด: ฿${CartService.totalPrice}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () async {
                          await SaleService.saveCart(items);
                          CartService.clear();
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("✅ สั่งซื้อ"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
