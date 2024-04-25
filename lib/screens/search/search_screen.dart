import 'package:flutter/material.dart';
import 'package:destiny_capsules/models/product_model/product_model.dart';
import 'package:destiny_capsules/dialogs/buy_item.dart';
import 'package:destiny_capsules/common_widgets/app_icons_buttons/back_button.dart';
import 'package:destiny_capsules/constants/appstyle.dart';
import 'package:destiny_capsules/constants/colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<ProductModel>> _futureProducts;
  final TextEditingController _searchController = TextEditingController();
  List<ProductModel> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _futureProducts = fetchProducts();
  }

 void _filterProducts(String query) {
  _futureProducts.then((products) {
    setState(() {
      _filteredProducts = products.where((product) {
        return product.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const AppBackButton(),
        backgroundColor: Colors.white,
        title: SizedBox(
          height: 50,
          width: double.infinity,
          child: TextField(
            controller: _searchController,
            onChanged: _filterProducts,
            style: appstyle(16, AppColors.secondaryText, FontWeight.w400),
            decoration: const InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              prefixIcon: Icon(Icons.search_outlined),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  color: Color(0xff1E1E1E),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(color: Colors.grey),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 235,
                  height: 35,
                  child: Text(
                    'Search Products',
                    style:
                        appstyle(24, AppColors.secondaryText, FontWeight.w700),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder<List<ProductModel>>(
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
                      // Use filtered products instead of snapshot data
                      return _buildProductGrid(
                          _searchController.text.isEmpty
                              ? snapshot.data!
                              : _filteredProducts);
                    }
                  },
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<ProductModel> products) {
    final media = MediaQuery.of(context).size;
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 15.0),
      shrinkWrap: true,
      primary: false,
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.9,
        crossAxisCount: 2,
      ),
      itemBuilder: (ctx, index) {
        final singleProduct = products[index];
        return GestureDetector(
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
              width: media.width * 0.45,
              height: media.height * 0.29,
              padding: const EdgeInsets.only(
                top: 12,
                left: 15,
                right: 15,
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
                        width: media.width * 0.12,
                        height: media.height * 0.1,
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
                    height: media.height * 0.011,
                  ),
                  Text(
                    singleProduct.title,
                    style: appstyle(12, AppColors.black, FontWeight.w400),
                  ),
                  const Spacer(),
                  Text(
                    "\$${(singleProduct.price / 113.33).toStringAsFixed(2)}",
                    style: appstyle(14, AppColors.black, FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
