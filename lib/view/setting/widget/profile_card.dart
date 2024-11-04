import 'package:blca_project_app/view/setting/widget/network_profile.dart';
import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class ProfileCard extends StatelessWidget {
  final String profileUrl, shortName, displayName, email;

  const ProfileCard({
    super.key,
    required this.profileUrl,
    required this.shortName,
    required this.displayName,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final textColor = theme.textTheme.bodyLarge?.color;
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
        left: 10,
        right: 10,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        borderRadius:
            BorderRadius.circular(8), // Color.fromRGBO(r, g, b, opacity)
      ),
      child: Row(
        children: [
          if (profileUrl.isEmpty == true)
            CircleAvatar(
              maxRadius: 35,
              child: Text(shortName,
                  style: TextStyle(fontSize: 28, color: textColor)),
            )
          else
            NetworkProfile(
              radius: 35,
              onFail: CircleAvatar(
                maxRadius: 35,
                child: Text(
                  shortName,
                  style: TextStyle(
                    fontSize: 28,
                    color: textColor,
                  ),
                ),
              ),
              profileUrl: profileUrl,
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    email,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const IconButton(
            onPressed: null,
            icon: Icon(Icons.chevron_right),
          )
        ],
      ),
    );
  }
}
