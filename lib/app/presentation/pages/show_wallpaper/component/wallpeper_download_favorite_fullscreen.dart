// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:wallpaper_app/app/domain/entity/media.dart';
import 'package:wallpaper_app/app/domain/entity/photo_entity.dart';
import 'package:wallpaper_app/app/domain/entity/video_entity.dart';
import 'package:wallpaper_app/core/enum/type_file.dart';
import 'package:wallpaper_app/core/routers/routes_name.dart';

class WallpaperDownloadFavoriteFullScreen extends StatefulWidget {
  Media media;
  WallpaperDownloadFavoriteFullScreen({super.key, required this.media});

  @override
  State<WallpaperDownloadFavoriteFullScreen> createState() =>
      _WallpaperDownloadFavoriteFullScreenState();
}

class _WallpaperDownloadFavoriteFullScreenState
    extends State<WallpaperDownloadFavoriteFullScreen>
    with AutomaticKeepAliveClientMixin {
  bool isFavorite = false;
  ImageProvider<Object>? imageSuccess;
  bool isShowDownload = true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        widget.media is PhotoEntity
            ? _imageBody(widget.media as PhotoEntity)
            : _videoBody(widget.media as VideoEntity),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 50,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () {
                  _onFavorite();
                }),
            IconButton(
                icon: const Icon(
                  Icons.fullscreen,
                  size: 50,
                  color: Colors.white,
                ),
                onPressed: () {
                  _onFullScreen();
                }),
            InkWell(
                onTap: () {
                  _onTapDownload();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 13,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  alignment: Alignment.center,
                  child: Text(
                    isShowDownload ? "Download" : "Apply",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ))
          ],
        )
      ],
    );
  }

  Widget _imageBody(PhotoEntity photo) {
    return CachedNetworkImage(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      imageUrl: photo.src!,
      imageBuilder: (context, imageProvider) {
        imageSuccess = imageProvider;
        return Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image:
                  DecorationImage(image: imageProvider, fit: BoxFit.fitHeight)),
        );
      },
      placeholder: (context, url) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.transparent.withOpacity(0.1),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }

  Widget _videoBody(VideoEntity video) {
    return Container();
  }

  void _onFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  void _onFullScreen() {
    if (imageSuccess != null && widget.media is PhotoEntity) {
      final photo = widget.media as PhotoEntity;
      Navigator.pushNamed(context, RoutesName.kFullScreenWallpaper, arguments: {
        "type": TypeFile.image,
        "imageProvider": imageSuccess,
        "url": photo.src
      });
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  void _onTapDownload() {
    if (isShowDownload) {
      setState(() {
        isShowDownload = false;
      });
    } else {
      print('Apply wallpeper');
    }
  }
}
