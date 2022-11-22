
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class CreateEventForm extends StatefulWidget {
  const CreateEventForm({super.key});

  @override
  CreateEventFormState createState() {
    return CreateEventFormState();
  }
}
class CreateEventFormState extends State<CreateEventForm> {
  @override
  void initState() {
    timeinput.text = "";
    super.initState();
  }
  XFile? image;

  final ImagePicker picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _decriptionController = TextEditingController();
  final TextEditingController timeinput = TextEditingController();
  final TextEditingController dateEventController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();


  String _dropdownValue = "Escolha";
  List<String> dropDownOptions = [
    "Escolha",
    "Música",
    "Teatro",
    "Arte",
    "Bar",
  ];
  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          buildLabelCreateEvent("Escolha a imagem"),
          const SizedBox(height: 20),
          buildImageSelectionField(),
          const SizedBox(height: 40),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: buildLabelCreateEvent("Título"),
                  ),
                  const SizedBox(height: 12),
                  buildTitleField(),
                  const SizedBox(height: 20),
                  buildRowLabels("Categorias", "Valor"),
                  const SizedBox(height: 12),
                  buildRowCategoriesValueFields(),
                  const SizedBox(height: 20),
                  buildRowLabels("Data", "Horário"),
                  const SizedBox(height: 12),
                  buildRowTimePickers(),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: buildLabelCreateEvent("CEP"),
                  ),
                  const SizedBox(height: 12),
                  buildFieldZipCode(),
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: buildLabelCreateEvent("Decrição"),
                  ),
                  const SizedBox(height: 12),
                  buildFieldDescription()
                ],
              ),
          ),
          const SizedBox(height: 40),
          buildSaveRegistterBtn()


        ],
      ),
    );
  }

  Stack buildImageSelectionField() {
    return Stack(
          children: [ image != null ? Image.file(File(image!.path),fit: BoxFit.cover,width: double.infinity,height: 200):
            Image.asset("assets/images/placeholder-img.jpg",
                fit: BoxFit.cover, width: double.infinity, height: 200),
            Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                top: 0,
                child: InkWell(
                  onTap: () {
                    myAlert();
                  },
                  child: const Icon(
                    Icons.camera_alt,
                    color: Color(0xffF7C548),
                    size: 40,
                  ),
                )
            )
          ],
        );
  }
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);

    setState(() {
      image = img;
    });
  }
  TextFormField buildTitleField() {
    return TextFormField(
                  controller: _titleController,
                  decoration: buildInputDecorationFields("Insira o título do seu evento"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'O campo não pode estar vazio.';
                    }
                    return null;
                  },
                );
  }
  void myAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            title: Text('Escolha de onde voce ira selecionar a foto'),
            content: Container(
              height: MediaQuery.of(context).size.height / 6,
              child: Column(
                children: [
                  ElevatedButton(
                    //if user click this button, user can upload image from gallery
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.gallery);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.image),
                        Text('Galeria'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    //if user click this button. user can upload image from camera
                    onPressed: () {
                      Navigator.pop(context);
                      getImage(ImageSource.camera);
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.camera),
                        Text('Camera'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
  SizedBox buildFieldDescription() {
    return SizedBox(
                  child: TextFormField(
                    controller: _decriptionController,
                    decoration: buildInputDecorationFields("Descreva o evento"),
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    minLines: 4,
                    maxLines: null,

                  ),
                );
  }

  Align buildFieldZipCode() {
    return Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 160,
                    child: TextFormField(
                      controller: zipCodeController,
                      decoration: buildInputDecorationFields("Informe seu CEP"),
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'O campo não pode estar vazio.';
                        }
                        return null;
                      },
                    ),
                  ),
                );
  }

  Row buildRowTimePickers()  {
    return Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: TextFormField(
                          controller: _eventDateController,
                          decoration: buildInputDecorationFields(
                              "Selecione a data"
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              helpText: "",
                              initialEntryMode: DatePickerEntryMode.calendarOnly,
                              firstDate: DateTime(1800),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              String formattedDate =
                              DateFormat('dd/MM/yyyy').format(pickedDate);
                              setState(() {
                                _eventDateController.text = formattedDate;
                              });
                            }
                          },
                        )),
                    const Spacer(),
                    Expanded(
                        flex: 4,
                        child: TextFormField(
                          readOnly: true,
                          controller: timeinput,
                          decoration: buildInputDecorationFields("Horário"),
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );
                            if (pickedTime != null) {
                              DateTime parsedTime = DateFormat.jm()
                                  .parse(pickedTime.format(context).toString());

                              String formattedTime =
                              DateFormat('HH:mm:ss').format(parsedTime);

                              setState(() {
                                timeinput.text = formattedTime;
                              });
                            }
                          },
                        )),
                  ],
                );
  }

  Row buildRowCategoriesValueFields() {
    return Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2(
                              buttonDecoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(0xffF7C548),
                                  width: 3
                                ),
                              ),
                              items: dropDownOptions
                                  .map<DropdownMenuItem<String>>(
                                      (String mascot) {
                                    return DropdownMenuItem<String>(
                                        value: mascot, child: Text(mascot));
                                  }).toList(),
                              value: _dropdownValue,
                              onChanged: dropdownCallback)),
                        ),
                    const Spacer(),
                    Expanded(
                        flex: 4,
                        child: TextFormField(
                          controller: _valueController,
                          decoration: buildInputDecorationFields("Valor do evento")
                        )
                    )
                  ],
                );
  }

  Row buildRowLabels(String label1, String label2) {
    return Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: buildLabelCreateEvent(label1)),
                    const Spacer(),

                    Expanded(
                      flex: 4,
                      child: buildLabelCreateEvent(label2),
                    )
                  ],
                );
  }
  Text buildLabelCreateEvent(String title) {
    return Text(
      title,
      style: const TextStyle(
          color: Color(0xff000000), fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  SizedBox buildSaveRegistterBtn() {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor:const Color(0xffF7C548),
        ),
        child: const Align(
          alignment: Alignment.center,
          child: Text("SALVAR",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration buildInputDecorationFields(String hintText) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(width: 3, color: Color(0xffF7C548))),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 4, color: Color(0xffF7C548))),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(width: 3, color: Colors.red),
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(width: 4, color: Color(0xffF7C548))),
      errorStyle: const TextStyle(
        fontSize: 16.00,
      ),
      hintText: hintText,
      hintStyle: const TextStyle(fontSize: 16.00, color: Colors.black54),
    );
  }
}
