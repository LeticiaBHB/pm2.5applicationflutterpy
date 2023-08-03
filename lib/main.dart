import 'package:flutter/material.dart';
import 'package:flutter_collapsing_toolbar/flutter_collapsing_toolbar.dart';
import 'package:lottie/lottie.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

const kSampleIcons = [
  Icons.track_changes_outlined,
  Icons.wifi_protected_setup_outlined,
  Icons.account_box_outlined,
];
const kSampleIconLabels = [
  'DADOS',
  'GITHUB',
];

class dados extends StatefulWidget {
  @override
  _dadosState createState() => _dadosState();
}

class _dadosState extends State<dados> {
  final controller = ScrollController();
  double headerOffset = 0.0;
  final String githubUrl = 'https://github.com/LeticiaBHB';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/dados': (context) => dados(),
        '/dadospage': (context) => DadosPage(),
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
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => DadosPage()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.orange[200], // Define a cor de fundo do botão
                                    onPrimary: Colors.black, // Define a cor do texto do botão
                                  ),
                                  child: Text(
                                    'Aqui estão os dados compilados na linguagem DART',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black, fontSize: 20),
                                  ),
                                ),
                                SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    // Lógica a ser executada ao pressionar o botão 2
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.orange[200],
                                    onPrimary: Colors.black,
                                  ),
                                  child: Text(
                                    'Aqui estão os dados compilados na linguagem PYTHON',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
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
////////////////////////////////////////////////////////////////////////////////
//PRIMEIRO BOTÃO

void main() {
  runApp(MaterialApp(
    home: DadosPage(),
  ));
}

class DadosPage extends StatefulWidget {
  @override
  _DadosPageState createState() => _DadosPageState();
}

class _DadosPageState extends State<DadosPage> {
  List<List<dynamic>> csvTable = [];
  bool isCalculating = true;

  @override
  void initState() {
    super.initState();
    readCsvData();
  }

  Future<void> readCsvData() async {
    try {
      // Ler o arquivo CSV 'dadospm25.csv' como bytes
      ByteData data = await rootBundle.load('assets/dadospm25.csv');
      List<int> bytes = data.buffer.asUint8List();

      // Converter os bytes para uma string
      String csvData = String.fromCharCodes(bytes);

      // Converter o conteúdo do CSV em uma lista de listas de dynamic
      csvTable = CsvToListConverter(fieldDelimiter: '|').convert(csvData);

      setState(() {
        isCalculating = false;
      });
    } catch (e) {
      print("Erro ao ler o arquivo CSV: $e");
      setState(() {
        isCalculating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dados CSV em Tabela'),
      ),
      body: Center(
        child: isCalculating
            ? CircularProgressIndicator()
            : SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SfDataGrid(
              source: EmployeeDataSource(csvTable),
              columnWidthMode: ColumnWidthMode.fill,
              columns: <GridColumn>[
                for (var column in csvTable[0])
                  GridColumn(
                    columnName: column.toString(),
                    label: Container(
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text(
                        column.toString(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmployeeDataSource extends DataGridSource {
  EmployeeDataSource(this.data) {
    _employeeData = data.sublist(1).map<DataGridRow>((row) {
      return DataGridRow(
        cells: row.map<DataGridCell>((cell) {
          return DataGridCell<dynamic>(
              columnName: row.indexOf(cell).toString(), value: cell);
        }).toList(),
      );
    }).toList();
  }

  final List<List<dynamic>> data;
  List<DataGridRow> _employeeData = [];

  @override
  List<DataGridRow> get rows => _employeeData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(e.value.toString()),
          );
        }).toList());
  }
}
