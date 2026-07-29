import 'package:flutter/material.dart';

class CharacterPortraits {
  static List<List<Color>> getPortrait(String id) {
    switch (id) {
      case 'not_a_genius':
        return _notAGenius;
      case 'laurencium':
        return _laurencium;
      case 'king':
        return _king;
      case 'arsene':
        return _arsene;
      case 'hemeryfb':
        return _hemeryfb;
      default:
        return _placeholder;
    }
  }

  static const Color _t = Colors.transparent;
  static const Color _sk = Color(0xFFDDBB88);
  static const Color _sk2 = Color(0xFFCCAA77);
  static const Color _hr = Color(0xFF222244);
  static const Color _hr2 = Color(0xFF333366);
  static const Color _ey = Color(0xFFEEEEEE);
  static const Color _pu = Color(0xFF222222);
  static const Color _sh = Color(0xFF4488CC);
  static const Color _sh2 = Color(0xFF3366AA);
  static const Color _gm = Color(0xFFCCAA00);
  static const Color _gm2 = Color(0xFFAA8800);
  static const Color _rd = Color(0xFFCC3333);
  static const Color _rd2 = Color(0xFFAA2222);
  static const Color _gn = Color(0xFF33CC55);
  static const Color _gn2 = Color(0xFF22AA44);
  static const Color _pr = Color(0xFF8844CC);
  static const Color _pr2 = Color(0xFF6633AA);
  static const Color _wh = Color(0xFFEEEEF0);

  static final List<List<Color>> _notAGenius = _parseGrid([
    '..._HHHH_...',
    '.._HHHHHH_..',
    '.._HSSSSH_..',
    '.._SEESSE_..',
    '.._S__PPS_..',
    '..._SMMS_...',
    '....SSSS....',
    '..._SSSS_...',
    '.._SSSSSS_..',
    '.._SSSSSS_..',
    '..._SSSS_...',
    '....SSSS....',
    '..._S__S_...',
    '..._S__S_...',
    '..._S__S_...',
  ], {
    'H': _hr, 'S': _sk, 'E': _ey, 'P': _pu, 'M': _sk2, '_': _t,
    'C': _sh, 'D': _sh2,
  });

  static final List<List<Color>> _laurencium = _parseGrid([
    '..._GGGG_...',
    '.._GGGGGG_..',
    '.._GSSSSG_..',
    '.._SEESSE_..',
    '.._S__PPS_..',
    '..._SMMS_...',
    '....SSSS....',
    '..._DDDD_...',
    '.._DDDDDD_..',
    '.._DDDDDD_..',
    '..._DDDD_...',
    '....SSSS....',
    '..._S__S_...',
    '..._S__S_...',
    '..._S__S_...',
  ], {
    'G': _gm, 'S': _sk, 'E': _ey, 'P': _pu, 'M': _sk2, '_': _t,
    'D': _gm2,
  });

  static final List<List<Color>> _king = _parseGrid([
    '..._RRRR_...',
    '.._RRRRRR_..',
    '.._RSSSSR_..',
    '.._SEESSE_..',
    '.._S__PPS_..',
    '..._SMMS_...',
    '....SSSS....',
    '..._RRRR_...',
    '.._RRRRRR_..',
    '.._RRRRRR_..',
    '..._RRRR_...',
    '....SSSS....',
    '..._S__S_...',
    '..._S__S_...',
    '..._S__S_...',
  ], {
    'R': _rd, 'S': _sk, 'E': _ey, 'P': _pu, 'M': _sk2, '_': _t,
  });

  static final List<List<Color>> _arsene = _parseGrid([
    '..._NNNN_...',
    '.._NNNNNN_..',
    '.._NSSSSN_..',
    '.._SEESSE_..',
    '.._S__PPS_..',
    '..._SMMS_...',
    '....SSSS....',
    '..._NNNN_...',
    '.._NNNNNN_..',
    '.._NNNNNN_..',
    '..._NNNN_...',
    '....SSSS....',
    '..._S__S_...',
    '..._S__S_...',
    '..._S__S_...',
  ], {
    'N': _gn, 'S': _sk, 'E': _ey, 'P': _pu, 'M': _sk2, '_': _t,
  });

  static final List<List<Color>> _hemeryfb = _parseGrid([
    '..._PPPP_...',
    '.._PPPPPP_..',
    '.._PSSSSP_..',
    '.._SEESSE_..',
    '.._S__PPS_..',
    '..._SMMS_...',
    '....SSSS....',
    '..._PPPP_...',
    '.._PPPPPP_..',
    '.._PPPPPP_..',
    '..._PPPP_...',
    '....SSSS....',
    '..._S__S_...',
    '..._S__S_...',
    '..._S__S_...',
  ], {
    'P': _pr, 'S': _sk, 'E': _ey, 'M': _sk2, '_': _t,
  });

  static final List<List<Color>> _placeholder = _parseGrid([
    '..._WWWW_...',
    '.._WWWWWW_..',
    '.._WSSSSW_..',
    '.._SEESSE_..',
    '.._S__PPS_..',
    '..._SMMS_...',
    '....SSSS....',
    '..._WWWW_...',
    '.._WWWWWW_..',
    '.._WWWWWW_..',
    '..._WWWW_...',
    '....SSSS....',
    '..._S__S_...',
    '..._S__S_...',
    '..._S__S_...',
  ], {
    'W': _wh, 'S': _sk, 'E': _ey, 'P': _pu, 'M': _sk2, '_': _t,
  });

  static List<List<Color>> _parseGrid(List<String> rows, Map<String, Color> palette) {
    return rows.map((row) {
      return row.split('').map((c) => palette[c] ?? _t).toList();
    }).toList();
  }
}
