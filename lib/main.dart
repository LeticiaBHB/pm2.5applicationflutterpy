import 'package:flutter/material.dart';
import 'package:flutter_collapsing_toolbar/flutter_collapsing_toolbar.dart';
import 'package:lottie/lottie.dart';
import 'dados.dart';
import 'package:url_launcher/url_launcher.dart';

void main() => runApp(MyApp());

const kSampleIcons = [
  Icons.track_changes_outlined,
  Icons.wifi_protected_setup_outlined,
  Icons.account_box_outlined,
];
const kSampleIconLabels = [
  'DADOS',
  'GITHUB',
];

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final controller = ScrollController();
  double headerOffset = 0.0;
  final String githubUrl = 'https://github.com/LeticiaBHB';


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/dados': (context) => dados(),
      },
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.only(top: 24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: CollapsingToolbar(
                  controller: controller,
                  expandedHeight: 160,
                  collapsedHeight: 64,
                  decorationForegroundColor: Colors.deepOrange.shade400,
                  decorationBackgroundColor: Colors.brown.shade200,
                  onCollapsing: (double offset) {
                    setState(() {
                      headerOffset = offset;
                    });
                  },
                  leading: Container(
                    margin: EdgeInsets.only(left: 12),
                    padding: EdgeInsets.all(4),
                    decoration: ShapeDecoration(
                      color: Colors.orange[200],
                      shape: CircleBorder(),
                    ),
                    child: Icon(
                      Icons.access_alarm_outlined,
                      size: 24,
                      color: Colors.red,
                    ),
                  ),
                  title: Text(
                    'Material Particulado - PM 2.5',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  featureCount: 2,
                  featureIconBuilder: (context, index) {
                    return InkWell(
                      onTap: () => _onFeaturePressed(context, index),
                      // Passar o contexto e o índice para o método
                      child: Icon(
                        kSampleIcons[index],
                        size: 54,
                        color: Colors.orange[200],
                      ),
                    );
                  },
                  featureLabelBuilder: (context, index) {
                    return Text(
                      kSampleIconLabels[index],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    );
                  },
                  featureOnPressed: (BuildContext context, int index) {},
                ),
              ),
              Expanded(
                child: Container(
                  color: Colors.brown.shade200,
                  child: SingleChildScrollView(
                    controller: controller,
                    child: Column(
                      children: [
                        Container(
                          height: headerOffset,
                        ),
                        Lottie.asset(
                          'assets/appbar.json',
                          width: 200,
                          height: 200,
                          fit: BoxFit.fill,
                        ),
                        Container(
                          height: 200,
                          width: 350,
                          color: Colors.brown.shade200,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "PM2.5 é um sério problema de poluição atmosférica que afeta a saúde e o meio ambiente.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                                SizedBox(height: 16),
                                // Espaço de 16 de altura entre os parágrafos
                                Text(
                                  "E a medicina veterinária é a guardiã da Saúde Única. Tendo isto em vista venho por meio deste apresentar os dados processados, em comparação com mortalidade de aves migratórias",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Image.asset('assets/saudeunica.png'),
                          width: 200,
                          height: 200,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para abrir URLs em um navegador externo
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir a URL: $url';
    }
  }

  // Método para lidar com o evento do botão de recurso
  void _onFeaturePressed(BuildContext context, int index) {
    switch (index) {
      case 0:
        // Abre a página 'dados' quando o primeiro recurso é pressionado
        Navigator.pushNamed(context, '/dados');
        break;
      case 1:
        // Abre o link do GitHub no navegador externo quando o segundo recurso é pressionado
        _launchURL(githubUrl);
        break;
      default:
    }
  }
}
