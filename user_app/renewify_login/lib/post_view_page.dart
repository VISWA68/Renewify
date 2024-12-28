import 'package:Renewify/complaint.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'biogas_services.dart';
import 'dashboard.dart';
import 'main.dart';
import 'monitoring.dart';
import 'post_model.dart'; // Ensure this path is correct
import 'post_write_page.dart'; // Ensure this path is correct
import 'dart:io';

import 'settings.dart';
import 'shop.dart';
import 'solarservices.dart';
import 'subsidies.dart'; // Import to handle File

class PostViewPage extends StatefulWidget {
  @override
  _PostViewPageState createState() => _PostViewPageState();
}

class _PostViewPageState extends State<PostViewPage> {
  List<Post> staticPosts = [
    Post(
      'Solar Energy is a renewable resource. It can be harnessed using solar panels.',
      imageUrl:
          'https://www.renewableenergyworld.com/wp-content/uploads/2022/12/perovskite.jpg',
    ),
    Post(
      'சோலார் பேனல்களை கூரைகள் அல்லது சோலார் பண்ணைகளில் நிறுவி மின்சாரம் தயாரிக்கலாம்.',
      imageUrl:
          'https://cdn.pixabay.com/photo/2024/02/24/10/48/solar-panels-8593759_1280.png',
    ),
    Post(
      'बायोगैस का उत्पादन कार्बनिक पदार्थों के अपघटन से होता है। इसका उपयोग खाना पकाने और बिजली उत्पादन के लिए किया जा सकता है।',
      imageUrl:
          'https://img.freepik.com/free-vector/industry-biogas-illustration_23-2149397907.jpg?size=626&ext=jpg&ga=GA1.1.2008272138.1721520000&semt=ais_user',
    ),
  ];

  List<Post> dynamicPosts = [];

  void _toggleLike(int index) {
    setState(() {
      if (index < dynamicPosts.length) {
        // Toggle like for dynamic posts
        dynamicPosts[index].isLiked = !dynamicPosts[index].isLiked;
      } else {
        // Toggle like for static posts
        int staticIndex = index - dynamicPosts.length;
        staticPosts[staticIndex].isLiked = !staticPosts[staticIndex].isLiked;
      }
    });
  }

  void _addPost(String text, String? imageUrl) {
    setState(() {
      dynamicPosts.insert(0, Post(text, imageUrl: imageUrl));
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Post> allPosts = [...dynamicPosts, ...staticPosts];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade300,
        title: Text('Solar Services'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostWritePage(
                    onPostCreated: _addPost,
                  ),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: FaIcon(FontAwesomeIcons.globe),
            onSelected: (String value) {
              if (value == 'en') {
                MyApp.of(context)!.setLocale(const Locale('en'));
              } else if (value == 'ta') {
                MyApp.of(context)!.setLocale(const Locale('ta'));
              } else if(value =='hi'){
                MyApp.of(context)!.setLocale(const Locale('hi'));
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'en',
                child: Text('English'),
              ),
              const PopupMenuItem<String>(
                value: 'ta',
                child: Text('Tamil'),
              ),
              const PopupMenuItem<String>(
                value: 'hi',
                child: Text('Hindi'),
              ),
            ],
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(12.0),
          child: Padding(
            padding: const EdgeInsets.only(top: 2.0),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.only(top: 15.0), // Adjust top padding here
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                        );
                      },
                      child: Image.asset(
                        'assets/images/logo1.png', 
                        height: 40, 
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Dashboard()),
                        );
                      },
                      child: Text(
                        'RENEWIFY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20, 
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Dashboard()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.wb_sunny),
              title: Text('Solar Installation'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SolarServices(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.attach_money),
              title: Text('Subsidies /Loans'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubsidiesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.warning_rounded),
              title: Text('Complaint'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ComplaintPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.electric_bolt),
              title: Text('Electricity'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SolarElectricityMonitoringPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.podcasts),
              title: Text('Green Edge'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostViewPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Energy Market'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShopPage()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountSettingsPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 125, 253, 245), // Light green
              Color.fromARGB(255, 59, 200, 186), // Dark green
            ],
            stops: [0.0, 1.0],
          ),
        ),
        child: allPosts.isEmpty
            ? const Center(
                child:
                    Text('No posts yet', style: TextStyle(color: Colors.white)))
            : ListView.builder(
                itemCount: allPosts.length,
                itemBuilder: (context, index) {
                  final post = allPosts[index];
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (post.imageUrl != null)
                          post.imageUrl!.startsWith('http')
                              ? Image.network(
                                  post.imageUrl!,
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(
                                  File(post.imageUrl!),
                                  height: 150,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                        const SizedBox(height: 10),
                        Text(
                          post.text,
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          post.createdAt.toString(),
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.thumb_up,
                                color: post.isLiked ? Colors.red : Colors.grey,
                              ),
                              onPressed: () => _toggleLike(index),
                            ),
                            IconButton(
                              icon:
                                  const Icon(Icons.comment, color: Colors.grey),
                              onPressed: () {
                                // Add your comment functionality here
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
