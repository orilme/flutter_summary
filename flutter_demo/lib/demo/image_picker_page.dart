import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class ImagePickerPage extends StatefulWidget {
  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  // final List<AssetEntity>? assets = await AssetPicker.pickAssets(context);

  late String textStr;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text("相册选择照片"),
      ),
      body: PhotoTool(
        imageCount: 9,
        lineCount: 3,
      ),
      // body: Column(
      //   crossAxisAlignment: CrossAxisAlignment.center,  //居中
      //   children: [
      //     Padding(padding: EdgeInsets.all(20), child: Text('相册选择照片'),),
      //     OutlinedButton(
      //       child: Text("相册选择照片"),
      //       onPressed: () {
      //         AssetPicker.pickAssets(context);
      //       },
      //     ),
      //   ],
      // ),
    );
  }
}


class PhotoTool extends StatefulWidget {
  @required final int imageCount;//最多几张
  @required  final int lineCount;//一行几个
  //注：最好把图片和文字这些都拿出来，方便更改，这里就不搞了
  const PhotoTool({Key? key, required this.imageCount, required this.lineCount});
  @override
  _PhotoToolState createState() => _PhotoToolState();
}

class _PhotoToolState extends State<PhotoTool> {
  List<AssetEntity> _imageFiles = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: '说明：',
                style: Theme.of(context).textTheme.subtitle2,
                children: [
                  TextSpan(
                    text: '（说明：上传图片，最多${widget.imageCount}张）',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            StaggeredGridView.countBuilder(
              shrinkWrap: true,
              crossAxisCount: widget.lineCount,
              itemCount: _imageFiles.length == widget.imageCount ? _imageFiles.length : _imageFiles.length + 1,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (BuildContext context, int index) {
                if (_imageFiles.length < widget.imageCount && index == 0) {
                  return InkWell(
                    onTap: () => _onPickImage(),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Color(0xFFF6F7F8),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.add,
                            color: Color(0xFFB4B4B4),
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(5),
                        child: InkWell(
                          child: FutureBuilder<File?>(
                            future: _imageFiles[_imageFiles.length < widget.imageCount ? index - 1 : index].file,
                            builder: (context, snapshot) {
                              return snapshot.connectionState ==
                                  ConnectionState.done
                                  ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                  BorderRadius.circular(6.0),
                                  image: DecorationImage(
                                    image: FileImage(snapshot.data!),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              )
                                  : Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius:
                                  BorderRadius.circular(6.0),
                                  color: Color(0xFFF6F7F8),
                                ),
                                child: Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => _deleteImage(
                            _imageFiles.length < widget.imageCount
                                ? index - 1
                                : index),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99.0),
                            color: Colors.red,
                          ),
                          padding: EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.close,
                            size: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
              staggeredTileBuilder: (int index) =>
              new StaggeredTile.count(1, 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            ),
          ],
        ),
      ),
    );
  }
  /// 选择图片
  _onPickImage() async {
    List<AssetEntity>? assets = await AssetPicker.pickAssets(
      context,
      maxAssets: widget.imageCount - _imageFiles.length,
      themeColor: Theme.of(context).primaryColor,
      requestType: RequestType.image,
    );
    if (assets == null || assets.length <= 0) return;
    setState(() {
      _imageFiles.addAll(assets);
    });
  }
  /// 删除图片
  _deleteImage(int index) {
    if (_imageFiles == null || _imageFiles.length <= index) return;
    setState(() {
      _imageFiles.removeAt(index);
    });
  }

}