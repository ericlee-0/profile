import 'package:flutter/material.dart';

TextStyle titleStyle = const TextStyle(
    fontSize: 20, color: Colors.white, fontWeight: FontWeight.w500);

TextStyle subTitleStyle = const TextStyle(
    fontSize: 16, color: Colors.lime, fontWeight: FontWeight.w500);

class HoverText extends StatelessWidget {
  final String? text;
  final Color? color;
  final VoidCallback? selectFn;

  const HoverText({this.text, this.color, this.selectFn, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print('build button rn)');
    return InkWell(
      // hoverColor: Colors.yellow,
      onTap: selectFn!,
      child: Text(
        text!,
        style: TextStyle(
          fontFamily: "myfont",
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

// display list of network images
class ContentImages extends StatelessWidget {
  const ContentImages({super.key, this.images, this.select});
  final Map<String, List>? images;
  final String? select;

  @override
  Widget build(BuildContext context) {
    return Row(
        children: images![select]!
            .map(
              (e) => Row(children: [
                Image.network(
                  e,
                  height: MediaQuery.of(context).size.height * 0.7,
                ),
                const SizedBox(
                  width: 50,
                ),
              ]),
            )
            .toList());
  }
}

//display project descriptions
class ContentDescription extends StatelessWidget {
  const ContentDescription({super.key, this.description, this.select});
  final Map<String, Map>? description;
  final String? select;

  buildTopPaddingText(String text, TextStyle tStyle) {
    return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Text(text, style: tStyle));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('FEATURES',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width >= 700 ? 50 : 35,
              color: Colors.blue[100],
            )),
        const SizedBox(
          height: 20,
        ),
        ...description![select]!['FEATURES']['title']
            .map(
              (value) => buildTopPaddingText(value as String, titleStyle),
            )
            .toList(),
        const SizedBox(
          height: 20,
        ),
        ...description![select]!['FEATURES']['subTitle']
            .map((value) => buildTopPaddingText(value as String, subTitleStyle))
            .toList(),
        const SizedBox(
          height: 50,
        ),
        Text('PARTICIPATIONS',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width >= 700 ? 50 : 35,
              color: Colors.blue[100],
            )),
        const SizedBox(
          height: 20,
        ),
        ...description![select]!['PARTICIPATIONS']
            .map((value) => buildTopPaddingText(value as String, subTitleStyle))
            .toList()
      ],
    );
  }
}

//display menu button list
class DisplayMenu extends StatelessWidget {
  const DisplayMenu({
    super.key,
    required this.menuData,
    required this.select,
    this.onChange,
    required this.selectedColor,
    required this.color,
    this.isRow = true,
  });
  final List menuData;
  final String? select;
  final bool isRow;
  final Color selectedColor;
  final Color color;
  final void Function(String)? onChange;

  List<Widget> _buildMenuList() {
    return menuData
        .asMap()
        .map(
          (i, e) => MapEntry(
            i,
            Row(
              children: [
                HoverText(
                  text: e,
                  selectFn: () {
                    onChange!(e);
                  },
                  color: i == menuData.indexOf(select!) ? selectedColor : color,
                ),
                isRow
                    ? const SizedBox(
                        width: 30,
                      )
                    : const SizedBox(height: 30),
              ],
            ),
          ),
        )
        .values
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return isRow
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildMenuList())
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildMenuList(),
          );
  }
}
