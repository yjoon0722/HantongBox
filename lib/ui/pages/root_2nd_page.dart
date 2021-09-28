import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hantong_cal/helpers/app_config.dart';
import 'package:hantong_cal/main.dart';
import 'package:hantong_cal/models/analytics.dart';
import 'package:hantong_cal/models/keypad.dart';
import 'package:hantong_cal/ui/widgets/SSToast.dart';
import 'package:url_launcher/url_launcher.dart';

final List<String> bannerUrlList = [
  'https://firebasestorage.googleapis.com/v0/b/hantong-calculator-web.appspot.com/o/banner.png?alt=media&token=b50268b6-f5b3-4ee9-8df9-41777ca09b7b',
  'https://images.mypetlife.co.kr/content/uploads/2019/09/06150205/cat-baby-4208578_1920.jpg'
];

class Root2ndPage extends StatelessWidget {
  final PAGE_MODE page_mode;

  final Function function;

  const Root2ndPage({Key key, this.page_mode, this.function}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    double statusBarHeight = MediaQuery.of(context).padding.top;

    final double keypad_padding = 20.0;
    final double keypad_crossAxisSpacing = 10.0;

    return
      Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 0.3, 0.7, 1.0],
                colors: [
                  Color(0xFF084172),
                  Color(0xFF084C82),
                  Color(0xFF084C82),
                  Color(0xFF115999)
                ])),
        child:
        SafeArea(
            top: false,
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: CustomScrollView(
                    physics: page_mode == PAGE_MODE.one ? BouncingScrollPhysics() : NeverScrollableScrollPhysics(),
                    slivers: <Widget>[

                      // 간격
                      SliverPadding(padding: EdgeInsets.only(top: statusBarHeight),),

                      // 토탈 금액 표시하는 텍스트 박스
                      SliverToBoxAdapter(
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(
                                    0.0, 20.0, 0.0, 0.0),
                                padding: const EdgeInsets.all(20.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey, width: 0.5),
                                    borderRadius: BorderRadius.circular(10.0),
                                    color:
                                    Color.fromRGBO(255, 255, 255, 0.90)),
                                child: Text(
                                  "한통 SNS",
                                  style:
                                  Theme.of(context).textTheme.headline4,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                      ),

                      // 키 패드
                      SliverPadding(
                        padding: EdgeInsets.all(keypad_padding),
                        sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                                _buildKeypadItem,
                                childCount: 21),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.6,
                                //(itemWidth * itemHeight),
                                crossAxisSpacing: keypad_crossAxisSpacing,
                                mainAxisSpacing: 10.0)),
                      ),

                      // 키 패드
                      SliverPadding(
                        padding:
                        const EdgeInsets.fromLTRB(20.0, 20, 20.0, 55.0),
                        sliver: SliverGrid(
                            delegate: SliverChildBuilderDelegate(
                                _buildKeypadItem_AD,
                                childCount: 9),
                            gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                childAspectRatio: 1.6,
                                crossAxisSpacing: keypad_crossAxisSpacing,
                                mainAxisSpacing: 10.0)),
                      ),

                      // 버전표시
                      /*
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(
                                    0.0, 20.0, 0.0, 0.0),
                                padding: const EdgeInsets.all(20.0),
                                //decoration: BoxDecoration(
                                //    border: Border.all(color: Colors.grey, width: 0.5),
                                //    borderRadius: BorderRadius.circular(10.0),
                                //    color: Color.fromRGBO(255, 255, 255, 0.85)
                                //),
                                child: Text(
                                  app_version,
                                  style: Theme.of(context).textTheme.headline6,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          */

                    ],
                  ),
                ),

                // 배너창
                /*
                    CarouselSlider(
                      height: bannerHeight,
                      viewportFraction: 1.0,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 10),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      scrollPhysics: NeverScrollableScrollPhysics(),
                      items: bannerUrlList.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return GestureDetector(
                              onTap: () {
                                print("onTap");
                                //_launchURL(i);
                              },
                              child: Container(
                                width: bannerWidth,
                                height: bannerHeight,
                                child: FadeInImage.assetNetwork(
                                    width: bannerWidth,
                                    height: bannerHeight,
                                    fit: BoxFit.cover,
                                    placeholder: 'assets/img/banner.png',
                                    image: i),
                              ),
                            );
                          },
                        );
                      }).toList(),
                    )
                // */
              ],
            )
        ),
      );
  }

  // 상단 - 키패드
  Widget _buildKeypadItem(BuildContext context, int index) {
    Keypad keypad = null;
    switch (index) {
      case 0:
        keypad = Keypad(id: 0,
          title: "스토어팜",
          detail: "https://smartstore.naver.com/hantongbox/",
          imagePath: 'assets/img_btn/button_bg_storefarm.png',
          backgroundColor: Colors.orange,
          textColor: Colors.white,);
        break;
      case 1:
        keypad = Keypad(id: 1,
          title: "블로그",
          detail: "https://blog.naver.com/hantongbox/",
          imagePath: 'assets/img_btn/button_bg_naverblog.png',);
        break;
      case 2:
        keypad = Keypad(id: 2,
          title: "홈페이지",
          detail: "http://zangzip.com/",
          imagePath: 'assets/img_btn/button_bg_zangzip.png',
          backgroundColor: Colors.red,
          textColor: Colors.white,);
        break;
      case 3:
        keypad = Keypad(id: 3,
          title: "유튜브",
          detail: "https://www.youtube.com/channel/UCjrBfjIiNMECA5Xje4N9W4g",
          imagePath: 'assets/img_btn/button_bg_youtube.png',
          backgroundColor: Colors.deepOrange,
          textColor: Colors.white,);
        break;
      case 4:
        keypad = Keypad(id: 4,
          title: "네이버TV ",
          detail: "https://tv.naver.com/hantongbox",
          imagePath: 'assets/img_btn/button_bg_navertv.png',
          backgroundColor: Colors.green,
          textColor: Colors.white,);
        break;
      case 5:
        keypad = Keypad(id: 5,
          title: "인스타그램",
          detail: "https://www.instagram.com/hantongbox",
          imagePath: 'assets/img_btn/button_bg_instagram.png',
          backgroundColor: Color(0xFFB74093),
          textColor: Colors.white,);
        break;
      case 6:
        keypad = Keypad(id: 6,
          title: "페이스북",
          detail: "https://www.facebook.com/hantongbox",
          imagePath: 'assets/img_btn/button_bg_facebook.png',
          backgroundColor: Colors.indigoAccent,
          textColor: Colors.white,);
        break;
      case 7:
        keypad = Keypad(id: 7,
          title: "카카오스토리",
          detail: "https://story.kakao.com/hantongbox",
          imagePath: 'assets/img_btn/button_bg_kakaostory.png',
          backgroundColor: Colors.yellow,);
        break;
      case 8:
        keypad = Keypad(id: 8,
          title: "트위터",
          detail: "https://twitter.com/hantongbox",
          imagePath: 'assets/img_btn/button_bg_twitter.png',
          backgroundColor: Colors.lightBlueAccent,
          textColor: Colors.white,);
        break;
      case 9:
        keypad = Keypad(id: 9,
          title: "한통도시락",
          detail: "https://hantong.modoo.at/",
          imagePath: 'assets/img_btn/button_bg_modoo.png',);
        break;
      case 10:
        keypad = Keypad(id: 10,
          title: "(주) 한통",
          detail: "https://zangzip.modoo.at/",
          imagePath: 'assets/img_btn/button_bg_modoo.png',);
        break;
      case 11:
        keypad = Keypad(id: 11,
          title: "착한나눔",
          detail: "http://goodshare.net/",
          imagePath: 'assets/img_btn/button_bg_goodshare.png',);
        break;
      case 12:
        keypad = Keypad(id: 12,
          title: "테스트",
          detail: "https://hantongbox.modoo.at/",
          imagePath: 'assets/img_btn/button_bg_modoo.png',);
        break;
      case 13:
        keypad = Keypad(id: 13,
          title: "크리에이터",
          detail: "http://hantong.creatorlink.net/",
          imagePath: 'assets/img_btn/button_bg_creatorlink.png',);
        break;
      case 14:
        keypad = Keypad(id: 14,
          title: "지도분포도",
          detail:"https://www.google.com/maps/d/u/0/edit?mid=1xGMLSzOY2im1T7hGAT0VSP6aPpM&ll=37.170501904964965%2C127.29979399251863&z=8",
          imagePath: 'assets/img_btn/button_bg_map.png',);
        break;
      case 15:
        keypad = Keypad(id: 15,
          title: "이카운트",
          detail: "https://login.ecounterp.com/",
          imagePath: 'assets/img_btn/button_bg_ecount.png',);
        break;
      case 16:
        keypad = Keypad(id: 16,
          title: "아이파킹",
          detail: "http://members.iparking.co.kr/",
          imagePath: 'assets/img_btn/button_bg_iparking.png',);
        break;
      case 17:
        keypad = Keypad(id: 17,
          title: "화물차비용",
          detail: "https://www.1truck.co.kr/price-inquiry/",
          imagePath: 'assets/img_btn/button_bg_1truck.png',);
        break;
      case 18:
        keypad = Keypad(id: 18,
          title: "텍스토리",
          detail: "https://www.textory.io",
          imagePath: '',);
        break;
      case 19:
        keypad = Keypad(id: 19,
          title: "빠방넷",
          detail: "http://ppabang.net/",
          imagePath: '');
        break;
      case 20:
        keypad = Keypad(id: 29,
            title: "한스트리",
            detail: "http://hanstree.com/",
            imagePath: '');
        break;
      default:
        break;
    }

    if (keypad == null) { return null; }

    return _buildImageKeypad(context, keypad);
  }

  // 하단 - 키패드
  Widget _buildKeypadItem_AD(BuildContext context, int index) {
    Keypad keypad = null;
    switch (index) {
      case 0:
        keypad = Keypad(id: 100,
            title: "비율계산기",
            detail: "http://zangzip.com/math/",
            imagePath: 'assets/img_btn/button_bg_abxy.png',);
        break;
      case 1:
        keypad = Keypad(id: 104,
          title: "인투샵",
          detail: 'http://intosharp.com',
          imagePath: 'assets/img_btn/button_bg_intosharp.png',);
        break;
      case 2:
        keypad = Keypad(id: 105,
          title: "AGAG",
          detail: 'https://aagag.com/mirror/',
          imagePath: 'assets/img_btn/button_bg_agag.png',);
        break;

      case 3:
        keypad = Keypad(id: 103,
          title: "Delivery Tracker",
          detail: "https://hantondeliverytrack.web.app/",
          imagePath: "assets/img_btn/button_bg_deliverytracker.png");
          // detail: "https://www.facebook.com/daesun.hong.58",
          // imagePath: 'assets/img_btn/button_bg_hong.png',);
        break;
      case 4:
        keypad = Keypad(id: 106,
          title: "망고보드",
          detail: 'https://www.mangoboard.net/',
          imagePath: 'assets/img_btn/button_bg_mangoboard.png',);
        break;
      case 5:
        keypad = Keypad(id: 108,
          title: "네이버톡톡",
          detail: 'https://partner.talk.naver.com/',
          imagePath: 'assets/img_btn/button_bg_partnertalktalk.png',
        );
        break;
      case 6:
        keypad = Keypad(id: 101,
            title: "App Store",
            detail: "https://apps.apple.com/id1502003463",
            imagePath: 'assets/img_btn/button_bg_apple.png',);
        break;
      case 7:
        keypad = Keypad(id: 107,
          title: App.version,
          detail: 'https://hantongcalcrawl.web.app/#/',
          imagePath: 'assets/img_btn/button_bg_hantongbox.png',);
        break;
      case 8:
        keypad = Keypad(id: 102,
            title: "Google Play",
            detail:"https://play.google.com/store/apps/details?id=com.heron.hantong_cal&hl=ko&ah=-1UV2GqKV6slrPC0WPDncQPQL-A",
            imagePath: 'assets/img_btn/button_bg_googleplay.png',);
        break;
      default:
        break;
    }

    return _buildImageKeypad(context, keypad);
  }

  // 키패드
  /*
  _buildKeyPad(BuildContext context, Keypad keypad,
      [String assetImagePath = '']) {
    var size = MediaQuery.of(context).size;

    final double keypad_padding = 20.0;
    final double keypad_crossAxisSpacing = 10.0;
    final double itemWidth =
        (size.width / 3) - keypad_padding - keypad_crossAxisSpacing;
    print('itemWidth: $itemWidth');
    final double itemHeight = itemWidth;
    print('itemHeight: $itemHeight');
    print('itemHeight: ${itemWidth / itemHeight}');

    print(keypad.title);

    if (assetImagePath.isEmpty) {
      return Stack(children: <Widget>[
        new Positioned.fill(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  color: MyApp.btnBackgroundColor,
                ))),
        new Positioned.fill(
            child: MaterialButton(
          onLongPress: () => _keypadLongPressed(context, keypad),
          onPressed: () => _keypadPressed(context, keypad, false),
          textColor: keypad.textColor,
          child: Container(
            child: Text(
              keypad.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ),
        ))
      ]);
    } else {
      return Stack(children: <Widget>[
        new Positioned.fill(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                    color: MyApp.btnBackgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: itemWidth * 0.18,
                          height: itemWidth * 0.18,
                          child: Image(
                            image: AssetImage(assetImagePath),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          keypad.title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2,
                        )
                      ],
                    )))),
        new Positioned.fill(
            child: MaterialButton(
          onLongPress: () => _keypadLongPressed(context, keypad),
          onPressed: () => _keypadPressed(context, keypad, false),
          //color: Colors.white,
          textColor: keypad.textColor,
          //child: Container(
          //  child: Text(keypad.id < 9 ? '' : keypad.title, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2,),
          //),
        ))
      ]);
    }
  }
  */

  // 이미지 키패드
  _buildImageKeypad(BuildContext context, Keypad keypad) {
    return Container(
        decoration: BoxDecoration(
          color: MyApp.btnBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: LayoutBuilder(builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;
          String imagePath = keypad.imagePath;

          if (imagePath.isEmpty) {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned.fill(
                  child: MaterialButton(
                    onLongPress: () => _keypadLongPressed(context, keypad),
                    onPressed: () => _keypadPressed(context, keypad, false),
                    textColor: keypad.textColor,
                    child: Text(keypad.title,textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2,),
                  ),
                )
              ],
            );
          } else {
            return Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: 0, width: width * 0.45, height: height * 0.8,
                  child: Container(
                    margin: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      image: DecorationImage(fit: BoxFit.fitWidth, image:AssetImage(imagePath),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0, right: 0, bottom: 0, height: height * 0.28,
                  child: Container(
                    child: Text(keypad.title,textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyText2,),
                  ),
                ),
                Positioned.fill(
                  child: MaterialButton(
                    onLongPress: () => _keypadLongPressed(context, keypad),
                    onPressed: () => _keypadPressed(context, keypad, false),
                    textColor: keypad.textColor,
                  ),
                )
              ],
            );
          }
        }),
      );
  }

  // Action - 키패드 롱터치
  _keypadLongPressed(BuildContext context, Keypad keypad) {
    if (keypad.detail.isEmpty) { return; }
    _launchURL(keypad.detail);
  }

  // Action - 키패드 터치
  _keypadPressed(BuildContext context, Keypad keypad, bool isDoublePressed) {
    if (keypad.detail.isEmpty) { return; }
    showToast("${keypad.title}\n주소가 복사되었습니다.", context);
    Clipboard.setData(ClipboardData(text: keypad.detail));
  }

  // 웹화면
  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // 토스트 메세지
  void showToast(String msg, BuildContext context,{int duration, int gravity}) {
    SSToast.show(msg, context,
        duration: SSToast.LENGTH_SHORT, gravity: SSToast.CENTER);
  }
}
