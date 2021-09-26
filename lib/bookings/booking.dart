import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:lumicash/Config/config.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';


class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Book a Ticket"),
          leading: IconButton(
            onPressed: ()=> Navigator.pop(context),
            icon: Icon(Icons.arrow_back, color: Colors.white,),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppConfig.gradient
            ),
          ),
          bottom: TabBar(
            //isScrollable: true,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                icon: Icon(Icons.train_rounded, color: Colors.white,),
                text: "Train Ticket",
              ),
              Tab(
                icon: Icon(Icons.flight, color: Colors.white,),
                text: "Flights",
              ),
              Tab(
                icon: Icon(Icons.directions_bus_rounded, color: Colors.white,),
                text: "Bus",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BookTrain(),
            BookFlight(),
            BookBus()
          ],
        ),
      ),
    );
  }
}


class BookTrain extends StatefulWidget {
  const BookTrain({Key? key}) : super(key: key);

  @override
  _BookTrainState createState() => _BookTrainState();
}

class _BookTrainState extends State<BookTrain> {

  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // TODO: implement your code here
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: DropdownSearch<String>(
            mode: Mode.DIALOG,
            showSelectedItem: true,
            items: [
              "Nairobi",
              "Mombasa"
            ],
            label: "From",
            hint: "From",
            //popupItemDisabled: (String s) => s.startsWith('I'),
            onChanged: (v) {
              setState(() {
                from.text = v!;
              });
            },
            //selectedItem: "Brazil"
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: DropdownSearch<String>(
            mode: Mode.DIALOG,
            showSelectedItem: true,
            items: [
              "Nairobi",
              "Mombasa"
            ],
            label: "To",
            hint: "To",
            //popupItemDisabled: (String s) => s.startsWith('I'),
            onChanged: (v) {
              setState(() {
                to.text = v!;
              });
            },
            //selectedItem: "Brazil"
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      spreadRadius: 3.0,
                      offset: Offset(2.0, 2.0)
                  )
                ]
            ),
            child: SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
            ),
          ),
        ),
      ],
    );
  }
}

class BookFlight extends StatefulWidget {
  const BookFlight({Key? key}) : super(key: key);

  @override
  _BookFlightState createState() => _BookFlightState();
}

class _BookFlightState extends State<BookFlight> {

  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();
  TextEditingController userClass = TextEditingController();
  bool isRound = false;

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // TODO: implement your code here
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 20.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("One Way", style: TextStyle(fontWeight: FontWeight.bold),),
              Switch(
                activeColor: Colors.blue,
                inactiveThumbColor: Theme.of(context).scaffoldBackgroundColor,
                inactiveTrackColor: Colors.grey,
                value: isRound,
                onChanged: (value) {
                  setState(() {
                    isRound = value;
                  });
                },
              ),
              Text("Round Trip", style: TextStyle(fontWeight: FontWeight.bold),),
            ],
          ),
          SizedBox(height: 20.0,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: DropdownSearch<String>(
              mode: Mode.DIALOG,
              showSelectedItem: true,
              items: [
                "Nairobi",
                "Mombasa"
              ],
              label: "From",
              hint: "From",
              //popupItemDisabled: (String s) => s.startsWith('I'),
              onChanged: (v) {
                setState(() {
                  from.text = v!;
                });
              },
              //selectedItem: "Brazil"
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: DropdownSearch<String>(
              mode: Mode.DIALOG,
              showSelectedItem: true,
              items: [
                "Nairobi",
                "Mombasa"
              ],
              label: "To",
              hint: "To",
              //popupItemDisabled: (String s) => s.startsWith('I'),
              onChanged: (v) {
                setState(() {
                  to.text = v!;
                });
              },
              //selectedItem: "Brazil"
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3.0,
                    spreadRadius: 3.0,
                    offset: Offset(2.0, 2.0)
                  )
                ]
              ),
              child: SfDateRangePicker(
                selectionMode: isRound ? DateRangePickerSelectionMode.range : DateRangePickerSelectionMode.single,
                onSelectionChanged: _onSelectionChanged,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: DropdownSearch<String>(
              mode: Mode.DIALOG,
              showSelectedItem: true,
              items: [
                "Business",
                "Economy"
              ],
              label: "Class",
              hint: "Class",
              //popupItemDisabled: (String s) => s.startsWith('I'),
              onChanged: (v) {
                setState(() {
                  userClass.text = v!;
                });
              },
              //selectedItem: "Brazil"
            ),
          ),
          // RaisedButton(
          //   onPressed: () {
          //     OnlineStoreAPI().getData();
          //   },
            // onPressed: () async {
            //   var result = await RequestAssistant
            //       .getRequest("https://skyscanner-skyscanner-flight-search-v1.p.rapidapi.com/apiservices/autosuggest/v1.0/KE/GBP/en-GB/?query=Nai",
            //       {
            //         "x-rapidapi-key": "c6fd8d4084msh0f81d6af2c4c3c3p10e482jsnf3689e9734af",
            //         "x-rapidapi-host": "skyscanner-skyscanner-flight-search-v1.p.rapidapi.com"
            //       });
            //
            //   print(result["Places"][0]);
            // },
          // )
        ],
      ),
    );
  }
}

class BookBus extends StatefulWidget {
  const BookBus({Key? key}) : super(key: key);

  @override
  _BookBusState createState() => _BookBusState();
}

class _BookBusState extends State<BookBus> {

  TextEditingController from = TextEditingController();
  TextEditingController to = TextEditingController();

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    // TODO: implement your code here
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: DropdownSearch<String>(
            mode: Mode.DIALOG,
            showSelectedItem: true,
            items: [
              "Nairobi",
              "Mombasa"
            ],
            label: "From",
            hint: "From",
            //popupItemDisabled: (String s) => s.startsWith('I'),
            onChanged: (v) {
              setState(() {
                from.text = v!;
              });
            },
            //selectedItem: "Brazil"
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: DropdownSearch<String>(
            mode: Mode.DIALOG,
            showSelectedItem: true,
            items: [
              "Nairobi",
              "Mombasa"
            ],
            label: "To",
            hint: "To",
            //popupItemDisabled: (String s) => s.startsWith('I'),
            onChanged: (v) {
              setState(() {
                to.text = v!;
              });
            },
            //selectedItem: "Brazil"
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7.0),
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26,
                      blurRadius: 3.0,
                      spreadRadius: 3.0,
                      offset: Offset(2.0, 2.0)
                  )
                ]
            ),
            child: SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
            ),
          ),
        ),
      ],
    );
  }
}


