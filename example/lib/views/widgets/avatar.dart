import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.columnWidth,
    required this.columIndex,
  });

  final double columnWidth;
  final int columIndex;

  @override
  Widget build(BuildContext context) {
    var name = switch (columIndex) {
      0 => 'Suzy',
      1 => 'Jose',
      2 => 'Michelle',
      3 => 'John',
      4 => 'Blaise',
      5 => 'Jane',
      6 => 'Alfred',
      int() => '',
    };
    var imageUrl = switch (columIndex) {
      0 => 'https://randomuser.me/api/portraits/thumb/women/88.jpg',
      1 => 'https://randomuser.me/api/portraits/thumb/men/11.jpg',
      2 => 'https://randomuser.me/api/portraits/thumb/women/85.jpg',
      3 => 'https://randomuser.me/api/portraits/thumb/men/88.jpg',
      4 => 'https://randomuser.me/api/portraits/thumb/men/12.jpg',
      5 => 'https://randomuser.me/api/portraits/thumb/women/18.jpg',
      6 => 'https://randomuser.me/api/portraits/thumb/men/90.jpg',
      int() => '',
    };

    return Container(
      width: columnWidth,
      child: Column(
        children: [
          ClipOval(
            child: Image.network(
              imageUrl,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          ),
          Text(name, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
