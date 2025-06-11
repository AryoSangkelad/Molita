class StatusGizi {
  final String statusBBU;
  final String statusTBU;
  final String statusBBTB;
  final double zscoreBBU;
  final double zscoreTBU;
  final double zscoreBBTB;

  StatusGizi({
    required this.statusBBU,
    required this.statusTBU,
    required this.statusBBTB,
    required this.zscoreBBU,
    required this.zscoreTBU,
    required this.zscoreBBTB,
  });

  factory StatusGizi.fromJson(Map<String, dynamic> json) {
    return StatusGizi(
      statusBBU: json['status_bb_u'],
      statusTBU: json['status_tb_u'],
      statusBBTB: json['status_bb_tb'],
      zscoreBBU: json['zscore_bb_u'].toDouble(),
      zscoreTBU: json['zscore_tb_u'].toDouble(),
      zscoreBBTB: json['zscore_bb_tb'].toDouble(),
    );
  }
}
