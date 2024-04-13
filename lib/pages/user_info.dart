import 'package:flutter/material.dart';

class UserInfoPage extends StatelessWidget {
  const UserInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Information', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green, // Changed app bar color to match UserPage
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
              Colors.green.shade100,
              Colors.green.shade300,
              ],
            ),
          ),
          child: Center(
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              margin: const EdgeInsets.all(32),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/images/user.jpg'),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Diyarbek',
                                style: Theme.of(context).textTheme.headline5?.copyWith(color: Colors.black),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'diyarbekoralbaev@gmail.com',
                                style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.black, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    ListTile(
                      leading: const Icon(Icons.school, color: Colors.blue),
                      title: const Text('Student Status'),
                      subtitle: Text('Grant: True', style: TextStyle(color: Colors.black)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.school_outlined, color: Colors.blue),
                      title: const Text('Degree'),
                      subtitle: Text('Bachelor\'s Degree', style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
