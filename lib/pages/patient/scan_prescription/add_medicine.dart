import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctors_prescription/components/detail_row.dart';
import 'package:doctors_prescription/components/patient/add_medicine/medicine_detail_card.dart';
import 'package:doctors_prescription/models/medicine.dart';
import 'package:doctors_prescription/pages/patient/components/app_bar.dart';
import 'package:flutter/material.dart';

class AddMedicineArguments {
  final List<String> predictedMedicines;
  final List<Medicine> medicines;

  AddMedicineArguments({this.medicines, this.predictedMedicines});
}

class PatientAddMedicine extends StatefulWidget {
  const PatientAddMedicine({Key key}) : super(key: key);

  @override
  _PatientAddMedicineState createState() => _PatientAddMedicineState();
}

class _PatientAddMedicineState extends State<PatientAddMedicine> {
  double _daySliderValue = 1;
  double _dozesSliderValue = 1;

  addMedicineReminder(BuildContext context, Medicine medicine) {
    setState(() {
      _daySliderValue = 1;
      _dozesSliderValue = 1;
    });
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          color: const Color(0xFF737373),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: StatefulBuilder(builder: (context, setState) {
              return Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 30.0),
                          child: CachedNetworkImage(
                            imageUrl: medicine.image,
                            placeholder: (context, url) => const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DetailRow(
                                title: 'Name',
                                data: medicine.name,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              DetailRow(
                                title: 'Category',
                                data: medicine.category,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              DetailRow(
                                title: 'Weight',
                                data: medicine.weight,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  const Text(
                    'Number of days',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Row(
                      children: [
                        const Text(
                          '1',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: _daySliderValue,
                            min: 1,
                            max: 7,
                            divisions: 6,
                            label: _daySliderValue.round().toString(),
                            activeColor: Colors.blue,
                            onChanged: (double newSliderValue) {
                              setState(() {
                                _daySliderValue = newSliderValue;
                              });
                            },
                          ),
                        ),
                        const Text(
                          '7',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  const Text(
                    'Number of dozes per day',
                    style: TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35.0),
                    child: Row(
                      children: [
                        const Text(
                          '1',
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                        Expanded(
                          child: Slider(
                            value: _dozesSliderValue,
                            min: 1,
                            max: 4,
                            divisions: 3,
                            label: _dozesSliderValue.round().toString(),
                            activeColor: Colors.blue,
                            onChanged: (double newSliderValue) {
                              setState(() {
                                _dozesSliderValue = newSliderValue;
                              });
                            },
                          ),
                        ),
                        const Text(
                          '4',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35.0),
                      child: ListView.builder(
                        itemCount: _dozesSliderValue.toInt(),
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text('Dose number => ${index + 1}'),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Center(
                    child: ElevatedButton.icon(
                      // color: Colors.blue,
                      // textColor: Colors.white,
                      onPressed: () {},
                      icon: const Icon(Icons.add),
                      label: const Text(
                        'Add Reminder',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AddMedicineArguments medicineArguments =
        ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: PatientAppBar(title: 'Scanned Medicines'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: medicineArguments.medicines.length,
              itemBuilder: (BuildContext context, int index) {
                Medicine currentMedicine = medicineArguments.medicines[index];
                return MedicineDetailCard(
                  name: currentMedicine.name,
                  category: currentMedicine.category,
                  weight: currentMedicine.weight,
                  id: currentMedicine.id,
                  image: currentMedicine.image,
                  hasAddedReminder: currentMedicine.hasAddedReminder,
                  showBottomSheet: () {
                    addMedicineReminder(context, currentMedicine);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
