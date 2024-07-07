import 'package:blca_project_app/injection.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NetworkProfile extends StatelessWidget {
  final Widget onFail;
  final String profileUrl;
  final double? radius;

  const NetworkProfile({
    super.key,
    required this.profileUrl,
    required this.radius,
    required this.onFail,
  });

  double get _radius => radius ?? 42;

  @override
  Widget build(BuildContext context) {
    // if (profileUrl.startsWith("http")) {
    //   return CircleAvatar(
    //     maxRadius: radius,
    //     backgroundImage: CachedNetworkImageProvider(profileUrl),
    //   );
    // }

    return FutureBuilder(
      key: ValueKey(profileUrl),
      future: Injection.get<FirebaseStorage>().ref(profileUrl).getDownloadURL(),
      builder: (_, snap) {
        return ClipOval(
          child: CachedNetworkImage(
            width: _radius,
            height: _radius,
            fit: BoxFit.cover,
            imageUrl: snap.data ?? '',
            placeholder: (_, s) => const CircleAvatar(
              child: Align(
                child: CupertinoActivityIndicator(),
              ),
            ),
            errorWidget: (_, s, b) => onFail,
          ),
        );
      },
    );
  }
}
