import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendario de Amalfi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;

  final List<Color> appBarColors = [
    Color.fromARGB(255, 101, 169, 209), // Color inicial
    Colors.red,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Color.fromARGB(255, 218, 93, 211),
  ];
  int selectedColorIndex = 0;

  late TextEditingController _noteController; // Controlador para el TextField

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.week; // Cambio a CalendarFormat.week
    _focusedDay = DateTime.now();
    _selectedDay = DateTime.now();
    _noteController = TextEditingController(); // Inicializa el controlador
  }

  @override
  void dispose() {
    _noteController.dispose(); // Libera el controlador cuando ya no se necesite
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Calendario de Amalfi',
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: appBarColors[selectedColorIndex],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                TableCalendar(
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  calendarFormat: _calendarFormat,
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  },
                  onFormatChanged: (format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    _focusedDay = focusedDay;
                  },
                  daysOfWeekHeight:
                      40, // Aumenta la altura de los días de la semana
                ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: FloatingActionButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          DateTime selectedDate = DateTime.now();
                          return AlertDialog(
                            title: const Text('Agregar Nota'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('Selecciona una fecha:'),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: () async {
                                    final DateTime? pickedDate =
                                        await showDatePicker(
                                      context: context,
                                      initialDate: selectedDate,
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2030),
                                    );
                                    if (pickedDate != null &&
                                        pickedDate != selectedDate) {
                                      setState(() {
                                        selectedDate = pickedDate;
                                      });
                                    }
                                  },
                                  child: const Text('Seleccionar Fecha'),
                                ),
                                const SizedBox(height: 16),
                                TextField(
                                  controller:
                                      _noteController, // Asigna el controlador al TextField
                                  decoration: const InputDecoration(
                                    hintText: 'Escribe tu nota aquí...',
                                  ),
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 16),
                                const Text('Selecciona un color:'),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: appBarColors.map((color) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedColorIndex =
                                              appBarColors.indexOf(color);
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: color,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Aquí guardas la nota
                                  String note = _noteController.text;
                                  // Puedes realizar la acción de guardado aquí
                                  print('Nota guardada: $note');
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Guardar'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.note_add),
                    backgroundColor: null,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.calendar_today),
                SizedBox(width: 9),
                Text(''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
