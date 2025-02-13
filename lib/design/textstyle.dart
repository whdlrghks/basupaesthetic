import 'package:basup_ver2/design/value.dart';
import 'package:flutter/material.dart';
import './color.dart';

var questionheight = 65.0;
var bannerheight = 105.0;
TextStyle labelstyle = TextStyle(
  fontFamily: "spoqahans",
////  fontStyle: GoogleFonts.,
//GoogleFonts.notoSansNKo(

  color: Colors.black45,
  fontSize: getDevice_Width() > 325 ? 18 : 14,
);


var submitloading_title = TextStyle(
  fontFamily: 'spoqahans',
  height: 1.6,
  fontSize: getDevice_Width() > 325 ? 22 : 18,
  color: Colors.black54,
  fontWeight: FontWeight.w500,
);

var submitloading_content = TextStyle(
  fontFamily: 'spoqahans',
  height: 1.6,
  fontSize: getDevice_Width() > 325 ? 16 : 12,
  color: Colors.black54,
  fontWeight: FontWeight.w200,
);

var percent_name = TextStyle(
  color: Color(0xFF49A85E),
  fontSize: 14,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w700,
);

var percent_graph = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

var subtitle_title= TextStyle(
  color: Color(0xFF979797),
  fontSize: 14,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w500,
);

var careroutinesubtitle_title =  TextStyle(
  color: Color(0xFF49A85E),
  fontSize: 20,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w700,
);

var careroutinesubtitle_content = TextStyle(
  color: Colors.black,
  fontSize: 20,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w700,
  letterSpacing: 0.40,
);

var careroutine_title = TextStyle(
  color: Color(0xFF49A85E),
  fontSize: 14,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w500,
);

var careroutine_content = TextStyle(
  color: Colors.black,
  fontSize: 14,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w400,
);

var ingredient_title = TextStyle(
  color: Color(0xFF49A85E),
  fontSize: 14,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w500,
  letterSpacing: 0.28,
);

var ingredient_content =  TextStyle(
  color: Color(0xFF858585),
  fontSize: 12,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w400,
);

var skinrecommend_content = TextStyle(
  color: Color(0xFF858585),
  fontSize: 14,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w400,
  letterSpacing: 0.28,
);

var skinrecommend_highlight = TextStyle(
  color: Color(0xFF49A85E),
  fontSize: 14,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w500,
);

var skinmoreinfo_button = TextStyle(
  color: Colors.white,
  fontSize: 14,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w600,
  letterSpacing: 0.28,
);

var removeusertitle = TextStyle(
    color:  const Color(0xf5000000),
    fontWeight: FontWeight.w700,
    fontFamily: "Pretendard",
    fontStyle:  FontStyle.normal,
    fontSize: 16
);

var removeusercontent =  TextStyle(
    color:  const Color(0x80151920),
    fontWeight: FontWeight.w400,
    fontFamily: "Pretendard",
    fontStyle:  FontStyle.normal,
    fontSize: 14
);

var removeuserdetail = TextStyle(
    color:  const Color(0x80151920),
    fontWeight: FontWeight.w400,
    fontFamily: "Pretendard",
    fontStyle:  FontStyle.normal,
    fontSize: 12
);

var removeuserreject = TextStyle(
    color:  const Color(0xff7c7c7c),
    fontWeight: FontWeight.w400,
    fontFamily: "Pretendard",
    fontStyle:  FontStyle.normal,
    fontSize: 14
);

var removeuserconfirm = TextStyle(
    color:  const Color(0xffffffff),
    fontWeight: FontWeight.w600,
    fontFamily: "Pretendard",
    fontStyle:  FontStyle.normal,
    fontSize: 14
);

var index_button = TextStyle(
  color: Colors.white,
  fontSize: 23,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w600,
  letterSpacing: 0.28,
);

var more_button = TextStyle(
  color: Colors.white,
  fontSize: 17,
  fontFamily: 'Pretendard',
  fontWeight: FontWeight.w400,
  letterSpacing: 0.28,
);
