import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/common/widgets/elevated_button/elevated_button.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart'; // Import package

class ScanBarcodeScreen extends StatefulWidget {
  const ScanBarcodeScreen({super.key});

  @override
  State<ScanBarcodeScreen> createState() => _ScanBarcodeScreenState();
}

class _ScanBarcodeScreenState extends State<ScanBarcodeScreen> {
  String? barcodeResult;

  // Hàm gọi màn hình quét mã vạch
  Future<void> scanBarcode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(),
      ),
    );
    if (result != null && result != '-1') { // result == '-1' khi người dùng hủy quét
      setState(() {
        barcodeResult = result; // Lưu kết quả quét
      });
      // Điều hướng đến AddFoodScreen sau khi quét thành công (giả lập thời gian xử lý)
      Future.delayed(const Duration(seconds: 1), () {
        context.go('/add_food');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nút điều hướng
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        barcodeResult = null; // Xóa kết quả quét
                      });
                    },
                    child: const Text(
                      'Clear',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            // Khu vực quét mã vạch
            Expanded(
              child: Center(
                child: barcodeResult == null
                    ? GestureDetector(
                  onTap: scanBarcode, // Mở màn hình quét khi nhấn
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Hình ảnh nền (giả lập khu vực quét)
                      Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[800],
                        child: Image.network(
                          'https://salt.tikicdn.com/cache/w1200/ts/product/82/07/62/110ba862da5f18c6e7241363ad7f1386.jpg',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 200);
                          },
                        ),
                      ),
                      // Vòng tròn với icon kính lúp
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.5),
                        ),
                        child: const Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                )
                    : const SizedBox(), // Ẩn khu vực quét sau khi quét thành công
              ),
            ),
            // Thông tin sản phẩm (hiển thị sau khi quét)
            if (barcodeResult != null) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      barcodeResult!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Image.network(
                          'https://salt.tikicdn.com/cache/w1200/ts/product/82/07/62/110ba862da5f18c6e7241363ad7f1386.jpg',
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 50);
                          },
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Coca cola',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            Text(
                              'Unknown brand',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButtonCustom(
                      onPressed: () {
                        context.go('/add_food');
                      },
                      icon: const Icon(Icons.bolt),
                      label: 'See details!',
                    ),
                    const SizedBox(height: 16),
                    // Thông tin dinh dưỡng
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'NUTRI-SCORE\nABCDE',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Lower nutritional quality',
                                style: TextStyle(color: Colors.white),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Tab "Scan" được chọn
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/profile');
              break;
            case 1:
              context.go('/scan');
              break;
            case 2:
              context.go('/lists');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lists',
          ),
        ],
      ),
    );
  }
}