import 'package:flutter/material.dart';

class DiamondFAB extends StatelessWidget{
  final VoidCallback? onPressed;
  final double size;
  final Color color;
  final IconData icon;
  final double pi;
  const DiamondFAB({super.key, 
    required this.onPressed,
    this.size = 30,
    this.color  = Colors.white,
    this.icon = Icons.add,
    this.pi = 3.1415926535897932
  });

  @override
  Widget build(BuildContext context){
    return Transform.rotate(
      angle: -45 * pi / 180,
      child: SizedBox(
        width: size,
        height: size,
        child: RawMaterialButton(
          elevation: 6.0,
          fillColor: color,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          onPressed: onPressed,
          child: Icon(
            icon,
            color: const Color.fromARGB(255, 31, 33, 38),
          ),
        ),
      ),
      );  
    }
}
