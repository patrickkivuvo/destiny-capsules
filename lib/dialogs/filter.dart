import 'package:destiny_capsules/screens/cart/cart_screen.dart';
import 'package:destiny_capsules/screens/home/home_screen.dart';
import 'package:destiny_capsules/screens/search/search_screen.dart';
import 'package:flutter/material.dart';

class Filter extends StatefulWidget {
  const Filter({
    Key? key,
  }) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  // State variables for expansion state of each filter category
  bool _isPersonalDevelopmentExpanded = false;
  bool _isBibleExpositionExpanded = false;
  bool _isReligionExpanded = false;
  bool _isChristianMinistryExpanded = false;
  bool _isExecutableOutlinesExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        height: 500, // Adjust the height accordingly
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 15,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 15),
                buildFilterButton(
                  'Personal Development',
                  _isPersonalDevelopmentExpanded,
                  () {
                    setState(() {
                      _isPersonalDevelopmentExpanded =
                          !_isPersonalDevelopmentExpanded;
                    });
                  },
                ),
                _isPersonalDevelopmentExpanded
                    ? buildFilterItems(['EBOOKS', 'PODCASTS', 'ONLINE COURSES'])
                    : const SizedBox(),
                const SizedBox(height: 3),
                buildFilterButton(
                    'Bible Exposition', _isBibleExpositionExpanded, () {
                  setState(() {
                    _isBibleExpositionExpanded = !_isBibleExpositionExpanded;
                  });
                }),
                _isBibleExpositionExpanded
                    ? buildFilterItems(['EBOOKS', 'PODCASTS', 'ONLINE COURSES'])
                    : const SizedBox(),
                const SizedBox(height: 3),
                buildFilterButton('Religion', _isReligionExpanded, () {
                  setState(() {
                    _isReligionExpanded = !_isReligionExpanded;
                  });
                }),
                _isReligionExpanded
                    ? buildFilterItems(['EBOOKS', 'PODCASTS', 'ONLINE COURSES'])
                    : const SizedBox(),
                const SizedBox(height: 3),
                buildFilterButton(
                    'Christian Ministry', _isChristianMinistryExpanded, () {
                  setState(() {
                    _isChristianMinistryExpanded =
                        !_isChristianMinistryExpanded;
                  });
                }),
                _isChristianMinistryExpanded
                    ? buildFilterItems(['EBOOKS', 'PODCASTS', 'ONLINE COURSES'])
                    : const SizedBox(),
                const SizedBox(height: 3),
                buildFilterButton(
                    'Executable Outlines', _isExecutableOutlinesExpanded, () {
                  setState(() {
                    _isExecutableOutlinesExpanded =
                        !_isExecutableOutlinesExpanded;
                  });
                }),
                _isExecutableOutlinesExpanded
                    ? buildFilterItems(['EBOOKS', 'PODCASTS', 'ONLINE COURSES'])
                    : const SizedBox(),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFilterButton(
      String label, bool isExpanded, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget buildFilterItems(List<String> items) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items
          .map(
            (item) => SizedBox(
              width: 150,
              child: ListTile(
                title: Center(
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                ),
                onTap: () {
                  print('Selected: $item');
                  switch (item.toUpperCase()) {
                    case 'EBOOKS':
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                      break;
                    case 'PODCASTS':
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchScreen()));
                      break;
                    case 'ONLINE COURSES':
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartScreen()));
                      break;
                    default:
                      break;
                  }
                },
              ),
            ),
          )
          .toList(),
    );
  }
}
