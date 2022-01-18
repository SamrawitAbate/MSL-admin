import 'package:admin/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<int> countDocuments(doc) async {
    QuerySnapshot _myDoc =
        await FirebaseFirestore.instance.collection(doc).get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    return _myDocCount.length; // Count of Documents in Collection
  }

  Future<int> countSomeDocuments(doc, active) async {
    QuerySnapshot _myDoc = await FirebaseFirestore.instance
        .collection(doc)
        .where('active', isEqualTo: active)
        .get();
    List<DocumentSnapshot> _myDocCount = _myDoc.docs;
    return _myDocCount.length; // Count of Documents in Collection
  }

  List a = [
    'Total registered user',
    'Toal registered Skilled personal',
    'Total Inactive Skilled personal',
    'Total Active Skilled personal',
  ];

  List? b;

  int q = 0, w = 0, e = 0, r = 0;

  @override
  Widget build(BuildContext context) {
    countDocuments('userDetail').then((value) {
      q = value;
    });
    countDocuments('maintenanceDetail').then((value) {
      w = value;
    });
    countSomeDocuments('maintenanceDetail', false).then((value) {
      e = value;
    });
    countSomeDocuments('maintenanceDetail', true).then((value) {
      setState(() {
        r = value;
      });
    });
    b = [q, w, e, r];
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                newMethod(0),
                newMethod(1),
                newMethod(2),
                newMethod(3),
              ],
            ),
          ),
       const  Center(child: Padding(
         padding: EdgeInsets.all(8.0),
         child: Text('Complains'),
       ),),
          Card(
            elevation: 15,
            margin: const EdgeInsets.all(8.0),
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('complain')
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!.docs;
                    return data.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(
                              child: Text('No Complain'),
                            ),
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * .4,
                            child: ListView.builder(
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(data[index]['to']),
                                    subtitle: Text(data[index]['message']),
                                    trailing: Text(data[index]['who']),
                                  );
                                }),
                          );
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    throw Exception(snapshot.error);
                  }
                  return const Loading();
                }),
          )
        ],
      ),
    );
  }

  newMethod(index) {
    return Card(
      elevation: 15,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(b![index].toString(),
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.w800)),
            ),
            const SizedBox(height: 10),
            Text(a[index],
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.w300)),
          ],
        ),
      ),
    );
  }
}
