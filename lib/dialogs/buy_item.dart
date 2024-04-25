import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';
import 'package:destiny_capsules/constants/constants.dart';
import 'package:destiny_capsules/models/order_model/order_model.dart';
import 'package:destiny_capsules/models/product_model/product_model.dart';
import 'package:destiny_capsules/provider/app_provider.dart';
import 'package:destiny_capsules/screens/home/home_screen.dart';
import 'package:destiny_capsules/screens/product_details/product_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuyItem extends StatefulWidget {
  final ProductModel singleProduct;
  const BuyItem({Key? key, required this.singleProduct}) : super(key: key);

  @override
  State<BuyItem> createState() => _BuyItemState();
}

class _BuyItemState extends State<BuyItem> {
  int qty = 1;
  late List<ProductModel> productModelList;
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    fetchProducts().then((products) {
      setState(() {
        productModelList = products;
        isLoading =
            false; // Set loading state to false when products are fetched
      });
    }).catchError((error) {
      print('Error fetching products: $error');
      setState(() {
        isLoading = false; // Set loading state to false in case of error
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 3,
          horizontal: 15,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.35,
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Image.asset(
                  'assets/img/logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            const SizedBox(height: 1),
            const Text(
              'Buy This Item!',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: Image.network(
                widget.singleProduct.image,
              ),
            ),
            const SizedBox(height: 25),
            // Conditional rendering based on loading state
            isLoading
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xff3249CA),
                    ),
                  ) // Show CircularProgressIndicator while loading
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.white,
                      backgroundColor: AppColors.primary,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      ProductModel bestProductModel =
                          widget.singleProduct.copyWith(qty: qty);
                      appProvider.addCartProduct(bestProductModel);
                      showMessage("Successfully Added!!");
                      // Place the order
                      try {
                        await placeOrder(bestProductModel.id, qty);
                        Navigator.pop(context); // Pop the CartScreen
                        Navigator.pushReplacement(
                          // Push a new instance of HomeScreen
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      } catch (e) {
                        print('Error placing order: $e');
                        // Handle error if necessary
                      }
                      // Navigator.pop(context);
                    },
                    child: Text(
                      'Add To Cart',
                      style: appstyle(17, AppColors.white, FontWeight.w600),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsScreen(
                            singleProduct: widget.singleProduct),
                      ),
                    );
                  },
                  child: Text(
                    'View Details',
                    style: appstyle(17, AppColors.primary, FontWeight.w600),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
