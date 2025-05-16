import 'package:flutter/material.dart';
import 'store_list_screen.dart';
import 'product_list_screen.dart';
import 'product_map_screen.dart';
import 'product_search_screen.dart';

class NavBar extends StatefulWidget {
  final int selectedIndex;
  

  const NavBar({super.key, required this.selectedIndex});

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    const Color Cone  = Color.fromARGB(255, 57, 93, 119); 
    const Color Cthree = Color.fromARGB(255, 218, 232, 242);
    return Container(
      decoration: BoxDecoration(
        color: Cthree,
        border: Border.all(
          color: Cone,
          width: 1.0,
        ),
      ),
      child: SizedBox(
        height:80,
        child: BottomAppBar(
          color: Colors.transparent,
          elevation: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildIconButton(Icons.store, 0,  StoreListScreen()),
              _buildIconButton(Icons.list_alt, 1,  ProductListScreen()),
              _buildIconButton(Icons.search, 2, ProductSearchScreen()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, int index, Widget targetScreen) {
    bool isSelected = _selectedIndex == index;
    const Color Cone  = Color.fromARGB(255, 57, 93, 119); 
    const Color Cthree = Color.fromARGB(255, 218, 232, 242);
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: MouseRegion(
        onEnter: (_) {
          setState(() {
            _selectedIndex = index;
          });
        },
        onExit: (_) {
          setState(() {
            _selectedIndex = -1;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(bottom: isSelected ? 0 : 10.0),
          height: isSelected ? 70.0 : 60.0,
          width: isSelected ? 70.0 : 60.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isSelected ? Cone : Colors.transparent,
          ),
          child: Icon(
            icon,
            color: isSelected ? Cthree : Cone,
            size: isSelected ? 30.0 : 25.0,
          ),
        ),
      ),
    );
  }
}