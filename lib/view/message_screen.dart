import 'package:flutter/material.dart';
import 'package:starlight_utils/starlight_utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: TextButton(onPressed: () {}, child: const Text("Edit")),
        actions: [
          OutlinedButton.icon(
            onPressed: () async {},
            label: const Text("New"),
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                isDense: true,
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (_, i) {
                    return const SizedBox(
                      height: 1,
                    );
                  },
                  itemCount: 20,
                  itemBuilder: (_, i) {
                    return MessagePost(name: "$i", message: "abacajfkjaljfkj");
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagePost extends StatelessWidget {
  final String name, message;
  const MessagePost({super.key, required this.name, required this.message});

  @override
  Widget build(BuildContext context) {
    final double width = context.width;
    final double height = context.height * 0.1;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10),
        child: SizedBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 25,
                    child: Icon(Icons.person),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(name),
                        Text(message),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Container(
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.green),
                  width: 16,
                  height: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
