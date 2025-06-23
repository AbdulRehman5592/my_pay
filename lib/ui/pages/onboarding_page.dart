import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mypay/data/repo/user_repo.dart';
import 'package:mypay/theme.dart';
import 'package:mypay/ui/pages/signup.dart';
import 'package:mypay/ui/pages/signin.dart';
import 'package:sqflite/sqflite.dart';

import '../../data/helpers/database_helper.dart';
import '../../data/models/user.dart';
import 'user_dashboard.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({Key? key}) : super(key: key);

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final dbHelper = DatabaseHelper.instance;
  late final users;
  UserRepository user = UserRepository();
  User userModel = User(
    userId: '1',
    email: 'asd@gmail.com',
    hashedPassword: '123456',
    fullName: 'John Doe',
    phone: '1234567890',
  );

  int currentIndex = 0;
  CarouselSliderController controller = CarouselSliderController();
  List<String> titles = [
    'Grow Your\nFinancial Today',
    'Build From\nZero to Freedom',
    'Start Together'
  ];

  List<String> subtitles = [
    'Our system is helping you to\nachieve a better goal',
    'We provide tips for you so that\nyou can adapt easier',
    'We will guide you to where\nyou wanted it too'
  ];
  Future<void> _initializeDatabase() async {
    final db = await dbHelper.database;
    String path = await getDatabasesPath();
    users = await user.getAllUsers();
    debugPrint(
        " dibbs$path"); // Example query to ensure the database is initialized
  }

  Future<void> getUsers() async {
    debugPrint(users.toString());
  }

  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider(
                items: [
                  Image.asset(
                    'assets/images/img_onboarding_1.png',
                  ),
                  Image.asset(
                    'assets/images/img_onboarding_2.png',
                  ),
                  Image.asset(
                    'assets/images/img_onboarding_3.png',
                  )
                ],
                carouselController: controller,
                options: CarouselOptions(
                    height: 305,
                    viewportFraction: 1,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    }),
              ),
              const SizedBox(height: 80),
              Container(
                width: 327,
                height: 294,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 22),
                decoration: BoxDecoration(
                    color: whiteColor, borderRadius: BorderRadius.circular(20)),
                child: Column(
                  children: [
                    Text(
                      titles[currentIndex],
                      textAlign: TextAlign.center,
                      style: blackTextStyle.copyWith(
                          fontSize: 20, fontWeight: semiBold),
                    ),
                    const SizedBox(height: 26),
                    Text(
                      subtitles[currentIndex],
                      textAlign: TextAlign.center,
                      style: greyTextStyle.copyWith(
                          fontSize: 16, fontWeight: regular),
                    ),
                    SizedBox(height: currentIndex == 2 ? 38 : 50),
                    currentIndex == 2
                        ? Column(
                            children: [
                              SizedBox(
                                width: 283,
                                height: 50,
                                child: TextButton(
                                  onPressed: () {
                                    //user.insertUser(userModel);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const SignUpScreen()),
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                      backgroundColor: purpleColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(56))),
                                  child: Text('Get Started',
                                      style: whiteTextStyle.copyWith(
                                          fontSize: 16, fontWeight: semiBold)),
                                ),
                              ),
                              const SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SignInScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign In',
                                  style: greyTextStyle.copyWith(
                                      fontSize: 16, fontWeight: regular),
                                ),
                              )
                            ],
                          )
                        : Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentIndex == 0
                                        ? blueColor
                                        : bulletBackgroundColor),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentIndex == 1
                                        ? blueColor
                                        : bulletBackgroundColor),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: currentIndex == 2
                                        ? blueColor
                                        : bulletBackgroundColor),
                              ),
                              const Spacer(),
                              SizedBox(
                                  width: 150,
                                  height: 50,
                                  child: TextButton(
                                    onPressed: () {
                                      controller.nextPage();
                                    },
                                    style: TextButton.styleFrom(
                                        backgroundColor: purpleColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(56))),
                                    child: Text(
                                      'Continue',
                                      style: whiteTextStyle.copyWith(
                                          fontSize: 16, fontWeight: semiBold),
                                    ),
                                  ))
                            ],
                          )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
