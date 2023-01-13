import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:pile/screens/profile/models/content_model.dart';
import 'package:pile/screens/profile/widgets/content_widgets.dart';
import 'package:flutter/material.dart';

class Desktop extends StatefulWidget {
  const Desktop({Key? key, this.contents}) : super(key: key);
  final ContentModel? contents;
  @override
  _DesktopState createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  String? _selectedMainIndex;
  String? _selectedProject;

  @override
  void initState() {
    super.initState();

    _selectedMainIndex = widget.contents!.menuList![0];
    _selectedProject = widget.contents!.projectList![0];
  }

  buildTopPart() {
    return AppBar(
      backgroundColor: const Color(0xff010101),
      title: DefaultTextStyle(
        style: const TextStyle(fontSize: 35, color: Colors.white, shadows: [
          BoxShadow(
            blurRadius: 7.0,
            color: Colors.white,
            offset: Offset(0, 0),
          )
        ]),
        child: AnimatedTextKit(
          repeatForever: true,
          animatedTexts: [
            FlickerAnimatedText(
              "ERIC YG LEE",
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            )
          ],
          onTap: () {
            // print("onTap");
          },
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 40.0),
          child: DisplayMenu(
            menuData: widget.contents!.menuList!,
            select: _selectedMainIndex,
            onChange: (e) {
              setState(() {
                _selectedMainIndex = e;
              });
            },
            selectedColor: Colors.white,
            color: Colors.blue,
          ),
        )
      ],
    );
  }

  Widget _buildSelectedProject() {
    return Row(
      children: [
        Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Column(
              children: [
                const SizedBox(height: 50),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Container(
                    padding: const EdgeInsets.only(left: 50),
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                        child: ContentImages(
                      images: widget.contents!.images,
                      select: _selectedProject,
                    )),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            )),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 0, 25),
            child: ContentDescription(
              description: widget.contents!.description!,
              select: _selectedProject,
            ),
          ),
        )
      ],
    );
  }

  Widget screens() {
    return IndexedStack(
      index: widget.contents!.menuList!.indexOf(_selectedMainIndex!),
      children: [
        Row(
          children: [
            Expanded(
              flex: 11,
              child: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(20),
                child: ClipOval(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.8),
                            spreadRadius: 10,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 7), // changes position of shadow
                          ),
                        ],
                        color: Colors.transparent,
                        image: const DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/queueing-6931d.appspot.com/o/profile.jpg?alt=media&token=7ae36ff8-4877-4e91-b15b-28f0a626c64e"),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: DefaultTextStyle(
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 20.0,
                      ),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          WavyAnimatedText(
                            "Welcome",
                            textStyle: const TextStyle(
                              fontSize: 100,
                              fontFamily: "myfont",
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        ],
                        isRepeatingAnimation: true,
                        onTap: () {
                          // print("onTap");
                        },
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 200,
                  // ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      'FLUTTER DEVELOPER \nSINCE 2020',
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                // padding: const EdgeInsets.only(right: 40.0),
                padding: const EdgeInsets.all(40.0),
                child: DisplayMenu(
                  menuData: widget.contents!.projectList!,
                  select: _selectedProject,
                  onChange: (e) {
                    setState(() {
                      _selectedProject = e;
                    });
                  },
                  selectedColor: Colors.white,
                  color: Colors.blue[200]!,
                ),
              ),
              _buildSelectedProject(),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('build rn');
    return Scaffold(
      backgroundColor: const Color(0xff010101),
      appBar: buildTopPart(),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: const AssetImage("assets/images/flutter_1.jpeg"),
                fit: BoxFit.fitWidth,
                colorFilter: _selectedMainIndex != 'MAIN'
                    ? ColorFilter.mode(
                        Colors.black.withOpacity(0.4), BlendMode.dstATop)
                    : ColorFilter.mode(
                        Colors.black.withOpacity(1), BlendMode.dstATop),
              )),
              height: MediaQuery.of(context).size.height,
              child: screens())
        ],
      ),
    );
  }
}

class Mobile extends StatefulWidget {
  const Mobile({Key? key, this.contents}) : super(key: key);

  final ContentModel? contents;

  @override
  _MobileState createState() => _MobileState();
}

class _MobileState extends State<Mobile> {
  String? _selectedMainIndex;
  String? _selectedProject;

  @override
  void initState() {
    super.initState();
    _selectedMainIndex = widget.contents!.menuList![0];
    _selectedProject = widget.contents!.projectList![0];
  }

  Widget buildDrawer() {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: SizedBox(
            height: 300,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xff1e1e1e),
                // color: Colors.white
              ),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 2,
                          color: Colors.blueAccent,
                        ),
                        image: const DecorationImage(
                            image: NetworkImage(
                                "https://firebasestorage.googleapis.com/v0/b/queueing-6931d.appspot.com/o/profile.jpg?alt=media&token=7ae36ff8-4877-4e91-b15b-28f0a626c64e"),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "ERIC YG LEE",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: DisplayMenu(
            menuData: widget.contents!.menuList!,
            select: _selectedMainIndex,
            onChange: (e) {
              setState(() {
                _selectedMainIndex = e;
              });
            },
            selectedColor: Colors.white,
            color: Colors.blue,
            isRow: false,
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedProject() {
    return Column(
      children: [
        const SizedBox(height: 50),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Container(
            padding: const EdgeInsets.only(left: 50),
            height: MediaQuery.of(context).size.height * 0.7,
            child: Center(
                // mainAxisAlignment: MainAxisAlignment.center,
                child: ContentImages(
              images: widget.contents!.images,
              select: _selectedProject,
            )),
          ),
        ),
        const SizedBox(height: 50),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 0, 25),
          child: ContentDescription(
            description: widget.contents!.description!,
            select: _selectedProject,
          ),
        )
      ],
    );
  }

  Widget screen() {
    return IndexedStack(
      index: widget.contents!.menuList!.indexOf(_selectedMainIndex!),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "ERIC LEE",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: DefaultTextStyle(
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: "myfont",
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            WavyAnimatedText("Welcome",
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "myfont",
                                  fontWeight: FontWeight.bold,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.1,
                                )),
                          ],
                          isRepeatingAnimation: true,
                          onTap: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'FLUTTER DEVELOPER \nSINCE 2020',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  // padding: const EdgeInsets.only(right: 40.0),
                  padding: const EdgeInsets.all(40.0),
                  child: DisplayMenu(
                    menuData: widget.contents!.projectList!,
                    select: _selectedProject,
                    onChange: (e) {
                      setState(() {
                        _selectedProject = e;
                      });
                    },
                    selectedColor: Colors.white,
                    color: Colors.blue[200]!,
                  ),
                ),
              ),
              _buildSelectedProject()
            ],
          ),
        ),
      ],
    );
  }

  buildTopPaddingText(String text, TextStyle tStyle) {
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(text, style: tStyle));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: buildDrawer(),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: const Color(0xff010101),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/flutter_1.jpeg"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [screen()],
        ),
      ),
    );
  }
}
