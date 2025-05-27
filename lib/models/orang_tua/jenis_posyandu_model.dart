import 'package:molita_flutter/models/orang_tua/desa_model.dart';

class JenisPosyandu {
  final String idJenisPosyandu;
  final String pos;
  final String alamat;
  final int? idDesa;
  final double? latitude;
  final double? longitude;
  final Desa? desa;

  JenisPosyandu({
    required this.idJenisPosyandu,
    required this.pos,
    required this.alamat,
    this.idDesa,
    this.latitude,
    this.longitude,
    this.desa,
  });

  factory JenisPosyandu.fromJson(Map<String, dynamic> json) {
    return JenisPosyandu(
      idJenisPosyandu: json['id_jenis_posyandu'],
      pos: json['pos'],
      alamat: json['alamat'],
      idDesa: json['id_desa'],
      latitude: _toDouble(json['latitude']),
      longitude: _toDouble(json['longitude']),
      desa: json['desa'] != null ? Desa.fromJson(json['desa']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_jenis_posyandu': idJenisPosyandu,
      'pos': pos,
      'alamat': alamat,
      'id_desa': idDesa,
      'latitude': latitude,
      'longitude': longitude,
      'desa': desa?.toJson(),
    };
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
