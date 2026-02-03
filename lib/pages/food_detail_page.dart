import 'package:flutter/material.dart';
import '../data/food_data.dart';
import '../service/location_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../service/cart_service.dart';

class FoodDetailPage extends StatefulWidget {
  final String name;
  const FoodDetailPage({super.key, required this.name});

  @override
  State<FoodDetailPage> createState() => _FoodDetailPageState();
}

class _FoodDetailPageState extends State<FoodDetailPage> {
  String gpsText = "กำลังหาตำแหน่ง...";
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    loadLocation();
    initVideo();
  }

  void initVideo() {
    final food = FoodData.foods[widget.name]!;
    _controller = VideoPlayerController.asset(food["video"])
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> loadLocation() async {
    final food = FoodData.foods[widget.name]!;
    final pos = await LocationService.getCurrentLocation();
    final dist = LocationService.distanceKm(
      pos.latitude,
      pos.longitude,
      food["lat"],
      food["lng"],
    );

    setState(() {
      gpsText =
          "พิกัดปัจจุบัน: ${pos.latitude.toStringAsFixed(5)}, ${pos.longitude.toStringAsFixed(5)}\n"
          "ระยะทางถึงร้าน: ${dist.toStringAsFixed(2)} กม.";
    });
  }

  @override
  Widget build(BuildContext context) {
    final food = FoodData.foods[widget.name]!;

    return Scaffold(
      appBar: AppBar(title: Text(widget.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🎥 วิดีโอ
              if (_controller.value.isInitialized)
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),

              IconButton(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
              ),

              const SizedBox(height: 10),
              Text(gpsText),

              const SizedBox(height: 10),
              const Text(
                "วัตถุดิบ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...food["ingredients"].map<Widget>((i) => Text("• $i")),

              const SizedBox(height: 10),
              const Text(
                "วิธีทำ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...food["steps"].map<Widget>((s) => Text("- $s")),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final lat = food["lat"];
                  final lng = food["lng"];

                  final uri = Uri.parse(
                    "https://www.google.com/maps/dir/?api=1"
                    "&destination=$lat,$lng"
                    "&travelmode=driving",
                  );

                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("ไม่สามารถเปิด Google Maps ได้"),
                      ),
                    );
                  }
                },
                child: const Text("🧭 นำทางไปยังร้าน"),
              ),
              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () {
                  CartService.addItem(widget.name, food["price"]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("เพิ่มลงตะกร้าแล้ว")),
                  );
                },
                child: const Text("🛒 เพิ่มลงตะกร้า"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
