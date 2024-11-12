import 'package:blca_project_app/controller/home_controller/home_controller_bloc.dart';
import 'package:blca_project_app/controller/home_controller/home_controller_event.dart';
import 'package:blca_project_app/controller/home_controller/home_controller_state.dart';
import 'package:blca_project_app/controller/videoCall/db_controller/video_call_db_blco.dart';
import 'package:blca_project_app/controller/videoCall/db_controller/video_call_db_event.dart';
import 'package:blca_project_app/controller/videoCall/db_controller/video_call_db_state.dart';
import 'package:blca_project_app/logger.dart';
import 'package:blca_project_app/route/route.dart';
import 'package:blca_project_app/view/chat_room_screen.dart';
import 'package:blca_project_app/view/contact_screen.dart';
import 'package:blca_project_app/view/homeScreen/post_screen.dart';
import 'package:blca_project_app/view/setting/widget/network_profile.dart';
import 'package:blca_project_app/view/setting/widget/network_user_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:starlight_utils/starlight_utils.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homePageBloc = context.read<HomePageBloc>();
    final videCalldb = context.read<VideoCallDbBlco>();
    return BlocListener<HomePageBloc, HomeBlocBaseState>(
      listener: (_, state) {
        print("state is $state");
        if (state is HomeLogout) {
          StarlightUtils.pushReplacementNamed(RouteNames.loginPage);
        }
      },
      child: BlocListener<VideoCallDbBlco, VideoCallDbState>(
        listenWhen: (p, c) => p.model?.id != c.model?.id,
        listener: (_, state) {
          logger.i("state of vc is $state");
          if (state is VideoCallDbIncomingState) {
            final result = StarlightUtils.dialog(AlertDialog(
                title: const Text("Incoming Call"),
                content: Text(state.caller!.email ?? state.caller!.uid),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        StarlightUtils.pop(result: true);
                        videCalldb.add(VideoCallDbAcceptedEvent());
                        StarlightUtils.pushNamed(RouteNames.call,
                            arguments: state.model);
                      },
                      child: const Text("Accept")),
                  ElevatedButton(
                      onPressed: () {
                        videCalldb.add(VideoCallDbDeclineEvent(state.model.id));
                        StarlightUtils.pop(result: false);
                      },
                      child: const Text("Decline")),
                ]));
          }
        },
        child: Scaffold(
            appBar: AppBar(
              actions: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          StarlightUtils.pushNamed(RouteNames.search);
                        },
                        icon: const Icon(Icons.search)),
                    IconButton(
                        onPressed: () {
                          StarlightUtils.pushNamed(RouteNames.settingPage);
                        },
                        icon: const Icon(Icons.settings)),
                  ],
                )
              ],
            ),
            drawer: Drawer(
              width: context.width * 0.9,
              child: Padding(
                padding: const EdgeInsets.only(top: 3.0, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DrawerHeader(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NetworkUserInfo(builder: (data) {
                            final shortName = data.email?[0] ?? data.uid[0];
                            // final shortName = data.displayName?[0] ??
                            //     data.email?[0] ??
                            //     data.uid[0];
                            final profileUrl = data.photoURL ?? "";
                            if (profileUrl.isEmpty == true) {
                              return CircleAvatar(
                                maxRadius: 48,
                                child: Text(
                                  shortName,
                                ),
                              );
                            }
                            return NetworkProfile(
                              radius: 42,
                              profileUrl: profileUrl,
                              onFail: CircleAvatar(
                                maxRadius: 42,
                                child: Text(
                                  shortName,
                                ),
                              ),
                            );
                          }),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: NetworkUserInfo(
                              builder: (user) {
                                return Text(
                                    user.displayName?.isNotEmpty == true
                                        ? user.displayName!
                                        : user.email?.isNotEmpty == true
                                            ? user.email!
                                            : "Anonymous",
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: context
                                            .theme.textTheme.bodyLarge?.color));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        ListTile(
                          title: const Text("Profile"),
                          onTap: () {
                            StarlightUtils.pushNamed(RouteNames.profile);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: const Text("Settings"),
                            onTap: () {
                              StarlightUtils.pushNamed(RouteNames.settingPage);
                            },
                          ),
                        ),
                      ],
                    )),
                    ListTile(
                      title: const Text("Logout"),
                      onTap: () {
                        homePageBloc.add(const SignoutEvent());
                      },
                    )
                  ],
                ),
              ),
            ),
            resizeToAvoidBottomInset: false,
            body: PageView.builder(
              controller: homePageBloc.controller,
              itemBuilder: (_, i) {
                return [
                  const ChatRoomListScreen(),
                  const HomePage(),
                  const PostScreen(),
                ][i];
              },
              itemCount: 3,
            ),
            bottomNavigationBar: BlocBuilder<HomePageBloc, HomeBlocBaseState>(
                builder: (_, state) {
              print("state is $state");
              if (state is HomeBlocNavigationState) {
                return BottomNavigationBar(
                    currentIndex: state.index,
                    onTap: (i) {
                      homePageBloc.add(homePageBloc.activate(i));
                    },
                    items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.chat), label: "Chat"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.contact_emergency),
                          label: "Contact"),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings), label: "Post"),
                    ]);
              }
              return const SizedBox();
            })),
      ),
    );
  }
}
