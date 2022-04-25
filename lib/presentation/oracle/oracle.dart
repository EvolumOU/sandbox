import 'package:auto_size_text/auto_size_text.dart';
import 'package:evolum_package/main.dart';
import 'package:evolum_package/model/oracle.dart';
import 'package:flutter/material.dart';

class OracleScreen extends StatefulWidget {
  const OracleScreen({Key? key}) : super(key: key);

  @override
  State<OracleScreen> createState() => _OracleState();
}

class _OracleState extends State<OracleScreen> {
  Oracle oracle = Oracle(
    name: 'Name',
    text: 'Texte',
  );

  List<Color> colors = [kevoElectric, kevoViolet, kevoYellow];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0, 0.5, 1],
            colors: colors,
          ),
        ),
        width: MediaQuery.of(context).size.width * 0.75,
        height: MediaQuery.of(context).size.height * 0.7,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: kevoWhite,
              borderRadius: BorderRadius.circular(28),
            ),
            child: FadeInOutTransitionner(
              child: oracle != null
                  ? OracleCardContent(
                      oracle: oracle,
                    )
                  : const DrawingCourse(
                      id: 'oracle',
                      blackOnly: true,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class OracleCardContent extends StatelessWidget {
  final Oracle? oracle;

  const OracleCardContent({Key? key, this.oracle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 34,
          fontWeight: FontWeight.w500,
          color: kevoBlack,
        );
    final textStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 21,
          fontWeight: FontWeight.w500,
          height: 1.5,
          color: kevoBlack,
        );
    final headerStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
          fontSize: 17,
          fontWeight: FontWeight.w500,
          color: kevoBlack,
        );

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Gautier",
                style: headerStyle,
              ),
              const SizedBox(height: 5),
              Text(DateTime.now().toDayMonth, style: headerStyle),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: AutoSizeText(
              oracle!.name,
              style: titleStyle,
              maxLines: 1,
            ),
          ),
          EntranceFader(
            offset: Offset.zero,
            delay: const Duration(milliseconds: 400),
            child: AutoSizeText(
              oracle!.text,
              style: textStyle,
              textAlign: TextAlign.center,
              maxLines: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class DrawingCourse extends StatelessWidget {
  final String? id;
  final bool big;
  final bool blackOnly;
  final BoxFit? fit;
  final bool random;
  const DrawingCourse({
    Key? key,
    this.id,
    this.big = true,
    this.blackOnly = false,
    this.fit,
    this.random = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = false;

    const blackUrl =
        "https://firebasestorage.googleapis.com/v0/b/evolum-936c6.appspot.com/o/drawing%2Fbig%2Fblack%2Fguidance.png?alt=media&token=77b707c8-3371-4107-b449-f5db172bb070";
    const whiteUrl =
        "https://firebasestorage.googleapis.com/v0/b/evolum-936c6.appspot.com/o/drawing%2Fbig%2Fwhite%2Fguidance.png?alt=media&token=024944a5-36ad-4291-befd-d71dbeec20ec";

    return Image.network(isDark ? blackUrl : whiteUrl, fit: fit);
  }
}
