import 'package:destiny_capsules/dialogs/buy_item.dart';
import 'package:destiny_capsules/models/product_model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../constants/appstyle.dart';
import '../constants/colors.dart';

class ProductGrid extends StatefulWidget {
  const ProductGrid({super.key});

  @override
  _ProductGridState createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  late Future<List<ProductModel>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductModel>>(
      future: _futureProducts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xff3249CA),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData && snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "Product is empty",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          );
        } else {
          return _buildProductGrid(snapshot.data!);
        }
      },
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    final media = MediaQuery.of(context).size;
    return MasonryGridView.builder(
      padding: const EdgeInsets.only(bottom: 15.0),
      shrinkWrap: true,
      primary: false,
      itemCount: products.length,
      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemBuilder: (ctx, index) {
        final singleProduct = products[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              showGeneralDialog(
                barrierLabel: 'Dialog',
                barrierDismissible: true,
                context: context,
                pageBuilder: (ctx, anim1, anim2) =>
                    BuyItem(singleProduct: singleProduct),
                transitionBuilder: (ctx, anim1, anim2, child) => ScaleTransition(
                  scale: anim1,
                  child: child,
                ),
              );
            },
            child: Center(
              child: Container(
                width: media.width * 0.4,
                height: media.height * 0.4,
                padding: const EdgeInsets.only(
                  top: 12,
                  left: 5,
                  right: 5,
                  bottom: 18,
                ),
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadows: const [
                    BoxShadow(
                      color: Color(0x1E000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Image.network(
                          singleProduct.image,
                          width: media.width * 0.32,
                          height: media.height * 0.2,
                          fit: BoxFit.cover,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                      Color(0xff3249CA)),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: media.height * 0.02,
                    ),
                    Center(
                      child: Text(
                        singleProduct.title,
                        style: appstyle(12, AppColors.black, FontWeight.w600),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "\$${(singleProduct.price / 113.33).toStringAsFixed(2)}",
                      style: appstyle(16, AppColors.black, FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
