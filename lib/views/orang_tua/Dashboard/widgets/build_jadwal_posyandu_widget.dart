import 'package:flutter/material.dart';

Widget buildJadwalPosyandu(BuildContext context) {
  final primaryColor = Theme.of(context).colorScheme.primary;

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 10,
                ),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text(
                'Pemeriksaan Balita',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Icon(Icons.add_box_outlined, color: primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Posyandu Melati 29',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: primaryColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.calendar_today, color: primaryColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  'Senin, 2 Desember 2024',
                  style: TextStyle(color: primaryColor, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.location_on, color: primaryColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Jl. Mawar No. 12, Kota Bandung',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.access_time, color: primaryColor),
              const SizedBox(width: 4),
              const Text('08.10 - 10.30', style: TextStyle(fontSize: 14)),
            ],
          ),
        ],
      ),
    ),
  );
}
