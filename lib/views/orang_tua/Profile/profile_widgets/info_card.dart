import 'package:flutter/material.dart';

Widget buildInfoCard({required List<Widget> items}) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children:
            items
                .map(
                  (item) => Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: item,
                      ),
                      if (item != items.last)
                        Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade200,
                        ),
                    ],
                  ),
                )
                .toList(),
      ),
    ),
  );
}
