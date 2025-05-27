// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:molita_flutter/core/constants/app_constant.dart';
// import 'package:molita_flutter/models/orang_tua/pengaduan_model.dart';
// import 'package:path/path.dart';
// import 'package:http_parser/http_parser.dart';

// class PengaduanService {

//   Future<bool> kirimPengaduan(Pengaduan data, {File? lampiran}) async {
//     var uri = Uri.parse('${AppConstant.baseUrlApi}/pengaduan');
//     var request = http.MultipartRequest('POST', uri);

//     // Tambahkan field biasa
//     request.fields.addAll(data.toMap());

//     // Tambahkan file jika ada
//     if (lampiran != null) {
//       request.files.add(
//         await http.MultipartFile.fromPath(
//           'lampiran',
//           lampiran.path,
//           contentType: MediaType('image', extension(lampiran.path)),
//         ),
//       );
//     }

//     try {
//       var response = await request.send();
//       return response.statusCode == 201;
//     } catch (e) {
//       rethrow;
//     }
//   }
// }
