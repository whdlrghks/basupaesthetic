import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';

class CameraPage extends StatefulWidget {
  final double initialZoom;

  CameraPage({this.initialZoom = 1.8});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraInitialized = false;
  double _zoomLevel = 1.0;
  double _maxZoom = 1.0;

  /// **여러 장**을 저장할 리스트
  List<html.File> takenFiles = [];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      final backCamera = _cameras.firstWhere(
        (desc) => desc.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras.isNotEmpty
            ? _cameras[0]
            : throw Exception("No cameras found"),
      );

      // ❷ 컨트롤러를 '후면 카메라'로 초기화
      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController.initialize();

      final minZoom = await _cameraController.getMinZoomLevel();
      final maxZoom = await _cameraController.getMaxZoomLevel();
      setState(() {
        _zoomLevel = widget.initialZoom; // e.g. 1.8
        if (_zoomLevel < minZoom) _zoomLevel = minZoom;
        if (_zoomLevel > maxZoom) _zoomLevel = maxZoom;
        _maxZoom = maxZoom;
        _isCameraInitialized = true;
      });

      // 줌 고정
      try {
        await _cameraController.setZoomLevel(_zoomLevel);
      } catch (e) {
        print("setZoomLevel error: $e");
      }
    }
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  /// 사진 촬영
  Future<html.File?> _takePicture() async {
    if (!_cameraController.value.isInitialized) return null;
    try {
      XFile xfile = await _cameraController.takePicture();
      final bytes = await xfile.readAsBytes();
      final fileName = "camera_${DateTime.now().millisecondsSinceEpoch}.jpg";
      final file = html.File([bytes], fileName, {'type': 'image/jpeg'});
      return file;
    } catch (e) {
      print("Error taking picture: $e");
      return null;
    }
  }

  /// 여러 장 촬영 -> takenFiles 리스트에 추가
  Future<void> _onCapture() async {
    final file = await _takePicture();
    if (file != null) {
      setState(() {
        takenFiles.add(file);
      });
    }
  }

  /// 확인(종료) -> 여러 장 파일 리스트 반환
  void _onConfirm() {
    if (takenFiles.isNotEmpty) {
      Get.back(result: takenFiles);
    } else {
      // 아무것도 없으면 그냥 닫기
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraInitialized
          ? Stack(
              children: [
                /// 카메라 미리보기 (전 화면)
                Positioned.fill(
                  child: CameraPreview(_cameraController),
                ),

                /// 촬영 & 확인 버튼 (하단)
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // 촬영 버튼 (카메라 아이콘)
                      IconButton(
                        onPressed: _onCapture,
                        icon: Icon(Icons.camera_alt),
                        iconSize: 60,
                        color: Colors.white,
                      ),

                      // 확인 버튼 (체크 아이콘)
                      IconButton(
                        onPressed: _onConfirm,
                        icon: Icon(Icons.check),
                        iconSize: 60,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                // 썸네일 영역 (오른쪽 상단에 미리보기 등 가능)
                Positioned(
                  top: 40,
                  right: 10,
                  child: _buildThumbnailPreview(),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Future<String> _convertFileToDataUrl(html.File file) async {
    final reader = html.FileReader();
    final completer = Completer<String>();
    reader.onLoadEnd.listen((_) {
      completer.complete(reader.result as String);
    });
    reader.readAsDataUrl(file);
    return completer.future;
  }

  /// 여러 장 찍은 썸네일 간단 표시
  Widget _buildThumbnailPreview() {
    if (takenFiles.isEmpty) {
      return const SizedBox.shrink();
    }

    // 최신 5개만 보이기
    final filesToShow = takenFiles.take(5).toList();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filesToShow.length,
        itemBuilder: (context, index) {
          final file = filesToShow[index];
          return FutureBuilder<String>(
            future: _convertFileToDataUrl(file),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  width: 80,
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final dataUrl = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    dataUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
