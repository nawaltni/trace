import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:trace/src/features/current_meta/data/current_meta.dart';
import 'package:trace/src/features/survey/data/db.dart';
import 'package:trace/src/features/survey/data/models.dart';

const List<String> _placeType = [
  'Cliente A',
  'Cliente B',
  'Cliente C',
];

class SurveyScreen extends ConsumerStatefulWidget {
  const SurveyScreen({super.key});

  @override
  SurveyScreenState createState() => SurveyScreenState();
}

class SurveyScreenState extends ConsumerState<SurveyScreen> {
  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    // ref.read(counterProvider);
  }

  @override
  void dispose() {
    print("overriding dispose");
    super.dispose();
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    placeValue.clear();
    ownerValue.clear();
    coordinatesValue.clear();
    commentsValue.clear();

    placeTypeValue = _placeType.first;
    cityValue = null;
  }

  final _formKey = GlobalKey<FormState>();

  String? placeTypeValue = _placeType.first;
  String? cityValue;
  TextEditingController placeValue = TextEditingController();
  TextEditingController ownerValue = TextEditingController();
  TextEditingController coordinatesValue = TextEditingController();
  TextEditingController commentsValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final FocusNode focus1 = FocusNode();
    final FocusNode focus2 = FocusNode();

    var metaService = ref.watch(currentMetaRepositoryProvider);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Form(
              key: _formKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Encuesta',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  TypeAheadField<String>(
                    controller: placeValue,
                    hideOnEmpty: true,
                    suggestionsCallback: (search) {
                      if (search.isNotEmpty) {
                        return DatabaseHelper.instance
                            .getPlaceNames(query: search);
                      }
                      return [];
                    },
                    builder: (context, controller, focusNode) {
                      return TextFormField(
                        controller: controller,
                        autofocus: false,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          hintText: 'Inserte Nombre de Farmacia',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      );
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSelected: (value) => placeValue.text = value,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TypeAheadField<String>(
                    controller: ownerValue,
                    hideOnEmpty: true,
                    suggestionsCallback: (search) {
                      if (search.isNotEmpty) {
                        return DatabaseHelper.instance
                            .getPlaceNames(query: search);
                      }
                      return [];
                    },
                    builder: (context, controller, focusNode) {
                      return TextFormField(
                        controller: controller,
                        autofocus: false,
                        focusNode: focusNode,
                        decoration: const InputDecoration(
                          hintText: 'Inserte Nombre de Propietario',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      );
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                        title: Text(suggestion),
                      );
                    },
                    onSelected: (value) => ownerValue.text = value,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: coordinatesValue,
                          decoration: const InputDecoration(
                            hintText: 'Coordenadas',
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final loc = await metaService.currentLocation();
                          coordinatesValue.text =
                              "${loc.latitude}, ${loc.longitude}";
                        },
                        child: const Text('Buscar'),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField(
                    hint: const Text('Seleccione una opción'),
                    value: placeTypeValue,
                    onChanged: (newValue) {
                      setState(() {
                        placeTypeValue = newValue.toString();
                      });
                    },
                    items: _placeType
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FutureBuilder(
                      future: DatabaseHelper.instance.getCities(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButtonFormField(
                            hint: const Text('Seleccione una opción'),
                            value: cityValue,
                            onChanged: (newValue) {
                              setState(() {
                                cityValue = newValue.toString();
                              });
                            },
                            items: snapshot.data!
                                .map<DropdownMenuItem<String>>((City value) {
                              return DropdownMenuItem<String>(
                                value: value.name,
                                child: Text(value.name),
                              );
                            }).toList(),
                          );
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }

                        // By default, show a loading spinner.
                        return const CircularProgressIndicator();
                      }),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: commentsValue,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Comentarios',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            _resetForm();
                          },
                          child: const Text('Limpiar')),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            foregroundColor: Colors.white),
                        onPressed: () async {
                          // Validate returns true if the form is valid, or false otherwise.
                          if (_formKey.currentState!.validate()) {
                            await DatabaseHelper.instance
                                .insertSurveyRecord(SurveyRecord(
                              placeName: placeValue.text,
                              contact: ownerValue.text,
                              location: coordinatesValue.text,
                              placeCategory: placeTypeValue!,
                              city: cityValue!,
                              comment: commentsValue.text,
                            ));

                            // If the form is valid, display a snackbar. In the real world,
                            // you'd often call a server or save the information in a database.
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Encuesta guardada')),
                            );

                            _resetForm();
                            FocusScope.of(context).unfocus();
                          }
                        },
                        child: const Text('Enviar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
