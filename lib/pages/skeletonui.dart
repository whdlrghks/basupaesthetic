import 'package:basup_ver2/design/skeleton.dart';
import 'package:flutter/material.dart';

Widget skeletonSkinResult() {
  return ListView(
    padding: EdgeInsets.all(100),
    children: [
      SizedBox(height: 30),
      SkeletonWidget(width: double.infinity, height: 88), // 타이틀
      SizedBox(height: 60),
      SkeletonWidget(width: double.infinity, height: 401), // 메인 콘텐츠 영역
      SizedBox(height: 16),
      SkeletonWidget(width: double.infinity, height: 653), // 추가 텍스트
      SizedBox(height: 25),
      SkeletonWidget(width: double.infinity, height: 400), // 그래프나 결과 영역
    ],
  );
}

Widget skeletonResultTitle(){
  return Container(
    height: 375,
    width: 300,
    child : ListView(
    children: [
      SizedBox(height: 5),
      SkeletonWidget(width: 300, height: 20), // 타이틀
      SizedBox(height: 5),
      SkeletonWidget(width: 300, height: 33), // 타이틀
      SizedBox(height: 10),
      SkeletonWidget(width: 300, height: 300), // 타이틀
    ],
  ),);
}

Widget skeletonResultGraph(){
  return Container(
    height: 550,
    width: 300,
    child : ListView(
      children: [
        SizedBox(height: 10),

        SkeletonWidget(width: 300, height: 60), // 타이틀
        SizedBox(height: 30),
        SkeletonWidget(width: 300, height: 14), // 타이틀
        SizedBox(height: 10),
        SkeletonWidget(width: 300, height: 20), // 타이틀
        SizedBox(height: 20),
        SkeletonWidget(width: 300, height: 65), // 그래프
        SizedBox(height: 20),
        SkeletonWidget(width: 300, height: 65), // 그래프
        SizedBox(height: 20),
        SkeletonWidget(width: 300, height: 65), // 그래프
        SizedBox(height: 20),
        SkeletonWidget(width: 300, height: 65), // 그래프
        SizedBox(height: 20),
        SkeletonWidget(width: 300, height: 65), // 그래프
        SizedBox(height: 10),
      ],
    ),);
}

Widget skeletonResultOpinion(){
  return Container(
    height: 750,
    margin: EdgeInsets.fromLTRB(100, 0, 100, 0),
    constraints: BoxConstraints(
      maxWidth: 300, // 부모가 450보다 크면 최대 450으로 제한
    ),
    child : ListView(
      children: [
        SizedBox(height: 10),

        SkeletonWidget(width: 300, height: 18), // 타이틀
        SizedBox(height: 15),
        SkeletonWidget(width: 300, height: 600), // 타이틀
        SizedBox(height: 32),
        SkeletonWidget(width: 300, height: 18), // 타이틀
        SizedBox(height: 15),
        SkeletonWidget(width: 300, height: 16), // 타이틀
        SizedBox(height: 32),
        SkeletonWidget(width: 300, height: 16), // 타이틀
        SizedBox(height: 32),
      ],
    ),);
}


Widget skeletonResultMatch(){
  return Container(
    margin: EdgeInsets.fromLTRB(100, 0, 100, 0),
    height: 600,
    constraints: BoxConstraints(
      maxWidth: 300, // 부모가 450보다 크면 최대 450으로 제한
    ),
    child : ListView(
      children: [
        SizedBox(height: 55),

        SkeletonWidget(width: 300, height: 25), // 타이틀
        SizedBox(height: 15),
        SkeletonWidget(width: 300, height: 35), // 타이틀
        SizedBox(height: 25),
        SkeletonWidget(width: 300, height: 350), // 타이틀
        SizedBox(height: 15),
      ],
    ),);
}